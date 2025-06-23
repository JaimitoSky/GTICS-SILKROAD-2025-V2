package com.example.grupo_6.Controller;

import com.example.grupo_6.Dto.CoordinadorPerfilDTO;
import com.example.grupo_6.Entity.*;
import com.example.grupo_6.Repository.*;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
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

import java.sql.Time;
import java.util.*;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalTime;

import java.sql.Timestamp;
import java.time.LocalDateTime;

@Controller
@RequestMapping("/coordinador")
public class CoordinadorController {


    @Autowired
    private AsistenciaCoordinadorRepository asistenciaCoordinadorRepository;
    @Autowired
    private UsuarioRepository usuarioRepository;
    @Autowired
    private SedeRepository sedeRepository;

    @Autowired
    private NotificacionRepository notificacionRepository;

    @Autowired
    private ReservaRepository reservaRepository;
    @Autowired
    private CoordinadorSedeRepository coordinadorSedeRepository;

    @Autowired
    private IncidenciaRepository incidenciaRepository;

    @GetMapping("/home")
    public String home(HttpSession session, Model model) throws JsonProcessingException {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";

        List<CoordinadorSede> asignaciones = coordinadorSedeRepository
                .findByUsuario_IdusuarioAndActivoTrue(usuario.getIdusuario());

        if (asignaciones.isEmpty()) {
            model.addAttribute("sedesAsignadas", List.of());
            model.addAttribute("sedeAsignada", null);
            model.addAttribute("asistenciasPorSede", Map.of());
            return "coordinador/coordinador_home";
        }

        List<Sede> sedesAsignadas = asignaciones.stream().map(cs -> {
            Sede sede = new Sede();
            sede.setIdsede(cs.getSede().getIdsede());
            sede.setNombre(cs.getSede().getNombre());
            sede.setLatitud(cs.getSede().getLatitud());
            sede.setLongitud(cs.getSede().getLongitud());
            return sede;
        }).toList();

        model.addAttribute("sedesAsignadas", sedesAsignadas);
        model.addAttribute("sedeAsignada", sedesAsignadas.get(0)); // por defecto

        // Mapear asistencias del día actual por sede
        Date fechaHoy = Date.valueOf(LocalDate.now());
        Map<Integer, String> asistenciasPorSede = new HashMap<>();

        for (Sede sede : sedesAsignadas) {
            asistenciaCoordinadorRepository
                    .findByUsuario_IdusuarioAndFechaAndSede_Idsede(usuario.getIdusuario(), fechaHoy, sede.getIdsede())
                    .ifPresent(a -> {
                        Time horaEntrada = a.getHoraEntrada();
                        String hora = (horaEntrada != null) ? horaEntrada.toString() : "—";
                        asistenciasPorSede.put(sede.getIdsede(), hora);
                    });
        }

        ObjectMapper objectMapper = new ObjectMapper();
        String asistenciasJson = objectMapper.writeValueAsString(asistenciasPorSede);
        model.addAttribute("asistenciasPorSede", asistenciasJson);        return "coordinador/coordinador_home";
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
        List<Incidencia> listaIncidencias = incidenciaRepository.findAllByReserva_Idreserva(idreserva);

        model.addAttribute("reserva", reserva);
        model.addAttribute("incidencias", listaIncidencias); // usa el mismo nombre que en el HTML

        return "coordinador/coordinador_reservas_detalle";
    }








    @GetMapping("/incidencia/{idreserva}")
    public String mostrarFormularioIncidencia(@PathVariable("idreserva") Integer idreserva, Model model) {
        Optional<Reserva> optReserva = reservaRepository.findById(idreserva);
        if (optReserva.isEmpty()) return "redirect:/coordinador/reservas-hoy";

        model.addAttribute("reserva", optReserva.get());
        return "coordinador/coordinador_incidencia";
    }
    private double calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
        final int R = 6371; // Radio de la tierra en km

        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
                        Math.sin(dLon / 2) * Math.sin(dLon / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return R * c; // Distancia en km
    }
    @ExceptionHandler
    public String handleException(Exception e, RedirectAttributes redirectAttributes) {
        e.printStackTrace(); // asegura log en consola
        redirectAttributes.addFlashAttribute("errorAsistencia", "Error interno: " + e.getMessage());
        return "redirect:/coordinador/home";
    }

    @PostMapping("/asistencia-dia/registrar")
    public String registrarAsistenciaDelDia(@RequestParam("latitud") BigDecimal latitud,
                                            @RequestParam("longitud") BigDecimal longitud,
                                            @RequestParam("idsede") Integer idsede,
                                            HttpSession session,
                                            RedirectAttributes redirectAttributes) {
        Usuario coordinador = (Usuario) session.getAttribute("usuario");
        if (coordinador == null) return "redirect:/login";

        LocalDate hoy = LocalDate.now();
        Date fechaHoy = Date.valueOf(hoy);

        if (idsede == null) {
            redirectAttributes.addFlashAttribute("errorAsistencia", "No se seleccionó una sede válida.");
            return "redirect:/coordinador/home";
        }

        try {
            // Validar si ya registró asistencia
            boolean yaRegistrada = asistenciaCoordinadorRepository
                    .existsByUsuario_IdusuarioAndFechaAndSede_Idsede(coordinador.getIdusuario(), fechaHoy, idsede);

            if (yaRegistrada) {
                redirectAttributes.addFlashAttribute("errorAsistencia", "Ya registraste tu asistencia hoy en esta sede.");
                return "redirect:/coordinador/home";
            }

            // Buscar sede
            Optional<Sede> sedeOpt = sedeRepository.findById(idsede);
            if (sedeOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("errorAsistencia", "La sede seleccionada no existe.");
                return "redirect:/coordinador/home";
            }

            Sede sede = sedeOpt.get();
            if (sede.getLatitud() == null || sede.getLongitud() == null) {
                redirectAttributes.addFlashAttribute("errorAsistencia", "Esta sede no tiene coordenadas configuradas.");
                return "redirect:/coordinador/home";
            }

            // Verificar distancia
            double distancia = calcularDistancia(
                    latitud.doubleValue(), longitud.doubleValue(),
                    sede.getLatitud().doubleValue(), sede.getLongitud().doubleValue()
            );

            if (distancia > 0.5) {
                redirectAttributes.addFlashAttribute("errorAsistencia", "Debes estar a menos de 500 metros del local.");
                return "redirect:/coordinador/home";
            }

            // Registrar asistencia
            AsistenciaCoordinador asistencia = new AsistenciaCoordinador();
            asistencia.setUsuario(coordinador);
            asistencia.setSede(sede); // requiere que esté bien mapeado el @ManyToOne
            asistencia.setFecha(fechaHoy);
            asistencia.setHoraEntrada(Time.valueOf(LocalTime.now()));
            asistencia.setLatitud(latitud);
            asistencia.setLongitud(longitud);

            asistenciaCoordinadorRepository.save(asistencia);

            redirectAttributes.addFlashAttribute("mensajeAsistencia", "Asistencia registrada exitosamente.");
            return "redirect:/coordinador/home";

        } catch (Exception e) {
            e.printStackTrace(); // log al server
            redirectAttributes.addFlashAttribute("errorAsistencia",
                    "Error inesperado al registrar asistencia: " + e.getMessage());
            return "redirect:/coordinador/home";
        }
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


        return "coordinador/coordinador_reservas_hoy";
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
