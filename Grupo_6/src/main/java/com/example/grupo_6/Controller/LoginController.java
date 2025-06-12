package com.example.grupo_6.Controller;

import com.example.grupo_6.Entity.Usuario;
import com.example.grupo_6.Repository.UsuarioRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LoginController {

    @GetMapping("/login")
    public String loginForm(@RequestParam(value = "logout", required = false) String logout,
                            @RequestParam(value = "error", required = false) String error,
                            @RequestParam(value = "inhabilitado", required = false) String inhabilitado,
                            Model model) {
        if (logout != null) {
            model.addAttribute("mensaje", "Has cerrado sesión exitosamente.");
            model.addAttribute("tipo", "success");
        }

        if (error != null) {
            model.addAttribute("mensaje", "Credenciales inválidas. Intenta de nuevo.");
            model.addAttribute("tipo", "error");
        }

        if (inhabilitado != null) {
            model.addAttribute("mensaje", "Tu cuenta está inhabilitada. Comunícate con el administrador.");
            model.addAttribute("tipo", "error");
        }

        return "session/login";
    }

    @Autowired
    private UsuarioRepository usuarioRepository;

    @PostMapping("/processLogin")
    public String processLogin(@RequestParam("username") String email,
                               @RequestParam("password") String password,
                               HttpSession session) {

        Usuario usuario = usuarioRepository.findByEmail(email);

        if (usuario != null && usuario.getPasswordHash().equals(password)) {
            if (!usuario.getEstado().equalsIgnoreCase("activo")) {
                return "redirect:/login?inhabilitado";
            }
            session.setAttribute("usuario", usuario); // 🔥 Este es el punto clave
            return "redirect:/vecino/home";
        }

        return "redirect:/login?error";
    }

}
