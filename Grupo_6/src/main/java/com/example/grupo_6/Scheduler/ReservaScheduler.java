package com.example.grupo_6.Scheduler;


import com.example.grupo_6.Entity.HorarioDisponible;
import com.example.grupo_6.Entity.Notificacion;
import com.example.grupo_6.Repository.*;

import java.sql.Timestamp;
import com.example.grupo_6.Entity.Estado;
import com.example.grupo_6.Entity.Reserva;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;


import java.time.LocalDateTime;
import java.util.List;

@Component
@RequiredArgsConstructor
public class ReservaScheduler {

    private final ReservaRepository reservaRepository;
    private final EstadoRepository estadoRepository;
    private final PagoRepository pagoRepository;
    private final NotificacionRepository notificacionRepository;
    private final HorarioDisponibleRepository horarioDisponibleRepository;


    @Scheduled(fixedRate = 60000) // cada 60 segundos
    @Transactional
    public void verificarReservasNoPagadas() {
        Estado estadoPendiente = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.reserva);
        Estado estadoRechazada = estadoRepository.findByNombreAndTipoAplicacion("rechazada", Estado.TipoAplicacion.reserva);
        Estado estadoNoPagado = estadoRepository.findByNombreAndTipoAplicacion("no_pagado", Estado.TipoAplicacion.pago);

        if (estadoPendiente == null || estadoRechazada == null || estadoNoPagado == null) return;

        LocalDateTime ahora = LocalDateTime.now();
        List<Reserva> vencidas = reservaRepository.findByEstadoAndFechaLimitePagoBefore(estadoPendiente, ahora);


        for (Reserva reserva : vencidas) {
            // Solo reservas pendientes y pagos pendientes
            if (reserva.getPago() != null &&
                    reserva.getEstado().getNombre().equalsIgnoreCase("pendiente") &&
                    reserva.getPago().getEstado().getNombre().equalsIgnoreCase("pendiente")) {

                // Cambiar estado
                reserva.setEstado(estadoRechazada);
                reserva.getPago().setEstado(estadoNoPagado);

                // Liberar aforo
                HorarioDisponible horario = reserva.getHorarioDisponible();
                if (horario != null && horario.getAforoDisponible() < horario.getAforoMaximo()) {
                    horario.setAforoDisponible(horario.getAforoDisponible() + 1);
                    horarioDisponibleRepository.save(horario);
                }

                reservaRepository.save(reserva);
                pagoRepository.save(reserva.getPago());
            }
        }

    }

    @Scheduled(fixedRate = 60000) // cada minuto
    @Transactional
    public void notificarReservasProximas() {
        LocalDateTime ahora = LocalDateTime.now();
        LocalDateTime enUnaHora = ahora.plusHours(1);

        List<Reserva> proximas = reservaRepository.findAll().stream()
                .filter(r -> {
                    LocalDateTime fechaHoraReserva = r.getFechaReserva().atTime(r.getHorarioDisponible().getHoraInicio());
                    return fechaHoraReserva.isAfter(ahora) && fechaHoraReserva.isBefore(enUnaHora);
                })
                .toList();

        for (Reserva r : proximas) {
            boolean yaNotificado = notificacionRepository
                    .existsByUsuario_IdusuarioAndTituloAndMensajeContaining(
                            r.getUsuario().getIdusuario(),
                            "Recordatorio de reserva",
                            r.getHorarioDisponible().getHoraInicio().toString()
                    );
            if (yaNotificado) continue;

            Notificacion noti = new Notificacion();
            noti.setUsuario(r.getUsuario());
            noti.setTitulo("Recordatorio de reserva");
            noti.setMensaje("Tu reserva en " + r.getSedeServicio().getServicio().getNombre() +
                    " es hoy a las " + r.getHorarioDisponible().getHoraInicio() + ".");
            noti.setLeido(false);
            noti.setFechaEnvio(Timestamp.valueOf(LocalDateTime.now()));
            notificacionRepository.save(noti);
        }
    }

    @Transactional
    public void cambiarEstadoReserva(Integer idReserva, Integer nuevoIdEstado) {
        Reserva reserva = reservaRepository.findById(idReserva).orElse(null);
        Estado nuevoEstado = estadoRepository.findById(nuevoIdEstado).orElse(null);

        if (reserva != null && nuevoEstado != null) {
            int estadoAnterior = reserva.getEstado().getIdestado();
            reserva.setEstado(nuevoEstado);

            // Solo si el nuevo estado es RECHAZADO (3), y antes era pendiente o aprobada
            if (nuevoEstado.getIdestado() == 3 && (estadoAnterior == 1 || estadoAnterior == 2)) {
                HorarioDisponible horario = reserva.getHorarioDisponible();
                if (horario != null && horario.getAforoDisponible() < horario.getAforoMaximo()) {
                    horario.setAforoDisponible(horario.getAforoDisponible() + 1);
                    horarioDisponibleRepository.save(horario);
                }
            }

            reservaRepository.save(reserva);
        }
    }

    @Scheduled(fixedRate = 10000)
    @Transactional
    public void restaurarAforoDeRechazadasInteligente() {
        Estado estadoRechazada = estadoRepository.findByNombreAndTipoAplicacion("rechazada", Estado.TipoAplicacion.reserva);
        Estado estadoPendiente = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.reserva);
        Estado estadoAprobada = estadoRepository.findByNombreAndTipoAplicacion("aprobada", Estado.TipoAplicacion.reserva);

        if (estadoRechazada == null || estadoPendiente == null || estadoAprobada == null) return;

        // Buscar reservas rechazadas que podrían liberar aforo
        List<Reserva> rechazadas = reservaRepository.findByEstado(estadoRechazada);

        for (Reserva r : rechazadas) {
            HorarioDisponible horario = r.getHorarioDisponible();
            if (horario == null) continue;

            // Obtener todas las reservas activas en ese horario y fecha
            int reservasActivas = Math.toIntExact(
                    reservaRepository.countByHorarioDisponibleAndEstadoInAndFechaReserva(
                            horario,
                            List.of(estadoPendiente, estadoAprobada),
                            r.getFechaReserva()
                    )
            );


            // Si el aforo disponible aún no fue restaurado
            int aforoEsperado = horario.getAforoMaximo() - reservasActivas;
            if (horario.getAforoDisponible() < aforoEsperado) {
                horario.setAforoDisponible(aforoEsperado);
                horarioDisponibleRepository.save(horario);
            }
        }
    }

}
