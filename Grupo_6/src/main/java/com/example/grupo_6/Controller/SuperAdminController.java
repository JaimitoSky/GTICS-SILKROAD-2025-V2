package com.example.grupo_6.Controller;

import com.example.grupo_6.Entity.Usuario;
import com.example.grupo_6.Repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

@Controller
public class SuperAdminController {

    @Autowired
    private UsuarioRepository usuarioRepository;
    private final Map<Integer, String> mapaRoles = Map.of(
            1, "Superadmin",
            2, "Administrador",
            3, "Coordinador",
            4, "Vecino"
    );


    // Vista principal del superadmin
    @GetMapping("/superadmin")
    public String superadminHome(Model model) {
        model.addAttribute("rol", "superadmin");
        return "superadmin/superadmin_home";
    }

    // Vista de gestión de usuarios
    @GetMapping("/superadmin/usuarios")
    public String listarUsuarios(Model model) {
        List<Usuario> listaUsuarios = usuarioRepository.findAll();
        model.addAttribute("usuarios", listaUsuarios);
        model.addAttribute("rol", "superadmin");
        model.addAttribute("mapaRoles", mapaRoles); // solo para vista
        return "superadmin/superadmin_usuarios";
    }


    // Cambiar rol del usuario
    @PostMapping("/cambiar-rol")
    public String cambiarRol(@RequestParam Integer idusuario, @RequestParam Integer rol) {
        Usuario u = usuarioRepository.findById(idusuario).orElse(null);
        if (u != null) {
            u.setIdrol(rol);
            usuarioRepository.save(u);
        }
        return "redirect:/superadmin/usuarios";
    }


    // Banear usuario (poner inactivo)
    @PostMapping("/superadmin/usuarios/{id}/ban")
    public String banearUsuario(@PathVariable("id") Integer idusuario) {
        Usuario u = usuarioRepository.findById(idusuario).orElse(null);
        if (u != null) {
            u.setEstado("inactivo");
            usuarioRepository.save(u);
        }
        return "redirect:/superadmin/usuarios";
    }

    // Activar usuario
    @PostMapping("/superadmin/usuarios/{id}/activar")
    public String activarUsuario(@PathVariable("id") Integer idusuario) {
        Usuario usuario = usuarioRepository.findById(idusuario).orElse(null);
        if (usuario != null) {
            usuario.setEstado("activo");
            usuarioRepository.save(usuario);
        }
        return "redirect:/superadmin/usuarios";
    }

    // Eliminar usuario
    @PostMapping("/eliminar")
    public String eliminarUsuario(@RequestParam("idusuario") Integer idusuario) {
        usuarioRepository.deleteById(idusuario);
        return "redirect:/superadmin/usuarios";
    }

    // Crear usuario
    @GetMapping("/superadmin/usuarios/nuevo")
    public String mostrarFormularioNuevoUsuario(Model model) {
        model.addAttribute("usuario", new Usuario()); // objeto vacío para el form
        return "superadmin/superadmin_usuarios_formulario";
    }


    // Manejo de errores global para debugging
    @ExceptionHandler(Exception.class)
    public String handleException(Exception e) {
        e.printStackTrace(); // Log para consola
        return "error";       // Asegúrate de tener un error.html
    }
    @PostMapping("/superadmin/usuarios/guardar")
    public String guardarUsuario(@ModelAttribute Usuario usuario) {
        usuario.setEstado("activo"); // se registra como activo por defecto
        usuario.setCreate_time(new Timestamp(System.currentTimeMillis())); // registrar fecha
        usuarioRepository.save(usuario);
        return "redirect:/superadmin/usuarios";
    }

}
