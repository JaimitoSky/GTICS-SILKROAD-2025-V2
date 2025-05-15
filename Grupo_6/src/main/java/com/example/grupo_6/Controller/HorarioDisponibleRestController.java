package com.example.grupo_6.Controller;

import com.example.grupo_6.Entity.HorarioDisponible;
import com.example.grupo_6.Repository.HorarioDisponibleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api")
public class HorarioDisponibleRestController {

    @Autowired
    private HorarioDisponibleRepository horarioDisponibleRepository;

    @GetMapping("/horarios-disponibles")
    public List<Map<String, String>> obtenerHorarios(
            @RequestParam("sedeServicioId") Integer sedeServicioId,
            @RequestParam(value = "fecha", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fecha
    ) {
        // Si se proporciona fecha, filtras si lo necesitas, sino traes todos
        List<HorarioDisponible> lista = horarioDisponibleRepository.buscarPorSedeServicioId(sedeServicioId);

        return lista.stream()
                .map(h -> {
                    Map<String, String> map = new HashMap<>();
                    map.put("idhorario", String.valueOf(h.getIdhorario()));
                    map.put("horaInicio", h.getHoraInicio().toString());
                    map.put("horaFin", h.getHoraFin().toString());
                    map.put("diaSemana", h.getHorarioAtencion().getDiaSemana().toString());
                    return map;
                })
                .collect(Collectors.toList());
    }
}


