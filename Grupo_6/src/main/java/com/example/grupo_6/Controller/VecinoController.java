package com.example.grupo_6.Controller;
import com.example.grupo_6.Dto.VecinoPerfilDTO;
import com.example.grupo_6.Entity.Usuario;
import com.example.grupo_6.Repository.UsuarioRepository;
import com.example.grupo_6.Repository.ServicioRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.example.grupo_6.Repository.SedeServicioRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import java.util.Optional;
import com.example.grupo_6.Entity.SedeServicio;
@Controller
@RequestMapping("/vecino")
public class VecinoController {
    @Autowired
    private ServicioRepository servicioRepository;
    @Autowired
    private UsuarioRepository usuarioRepository;
    @Autowired
    private SedeServicioRepository sedeServicioRepository;
    // Temporal: en el futuro usar autenticación real
    private final Integer idVecino = 4;

    // --- Vista principal ---
    @GetMapping
    public String vecinoHome(Model model) {
        model.addAttribute("rol", "vecino");
        return "vecino/vecino_home";
    }

    // --- Vista de perfil ---
    @GetMapping("/perfil")
    public String mostrarPerfil(Model model) {
        VecinoPerfilDTO perfil = usuarioRepository.obtenerPerfilVecinoPorId(idVecino);
        model.addAttribute("perfil", perfil);
        model.addAttribute("rol", "vecino");
        return "vecino/vecino_perfil";
    }


    // --- Actualizar información del perfil ---
    @PostMapping("/perfil/actualizar")
    @Transactional
    public String actualizarPerfil(@RequestParam("correo") String correo,
                                   @RequestParam("telefono") String telefono,
                                   @RequestParam("direccion") String direccion) {
        Usuario usuario = usuarioRepository.findById(idVecino).orElse(null);
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
    public String cambiarPassword(@RequestParam("nuevaClave") String nuevaClave) {
        Usuario usuario = usuarioRepository.findById(idVecino).orElse(null);
        if (usuario != null) {
            usuario.setPasswordHash(nuevaClave); // En producción: aplicar hash seguro
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


}
