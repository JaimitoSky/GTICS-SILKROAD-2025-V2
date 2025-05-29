package com.example.grupo_6.Controller;

import com.example.grupo_6.Dto.CoordinadorPerfilDTO;
import com.example.grupo_6.Entity.*;
import com.example.grupo_6.Repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.*;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.stream.Collectors;

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

        List<CoordinadorSede> asignaciones = coordinadorSedeRepository.findByUsuario_IdusuarioAndActivoTrue(usuario.getIdusuario());

        if (!asignaciones.isEmpty()) {
            List<Sede> sedesLimpiadas = asignaciones.stream().map(cs -> {
                Sede sede = new Sede();
                sede.setIdsede(cs.getSede().getIdsede());
                sede.setNombre(cs.getSede().getNombre());
                sede.setLatitud(cs.getSede().getLatitud());
                sede.setLongitud(cs.getSede().getLongitud());
                return sede;
            }).toList();

            model.addAttribute("sedesAsignadas", sedesLimpiadas);
            model.addAttribute("sedeAsignada", sedesLimpiadas.get(0)); // Primera sede por defecto
        } else {
            model.addAttribute("sedesAsignadas", List.of());
            model.addAttribute("sedeAsignada", null);
        }

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
    public String mostrarFormularioAsistencia(@PathVariable("idreserva") Integer idreserva,
                                              RedirectAttributes attr,
                                              Model model) {
        Optional<Reserva> optReserva = reservaRepository.findById(idreserva);
        if (optReserva.isEmpty()) return "redirect:/coordinador/reservas-hoy";

        boolean yaRegistrada = asistenciaRepository.existsByReserva_Idreserva(idreserva);
        if (yaRegistrada) {
            attr.addFlashAttribute("errorAsistencia", "Ya se ha registrado asistencia para esta reserva.");
            return "redirect:/coordinador/reservas-hoy";
        }

        model.addAttribute("reserva", optReserva.get());
        return "coordinador/coordinador_asistencia";
    }


    @PostMapping("/asistencia/marcar")
    public String registrarAsistencia(@RequestParam("idusuario") Integer idusuario,
                                      @RequestParam("idreserva") Integer idreserva,
                                      @RequestParam("horaEntrada") String horaEntradaStr,
                                      @RequestParam(value = "latitud", required = false) Double latitud,
                                      @RequestParam(value = "longitud", required = false) Double longitud,
                                      RedirectAttributes attr) {

        if (asistenciaRepository.existsByReserva_Idreserva(idreserva)) {
            attr.addFlashAttribute("errorAsistencia", "La asistencia ya fue registrada.");
            return "redirect:/coordinador/reservas-hoy";
        }

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

    @GetMapping("/reservas-hoy")
    public String verReservasDeSede(@RequestParam(value = "asistenciaRegistrada", required = false) String asistenciaRegistrada,
                                    @RequestParam(defaultValue = "0") int page,
                                    Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";

        List<CoordinadorSede> asignaciones = coordinadorSedeRepository.findByUsuario_IdusuarioAndActivoTrue(usuario.getIdusuario());

        if (asignaciones.isEmpty()) {
            model.addAttribute("mensaje", "No estás asignado a ninguna sede.");
            model.addAttribute("reservas", Page.empty());
            model.addAttribute("sedesAsignadas", List.of());
            return "coordinador/coordinador_reservas_hoy";
        }

        List<Sede> sedesAsignadas = asignaciones.stream()
                .map(CoordinadorSede::getSede)
                .toList();

        List<Integer> idsSede = sedesAsignadas.stream()
                .map(Sede::getIdsede)
                .toList();

        Pageable pageable = PageRequest.of(page, 10);

        Page<Reserva> reservasPaginadas = reservaRepository.buscarReservasPorIdsSedePaginado(idsSede, pageable);

        // Filtrar solo reservas válidas
        List<Reserva> filtradas = reservasPaginadas.getContent().stream()
                .filter(r -> r.getUsuario() != null
                        && r.getSedeServicio() != null
                        && r.getHorarioDisponible() != null
                        && r.getEstado() != null)
                .toList();

        Page<Reserva> reservasFiltradas = new PageImpl<>(filtradas, pageable, filtradas.size());


        model.addAttribute("reservas", reservasFiltradas);
        model.addAttribute("sedesAsignadas", sedesAsignadas);
        model.addAttribute("rol", "coordinador");

        if ("true".equals(asistenciaRegistrada)) {
            model.addAttribute("mensajeAsistencia", "Ya se ha registrado asistencia para esta reserva.");
        }

        return "coordinador/coordinador_reservas_hoy";
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
