package com.example.grupo_6.Controller;

import com.example.grupo_6.Dto.CoordinadorPerfilDTO;
import com.example.grupo_6.Entity.AsignacionSede;
import com.example.grupo_6.Entity.Asistencia;
import com.example.grupo_6.Entity.Usuario;
import com.example.grupo_6.Repository.AsignacionSedeRepository;
import com.example.grupo_6.Repository.AsistenciaRepository;
import com.example.grupo_6.Repository.NotificacionRepository;
import com.example.grupo_6.Repository.UsuarioRepository;
import jakarta.servlet.http.HttpSession;
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

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private NotificacionRepository notificacionRepository;

    @GetMapping("/home")
    public String home(HttpSession session, Model model) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";
        Integer idUsuario = usuario.getIdusuario();

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
    public String verTareas(HttpSession session, Model model) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";
        Integer idUsuario = usuario.getIdusuario();

        LocalDate hoy = LocalDate.now();
        Optional<Asistencia> asistencia = asistenciaRepository.findByIdusuarioAndFecha(idUsuario, hoy);
        asistencia.ifPresent(a -> model.addAttribute("observacionesRegistradas", a.getObservaciones()));

        return "coordinador/coordinador_tareas";
    }

    @PostMapping("/tareas")
    public String registrarTareas(HttpSession session,
                                  @RequestParam(required = false) List<String> tareas,
                                  @RequestParam(required = false) String extra) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";
        Integer idUsuario = usuario.getIdusuario();

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

    @GetMapping("/perfil")
    public String verPerfil(HttpSession session, Model model) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";
        Integer idUsuario = usuario.getIdusuario();

        CoordinadorPerfilDTO perfil = usuarioRepository.obtenerPerfilCoordinadorPorId(idUsuario);
        model.addAttribute("perfil", perfil);
        return "coordinador/coordinador_perfil";
    }

    @PostMapping("/perfil/actualizar")
    public String actualizarPerfil(HttpSession session,
                                   @RequestParam String correo,
                                   @RequestParam String telefono,
                                   @RequestParam String direccion) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";
        Integer idUsuario = usuario.getIdusuario();

        Usuario u = usuarioRepository.findByIdusuario(idUsuario);
        if (u != null) {
            u.setEmail(correo);
            u.setTelefono(telefono);
            u.setDireccion(direccion);
            usuarioRepository.save(u);
        }
        return "redirect:/coordinador/perfil?success";
    }

    @GetMapping("/notificaciones")
    public String verNotificaciones(HttpSession session, Model model) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";
        Integer idUsuario = usuario.getIdusuario();

        model.addAttribute("notificaciones", notificacionRepository.findByIdusuarioOrderByFechaEnvioDesc(idUsuario));
        return "coordinador/coordinador_notificaciones";
    }
}
