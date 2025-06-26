package com.example.grupo_6.Scheduler;

import com.example.grupo_6.Entity.*;
import com.example.grupo_6.Repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.sql.Date;
import java.util.List;
import java.util.Optional;

@Component
@EnableScheduling
public class AsistenciaScheduler {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private CoordinadorHorarioRepository coordinadorHorarioRepository;

    @Autowired
    private CoordinadorSedeRepository coordinadorSedeRepository;

    @Autowired
    private AsistenciaCoordinadorRepository asistenciaRepository;

    @Autowired
    private SedeRepository sedeRepository;

    @Scheduled(cron = "0 59 23 * * *", zone = "America/Lima")  // todos los días a las 23:59
    public void verificarAsistenciasFaltantes() {
        LocalDate hoy = LocalDate.now();
        Date fechaHoy = Date.valueOf(hoy);
        HorarioAtencion.DiaSemana diaSemanaHoy = HorarioAtencion.DiaSemana.valueOf(hoy.getDayOfWeek().name());

        List<Usuario> coordinadores = usuarioRepository.findByRol_Nombre("COORDINADOR");

        for (Usuario u : coordinadores) {
            List<CoordinadorSede> sedes = coordinadorSedeRepository.findByUsuario_IdusuarioAndActivoTrue(u.getIdusuario());

            for (CoordinadorSede cs : sedes) {
                Sede sede = cs.getSede();

                Optional<AsistenciaCoordinador> asistenciaOpt =
                        asistenciaRepository.findByUsuario_IdusuarioAndFechaAndSede_Idsede(u.getIdusuario(), fechaHoy, sede.getIdsede());

                if (asistenciaOpt.isPresent()) {
                    continue;  // Ya hay asistencia registrada (presente o tarde)
                }

                // Verificar si tenía turno activo
                Optional<CoordinadorHorario> turnoOpt =
                        coordinadorHorarioRepository.findByCoordinadorSede_IdAndDiaSemanaAndActivoTrue(cs.getId(), diaSemanaHoy);

                AsistenciaCoordinador asistencia = new AsistenciaCoordinador();
                asistencia.setUsuario(u);
                asistencia.setSede(sede);
                asistencia.setFecha(fechaHoy);

                if (turnoOpt.isPresent()) {
                    CoordinadorHorario turno = turnoOpt.get();
                    asistencia.setCoordinadorHorario(turno);
                    asistencia.setHoraProgramadaEntrada(turno.getHoraEntrada());
                    asistencia.setHoraProgramadaSalida(turno.getHoraSalida());
                    asistencia.setEstado(AsistenciaCoordinador.EstadoAsistencia.falta);
                } else {
                    asistencia.setEstado(AsistenciaCoordinador.EstadoAsistencia.no_trabaja);
                }

                asistenciaRepository.save(asistencia);
                System.out.printf("[SCHEDULER] Registrado automáticamente estado %s para %s en sede %s%n",
                        asistencia.getEstado(), u.getEmail(), sede.getNombre());
            }
        }
    }

}
