package com.example.grupo_6.Controller;

import com.example.grupo_6.Entity.Usuario;
import com.example.grupo_6.Repository.UsuarioRepository;
import com.example.grupo_6.Service.EmailService;
import jakarta.mail.MessagingException;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Random;

@Controller
@RequestMapping("/recuperar")
public class RecuperarPasswordController {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private EmailService emailService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping("/olvide")
    public String mostrarOlvidePassword() {
        return "session/olvide-contraseña";
    }

    @PostMapping("/enviar-codigo")
    public String enviarCodigo(@RequestParam String email,
                               HttpSession session,
                               Model model,
                               RedirectAttributes redirectAttributes) {
        Usuario usuario = usuarioRepository.findByEmail(email);
        if (usuario == null) {
            model.addAttribute("error", "No existe una cuenta con ese correo.");
            return "session/olvide-contraseña";
        }

        String codigo = String.format("%06d", new Random().nextInt(999999));
        session.setAttribute("codigoRecuperacion", codigo);
        session.setAttribute("usuarioRecuperacionEmail", usuario.getEmail());

        try {
            emailService.enviarCodigoVerificacion(email, codigo);
        } catch (MessagingException e) {
            model.addAttribute("error", "No se pudo enviar el correo de verificación.");
            return "session/olvide-contraseña";
        }

        redirectAttributes.addFlashAttribute("success", "Hemos enviado un código a tu correo.");
        return "redirect:/recuperar/verificar-codigo";
    }


    @GetMapping("/verificar-codigo")
    public String mostrarVerificacion() {
        return "session/verificar-codigo-recuperacion";
    }

    @PostMapping("/verificar-codigo")
    public String procesarVerificacion(@RequestParam String codigoIngresado,
                                       HttpSession session,
                                       Model model,
                                       RedirectAttributes redirectAttributes) {
        String codigoGuardado = (String) session.getAttribute("codigoRecuperacion");

        if (codigoGuardado == null || !codigoGuardado.equals(codigoIngresado)) {
            model.addAttribute("error", "Código incorrecto.");
            return "session/verificar-codigo-recuperacion";
        }

        redirectAttributes.addFlashAttribute("success", "Código verificado. Establece tu nueva contraseña.");
        return "redirect:/recuperar/nueva";
    }


    @GetMapping("/nueva")
    public String mostrarNuevaPassword() {
        return "session/nueva-contraseña";
    }

    @PostMapping("/nueva")
    public String guardarNuevaPassword(@RequestParam("password") String password,
                                       HttpSession session,
                                       Model model,
                                       RedirectAttributes redirectAttributes) {
        String email = (String) session.getAttribute("usuarioRecuperacionEmail");
        if (email == null) {
            model.addAttribute("error", "Sesión inválida. Intenta nuevamente.");
            return "session/olvide-contraseña";
        }

        Usuario usuario = usuarioRepository.findByEmail(email);
        if (usuario == null) {
            model.addAttribute("error", "Usuario no encontrado.");
            return "session/olvide-contraseña";
        }

        usuario.setPasswordHash(passwordEncoder.encode(password));
        usuarioRepository.save(usuario);

        // Limpieza de sesión
        session.removeAttribute("codigoRecuperacion");
        session.removeAttribute("usuarioRecuperacionEmail");

        // ✅ Mensaje para mostrar en login.html
        redirectAttributes.addFlashAttribute("successMessage", "¡Contraseña actualizada con éxito! Ya puedes iniciar sesión.");
        return "redirect:/login";
    }

}
