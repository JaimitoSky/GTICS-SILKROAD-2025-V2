package com.example.grupo_6.Controller;
import com.example.grupo_6.Entity.*;
import com.example.grupo_6.Repository.HorarioAtencionRepository;
import com.example.grupo_6.Repository.HorarioDisponibleRepository;
import com.example.grupo_6.Repository.SedeServicioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api")
public class HorarioAtencionRestController {
    @Autowired
    private HorarioAtencionRepository horarioAtencionRepository;
    @GetMapping("/dias-activos")
    public List<String> obtenerDiasActivos(@RequestParam("idsede") Integer idsede) {
        List<HorarioAtencion> activos = horarioAtencionRepository.findBySede_IdsedeAndActivoTrue(idsede);
        return activos.stream()
                .map(h -> h.getDiaSemana().name()) // Retorna "LUNES", "MARTES", etc.
                .collect(Collectors.toList());
    }
}
