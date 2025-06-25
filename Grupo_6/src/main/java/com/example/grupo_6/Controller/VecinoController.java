package com.example.grupo_6.Controller;
import com.example.grupo_6.Dto.ServicioSimplificado;
import com.example.grupo_6.Dto.VecinoPerfilDTO;
import com.example.grupo_6.Entity.*;
import com.example.grupo_6.Repository.UsuarioRepository;
import com.example.grupo_6.Repository.ServicioRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.*;
import com.example.grupo_6.Repository.SedeServicioRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import com.example.grupo_6.Entity.Reserva;
import com.example.grupo_6.Repository.ReservaRepository;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.math.BigDecimal;
import java.net.URLConnection;
import java.sql.Timestamp;
import java.util.Optional;
import java.util.stream.Collectors;
import com.example.grupo_6.Repository.PagoRepository;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.List;
import java.util.ArrayList;
import jakarta.servlet.http.HttpSession;
import com.example.grupo_6.Repository.SedeRepository;
import com.example.grupo_6.Entity.Usuario;
import com.example.grupo_6.Repository.HorarioDisponibleRepository;
import java.time.LocalDate;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import com.example.grupo_6.Repository.ReservaRepository;
import java.time.LocalDate;
import java.time.LocalDateTime;
import com.example.grupo_6.Entity.Estado.TipoAplicacion;
import com.example.grupo_6.Repository.EstadoRepository ;
import java.util.Map;
import java.util.HashMap;
import org.springframework.format.annotation.DateTimeFormat;
import com.example.grupo_6.Entity.*;
import com.example.grupo_6.Repository.*;
import com.example.grupo_6.Dto.ServicioPorSedeDTO;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;import java.time.ZonedDateTime;
import java.time.ZoneId;
import java.time.LocalDateTime;



@Controller
@RequestMapping("/vecino")
public class VecinoController {
    @Autowired
    private EstadoRepository estadoRepository;
    @Autowired
    private ServicioRepository servicioRepository;
    @Autowired
    private SedeServicioRepository sedeServicioRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private SedeRepository sedeRepository;
    @Autowired
    private ReservaRepository reservaRepository;
    @Autowired
    private PagoRepository pagoRepository;

    @Autowired
    private HorarioDisponibleRepository horarioDisponibleRepository;

    // Temporal: en el futuro usar autenticación real

    // --- Vista principal ---
    @GetMapping
    public String vecinoHome(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) {
            System.out.println("🔴 Usuario no encontrado en sesión");
            return "redirect:/login";
        }

        System.out.println("🟢 Usuario en sesión: " + usuario.getNombres());

