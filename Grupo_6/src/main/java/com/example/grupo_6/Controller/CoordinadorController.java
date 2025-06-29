package com.example.grupo_6.Controller;
import com.example.grupo_6.Entity.AsistenciaCoordinador.EstadoAsistencia;

import com.example.grupo_6.Dto.CoordinadorPerfilDTO;
import com.example.grupo_6.Entity.*;
import com.example.grupo_6.Repository.*;
import com.example.grupo_6.Service.FileUploadService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
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
    private FileUploadService fileUploadService;
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

    @Transactional
    @PostMapping("/asistencia-dia/registrar")
    public String registrarAsistencia(
            @RequestParam BigDecimal latitud,
            @RequestParam BigDecimal longitud,
            @RequestParam Integer idsede,
            @RequestParam String accion,
            @RequestParam("id_coordinador_horario") Integer idCoordHorario,
            HttpSession session,
            RedirectAttributes flash
    ) {
        Usuario u = (Usuario) session.getAttribute("usuario");
        if (u == null) {
            System.out.println("[AUTH] Intento de acceso no autenticado");
            return "redirect:/login";
        }

        LocalDate ld = LocalDate.now();
        Date hoy = Date.valueOf(ld);
        LocalDateTime ahora = LocalDateTime.now();

        System.out.printf("[DEBUG] Usuario: %s - Acción: %s - Fecha: %s - IDsede: %d - IDHorario: %d - Lat: %s - Lon: %s%n",
                u.getEmail(), accion, hoy, idsede, idCoordHorario, latitud, longitud);

        // Validación de parámetros mejorada
        if (idsede == null || idCoordHorario == null || latitud == null || longitud == null ||
                (!"entrada".equals(accion) && !"salida".equals(accion))) {
            System.out.println("[VALIDATION] Parámetros inválidos recibidos");
            flash.addFlashAttribute("errorAsistencia", "Parámetros inválidos.");
            return "redirect:/coordinador/home";
        }

        // Verificación de sede con logs mejorados
        var sedeOpt = sedeRepository.findById(idsede);
        if (sedeOpt.isEmpty()) {
            System.out.printf("[SEDE] No se encontró sede con ID: %d%n", idsede);
            flash.addFlashAttribute("errorAsistencia", "Sede inválida.");
            return "redirect:/coordinador/home";
        }

        Sede sede = sedeOpt.get();
        if (sede.getLatitud() == null || sede.getLongitud() == null) {
            System.out.printf("[SEDE] Sede %d no tiene coordenadas definidas%n", idsede);
            flash.addFlashAttribute("errorAsistencia", "Sede no tiene ubicación definida.");
            return "redirect:/coordinador/home";
        }

        // Cálculo de distancia con precisión mejorada
        double dist = calcularDistancia(
                latitud.doubleValue(), longitud.doubleValue(),
                sede.getLatitud().doubleValue(), sede.getLongitud().doubleValue()
        );
        System.out.printf("[DISTANCE] Sede: %s - Distancia calculada: %.3f km%n", sede.getNombre(), dist);

        if (dist > 0.5) {
            System.out.printf("[DISTANCE] Usuario %s a %.3f km de la sede (límite 0.5 km)%n", u.getEmail(), dist);
            flash.addFlashAttribute("errorAsistencia", "Debes estar a menos de 500 m del local.");
            return "redirect:/coordinador/home";
        }

        // Obtención de turno con manejo mejorado de errores
        CoordinadorHorario turno;
        try {
            turno = coordinadorHorarioRepository.findById(idCoordHorario)
                    .orElseThrow(() -> new IllegalArgumentException("Turno no encontrado"));
            System.out.printf("[TURNO] Encontrado: ID=%d, Entrada=%s, Salida=%s, Activo=%s%n",
                    turno.getIdCoordinadorHorario(), turno.getHoraEntrada(), turno.getHoraSalida(), turno.isActivo());
        } catch (Exception e) {
            System.out.printf("[TURNO] Error al buscar turno ID %d: %s%n", idCoordHorario, e.getMessage());
            flash.addFlashAttribute("errorAsistencia", "Error al validar el turno.");
            return "redirect:/coordinador/home";
        }

        if (!turno.isActivo()) {
            System.out.printf("[TURNO] Turno ID %d no está activo%n", idCoordHorario);
            flash.addFlashAttribute("errorAsistencia", "Este día no tienes turno activo.");
            return "redirect:/coordinador/home";
        }

        // Búsqueda de asistencia existente
        var asistenciaOpt = asistenciaCoordinadorRepository
                .findByUsuario_IdusuarioAndFechaAndSede_Idsede(u.getIdusuario(), hoy, idsede);
        AsistenciaCoordinador asistencia = asistenciaOpt.orElse(null);

        if (asistencia != null) {
            System.out.printf("[ASISTENCIA] Asistencia existente encontrada: ID=%d%n", asistencia.getIdasistencia());
        }

        try {
            if ("entrada".equals(accion)) {
                asistencia = procesarEntrada(u, sede, hoy, ahora, turno, asistencia, latitud, longitud, flash);
            } else if ("salida".equals(accion)) {
                procesarSalida(u, ld, ahora, turno, asistencia, latitud, longitud, flash);
            }
        } catch (Exception e) {
            System.out.printf("[ERROR] Excepción inesperada: %s%n", e.getMessage());
            e.printStackTrace();
            flash.addFlashAttribute("errorAsistencia", "Error interno procesando la asistencia.");
        }

        return "redirect:/coordinador/home";
    }

    private AsistenciaCoordinador procesarEntrada(Usuario u, Sede sede, Date hoy, LocalDateTime ahora,
                                                  CoordinadorHorario turno, AsistenciaCoordinador asistencia,
                                                  BigDecimal latitud, BigDecimal longitud, RedirectAttributes flash) {
        if (asistencia != null && asistencia.getHoraMarcacionEntrada() != null) {
            System.out.println("[ENTRADA] Ya existe entrada registrada");
            flash.addFlashAttribute("errorAsistencia", "Ya registraste entrada.");
            return asistencia;
        }

        LocalTime inicioVentana = turno.getHoraEntrada().minusMinutes(50);
        LocalTime finVentana = turno.getHoraEntrada().plusMinutes(30);
        LocalTime horaActual = ahora.toLocalTime();

        System.out.printf("[VENTANA] Entrada permitida entre %s y %s | Hora actual: %s%n",
                inicioVentana, finVentana, horaActual);

        if (horaActual.isBefore(inicioVentana)) {
            System.out.println("[ENTRADA] Intento demasiado temprano");
            flash.addFlashAttribute("errorAsistencia", "Aún no puedes registrar entrada.");
            return asistencia;
        }

        if (horaActual.isAfter(finVentana)) {
            System.out.println("[ENTRADA] Intento demasiado tarde");
            flash.addFlashAttribute("errorAsistencia", "Ventana de entrada cerrada.");
            return asistencia;
        }

        if (asistencia == null) {
            asistencia = new AsistenciaCoordinador();
            asistencia.setUsuario(u);
            asistencia.setSede(sede);
            asistencia.setFecha(hoy);
            asistencia.setCoordinadorHorario(turno);
            System.out.println("[ENTRADA] Nueva asistencia creada");
        }

        asistencia.setHoraMarcacionEntrada(horaActual);
        asistencia.setHoraProgramadaEntrada(turno.getHoraEntrada());
        asistencia.setHoraProgramadaSalida(turno.getHoraSalida());
        asistencia.setLatitud(latitud);
        asistencia.setLongitud(longitud);

        if (horaActual.isAfter(turno.getHoraEntrada())) {
            asistencia.setEstado(AsistenciaCoordinador.EstadoAsistencia.tarde);
            System.out.println("[ENTRADA] Registrada como tarde");
        } else {
            asistencia.setEstado(AsistenciaCoordinador.EstadoAsistencia.presente);
            System.out.println("[ENTRADA] Registrada como presente");
        }

        System.out.println("[ENTRADA] Detalles antes de guardar:");
        System.out.printf(" - ID Horario: %d%n", turno.getIdCoordinadorHorario());
        System.out.printf(" - Hora programada: %s%n", turno.getHoraEntrada());
        System.out.printf(" - Estado: %s%n", asistencia.getEstado());

        AsistenciaCoordinador saved = asistenciaCoordinadorRepository.save(asistencia);
        System.out.println("[ENTRADA] Guardada exitosamente. ID: " + saved.getIdasistencia());
        flash.addFlashAttribute("mensajeAsistencia", "Entrada registrada con éxito.");

        return saved;
    }


    private void procesarSalida(Usuario u, LocalDate ld, LocalDateTime ahora,
                                CoordinadorHorario turno, AsistenciaCoordinador asistencia,
                                BigDecimal latitud, BigDecimal longitud, RedirectAttributes flash) {
        if (asistencia == null || asistencia.getHoraMarcacionEntrada() == null) {
            System.out.println("[SALIDA] No hay entrada previa registrada");
            flash.addFlashAttribute("errorAsistencia", "No hay entrada previa para hoy.");
            return;
        }

        if (asistencia.getHoraMarcacionSalida() != null) {
            System.out.println("[SALIDA] Ya existe salida registrada");
            flash.addFlashAttribute("errorAsistencia", "Ya registraste salida.");
            return;
        }

        LocalDateTime finTurno = LocalDateTime.of(ld, turno.getHoraSalida());
        System.out.printf("[SALIDA] Hora programada: %s | Hora actual: %s%n", finTurno, ahora);

        if (ahora.isAfter(finTurno.plusHours(24))) {
            System.out.println("[SALIDA] Fuera de ventana permitida (24h después)");
            flash.addFlashAttribute("errorAsistencia", "Ventana de salida expirada.");
            return;
        }

        asistencia.setHoraMarcacionSalida(ahora.toLocalTime());
        asistencia.setHoraProgramadaSalida(turno.getHoraSalida());
        asistencia.setLatitudSalida(latitud);
        asistencia.setLongitudSalida(longitud);

        AsistenciaCoordinador saved = asistenciaCoordinadorRepository.save(asistencia);
        System.out.println("[SALIDA] Guardada exitosamente. ID: " + saved.getIdasistencia());
        flash.addFlashAttribute("mensajeAsistencia", "Salida registrada con éxito.");
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
    public String detalleReserva(@PathVariable Integer idreserva, Model model) {
        // 1) Obtener reserva o 404
        Reserva reserva = reservaRepository.findById(idreserva)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));

        // 2) Incidencias asociadas
        List<Incidencia> listaIncidencias =
                incidenciaRepository.findAllByReserva_Idreserva(idreserva);

        // 3) DESCARGAR la imagen desde S3 y construir Data-URI
        String fotoKey = reserva.getUsuario().getImagen(); // campo "imagen" en tu entidad
        if (fotoKey != null && !fotoKey.isBlank()) {
            try {
                byte[] bytes = fileUploadService.descargarArchivo(fotoKey);
                String mime = fileUploadService.obtenerMimeDesdeKey(fotoKey);
                String base64 = Base64.getEncoder().encodeToString(bytes);
                String fotoDataUrl = "data:" + mime + ";base64," + base64;
                model.addAttribute("fotoDataUrl", fotoDataUrl);
            } catch (RuntimeException e) {
                // Opcional: loguear o dejar fotoDataUrl ausente si falla la descarga
                System.err.println("No se pudo descargar foto: " + e.getMessage());
            }
        }

        // 4) Inyectar resto de atributos
        model.addAttribute("reserva", reserva);
        model.addAttribute("incidencias", listaIncidencias);

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

    // CoordinadorController.java

    @GetMapping("/reservas-hoy")
    public String verReservasDeSede(
            @RequestParam(required = false) Integer sedeId,
            @RequestParam(required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
            LocalDate fecha,                            // null = todas las fechas
            @RequestParam(defaultValue = "0") int page,
            Model model,
            HttpSession session) {

        // 1. Autenticación
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) {
            return "redirect:/login";
        }

        // 2. Obtener sedes asignadas al coordinador
        List<CoordinadorSede> asignaciones =
                coordinadorSedeRepository
                        .findByUsuario_IdusuarioAndActivoTrue(usuario.getIdusuario());

        if (asignaciones.isEmpty()) {
            model.addAttribute("mensaje", "No estás asignado a ninguna sede.");
            model.addAttribute("reservas", Page.empty());
            model.addAttribute("sedesAsignadas", List.of());
            return "coordinador/coordinador_reservas_hoy";
        }

        List<Sede> sedesAsignadas = asignaciones.stream()
                .map(CoordinadorSede::getSede)
                .toList();

        // 3. Determinar lista de IDs de sede según filtro (o todas si sedeId == null)
        List<Integer> idsSede = (sedeId != null)
                ? List.of(sedeId)
                : sedesAsignadas.stream()
                .map(Sede::getIdsede)
                .toList();

        // 4. Paginación
        Pageable pageable = PageRequest.of(page, 10);

        // 5. Búsqueda de reservas: estado=2 (aprobado), fecha opcional
        Page<Reserva> reservas = reservaRepository.buscarReservasAprobadas(
                idsSede,
                fecha,       // si es null → todas las fechas
                2,           // ID de estado “aprobado”
                pageable
        );

        // 6. Inyectar atributos al modelo para Thymeleaf
        model.addAttribute("reservas", reservas);
        model.addAttribute("sedesAsignadas", sedesAsignadas);
        model.addAttribute("filtroSedeId", sedeId);
        model.addAttribute("filtroFecha", fecha);

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
