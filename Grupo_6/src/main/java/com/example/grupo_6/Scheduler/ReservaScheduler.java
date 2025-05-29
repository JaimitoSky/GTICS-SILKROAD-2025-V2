package com.example.grupo_6.Scheduler;


import com.example.grupo_6.Entity.Notificacion;
import com.example.grupo_6.Repository.NotificacionRepository;
import java.sql.Timestamp;
import com.example.grupo_6.Entity.Estado;
import com.example.grupo_6.Entity.Reserva;
import com.example.grupo_6.Repository.EstadoRepository;
import com.example.grupo_6.Repository.ReservaRepository;
import com.example.grupo_6.Repository.PagoRepository;
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
            if (reserva.getPago() != null &&
                    reserva.getPago().getEstado().getNombre().equalsIgnoreCase("pendiente")) {

                reserva.setEstado(estadoRechazada);
                reserva.getPago().setEstado(estadoNoPagado);

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

}
