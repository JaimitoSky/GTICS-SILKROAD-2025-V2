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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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
    private static final Logger log = LoggerFactory.getLogger(ReservaScheduler.class);


    @Scheduled(fixedRate = 60000)
    @Transactional
    public void verificarReservasNoPagadas() {
        try {
            Estado estadoPendiente = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.reserva);
            Estado estadoRechazada = estadoRepository.findByNombreAndTipoAplicacion("rechazada", Estado.TipoAplicacion.reserva);
            Estado estadoNoPagado = estadoRepository.findByNombreAndTipoAplicacion("no_pagado", Estado.TipoAplicacion.pago);

            if (estadoPendiente == null || estadoRechazada == null || estadoNoPagado == null) {
                log.warn("Estados necesarios no encontrados");
                return;
            }

            LocalDateTime ahora = LocalDateTime.now();
            List<Reserva> vencidas = reservaRepository.findByEstadoAndFechaLimitePagoBefore(estadoPendiente, ahora);

            for (Reserva reserva : vencidas) {
                try {
                    if (reserva.getPago() == null ||
                            !"pendiente".equalsIgnoreCase(reserva.getEstado().getNombre()) ||
                            !"pendiente".equalsIgnoreCase(reserva.getPago().getEstado().getNombre())) {
                        continue;
                    }

                    // Cambiar estados
                    reserva.setEstado(estadoRechazada);
                    reserva.getPago().setEstado(estadoNoPagado);

                    // No es necesario actualizar aforo disponible ya que se calcula dinámicamente
                    reservaRepository.save(reserva);
                    pagoRepository.save(reserva.getPago());

                    log.info("Reserva {} marcada como rechazada por no pago", reserva.getIdreserva());
                } catch (Exception e) {
                    log.error("Error procesando reserva {}", reserva.getIdreserva(), e);
                }
            }
        } catch (Exception e) {
            log.error("Error en verificarReservasNoPagadas", e);
        }
    }
    @Scheduled(fixedRate = 60000)
    @Transactional
    public void notificarReservasProximas() {
        try {
            LocalDateTime ahora = LocalDateTime.now();
            LocalDateTime enUnaHora = ahora.plusHours(1);

            List<Reserva> proximas = reservaRepository.findAll().stream()
                    .filter(r -> {
                        try {
                            LocalDateTime fechaHoraReserva = r.getFechaReserva().atTime(r.getHorarioDisponible().getHoraInicio());
                            return fechaHoraReserva.isAfter(ahora) && fechaHoraReserva.isBefore(enUnaHora);
                        } catch (Exception e) {
                            log.warn("Error al procesar reserva {}", r.getIdreserva(), e);
                            return false;
                        }
                    })
                    .toList();

            for (Reserva r : proximas) {
                try {
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

                    log.info("Notificación enviada para reserva {}", r.getIdreserva());
                } catch (Exception e) {
                    log.error("Error al notificar reserva {}", r.getIdreserva(), e);
                }
            }
        } catch (Exception e) {
            log.error("Error en notificarReservasProximas", e);
        }
    }

    @Transactional
    public void cambiarEstadoReserva(Integer idReserva, Integer nuevoIdEstado) {
        try {
            Reserva reserva = reservaRepository.findById(idReserva).orElse(null);
            Estado nuevoEstado = estadoRepository.findById(nuevoIdEstado).orElse(null);

            if (reserva == null || nuevoEstado == null) {
                log.warn("Reserva o estado no encontrado");
                return;
            }

            int estadoAnterior = reserva.getEstado().getIdestado();
            reserva.setEstado(nuevoEstado);

            // No es necesario modificar aforo disponible ya que se calcula dinámicamente
            reservaRepository.save(reserva);
            log.info("Estado de reserva {} cambiado a {}", reserva.getIdreserva(), nuevoEstado.getNombre());

        } catch (Exception e) {
            log.error("Error al cambiar estado de reserva", e);
            throw e;
        }
    }

    //@Scheduled(fixedRate = 10000)
    // @Transactional
    // public void restaurarAforoDeRechazadasInteligente() {
    // log.info("Método obsoleto - El aforo ahora se calcula dinámicamente en los endpoints");
        // Este método ya no es necesario porque el aforo disponible se calcula dinámicamente
        // basado en las reservas activas (aprobadas/pendientes) para cada horario y fecha

        // Podrías eliminar este método por completo o dejarlo como registro histórico
    // }

}