        model.addAttribute("rol", "vecino");
        model.addAttribute("usuario", usuario);
        return "vecino/vecino_home";
    }



    // --- Vista de perfil ---
    @GetMapping("/perfil")
    public String mostrarPerfil(Model model, HttpSession session) {
        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
        if (usuarioSesion == null) {
            return "redirect:/login";
        }
        System.out.println("🟢 ID del usuario en sesión: " + usuarioSesion.getIdusuario());
        VecinoPerfilDTO perfil = usuarioRepository.obtenerPerfilVecinoPorId(usuarioSesion.getIdusuario());
        model.addAttribute("perfil", perfil);
        model.addAttribute("rol", "vecino");
        return "vecino/vecino_perfil";
    }



    // --- Actualizar información del perfil ---
    @PostMapping("/perfil/actualizar")
    @Transactional
    public String actualizarPerfil(@RequestParam("correo") String correo,
                                   @RequestParam("telefono") String telefono,
                                   @RequestParam("direccion") String direccion,
                                   RedirectAttributes attr,
                                   HttpSession session) {

        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
        if (usuarioSesion == null) {
            return "redirect:/login";
        }

        // Validación manual de correo
        if (!correo.matches("^[\\w.-]+@(gmail\\.com|outlook\\.com|hotmail\\.com|pucp\\.edu\\.pe)$")) {
            attr.addFlashAttribute("error", "Solo se permiten correos @gmail.com, @outlook.com, @hotmail.com o @pucp.edu.pe.");
            return "redirect:/vecino/perfil";
        }

        // Validación de teléfono (9 dígitos)
        if (!telefono.matches("^\\d{9}$")) {
            attr.addFlashAttribute("error", "El número de celular debe tener 9 dígitos.");
            return "redirect:/vecino/perfil";
        }

        Usuario usuario = usuarioRepository.findById(usuarioSesion.getIdusuario()).orElse(null);
        if (usuario != null) {
            usuario.setEmail(correo);
            usuario.setTelefono(telefono);
            usuario.setDireccion(direccion);
            usuarioRepository.save(usuario);
        }

        attr.addFlashAttribute("success", "Perfil actualizado correctamente.");
        return "redirect:/vecino/perfil";
    }


    // --- Cambiar contraseña ---
    @GetMapping("/cambiar-contrasena")
    public String mostrarFormularioCambioClave(Model model) {
        model.addAttribute("rol", "vecino");
        return "vecino/vecino_cambiar_contrasena";
    }

    @PostMapping("/perfil/cambiar-password")
    @Transactional
    public String cambiarPassword(@RequestParam("actual") String actual,
                                  @RequestParam("nuevaClave") String nuevaClave,
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {
        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
        if (usuarioSesion == null) return "redirect:/login";

        Usuario usuario = usuarioRepository.findById(usuarioSesion.getIdusuario()).orElse(null);
        if (usuario != null) {
            boolean correcta = passwordEncoder.matches(actual, usuario.getPasswordHash());
            if (!correcta) {
                redirectAttributes.addFlashAttribute("mensajeError", "La contraseña actual es incorrecta.");
                return "redirect:/vecino/cambiar-contrasena";
            }

            usuario.setPasswordHash(passwordEncoder.encode(nuevaClave));
            usuarioRepository.save(usuario);
            redirectAttributes.addFlashAttribute("mensajeExito", "Contraseña actualizada exitosamente.");
        }

        return "redirect:/vecino/perfil";
    }


    @GetMapping("/ListaComplejoDeportivo")
    public String mostrarComplejosPorTipo(@RequestParam("idtipo") int idtipo, Model model) {
        List<ServicioSimplificado> complejos = sedeServicioRepository.listarServiciosSimplificadosPorTipo(idtipo);

        // Debug temporal
        for (ServicioSimplificado c : complejos) {
            System.out.println("ID: " + c.getIdServicio() +
                    " | Nombre: " + c.getNombreServicio() +
                    " | Imagen: /vecino/imagen/" + c.getIdServicio());
        }

        model.addAttribute("complejos", complejos);
        return "vecino/vecino_ListaComplejoDeportivo";
    }




    @GetMapping("/imagen/{id}")
    @ResponseBody
    public ResponseEntity<byte[]> mostrarImagen(@PathVariable("id") Integer id) {
        Optional<Servicio> servicioOpt = servicioRepository.findById(id);

        if (servicioOpt.isPresent()) {
            Servicio servicio = servicioOpt.get();
            System.out.println("Servicio encontrado: " + servicio.getNombre());

            byte[] imagen = servicio.getImagenComplejo();
            if (imagen != null && imagen.length > 0) {
                System.out.println("Imagen encontrada, tamaño: " + imagen.length);

                MediaType mediaType = MediaType.APPLICATION_OCTET_STREAM;
                try {
                    String mimeType = URLConnection.guessContentTypeFromStream(new ByteArrayInputStream(imagen));
                    if (mimeType != null) {
                        mediaType = MediaType.parseMediaType(mimeType);
                    }
                } catch (IOException ignored) {}

                HttpHeaders headers = new HttpHeaders();
                headers.setContentType(mediaType);
                return new ResponseEntity<>(imagen, headers, HttpStatus.OK);
            } else {
                System.out.println("Servicio con ID " + id + " no tiene imagen.");
            }
        } else {
            System.out.println("Servicio no encontrado con ID: " + id);
        }

        return ResponseEntity.notFound().build();
    }






    @GetMapping("/complejo/detalle/{id}")
    public String descripcionComplejo(@PathVariable("id") Integer id, Model model) {
        Optional<SedeServicio> optional = sedeServicioRepository.findById(id);
        if (optional.isPresent()) {
            SedeServicio sedeServicio = optional.get();
            model.addAttribute("sedeServicio", sedeServicio);

            List<HorarioDisponible> horarios = horarioDisponibleRepository.buscarPorSedeServicioId(
                    sedeServicio.getSede().getIdsede(),
                    sedeServicio.getServicio().getIdservicio()
            );
            model.addAttribute("horarios", horarios);

            return "vecino/vecino_DescripcionComplejoDeportivo";
        } else {
            return "redirect:/vecino";
        }
    }

    @GetMapping("/reservas")
    public String listarReservas(Model model, HttpSession session) {
        Integer idUsuario = (Integer) session.getAttribute("idusuario");
        List<Reserva> reservas = reservaRepository.findByUsuarioIdusuario(idUsuario);
        model.addAttribute("listaReservas", reservas);
        model.addAttribute("reserva", new Reserva());
        return "vecino/vecino_reservas";
    }

    @GetMapping("/reservas/nueva")
    public String nuevaReserva(@RequestParam("idSedeServicio") Integer idSedeServicio,
                               Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";

        SedeServicio ss = sedeServicioRepository.findById(idSedeServicio).orElse(null);
        if (ss == null) return "redirect:/vecino";
        int idtipo = ss.getServicio().getTipoServicio().getIdtipo();
        model.addAttribute("idtipoActivo", idtipo);
        // Verifica si ya tiene una reserva activa en esa sede
        List<Reserva> reservasActivas = reservaRepository
                .findByUsuario_IdusuarioAndSedeServicio_IdSedeServicio(usuario.getIdusuario(), idSedeServicio)
                .stream()
                .filter(r -> r.getEstado().getIdestado() == 1 || r.getEstado().getIdestado() == 2)
                .toList();

        if (!reservasActivas.isEmpty()) {
            int estado = reservasActivas.get(0).getEstado().getIdestado();

            model.addAttribute("reservaBloqueada", true);

            if (estado == 1) {
                model.addAttribute("mensajeBloqueoPrincipal", "Usted tiene una reserva pendiente.");
                model.addAttribute("modalColor", "warning");
            } else {
                model.addAttribute("mensajeBloqueoPrincipal", "Usted presenta una reserva registrada.");
                model.addAttribute("mensajeBloqueoSecundario", "Llame al número de soporte para más información.");
                model.addAttribute("modalColor", "success");
            }
        }


        else {
            model.addAttribute("reservaBloqueada", false);
        }

        Reserva reserva = new Reserva();
        reserva.setSedeServicio(ss);

        model.addAttribute("reserva", reserva);
        model.addAttribute("listaSedes", sedeRepository.findAll());
        model.addAttribute("listaHorarios", horarioDisponibleRepository.findByActivoTrue());

        return "vecino/vecino_FormularioReservas";
    }



    @PostMapping("/reservas/guardar")
    public String guardarReserva(@ModelAttribute("reserva") Reserva reserva,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes,
                                 Model model) {

        Integer idUsuario = (Integer) session.getAttribute("idusuario");
        Usuario usuario = usuarioRepository.findById(idUsuario).orElse(null);

        Estado estadoPendienteReserva = estadoRepository.findById(1).orElse(null); // Estado ID 1 = "pendiente"
        Estado estadoPendientePago = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.pago);

        Integer idSedeServicio = reserva.getSedeServicio().getIdSedeServicio();
        Integer idHorario = reserva.getHorarioDisponible().getIdhorario();

        SedeServicio sedeServicio = sedeServicioRepository.findById(idSedeServicio).orElse(null);
        HorarioDisponible horario = horarioDisponibleRepository.findById(idHorario).orElse(null);

        if (usuario != null && sedeServicio != null && horario != null && estadoPendienteReserva != null && estadoPendientePago != null) {

            Pago pago = new Pago();
            pago.setUsuario(usuario);
            pago.setMetodo(Pago.Metodo.banco);
            pago.setMonto(BigDecimal.valueOf(sedeServicio.getTarifa().getMonto()));
            pago.setEstado(estadoPendientePago);
            pago.setFechaPago(null);
            pagoRepository.save(pago);

            reserva.setUsuario(usuario);
            reserva.setFechaCreacion(LocalDateTime.now());
            reserva.setFechaLimitePago(reserva.getFechaCreacion().plusHours(4));
            reserva.setPago(pago);
            reserva.setSedeServicio(sedeServicio);
            reserva.setHorarioDisponible(horario);
            reserva.setEstado(estadoPendienteReserva); // siempre será pendiente



            reservaRepository.save(reserva);

            Notificacion noti = new Notificacion();
            noti.setUsuario(usuario);
            noti.setTitulo("Reserva registrada");
            noti.setMensaje("Tu reserva en " + reserva.getSedeServicio().getServicio().getNombre() +
                    " ha sido registrada para el día " + reserva.getFechaReserva() +
                    " a las " + reserva.getHorarioDisponible().getHoraInicio() + ".");
            noti.setLeido(false);
            noti.setFechaEnvio(Timestamp.valueOf(LocalDateTime.now()));
            noti.setTipo("reserva");
            noti.setIdReferencia(reserva.getIdreserva());

            notificacionRepository.save(noti);


            model.addAttribute("hoy", LocalDate.now());

            model.addAttribute("reserva", reserva);
            model.addAttribute("usuario", usuario);
            model.addAttribute("servicio", sedeServicio.getServicio());
            System.out.println("Mostrando vista pendiente...");
            return "vecino/vecino_ReservaPendiente";

        } else {
            redirectAttributes.addFlashAttribute("mensajeError", "Error al crear la reserva. Verifique los datos.");
            return "redirect:/vecino/reservas";
        }
    }


    @GetMapping("/reservas/api/servicios-por-sede/{idSede}")
    @ResponseBody
    public List<ServicioPorSedeDTO> obtenerServiciosPorSede(@PathVariable("idSede") Integer idSede) {
        return sedeServicioRepository.obtenerServiciosPorSede(idSede);
    }

    @GetMapping("/reservas/api/horarios-disponibles")
    @ResponseBody
    public List<HorarioDisponible> obtenerHorariosDisponibles(
            @RequestParam("sedeServicioId") Integer sedeServicioId,
            @RequestParam("fecha") String fecha) {

        SedeServicio sedeServicio = sedeServicioRepository.findById(sedeServicioId).orElse(null);

        if (sedeServicio == null) return List.of();

        Integer idSede = sedeServicio.getSede().getIdsede();
        Integer idServicio = sedeServicio.getServicio().getIdservicio();

        return horarioDisponibleRepository.buscarPorSedeServicioId(idSede, idServicio);
    }




    @PostMapping("/reservas/comprobante")
    public String subirComprobante(@RequestParam("idpago") Integer idPago,
                                   @RequestParam("comprobante") MultipartFile file,
                                   RedirectAttributes redirectAttributes) {
        try {
            Pago pago = pagoRepository.findById(idPago).orElse(null);

            if (pago == null) {
                redirectAttributes.addFlashAttribute("mensajeError", "Pago no encontrado.");
                return "redirect:/vecino/reservas";
            }

            if (file.isEmpty()) {
                redirectAttributes.addFlashAttribute("mensajeError", "Debe seleccionar un archivo.");
                return "redirect:/vecino/reservas";
            }

            String tipo = file.getContentType();
            if (tipo == null || (!tipo.equals("image/jpeg") && !tipo.equals("image/png"))) {
                redirectAttributes.addFlashAttribute("mensajeError", "Archivo no permitido. Solo se aceptan imágenes JPG o PNG.");
                return "redirect:/vecino/reservas";
            }

            String nombreArchivo = file.getOriginalFilename();
            if (nombreArchivo == null || !nombreArchivo.toLowerCase().matches(".*\\.(jpg|jpeg|png)$")) {
                redirectAttributes.addFlashAttribute("mensajeError", "Extensión de archivo no válida. Solo JPG o PNG.");
                return "redirect:/vecino/reservas";
            }

            if (file.getSize() > 2 * 1024 * 1024) {
                redirectAttributes.addFlashAttribute("mensajeError", "El archivo excede el tamaño máximo (2 MB).");
                return "redirect:/vecino/reservas";
            }

            // Hasta aquí, el archivo es válido
            pago.setComprobante(file.getBytes());
            pago.setFechaPago(LocalDateTime.now());
            pagoRepository.save(pago);

            redirectAttributes.addFlashAttribute("mensajeExito", "Comprobante enviado con éxito.");

        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("mensajeError", "Error al procesar el archivo.");
            e.printStackTrace();
        }

        return "redirect:/vecino/reservas";
    }



    @GetMapping("/reservas/historial")
    public String verHistorialReservas(Model model, HttpSession session) {
        Integer idUsuario = (Integer) session.getAttribute("idusuario");
        List<Reserva> reservas = reservaRepository.findByUsuario_Idusuario(idUsuario);
        model.addAttribute("listaReservas", reservas);
        return "vecino/vecino_reservas";
    }




    // 🔔 Repositorio de notificaciones
    @Autowired
    private NotificacionRepository notificacionRepository;

    // 🔔 Método para vista de notificaciones
    @GetMapping("/notificaciones")
    public String verNotificaciones(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";

        List<Notificacion> lista = notificacionRepository.findByUsuario_IdusuarioOrderByFechaEnvioDesc(usuario.getIdusuario());
        model.addAttribute("notificaciones", lista);
        model.addAttribute("rol", "vecino");
        return "vecino/vecino_notificaciones";
    }

    // 🔔 Método para contar notificaciones no leídas y mostrarlas en el navbar
    @ModelAttribute
    public void cargarNotificacionesNavbar(HttpSession session, Model model) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario != null) {
            long sinLeer = notificacionRepository.countByUsuario_IdusuarioAndLeidoFalse(usuario.getIdusuario());
            model.addAttribute("notificacionesNoLeidas", sinLeer);
        }
    }




    @GetMapping("/reservas/{id}")
    public String verDetalleReserva(@PathVariable("id") Integer id, Model model, HttpSession session) {
        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
        if (usuarioSesion == null) return "redirect:/login";

        Optional<Reserva> opt = reservaRepository.findById(id);
        if (opt.isEmpty() || !opt.get().getUsuario().getIdusuario().equals(usuarioSesion.getIdusuario())) {
            return "redirect:/vecino/reservas";
        }

        Reserva reserva = opt.get();
        model.addAttribute("reserva", reserva);
        model.addAttribute("rol", "vecino");

        ZonedDateTime ahoraZonificado = ZonedDateTime.now(ZoneId.of("America/Lima"));
        model.addAttribute("ahora", ahoraZonificado.toLocalDateTime());


        return "vecino/vecino_detalle_reserva";
    }


    @GetMapping("/comprobante/{idPago}")
    @ResponseBody
    public ResponseEntity<byte[]> mostrarComprobante(@PathVariable("idPago") Integer idPago) {
        Optional<Pago> pagoOpt = pagoRepository.findById(idPago);

        if (pagoOpt.isPresent() && pagoOpt.get().getComprobante() != null) {
            byte[] comprobante = pagoOpt.get().getComprobante();

            MediaType mediaType = MediaType.IMAGE_JPEG;
            try {
                String mimeType = URLConnection.guessContentTypeFromStream(new ByteArrayInputStream(comprobante));
                if (mimeType != null) {
                    mediaType = MediaType.parseMediaType(mimeType);
                }
            } catch (IOException ignored) {}

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(mediaType);
            return new ResponseEntity<>(comprobante, headers, HttpStatus.OK);
        }

        return ResponseEntity.notFound().build();
    }

    // 🔔 Ver detalle y marcar como leída
    @GetMapping("/notificaciones/{id}/leer")
    public String leerNotificacion(@PathVariable("id") Integer id, HttpSession session) {
        Integer idusuario = (Integer) session.getAttribute("idusuario");
        Optional<Notificacion> optional = notificacionRepository.findById(id);
        if (optional.isPresent()) {
            Notificacion noti = optional.get();
            if (noti.getUsuario().getIdusuario().equals(idusuario)) {
                noti.setLeido(true);
                notificacionRepository.save(noti);
            }
        }
        return "redirect:/vecino/notificaciones";
    }


    // 🔔 Marcar todas como leídas
    @PostMapping("/notificaciones/marcar-todo")
    public String marcarTodasComoLeidas(HttpSession session) {
        Integer idusuario = (Integer) session.getAttribute("idusuario");
        notificacionRepository.marcarTodasComoLeidas(idusuario);
        return "redirect:/vecino/notificaciones";
    }


    @PostMapping("/notificaciones/{id}/eliminar")
    public String eliminarNotificacion(@PathVariable("id") Integer id, HttpSession session) {
        Integer idusuario = (Integer) session.getAttribute("idusuario");
        Optional<Notificacion> optional = notificacionRepository.findById(id);
        if (optional.isPresent() && optional.get().getUsuario().getIdusuario().equals(idusuario)) {
            notificacionRepository.deleteById(id);
        }
        return "redirect:/vecino/notificaciones";
    }

    @PostMapping("/notificaciones/eliminar-todo")
    public String eliminarTodasNotificaciones(HttpSession session) {
        Integer idusuario = (Integer) session.getAttribute("idusuario");
        notificacionRepository.deleteByUsuario_Idusuario(idusuario);
        return "redirect:/vecino/notificaciones";
    }

    @GetMapping("/notificaciones/{id}/ver")
    public String verContenidoNotificacion(@PathVariable("id") Integer id, HttpSession session, Model model) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";

        Optional<Notificacion> optional = notificacionRepository.findById(id);
        if (optional.isPresent()) {
            Notificacion noti = optional.get();
            if (noti.getUsuario().getIdusuario().equals(usuario.getIdusuario())) {
                noti.setLeido(true);
                notificacionRepository.save(noti);

                if ("reserva".equals(noti.getTipo()) && noti.getIdReferencia() != null) {
                    return "redirect:/vecino/reservas/" + noti.getIdReferencia();
                }
            }
        }
        return "redirect:/vecino/notificaciones";
    }

    @GetMapping("/vecino/home")
    public String home(HttpSession session, Model model) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario == null) {
            return "redirect:/login";
        }

        return "vecino/vecino_home";
    }
    @GetMapping("/vecino/ListaComplejoDeportivo")
    public String listaPorTipo(@RequestParam("idtipo") int idtipo, Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";

        model.addAttribute("usuario", usuario); // ✅ sigue siendo necesario
        model.addAttribute("idtipoActivo", idtipo); // ✅ esto es lo que usa el sidebar
        return "vecino/vecino_ListaComplejoDeportivo";
    }


}
