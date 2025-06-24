package com.example.grupo_6.Controller;
import com.example.grupo_6.Entity.AsistenciaCoordinador.EstadoAsistencia;

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


import java.util.stream.Collectors;
import com.example.grupo_6.Repository.CoordinadorHorarioRepository;
import com.example.grupo_6.Entity.HorarioAtencion.DiaSemana;


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
    private CoordinadorHorarioRepository     coordinadorHorarioRepository;

    @Autowired
    private ReservaRepository reservaRepository;
    @Autowired
    private CoordinadorSedeRepository coordinadorSedeRepository;
    @Autowired
    private ObjectMapper objectMapper;
    @Autowired
    private IncidenciaRepository incidenciaRepository;

    // — GET /home —
    // — GET /coordinador/home —
    @GetMapping("/home")
    public String home(HttpSession session, Model model) throws JsonProcessingException {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) {
            return "redirect:/login";
        }

        // 1) Traer sedes activas del coordinador
        var asignas = coordinadorSedeRepository
                .findByUsuario_IdusuarioAndActivoTrue(usuario.getIdusuario());
        if (asignas.isEmpty()) {
            model.addAttribute("sedesAsignadas", List.of());
            model.addAttribute("asistenciasPorSede", "{}");
            model.addAttribute("turnosJson", "{}");
            return "coordinador/coordinador_home";
        }

        // 2) Construir lista mínima de sedes
        List<Sede> sedes = asignas.stream()
                .map(cs -> {
                    Sede s = new Sede();
                    s.setIdsede(cs.getSede().getIdsede());
                    s.setNombre(cs.getSede().getNombre());
                    s.setLatitud(cs.getSede().getLatitud());
                    s.setLongitud(cs.getSede().getLongitud());
                    return s;
                })
                .toList();
        model.addAttribute("sedesAsignadas", sedes);

        // 3) JSON de asistencias ya marcadas hoy (entrada/salida)
        Date hoy = Date.valueOf(LocalDate.now());
        Map<Integer, Map<String,String>> asisPorSede = new HashMap<>();
        for (Sede s : sedes) {
            asistenciaCoordinadorRepository
                    .findByUsuario_IdusuarioAndFechaAndSede_Idsede(
                            usuario.getIdusuario(), hoy, s.getIdsede()
                    )
                    .ifPresent(a -> {
                        Map<String,String> tiempos = new HashMap<>();
                        tiempos.put("entrada",
                                a.getHoraMarcacionEntrada() != null
                                        ? a.getHoraMarcacionEntrada().toString() : null
                        );
                        tiempos.put("salida",
                                a.getHoraMarcacionSalida() != null
                                        ? a.getHoraMarcacionSalida().toString() : null
                        );
                        asisPorSede.put(s.getIdsede(), tiempos);
                    });
        }
        model.addAttribute("asistenciasPorSede",
                objectMapper.writeValueAsString(asisPorSede)
        );

        // 4) JSON de turnos: incluir id_coordinador_horario + horas + activo
        record TurnoDTO(
                Integer id,
                String horaEntrada,
                String horaSalida,
                boolean activo
        ) {}

        Map<Integer, Map<String,TurnoDTO>> turnosPorSede = new HashMap<>();
        for (var cs : asignas) {
            int sid = cs.getSede().getIdsede();
            Map<String,TurnoDTO> m = coordinadorHorarioRepository
                    .findByCoordinadorSedeAndActivoTrue(cs)
                    .stream()
                    .collect(Collectors.toMap(
                            ch -> ch.getDiaSemana().name(),
                            ch -> new TurnoDTO(
                                    ch.getIdCoordinadorHorario(),        // ← aquí el ID real
                                    ch.getHoraEntrada().toString(),
                                    ch.getHoraSalida().toString(),
                                    ch.isActivo()
                            )
                    ));
            turnosPorSede.put(sid, m);
        }
        model.addAttribute("turnosJson",
                objectMapper.writeValueAsString(turnosPorSede)
        );

        return "coordinador/coordinador_home";
    }


    // — POST /coordinador/asistencia-dia/registrar —
    @PostMapping("/asistencia-dia/registrar")
    public String registrarAsistencia(
            @RequestParam BigDecimal latitud,
            @RequestParam BigDecimal longitud,
            @RequestParam Integer idsede,
            @RequestParam String accion,
            @RequestParam("id_coordinador_horario") Integer idCoordHorario,  // ← nuevo
            HttpSession session,
            RedirectAttributes flash
    ) {
        Usuario u = (Usuario) session.getAttribute("usuario");
        if (u == null) {
            return "redirect:/login";
        }

        LocalDate ld = LocalDate.now();
        Date hoy = Date.valueOf(ld);

        // 1) Validar parámetros
        if (idsede == null || (!"entrada".equals(accion) && !"salida".equals(accion))) {
            flash.addFlashAttribute("errorAsistencia", "Parámetros inválidos.");
            return "redirect:/coordinador/home";
        }

        // 2) Verificar sede y distancia ≤ 0.5 km
        var sedeOpt = sedeRepository.findById(idsede);
        if (sedeOpt.isEmpty()
                || sedeOpt.get().getLatitud() == null
                || sedeOpt.get().getLongitud() == null
        ) {
            flash.addFlashAttribute("errorAsistencia", "Sede inválida.");
            return "redirect:/coordinador/home";
        }
        Sede sede = sedeOpt.get();
        double dist = calcularDistancia(
                latitud.doubleValue(), longitud.doubleValue(),
                sede.getLatitud().doubleValue(), sede.getLongitud().doubleValue()
        );
        if (dist > 0.5) {
            flash.addFlashAttribute("errorAsistencia", "Debes estar a menos de 500 m del local.");
            return "redirect:/coordinador/home";
        }

        // 3) Recuperar el turno seleccionado por su ID
        CoordinadorHorario turno = coordinadorHorarioRepository
                .findById(idCoordHorario)
                .orElseThrow(() -> new IllegalArgumentException("Turno inválido"));

        // 4) Buscar o inicializar el registro de asistencia hoy
        var existeOpt = asistenciaCoordinadorRepository
                .findByUsuario_IdusuarioAndFechaAndSede_Idsede(u.getIdusuario(), hoy, idsede);

        LocalTime ahora = LocalTime.now();
        try {
            if ("entrada".equals(accion)) {
                // — ENTRADA —
                if (existeOpt.isPresent()) {
                    flash.addFlashAttribute("errorAsistencia","Ya registraste entrada.");
                } else {
                    LocalTime inicioVentana = turno.getHoraEntrada().minusMinutes(10);
                    LocalTime finVentana    = turno.getHoraEntrada().plusMinutes(30);
                    if (ahora.isBefore(inicioVentana)) {
                        flash.addFlashAttribute("errorAsistencia","Aún no puedes registrar entrada.");
                    }
                    else if (ahora.isAfter(finVentana)) {
                        flash.addFlashAttribute("errorAsistencia","Ventana de entrada cerrada.");
                    }
                    else {
                        AsistenciaCoordinador a = new AsistenciaCoordinador();
                        a.setUsuario(u);
                        a.setSede(sede);
                        a.setCoordinadorHorario(turno);
                        a.setFecha(hoy);

                        // marcación + programada entrada
                        a.setHoraMarcacionEntrada(ahora);
                        a.setHoraProgramadaEntrada(turno.getHoraEntrada());
                        a.setLatitud(latitud);
                        a.setLongitud(longitud);
                        a.setEstado(AsistenciaCoordinador.EstadoAsistencia.presente);

                        asistenciaCoordinadorRepository.save(a);
                        flash.addFlashAttribute("mensajeAsistencia","Entrada registrada con éxito.");
                    }
                }

            } else {
                // — SALIDA —
                if (existeOpt.isEmpty()) {
                    flash.addFlashAttribute("errorAsistencia","No hay entrada previa para hoy.");
                } else {
                    AsistenciaCoordinador a = existeOpt.get();
                    if (a.getHoraMarcacionSalida() != null) {
                        flash.addFlashAttribute("errorAsistencia","Ya registraste salida.");
                    } else {
                        LocalTime finTurno = turno.getHoraSalida();
                        // permitimos hasta 24 h después del fin de turno
                        if (ahora.isAfter(finTurno.plusHours(24))) {
                            flash.addFlashAttribute("errorAsistencia","Ventana de salida expirada.");
                        } else {
                            // marcación + programada salida
                            a.setHoraMarcacionSalida(ahora);
                            a.setHoraProgramadaSalida(turno.getHoraSalida());
                            a.setLatitudSalida(latitud);
                            a.setLongitudSalida(longitud);

                            // si se salió +30 min tarde de la entrada, marcar tarde
                            if (ahora.isAfter(turno.getHoraEntrada().plusMinutes(30))) {
                                a.setEstado(AsistenciaCoordinador.EstadoAsistencia.tarde);
                            }

                            asistenciaCoordinadorRepository.save(a);
                            flash.addFlashAttribute("mensajeAsistencia","Salida registrada con éxito.");
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            flash.addFlashAttribute("errorAsistencia","Error interno procesando la asistencia.");
        }

        return "redirect:/coordinador/home";
    }


// tu método calcularDistancia(...) permanece igual



    // — método auxiliar Haversine —
    private double calcularDistancia(double lat1,double lon1,double lat2,double lon2) {
        final int R = 6371;
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat/2)*Math.sin(dLat/2)
                + Math.cos(Math.toRadians(lat1))
                * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLon/2)*Math.sin(dLon/2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
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

    @ExceptionHandler
    public String handleException(Exception e, RedirectAttributes redirectAttributes) {
        e.printStackTrace(); // asegura log en consola
        redirectAttributes.addFlashAttribute("errorAsistencia", "Error interno: " + e.getMessage());
        return "redirect:/coordinador/home";
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
