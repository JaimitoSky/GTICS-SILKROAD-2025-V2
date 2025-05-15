package com.example.grupo_6.Controller;

import com.example.grupo_6.Entity.Asistencia;
import com.example.grupo_6.Repository.AsistenciaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

@Controller
@RequestMapping("/asistencia")
public class AsistenciaController {

    @Autowired
    private AsistenciaRepository asistenciaRepository;

    @PostMapping("/registrar")
    @ResponseBody
    public String registrarAsistencia(
            @RequestParam("idusuario") Integer idusuario,
            @RequestParam("latitud") Double latitud,
            @RequestParam("longitud") Double longitud,
            @RequestParam(value = "fecha", required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha
    ) {
        // Si no se pasa la fecha, usar hoy
        if (fecha == null) {
            fecha = LocalDate.now();
        }

        // Verificar si ya existe asistencia hoy
        if (asistenciaRepository.existsByIdusuarioAndFecha(idusuario, fecha)) {
            return "Ya existe una asistencia registrada hoy.";
        }

        Asistencia asistencia = new Asistencia();
        asistencia.setIdusuario(idusuario);
        asistencia.setFecha(fecha);
        asistencia.setHoraEntrada(LocalTime.now());
        asistencia.setLatitud(BigDecimal.valueOf(latitud));
        asistencia.setLongitud(BigDecimal.valueOf(longitud));
        asistencia.setObservaciones("Entrada automática");

        asistenciaRepository.save(asistencia);
        return "Entrada registrada correctamente.";
    }
}
