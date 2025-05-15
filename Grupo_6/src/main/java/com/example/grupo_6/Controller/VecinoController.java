package com.example.grupo_6.Controller;
import com.example.grupo_6.Dto.VecinoPerfilDTO;
import com.example.grupo_6.Entity.*;
import com.example.grupo_6.Repository.UsuarioRepository;
import com.example.grupo_6.Repository.ServicioRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.example.grupo_6.Repository.SedeServicioRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import com.example.grupo_6.Entity.Reserva;
import com.example.grupo_6.Repository.ReservaRepository;
import java.math.BigDecimal;
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
    public String vecinoHome(Model model) {
        model.addAttribute("rol", "vecino");
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
                                   HttpSession session) {
        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
        if (usuarioSesion == null) {
            return "redirect:/login";
        }

        Usuario usuario = usuarioRepository.findById(usuarioSesion.getIdusuario()).orElse(null);
        if (usuario != null) {
            usuario.setEmail(correo);
            usuario.setTelefono(telefono);
            usuario.setDireccion(direccion);
            usuarioRepository.save(usuario);
        }
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
    public String cambiarPassword(@RequestParam("nuevaClave") String nuevaClave,
                                  HttpSession session) {
        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
        if (usuarioSesion == null) {
            return "redirect:/login";
        }

        Usuario usuario = usuarioRepository.findById(usuarioSesion.getIdusuario()).orElse(null);
        if (usuario != null) {
            usuario.setPasswordHash(nuevaClave); // En producción, usa PasswordEncoder
            usuarioRepository.save(usuario);
        }
        return "redirect:/vecino/perfil";
    }

    @GetMapping("/ListaComplejoDeportivo")
    public String mostrarComplejosPorTipo(@RequestParam("idtipo") int idtipo, Model model) {
        model.addAttribute("complejos", sedeServicioRepository.listarServiciosSimplificadosPorTipo(idtipo));
        return "vecino/vecino_ListaComplejoDeportivo"; // Asegúrate que el archivo exista
    }
    @GetMapping("/imagen/{id}")
    @ResponseBody
    public ResponseEntity<byte[]> mostrarImagen(@PathVariable("id") Integer id) {
        var servicioOpt = servicioRepository.findById(id);

        if (servicioOpt.isPresent() && servicioOpt.get().getImagenComplejo() != null) {
            byte[] imagen = servicioOpt.get().getImagenComplejo();
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_JPEG); // o IMAGE_PNG si tu imagen es PNG
            return new ResponseEntity<>(imagen, headers, HttpStatus.OK);
        } else {
            return ResponseEntity.notFound().build(); // o puedes devolver una imagen por defecto
        }
    }
    @GetMapping("/complejo/detalle/{id}")
    public String mostrarDetalleComplejo(@PathVariable("id") Integer id, Model model) {
        Optional<SedeServicio> sedeServicioOpt = sedeServicioRepository.obtenerDetalleComplejoPorId(id);

        if (sedeServicioOpt.isPresent()) {
            model.addAttribute("sedeServicio", sedeServicioOpt.get());
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
    public String nuevaReserva(Model model) {
        model.addAttribute("reserva", new Reserva());
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

            model.addAttribute("reserva", reserva); // para mostrar en la vista de confirmación
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
    public List<HorarioDisponible> obtenerHorariosDisponibles(@RequestParam("sedeServicioId") Integer sedeServicioId,
                                                              @RequestParam("fecha") String fecha) {
        SedeServicio sedeServicio = sedeServicioRepository.findById(sedeServicioId).orElse(null);

        if (sedeServicio == null) return List.of();

        Integer idSede = sedeServicio.getSede().getIdsede();

        // Aquí usas tu método existente basado en idSede
        return horarioDisponibleRepository.buscarPorSedeServicioId(idSede);
    }



}
