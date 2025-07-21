package com.example.grupo_6.Controller;
import com.example.grupo_6.Dto.ServicioComplejoDTO;
import com.example.grupo_6.Dto.ServicioSimplificado;
import com.example.grupo_6.Dto.VecinoPerfilDTO;
import com.example.grupo_6.Entity.*;
import com.example.grupo_6.Repository.UsuarioRepository;
import com.example.grupo_6.Repository.ServicioRepository;
import com.example.grupo_6.Service.EmailService;
import com.example.grupo_6.Service.FileUploadService;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StreamUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import com.example.grupo_6.Repository.SedeServicioRepository;
import com.example.grupo_6.Entity.Reserva;
import com.example.grupo_6.Repository.ReservaRepository;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.math.BigDecimal;
import java.net.URLConnection;
import java.sql.Timestamp;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;
import com.example.grupo_6.Repository.PagoRepository;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.servlet.http.HttpSession;
import com.example.grupo_6.Repository.SedeRepository;
import com.example.grupo_6.Entity.Usuario;
import com.example.grupo_6.Repository.HorarioDisponibleRepository;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import com.example.grupo_6.Repository.ReservaRepository;
import java.time.LocalDate;
import java.time.LocalDateTime;
import com.example.grupo_6.Entity.Estado.TipoAplicacion;
import com.example.grupo_6.Repository.EstadoRepository ;
import org.springframework.format.annotation.DateTimeFormat;
import com.example.grupo_6.Entity.*;
import com.example.grupo_6.Repository.*;
import com.example.grupo_6.Dto.ServicioPorSedeDTO;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.time.LocalDateTime;

import static com.example.grupo_6.Entity.Estado.TipoAplicacion.pago;


@Controller
@RequestMapping("/vecino")
public class VecinoController {
    @Autowired
    private EstadoRepository estadoRepository;
    @Autowired
    private FileUploadService fileUploadService;

    @Autowired
    private TarjetaVirtualRepository tarjetaVirtualRepository;
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
    private EmailService emailService;

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

        List<Sede> sedes = sedeRepository.findByActivoTrue();
        model.addAttribute("sedes", sedes);

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

        // Traemos sólo los campos definidos en VecinoPerfilDTO
        VecinoPerfilDTO perfil = usuarioRepository
                .obtenerPerfilVecinoPorId(usuarioSesion.getIdusuario());

        // Lógica para permitir cambio de foto sólo una vez por día
        LocalDate today = LocalDate.now(ZoneId.of("America/Lima"));
        LocalDate lastUpdate =
                perfil.getPhotoUpdatedAt() == null
                        ? LocalDate.MIN
                        : perfil.getPhotoUpdatedAt().toLocalDate();
        boolean canChangePhoto = lastUpdate.isBefore(today);


