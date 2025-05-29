package com.example.grupo_6.Controller;

import com.example.grupo_6.Dto.ServicioPorSedeDTO;
import com.example.grupo_6.Entity.*;
import com.example.grupo_6.Repository.HorarioAtencionRepository;
import com.example.grupo_6.Repository.HorarioDisponibleRepository;
import com.example.grupo_6.Repository.SedeServicioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api")
public class HorarioDisponibleRestController {

    @Autowired
    private HorarioDisponibleRepository horarioDisponibleRepository;

    @Autowired
    private HorarioAtencionRepository horarioAtencionRepository;

    @Autowired
    private SedeServicioRepository sedeServicioRepository;

    //  GET - Cargar horarios disponibles
    //  GET - Listar horarios disponibles por sedeServicio
    @GetMapping("/horarios-disponibles")
    public List<Map<String, String>> obtenerHorarios(
            @RequestParam("sedeServicioId") Integer sedeServicioId,
            @RequestParam(value = "fecha", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fecha
    ) {
        Optional<SedeServicio> ssOpt = sedeServicioRepository.findById(sedeServicioId);
        if (ssOpt.isEmpty()) {
            return List.of(); // Devuelve lista vacía si no existe
        }

        SedeServicio ss = ssOpt.get();
        Integer idSede = ss.getSede().getIdsede();
        Integer idServicio = ss.getServicio().getIdservicio();

        List<HorarioDisponible> lista = horarioDisponibleRepository.buscarTodosPorSedeYServicio(idSede, idServicio); // 👈 CAMBIO
        return lista.stream()
                .map(h -> {
                    Map<String, String> map = new HashMap<>();
                    map.put("idhorario", String.valueOf(h.getIdhorario()));
                    map.put("horaInicio", h.getHoraInicio().toString());
                    map.put("horaFin", h.getHoraFin().toString());
                    map.put("activo", String.valueOf(h.getActivo()));  // <-- línea clave

                    map.put("diaSemana", h.getHorarioAtencion().getDiaSemana().toString());
                    return map;
                })
                .collect(Collectors.toList());
    }

    @GetMapping("/horarios-disponibles-por-fecha")
    public List<Map<String, String>> obtenerHorariosPorFecha(
            @RequestParam("sedeServicioId") Integer sedeServicioId,
            @RequestParam("fecha") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fecha
    ) {
        Optional<SedeServicio> ssOpt = sedeServicioRepository.findById(sedeServicioId);
        if (ssOpt.isEmpty() || fecha == null) return List.of();

        SedeServicio ss = ssOpt.get();
        Integer idSede = ss.getSede().getIdsede();
        Integer idServicio = ss.getServicio().getIdservicio();
        HorarioAtencion.DiaSemana diaSemana = switch (fecha.getDayOfWeek()) {
            case MONDAY    -> HorarioAtencion.DiaSemana.Lunes;
            case TUESDAY   -> HorarioAtencion.DiaSemana.Martes;
            case WEDNESDAY -> HorarioAtencion.DiaSemana.Miércoles;
            case THURSDAY  -> HorarioAtencion.DiaSemana.Jueves;
            case FRIDAY    -> HorarioAtencion.DiaSemana.Viernes;
            case SATURDAY  -> HorarioAtencion.DiaSemana.Sábado;
            case SUNDAY    -> HorarioAtencion.DiaSemana.Domingo;
        };

        System.out.println("Fecha: " + fecha);
        System.out.println("DayOfWeek: " + fecha.getDayOfWeek());
        System.out.println("DiaSemana (enum): " + diaSemana);


        List<HorarioDisponible> lista = horarioDisponibleRepository
                .findBySedeAndServicioAndDiaSemanaActivos(idSede, idServicio, diaSemana);

        return lista.stream().map(h -> {
            Map<String, String> m = new HashMap<>();
            m.put("idhorario", String.valueOf(h.getIdhorario()));
            m.put("horaInicio", h.getHoraInicio().toString());
            m.put("horaFin", h.getHoraFin().toString());
            return m;
        }).collect(Collectors.toList());
    }




    //  POST - Agregar horario disponible
    @PostMapping("/horarios-disponibles")
    public ResponseEntity<?> agregarHorarioDisponible(
            @RequestParam("sedeServicioId") Integer sedeServicioId,
            @RequestParam("horaInicio") String horaInicio,
            @RequestParam("horaFin") String horaFin,
            @RequestParam("diaSemana") String diaSemana
    ) {
        try {
            System.out.println(" POST recibido:");
            System.out.println("  ➤ sedeServicioId = " + sedeServicioId);
            System.out.println("  ➤ diaSemana = " + diaSemana);
            System.out.println("  ➤ horaInicio = " + horaInicio);
            System.out.println("  ➤ horaFin = " + horaFin);

            Optional<SedeServicio> ssOpt = sedeServicioRepository.findById(sedeServicioId);
            if (ssOpt.isEmpty()) {
                System.out.println(" SedeServicio no encontrado");
                return ResponseEntity.badRequest().body("SedeServicio no encontrado");
            }

            Sede sede = ssOpt.get().getSede();
            Servicio servicio = ssOpt.get().getServicio();

            Optional<HorarioAtencion> haOpt = horarioAtencionRepository.findBySedeAndDiaSemana(
                    sede, HorarioAtencion.DiaSemana.valueOf(diaSemana)
            );

            if (haOpt.isEmpty()) {
                System.out.println(" HorarioAtencion no encontrado para sede " + sede.getIdsede() + ", día " + diaSemana);
                return ResponseEntity.badRequest().body("Horario de atención no encontrado para el día " + diaSemana);
            }

            HorarioAtencion ha = haOpt.get();

            LocalTime ini = LocalTime.parse(horaInicio);
            LocalTime fin = LocalTime.parse(horaFin);

            if (!ini.isBefore(fin)) {
                System.out.println(" Hora de inicio debe ser anterior a hora de fin");
                return ResponseEntity.badRequest().body("La hora de inicio debe ser menor a la hora de fin");
            }

            boolean existe = horarioDisponibleRepository
                    .existsByHorarioAtencionAndHoraInicioAndHoraFinAndServicio(ha, ini, fin, servicio);

            if (existe) {
                System.out.println(" Intervalo duplicado");
                return ResponseEntity.status(HttpStatus.CONFLICT).body("Ya existe un intervalo idéntico");
            }

            HorarioDisponible nuevo = new HorarioDisponible();
            nuevo.setHorarioAtencion(ha);
            nuevo.setServicio(servicio);
            nuevo.setHoraInicio(ini);
            nuevo.setHoraFin(fin);
            nuevo.setActivo(true);
            horarioDisponibleRepository.save(nuevo);

            System.out.println("Intervalo guardado con éxito");
            return ResponseEntity.ok().build();

        } catch (Exception e) {
            System.out.println(" ERROR inesperado al agregar horario:");
            e.printStackTrace();
            return ResponseEntity.status(500).body("Error inesperado: " + e.getMessage());
        }
    }


    //  DELETE - Eliminar horario disponible
    @PostMapping("/horarios-disponibles/{id}/toggle")
    public ResponseEntity<?> toggleEstadoHorario(@PathVariable("id") Integer id) {
        Optional<HorarioDisponible> opt = horarioDisponibleRepository.findById(id);
        if (opt.isPresent()) {
            HorarioDisponible horario = opt.get();
            horario.setActivo(!Boolean.TRUE.equals(horario.getActivo())); // invierte estado
            horarioDisponibleRepository.save(horario);
            return ResponseEntity.ok().body("Estado actualizado correctamente");
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Horario no encontrado");
    }

}


