package com.example.grupo_6.Controller;

import com.example.grupo_6.Dto.VecinoPerfilDTO;
import com.example.grupo_6.Entity.Usuario;
import com.example.grupo_6.Repository.UsuarioRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/vecino")
public class VecinoController {

    @Autowired
    private UsuarioRepository usuarioRepository;

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
}
