package com.example.grupo_6.Controller;

import com.example.grupo_6.Entity.AsignacionSede;
import com.example.grupo_6.Entity.Asistencia;
import com.example.grupo_6.Repository.AsignacionSedeRepository;
import com.example.grupo_6.Repository.AsistenciaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/coordinador")
public class CoordinadorController {

    @Autowired
    private AsignacionSedeRepository asignacionSedeRepository;

    @Autowired
    private AsistenciaRepository asistenciaRepository;

    @GetMapping("/home")
    public String home(Model model) {
        Integer idUsuario = 5; // reemplazar por sesión en el futuro
        LocalDate hoy = LocalDate.now();

        Optional<AsignacionSede> asignacion = asignacionSedeRepository.findByIdUsuarioAndFecha(idUsuario, hoy);

        if (asignacion.isPresent()) {
            model.addAttribute("localAsignado", asignacion.get().getSede().getNombre());
            model.addAttribute("latitud", asignacion.get().getSede().getLatitud());
            model.addAttribute("longitud", asignacion.get().getSede().getLongitud());
        } else {
            model.addAttribute("localAsignado", "Sin asignación");
            model.addAttribute("latitud", 0);
            model.addAttribute("longitud", 0);
        }

        model.addAttribute("fechaActual", hoy.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        return "coordinador/coordinador_home";
    }

    @GetMapping("/tareas")
    public String verTareas(Model model) {
        Integer idUsuario = 1;
        LocalDate hoy = LocalDate.now();

        Optional<Asistencia> asistencia = asistenciaRepository.findByIdusuarioAndFecha(idUsuario, hoy);
        asistencia.ifPresent(a -> model.addAttribute("observacionesRegistradas", a.getObservaciones()));

        return "coordinador/coordinador_tareas";
    }

    @PostMapping("/tareas")
    public String registrarTareas(@RequestParam(required = false) List<String> tareas,
                                  @RequestParam(required = false) String extra) {
        Integer idUsuario = 1;
        LocalDate hoy = LocalDate.now();

        Optional<Asistencia> asistenciaOpt = asistenciaRepository.findByIdusuarioAndFecha(idUsuario, hoy);
        Asistencia asistencia = asistenciaOpt.orElseGet(() -> {
            Asistencia nueva = new Asistencia();
            nueva.setIdusuario(idUsuario);
            nueva.setFecha(hoy);
            nueva.setHoraEntrada(LocalTime.now());
            return nueva;
        });

        String observaciones = "";
        if (tareas != null && !tareas.isEmpty()) {
            observaciones += String.join(", ", tareas);
        }
        if (extra != null && !extra.isBlank()) {
            observaciones += "\n" + extra;
        }

        asistencia.setObservaciones(observaciones.trim());
        asistenciaRepository.save(asistencia);

        return "redirect:/coordinador/tareas";
    }
}