        model.addAttribute("perfil", perfil);
        model.addAttribute("canChangePhoto", canChangePhoto);
        model.addAttribute("rol", "vecino");
        System.out.println("Teléfono obtenido de BD: " + perfil.getTelefono()); // Debug
        System.out.println("Longitud teléfono: " + (perfil.getTelefono() != null ? perfil.getTelefono().length() : "null")); // Debug
        return "vecino/vecino_perfil";
    }



    // --- Actualizar información del perfil ---
    @PostMapping("/perfil/actualizar")
    @Transactional
    public String actualizarPerfil(
            @RequestParam("correo")    String correo,
            @RequestParam("telefono")  String telefono,
            @RequestParam("direccion") String direccion,
            @RequestParam(value = "foto", required = false) MultipartFile foto,
            RedirectAttributes attr,
            HttpSession session
    ) throws IOException {
        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
        if (usuarioSesion == null) {
            return "redirect:/login";
        }

        Usuario usuario = usuarioRepository
                .findById(usuarioSesion.getIdusuario())
                .orElseThrow();

        // Validación de teléfono
        telefono = telefono.replaceAll("\\D", "");
        if (telefono.length() != 9) {
            attr.addFlashAttribute("error", "El celular debe tener exactamente 9 dígitos");
            attr.addFlashAttribute("telefono", telefono);
            return "redirect:/vecino/perfil";
        }

        // Validación de correo
        if (!correo.matches("^[\\w.-]+@(gmail\\.com|outlook\\.com|hotmail\\.com|pucp\\.edu\\.pe)$")) {
            attr.addFlashAttribute("error", "Dominio de correo inválido.");
            return "redirect:/vecino/perfil";
        }

        // ---- FOTO: Procesar solo si el usuario ha seleccionado una nueva ----
        if (foto != null && !foto.isEmpty()) {
            LocalDate hoy = LocalDate.now(ZoneId.of("America/Lima"));
            LocalDate last = usuario.getPhotoUpdatedAt() == null
                    ? LocalDate.MIN
                    : usuario.getPhotoUpdatedAt().toLocalDate();

            if (!last.isBefore(hoy)) {
                // No bloquear el formulario, solo advertir que la foto no se puede cambiar
                attr.addFlashAttribute("warning", "No puedes cambiar tu foto hoy, pero tus datos se actualizaron.");
            } else {
                // Subir la nueva foto
                String ext = StringUtils.getFilenameExtension(foto.getOriginalFilename());
                String fileName = usuario.getIdusuario() + "." + ext;
                fileUploadService.subirArchivoSobrescribible(foto, "usuarios", fileName);
                usuario.setImagen(fileName);
                usuario.setPhotoUpdatedAt(LocalDateTime.now(ZoneId.of("America/Lima")));
            }
        }

        // Guardar datos básicos (siempre se actualizan)
        usuario.setEmail(correo);
        usuario.setTelefono(telefono);
        usuario.setDireccion(direccion);
        usuarioRepository.save(usuario);

        // Actualizar sesión
        session.setAttribute("usuario", usuario);

        if (!attr.getFlashAttributes().containsKey("warning")) {
            attr.addFlashAttribute("success", "Perfil actualizado correctamente.");
        }

        return "redirect:/vecino/perfil";
    }

    @GetMapping("/imagen/{id}")
    public ResponseEntity<byte[]> verImagenSede(@PathVariable("id") Integer idSede) {

        // buscar la sede directamente
        Sede sede = sedeRepository.findById(idSede)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));

        String nombreArchivo = sede.getImagen();
        if (nombreArchivo == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }

        byte[] data;
        try {
            data = fileUploadService
                    .descargarArchivoSobrescribible("sedes", nombreArchivo);
        } catch (Exception e) {
            throw new ResponseStatusException(
                    HttpStatus.INTERNAL_SERVER_ERROR, "No se pudo leer la imagen", e);
        }

        String mime = URLConnection.guessContentTypeFromName(nombreArchivo);
        if (mime == null) mime = "application/octet-stream";

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(mime))
                .cacheControl(CacheControl.noStore())
                .body(data);
    }


    @GetMapping("/imagen-servicio-sede/{id}")
    public ResponseEntity<byte[]> verImagenServicioSede(
            @PathVariable("id") Integer idSedeServicio) {

        SedeServicio ss = sedeServicioRepository.findById(idSedeServicio)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));

        String nombreArchivo = ss.getImagen();
        if (nombreArchivo == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }

        byte[] data;
        try {
            data = fileUploadService
                    .descargarArchivoSobrescribible("servicio-sede", nombreArchivo);
        } catch (Exception e) {
            throw new ResponseStatusException(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "Error al leer la imagen", e);
        }

        String mime = URLConnection.guessContentTypeFromName(nombreArchivo);
        if (mime == null) mime = "application/octet-stream";

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(mime))
                .cacheControl(CacheControl.noStore())
                .body(data);
    }

    // --- Servir la foto de perfil desde S3 ---

    @GetMapping("/perfil/photo")
    public ResponseEntity<byte[]> verFoto(HttpSession session) {
        System.out.println(">> verFoto: inicio");

        // 1) comprueba sesión
        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
        if (usuarioSesion == null) {
            System.out.println("[WARN] verFoto: no hay usuario en sesión");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        System.out.printf("verFoto: usuario en sesión id=%d%n", usuarioSesion.getIdusuario());

        // 2) carga entidad desde BD
        Usuario usuario = usuarioRepository.findById(usuarioSesion.getIdusuario())
                .orElse(null);
        if (usuario == null) {
            System.out.printf("[WARN] verFoto: no existe Usuario id=%d%n", usuarioSesion.getIdusuario());
            return ResponseEntity.notFound().build();
        }
        if (usuario.getImagen() == null) {
            System.out.printf("[WARN] verFoto: usuario %d sin imagen asignada%n", usuario.getIdusuario());
            return ResponseEntity.notFound().build();
        }
        System.out.printf("verFoto: imagen encontrada para usuario %d => key='%s'%n",
                usuario.getIdusuario(), usuario.getImagen());

        // 3) descarga bytes desde S3
        byte[] data;
        try {
            data = fileUploadService
                    .descargarArchivoSobrescribible("usuarios", usuario.getImagen());
            System.out.printf("verFoto: bytes descargados = %d%n", data != null ? data.length : 0);
        } catch (Exception e) {
            System.out.printf("[ERROR] verFoto: error al descargar de S3: %s%n", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }

        // 4) detecta MIME y prepara headers
        String mime = URLConnection.guessContentTypeFromName(usuario.getImagen());
        if (mime == null) {
            mime = "application/octet-stream";
        }
        System.out.printf("verFoto: MIME detectado = %s%n", mime);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType(mime));
        headers.setCacheControl(CacheControl.noStore());
        System.out.println("<< verFoto: devolviendo respuesta OK");

        // 5) responde
        return new ResponseEntity<>(data, headers, HttpStatus.OK);
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
        List<ServicioComplejoDTO> complejos = sedeServicioRepository
                .listarServiciosPorTipoConNombre(idtipo);
        model.addAttribute("complejos", complejos);
        return "vecino/vecino_ListaComplejoDeportivo";
    }

    @GetMapping("/sede/{id}/servicios")
    public String mostrarServiciosPorSede(@PathVariable("id") Integer idSede, Model model) {
        System.out.println("🟢 Entrando a mostrarServiciosPorSede con id: " + idSede);

        List<SedeServicio> servicios = sedeServicioRepository.findBySede_IdsedeAndActivoTrue(idSede);
        model.addAttribute("servicios", servicios);

        Sede sede = sedeRepository.findById(idSede).orElse(null);
        model.addAttribute("sede", sede);

        return "vecino/vecino_SedeServicios"; // Verifica que el archivo exista
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

            // 👇 Asegura que nunca sea nulo
            if (horarios == null) {
                horarios = new ArrayList<>();
            }

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

        // NO validar reservas aquí porque aún no se ha elegido fecha y horario

        // Preparar el objeto reserva con sedeServicio prellenado
        Reserva reserva = new Reserva();
        reserva.setSedeServicio(ss);

        // Atributos para mostrar en el formulario
        model.addAttribute("reserva", reserva);
        model.addAttribute("listaSedes", sedeRepository.findAll());
        model.addAttribute("listaHorarios", horarioDisponibleRepository.findByActivoTrue());
        model.addAttribute("reservaBloqueada", false); // por defecto falso

        return "vecino/vecino_FormularioReservas";
    }

    @GetMapping("/reservas/pago-tarjeta")
    public String vistaPagoTarjeta(@RequestParam("idreserva") Integer idreserva, Model model, HttpSession session) {
        Reserva reserva = reservaRepository.findById(idreserva).orElseThrow();
        model.addAttribute("reserva", reserva);
        return "vecino/vecino_pagar_tarjeta";
    }

    @PostMapping("/reservas/procesar-pago-tarjeta")
    public String procesarPagoTarjeta(@RequestParam String numero,
                                      @RequestParam String vencimiento,
                                      @RequestParam String cvv,
                                      @RequestParam Integer idreserva,
                                      RedirectAttributes attr) {

        // 🔴 AQUÍ ESTABA TU LÍNEA QUE FALLABA:
        // Optional<TarjetaVirtual> opt = tarjetaVirtualRepository
        //         .findByNumeroTarjetaAndVencimientoAndCvv(
        //                 numero,
        //                 LocalDate.parse(vencimiento + "-01"),
        //                 cvv
        //         );

        // ✅ SOLUCIÓN:
        LocalDate vencimientoDate;
        try {
            YearMonth ym = YearMonth.parse(vencimiento);
            vencimientoDate = ym.atDay(1); // Esto devuelve LocalDate con el primer día del mes
        } catch (Exception e) {
            attr.addFlashAttribute("msg", "Formato de fecha inválido.");
            return "redirect:/vecino/reservas/pago-tarjeta?idreserva=" + idreserva;
        }

        Optional<TarjetaVirtual> opt = tarjetaVirtualRepository
                .findByNumeroTarjetaAndVencimientoAndCvv(
                        numero,
                        vencimientoDate,
                        cvv
                );

        if (opt.isEmpty()) {
            attr.addFlashAttribute("msg", "Tarjeta inválida");
            return "redirect:/vecino/reservas/pago-tarjeta?idreserva=" + idreserva;
        }

        TarjetaVirtual tarjeta = opt.get();

        Reserva reserva = reservaRepository.findById(idreserva)
                .orElseThrow();
        BigDecimal monto = reserva.getPago().getMonto();

        if (tarjeta.getSaldo().compareTo(monto) < 0) {
            attr.addFlashAttribute("msg", "Saldo insuficiente");
            return "redirect:/vecino/reservas/pago-tarjeta?idreserva=" + idreserva;
        }

        tarjeta.setSaldo(tarjeta.getSaldo().subtract(monto));
        tarjetaVirtualRepository.save(tarjeta);

        reserva.setEstado(
                estadoRepository.findByNombre("aprobada")
                        .orElseThrow(() -> new IllegalStateException("Estado 'aprobada' no existe"))
        );

        Pago pago = reserva.getPago();
        pago.setMetodo(Pago.Metodo.online);
        pago.setFechaPago(LocalDateTime.now(ZoneId.of("America/Lima")));
        pago.setTarjeta(tarjeta);
        pagoRepository.save(pago);

        reservaRepository.save(reserva);

        try {
            String asunto = "Reserva aprobada";
            String mensajeHtml = "<div style='font-family: Arial, sans-serif; color: #333;'>"
                    + "<h2>Reserva aprobada</h2>"
                    + "<p>Hola " + reserva.getUsuario().getNombres() + ",</p>"
                    + "<p>Tu reserva ha sido aprobada para el servicio <strong>"
                    + reserva.getSedeServicio().getServicio().getNombre() + "</strong> en la sede <strong>"
                    + reserva.getSedeServicio().getSede().getNombre() + "</strong> el día <strong>"
                    + reserva.getFechaReserva() + "</strong> a las <strong>"
                    + reserva.getHorarioDisponible().getHoraInicio() + "</strong>.</p>"
                    + "<br><p>Gracias por usar el sistema de reservas deportivas de la Municipalidad de San Miguel.</p>"
                    + "<img src='cid:logoSanMiguel' style='margin-top:20px; width:180px;'/>"
                    + "</div>";

            emailService.enviarNotificacionReserva(reserva.getUsuario().getEmail(), asunto, mensajeHtml);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/vecino/reservas/" + idreserva;
    }

    @PostMapping("/reservas/guardar")
    public String guardarReserva(@ModelAttribute("reserva") Reserva reserva,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes,
                                 Model model) {

        Integer idUsuario = (Integer) session.getAttribute("idusuario");
        Usuario usuario = usuarioRepository.findById(idUsuario).orElse(null);

        Estado estadoPendienteReserva = estadoRepository.findById(1).orElse(null); // ID 1 = pendiente
        Estado estadoPendientePago = estadoRepository.findByNombreAndTipoAplicacion("pendiente", pago);

        Integer idSedeServicio = reserva.getSedeServicio().getIdSedeServicio();
        Integer idHorario = reserva.getHorarioDisponible().getIdhorario();

        SedeServicio sedeServicio = sedeServicioRepository.findById(idSedeServicio).orElse(null);
        HorarioDisponible horario = horarioDisponibleRepository.findById(idHorario).orElse(null);

        // 🟨 VALIDACIÓN: Verificar si ya tiene una reserva en esa fecha y horario (cualquier estado)
        List<Reserva> reservasEnEseHorario = reservaRepository
                .findByUsuario_IdusuarioAndFechaReservaAndHorarioDisponible_Idhorario(
                        idUsuario,
                        reserva.getFechaReserva(),
                        idHorario
                );

        for (Reserva r : reservasEnEseHorario) {
            String estadoNombre = r.getEstado().getNombre().toLowerCase();

            if (estadoNombre.equals("pendiente")) {
                model.addAttribute("reservaBloqueada", true);
                model.addAttribute("modalColor", "warning"); // o "danger"
                model.addAttribute("mensajeBloqueoPrincipal", "Ya tienes una reserva pendiente en esta fecha y horario.");

                reserva.setSedeServicio(sedeServicio); // ya lo obtuviste arriba con findById

                model.addAttribute("reserva", reserva);

// Solo accede a getServicio() después de verificar que sedeServicio no es null
                if (sedeServicio != null && sedeServicio.getServicio() != null && sedeServicio.getServicio().getTipoServicio() != null) {
                    model.addAttribute("idtipoActivo", sedeServicio.getServicio().getTipoServicio().getIdtipo());
                } else {
                    model.addAttribute("idtipoActivo", 1); // fallback para evitar crash
                }

                model.addAttribute("listaSedes", sedeRepository.findAll());
                model.addAttribute("listaHorarios", horarioDisponibleRepository.findByActivoTrue());

                return "vecino/vecino_FormularioReservas";

            }

            if (estadoNombre.equals("aprobada")) {
                model.addAttribute("reservaBloqueada", true);
                model.addAttribute("modalColor", "danger");
                model.addAttribute("mensajeBloqueoPrincipal", "Ya tienes una reserva aprobada para esta fecha y horario.");

                reserva.setSedeServicio(sedeServicio);

                model.addAttribute("reserva", reserva);

                if (sedeServicio != null && sedeServicio.getServicio() != null && sedeServicio.getServicio().getTipoServicio() != null) {
                    model.addAttribute("idtipoActivo", sedeServicio.getServicio().getTipoServicio().getIdtipo());
                } else {
                    model.addAttribute("idtipoActivo", 1); // fallback
                }

                model.addAttribute("listaSedes", sedeRepository.findAll());
                model.addAttribute("listaHorarios", horarioDisponibleRepository.findByActivoTrue());

                return "vecino/vecino_FormularioReservas";
            }

        }

        // 🟩 Continuar si no hay conflictos
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
            model.addAttribute("reserva", reserva);

            if (sedeServicio != null && sedeServicio.getServicio() != null && sedeServicio.getServicio().getTipoServicio() != null) {
                model.addAttribute("idtipoActivo", sedeServicio.getServicio().getTipoServicio().getIdtipo());
            } else {
                model.addAttribute("idtipoActivo", 1);
            }

            reserva.setHorarioDisponible(horario);
            reserva.setEstado(estadoPendienteReserva); // siempre será pendiente

            reservaRepository.save(reserva);

            try {
                String asunto = "Reserva registrada correctamente";
                String mensajeHtml = "<div style='font-family: Arial, sans-serif; color: #333;'>"
                        + "<h2>Reserva registrada</h2>"
                        + "<p>Hola " + usuario.getNombres() + ",</p>"
                        + "<p>Tu reserva ha sido registrada correctamente para el servicio <strong>"
                        + sedeServicio.getServicio().getNombre() + "</strong> en la sede <strong>"
                        + sedeServicio.getSede().getNombre() + "</strong> el día <strong>"
                        + reserva.getFechaReserva() + "</strong> a las <strong>"
                        + reserva.getHorarioDisponible().getHoraInicio() + "</strong>.</p>"
                        + "<br><p>Gracias por usar el sistema de reservas deportivas de la Municipalidad de San Miguel.</p>"
                        + "<img src='cid:logoSanMiguel' style='margin-top:20px; width:180px;'/>"
                        + "</div>";

                emailService.enviarNotificacionReserva(usuario.getEmail(), asunto, mensajeHtml);
            } catch (Exception e) {
                e.printStackTrace();
            }
            // Notificación
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

            return "vecino/vecino_ReservaPendiente";
        }

        redirectAttributes.addFlashAttribute("mensajeError", "Error al crear la reserva. Verifique los datos.");
        return "redirect:/vecino/reservas";
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

            // ✅ Subida a S3 y obtención de la key
            String keyS3 = fileUploadService.subirArchivo(file, "comprobantes"); // solo retorna la key, no la URL completa

            // ✅ Guardar key en DB
            pago.setComprobante(keyS3);
            pago.setFechaPago(LocalDateTime.now());
            pagoRepository.save(pago);

            redirectAttributes.addFlashAttribute("mensajeExito", "Comprobante enviado con éxito.");

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("mensajeError", "Error al procesar el archivo.");
            e.printStackTrace();
        }

        return "redirect:/vecino/reservas";
    }


    @GetMapping("/api/horarios-disponibles-por-fecha")
    public ResponseEntity<List<Map<String, Object>>> obtenerHorariosDisponibles(
            @RequestParam("sedeServicioId") Integer sedeServicioId,
            @RequestParam("fecha") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha) {

        Optional<SedeServicio> optionalSedeServicio = sedeServicioRepository.findById(sedeServicioId);
        if (optionalSedeServicio.isEmpty()) {
            return ResponseEntity.badRequest().build();
        }

        SedeServicio sedeServicio = optionalSedeServicio.get();
        Servicio servicio = sedeServicio.getServicio();
        Integer idServicio = servicio.getIdservicio();
        Integer idSede = sedeServicio.getSede().getIdsede();

        // Convertir LocalDate a día de la semana enum
        DayOfWeek dayOfWeek = fecha.getDayOfWeek();
        HorarioAtencion.DiaSemana diaSemana = switch (dayOfWeek) {
            case MONDAY -> HorarioAtencion.DiaSemana.Lunes;
            case TUESDAY -> HorarioAtencion.DiaSemana.Martes;
            case WEDNESDAY -> HorarioAtencion.DiaSemana.Miércoles;
            case THURSDAY -> HorarioAtencion.DiaSemana.Jueves;
            case FRIDAY -> HorarioAtencion.DiaSemana.Viernes;
            case SATURDAY -> HorarioAtencion.DiaSemana.Sábado;
            case SUNDAY -> HorarioAtencion.DiaSemana.Domingo;
        };

        Estado estadoAprobadaReserva = estadoRepository.findByNombreAndTipoAplicacion("aprobada", Estado.TipoAplicacion.reserva);

        // Buscar horarios activos para esa sede, servicio y día
        List<HorarioDisponible> horarios = horarioDisponibleRepository
                .findByServicio_IdservicioAndHorarioAtencion_Sede_IdsedeAndHorarioAtencion_DiaSemanaAndActivoTrue(
                        idServicio, idSede, diaSemana);

        List<Map<String, Object>> resultado = new ArrayList<>();

        for (HorarioDisponible h : horarios) {
            long reservasActuales = reservaRepository.countByHorarioDisponibleAndEstadoAndFechaReserva(h, estadoAprobadaReserva, fecha);
            int aforoDisponible = h.getAforoMaximo() - (int) reservasActuales;

            Map<String, Object> item = new HashMap<>();
            item.put("idhorario", h.getIdhorario());
            item.put("horaInicio", h.getHoraInicio().toString());
            item.put("horaFin", h.getHoraFin().toString());
            item.put("aforoMaximo", h.getAforoMaximo());
            item.put("aforoDisponible", Math.max(aforoDisponible, 0));

            resultado.add(item);
        }

        return ResponseEntity.ok(resultado);
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
    public String verDetalleReserva(@PathVariable("id") Integer id,
                                    Model model,
                                    HttpSession session) {
        // 1) Validar sesión
        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
        if (usuarioSesion == null) {
            return "redirect:/login";
        }

        // 2) Cargar reserva y validar propiedad
        Optional<Reserva> opt = reservaRepository.findById(id);
        if (opt.isEmpty() ||
                !opt.get().getUsuario().getIdusuario().equals(usuarioSesion.getIdusuario())) {
            return "redirect:/vecino/reservas";
        }
        Reserva reserva = opt.get();
        model.addAttribute("reserva", reserva);
        model.addAttribute("rol", "vecino");

        // 3) Si existe pago, añadimos el enum y los datos específicos
        Pago pago = reserva.getPago();
        if (pago != null) {
            // agregamos el enum al modelo para que Thymeleaf lo consulte
            model.addAttribute("pagoMetodo", pago.getMetodo());

            // caso online → simulación de voucher
            if (Pago.Metodo.online.equals(pago.getMetodo())) {
                model.addAttribute("voucherId",     pago.getIdpago());
                model.addAttribute("voucherFecha",  pago.getFechaPago());
                model.addAttribute("voucherMonto",  pago.getMonto());
                model.addAttribute("voucherMetodo", "con tarjeta");

                TarjetaVirtual tv = pago.getTarjeta();
                if (tv != null) {
                    model.addAttribute("voucherTitular",   tv.getTitular());
                    String num = tv.getNumeroTarjeta();
                    String ult4 = (num != null && num.length() >= 4)
                            ? num.substring(num.length() - 4)
                            : num;
                    model.addAttribute("voucherUltimos4",  ult4);
                    model.addAttribute("voucherVencimiento",
                            tv.getVencimiento()
                                    .format(DateTimeFormatter.ofPattern("MM/yyyy")));
                }

                // caso banco → comprobante real en S3
            } else if (Pago.Metodo.banco.equals(pago.getMetodo())) {
                // 'comprobante' guarda la key S3
                model.addAttribute("comprobanteKey", pago.getComprobante());
                // si tienes URL presignada:
                // model.addAttribute("comprobanteUrl", s3Service.generarUrlPresignada(pago.getComprobante()));
            }
        }

        // 4) Fecha “ahora” para lógica de UI
        ZonedDateTime zdt = ZonedDateTime.now(ZoneId.of("America/Lima"));
        model.addAttribute("ahora", zdt.toLocalDateTime());

        return "vecino/vecino_detalle_reserva";
    }



    @GetMapping("/comprobante/{id}")
    @ResponseBody
    public ResponseEntity<byte[]> verComprobanteVecino(@PathVariable Integer id) {
        System.out.println("[LOG] Solicitando comprobante para pago ID: " + id);

        Optional<Pago> opt = pagoRepository.findById(id);

        if (opt.isEmpty()) {
            System.out.println("[LOG] No se encontró pago con ID: " + id);
            return ResponseEntity.notFound().build();
        }

        Pago pago = opt.get();
        String keyS3 = pago.getComprobante();

        System.out.println("[LOG] Key S3 del comprobante: " + keyS3);

        if (keyS3 == null || keyS3.isBlank()) {
            System.out.println("[LOG] El comprobante está vacío o es nulo");
            return ResponseEntity.noContent().build();
        }

        try {
            byte[] archivo = fileUploadService.descargarArchivo(keyS3);
            String mimeType = fileUploadService.obtenerMimeDesdeKey(keyS3);

            System.out.println("[LOG] Tamaño del archivo descargado: " + (archivo != null ? archivo.length : 0) + " bytes");
            System.out.println("[LOG] MimeType detectado: " + mimeType);

            if (archivo == null || archivo.length == 0) {
                System.out.println("[ERROR] El archivo descargado está vacío");
                return ResponseEntity.noContent().build();
            }

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(mimeType))
                    .header("Cache-Control", "max-age=3600")
                    .body(archivo);
        } catch (RuntimeException ex) {
            System.out.println("[ERROR] Falló la descarga del comprobante: " + ex.getMessage());
            ex.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
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
