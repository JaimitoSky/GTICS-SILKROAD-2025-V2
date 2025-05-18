package com.example.grupo_6.Controller;

import com.example.grupo_6.Dto.CoordinadorPerfilDTO;
import com.example.grupo_6.Entity.*;
import com.example.grupo_6.Repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
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

    @Autowired
    private ReservaRepository reservaRepository;
    @Autowired
    private CoordinadorSedeRepository coordinadorSedeRepository;

    @Autowired
    private IncidenciaRepository incidenciaRepository;

    @GetMapping("/home")
    public String home(HttpSession session, Model model) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";

        Integer idUsuario = usuario.getIdusuario();
        Optional<CoordinadorSede> asignacion = coordinadorSedeRepository.findByUsuario_IdusuarioAndActivoTrue(idUsuario);

        if (asignacion.isPresent()) {
            Sede sede = asignacion.get().getSede();
            model.addAttribute("sedeAsignada", sede);
            model.addAttribute("latitud", sede.getLatitud());
            model.addAttribute("longitud", sede.getLongitud());
        } else {
            // Para evitar null en el template
            model.addAttribute("sedeAsignada", new Sede()); // con atributos nulos
            model.addAttribute("latitud", 0);
            model.addAttribute("longitud", 0);
        }

        model.addAttribute("fechaActual", LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
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
        // 1. Verificar sesión
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";

        Integer idUsuario = usuario.getIdusuario();
        LocalDate hoy = LocalDate.now();

        // 2. Buscar si ya hay una asistencia hoy
        Optional<Asistencia> asistenciaOpt = asistenciaRepository.findByIdusuarioAndFecha(idUsuario, hoy);

        Asistencia asistencia = asistenciaOpt.orElseGet(() -> {
            Asistencia nueva = new Asistencia();
            nueva.setIdusuario(idUsuario);
            nueva.setFecha(hoy);
            nueva.setHoraEntrada(LocalTime.now());
            return nueva;
        });

        // 3. Combinar observaciones de tareas + extra
        String observaciones = "";
        if (tareas != null && !tareas.isEmpty()) {
            observaciones += String.join(", ", tareas);
        }
        if (extra != null && !extra.isBlank()) {
            observaciones += "\n" + extra;
        }

        // 4. Guardar asistencia
        asistencia.setObservaciones(observaciones.trim());
        asistenciaRepository.save(asistencia);

        // 5. Confirmación en consola
        System.out.println("Tareas recibidas: " + tareas);
        System.out.println("Extra: " + extra);

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
        List<Notificacion> lista = notificacionRepository.findByUsuario_IdusuarioOrderByFechaEnvioDesc(idUsuario);

        // Marcar como leídas
        lista.forEach(n -> {
            if (!Boolean.TRUE.equals(n.getLeido())) {
                n.setLeido(true);
                notificacionRepository.save(n);
            }
        });


        model.addAttribute("notificaciones", lista);
        return "coordinador/coordinador_notificaciones";
    }


    @GetMapping("/reservas-hoy")
    public String verReservasDeSede(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";

        Optional<CoordinadorSede> asignacion = coordinadorSedeRepository.findByUsuario_IdusuarioAndActivoTrue(usuario.getIdusuario());
        if (asignacion.isEmpty()) {
            model.addAttribute("mensaje", "No estás asignado a ninguna sede.");
            return "coordinador/coordinador_reservas_hoy";
        }

        Integer idSede = asignacion.get().getSede().getIdsede();
        List<Reserva> reservas = reservaRepository.buscarReservasPorIdSede(idSede);  // ajusta esto si usas otro método

        // ⚠️ Filtrar reservas válidas
        List<Reserva> reservasFiltradas = reservas.stream()
                .filter(r -> r.getUsuario() != null
                        && r.getSedeServicio() != null
                        && r.getHorarioDisponible() != null
                        && r.getEstado() != null)
                .toList();

        model.addAttribute("reservas", reservasFiltradas);
        model.addAttribute("rol", "coordinador");
        return "coordinador/coordinador_reservas_hoy";
    }
    @GetMapping("/reserva-detalle/{idreserva}")
    public String detalleReserva(@PathVariable("idreserva") Integer idreserva, Model model) {
        Optional<Reserva> optReserva = reservaRepository.findById(idreserva);
        if (optReserva.isEmpty()) return "redirect:/coordinador/reservas-hoy";

        Reserva reserva = optReserva.get();

        // Manejo con Optional para evitar NullPointer
        Optional<Asistencia> asistenciaOpt = asistenciaRepository.findByReserva_Idreserva(idreserva);
        List<Incidencia> listaIncidencias = incidenciaRepository.findAllByReserva_Idreserva(idreserva);

        model.addAttribute("reserva", reserva);
        model.addAttribute("asistencia", asistenciaOpt.orElse(null)); // si no hay, manda null
        model.addAttribute("incidencias", listaIncidencias); // usa el mismo nombre que en el HTML

        return "coordinador/coordinador_reservas_detalle";
    }

    @GetMapping("/asistencia/{idreserva}")
    public String mostrarFormularioAsistencia(@PathVariable("idreserva") Integer idreserva, Model model) {
        Optional<Reserva> optReserva = reservaRepository.findById(idreserva);
        if (optReserva.isEmpty()) return "redirect:/coordinador/reservas-hoy";

        model.addAttribute("reserva", optReserva.get());
        return "coordinador/coordinador_asistencia"; // se mantiene esta vista
    }







    @PostMapping("/asistencia/marcar")
    public String registrarAsistencia(@RequestParam("idusuario") Integer idusuario,
                                      @RequestParam("idreserva") Integer idreserva,
                                      @RequestParam("horaEntrada") String horaEntradaStr,
                                      @RequestParam(value = "latitud", required = false) Double latitud,
                                      @RequestParam(value = "longitud", required = false) Double longitud) {

        Optional<Usuario> optUsuario = usuarioRepository.findById(idusuario);
        Optional<Reserva> optReserva = reservaRepository.findById(idreserva);
        if (optUsuario.isEmpty() || optReserva.isEmpty()) return "redirect:/coordinador/reservas-hoy";

        Asistencia asistencia = new Asistencia();
        asistencia.setIdusuario(idusuario);
        asistencia.setReserva(optReserva.get());
        asistencia.setFecha(LocalDate.now());
        asistencia.setHoraEntrada(LocalTime.parse(horaEntradaStr));

        if (latitud != null && longitud != null) {
            asistencia.setLatitud(BigDecimal.valueOf(latitud));
            asistencia.setLongitud(BigDecimal.valueOf(longitud));
        }

        asistencia.setObservaciones("Asistencia registrada manualmente");
        asistenciaRepository.save(asistencia);

        return "redirect:/coordinador/reservas-hoy";
    }


    @GetMapping("/incidencia/{idreserva}")
    public String mostrarFormularioIncidencia(@PathVariable("idreserva") Integer idreserva, Model model) {
        Optional<Reserva> optReserva = reservaRepository.findById(idreserva);
        if (optReserva.isEmpty()) return "redirect:/coordinador/reservas-hoy";

        model.addAttribute("reserva", optReserva.get());
        return "coordinador/coordinador_incidencia";
    }


    @PostMapping("/incidencia/guardar")
    public String guardarIncidencia(@RequestParam("idreserva") Integer idreserva,
                                    @RequestParam("descripcion") String descripcion,
                                    HttpSession session) {

        Usuario coordinador = (Usuario) session.getAttribute("usuario");
        if (coordinador == null) return "redirect:/login";

        Optional<Reserva> optReserva = reservaRepository.findById(idreserva);
        if (optReserva.isEmpty()) return "redirect:/coordinador/reservas-hoy";

        Incidencia incidencia = new Incidencia();
        incidencia.setReserva(optReserva.get());
        incidencia.setCoordinador(coordinador); // usamos directamente el objeto de sesión
        incidencia.setDescripcion(descripcion);
        incidencia.setFecha(Timestamp.valueOf(LocalDateTime.now()));

        incidenciaRepository.save(incidencia);

        return "redirect:/coordinador/reservas-hoy";
    }





    @GetMapping("/historial-reservas")
    public String verHistorialReservas(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";

        Optional<AsignacionSede> asignacion = asignacionSedeRepository.findByIdUsuarioAndFecha(usuario.getIdusuario(), LocalDate.now());
        if (asignacion.isEmpty()) {
            model.addAttribute("mensaje", "No tienes asignación registrada.");
            return "coordinador/coordinador_historial";
        }

        Integer idSede = asignacion.get().getSede().getIdsede();
        List<Reserva> historial = reservaRepository.buscarHistorialReservasPorSede(idSede);

        model.addAttribute("reservas", historial);
        model.addAttribute("rol", "coordinador");
        return "coordinador/coordinador_historial";
    }

    @ModelAttribute
    public void cargarNotificacionesNavbar(HttpSession session, Model model) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario != null) {
            long sinLeer = notificacionRepository.countByUsuario_IdusuarioAndLeidoFalse(usuario.getIdusuario());
            model.addAttribute("notificacionesNoLeidas", sinLeer);
        }
    }

}
