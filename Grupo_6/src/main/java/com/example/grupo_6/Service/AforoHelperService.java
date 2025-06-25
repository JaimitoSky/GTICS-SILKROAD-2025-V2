package com.example.grupo_6.Service;

import com.example.grupo_6.Entity.Estado;
import com.example.grupo_6.Entity.HorarioDisponible;
import com.example.grupo_6.Repository.EstadoRepository;
import com.example.grupo_6.Repository.ReservaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AforoHelperService {
    private final ReservaRepository reservaRepository;
    private final EstadoRepository estadoRepository;

    public int calcularAforoDisponible(HorarioDisponible horario, LocalDate fecha) {
        List<Estado> estados = estadoRepository.findByNombreInAndTipoAplicacion(
                List.of("aprobada", "pendiente"),
                Estado.TipoAplicacion.reserva
        );

        long reservasCount = reservaRepository.countByHorarioDisponibleAndEstadoInAndFechaReserva(
                horario, estados, fecha
        );

        return Math.max(horario.getAforoMaximo() - (int)reservasCount, 0);
    }
}