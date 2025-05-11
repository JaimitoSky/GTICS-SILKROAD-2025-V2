package com.example.grupo_6.Scheduler;

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
}
