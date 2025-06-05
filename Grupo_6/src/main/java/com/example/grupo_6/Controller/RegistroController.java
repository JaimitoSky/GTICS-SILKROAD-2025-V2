package com.example.grupo_6.Controller;

import com.example.grupo_6.Entity.Usuario;
import com.example.grupo_6.Repository.UsuarioRepository;
import com.example.grupo_6.Service.EmailService;
import jakarta.mail.MessagingException;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Random;

@Controller
@RequestMapping("/registro")
public class RegistroController {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private EmailService emailService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping
    public String mostrarFormulario(Model model) {
        model.addAttribute("usuario", new Usuario());
        return "session/registro";
    }

    @PostMapping("/enviar-codigo")
    public String enviarCodigo(
            @Valid @ModelAttribute("usuario") Usuario usuario,
            BindingResult bindingResult,
            @RequestParam(required = false) String codigoCoordinador,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {

        // Validaciones manuales
        if (usuarioRepository.findByEmail(usuario.getEmail()) != null) {
            bindingResult.rejectValue("email", "error.usuario", "Ya existe una cuenta con ese correo.");
        }

        if (usuarioRepository.findByDni(usuario.getDni()) != null) {
            bindingResult.rejectValue("dni", "error.usuario", "Ya existe una cuenta con ese DNI.");
        }

        if (bindingResult.hasErrors()) {
            return "session/registro";
        }

        String codigo = String.format("%06d", new Random().nextInt(999999));

        usuario.setPasswordHash(passwordEncoder.encode(usuario.getPasswordHash()));
        usuario.setEstado("activo");

        // Guardamos en sesión
        session.setAttribute("codigo", codigo);
        session.setAttribute("nuevoUsuario", usuario);
        session.setAttribute("codigoCoordinador", codigoCoordinador);

        try {
            emailService.enviarCodigoVerificacion(usuario.getEmail(), codigo);
        } catch (MessagingException e) {
            model.addAttribute("error", "No se pudo enviar el correo de verificación.");
            return "session/registro";
        }

        redirectAttributes.addFlashAttribute("successMessage", "Se ha enviado un código de verificación a tu correo.");
        return "redirect:/registro/verificar-codigo";
    }

    @GetMapping("/verificar-codigo")
    public String verificarForm() {
        return "session/verificar-codigo";
    }

    @PostMapping("/verificar-codigo")
    public String procesarCodigo(@RequestParam String codigoIngresado,
                                 HttpSession session,
                                 Model model,
                                 RedirectAttributes redirectAttributes) {

        String codigoGenerado = (String) session.getAttribute("codigo");
        Usuario usuario = (Usuario) session.getAttribute("nuevoUsuario");
        String codigoCoordinador = (String) session.getAttribute("codigoCoordinador");

        if (codigoGenerado == null || !codigoGenerado.equals(codigoIngresado)) {
            model.addAttribute("error", "Código incorrecto. Intenta de nuevo.");
            return "session/verificar-codigo";
        }

        if (codigoCoordinador != null && !codigoCoordinador.isBlank()
                && !codigoCoordinador.equals("CODIGO-COORDI-2025")) {
            model.addAttribute("error", "Código de coordinador inválido.");
            return "session/verificar-codigo";
        }

        usuario.setIdrol((codigoCoordinador != null && codigoCoordinador.equals("CODIGO-COORDI-2025")) ? 3 : 4);
        usuarioRepository.save(usuario);

        session.removeAttribute("codigo");
        session.removeAttribute("nuevoUsuario");
        session.removeAttribute("codigoCoordinador");

        redirectAttributes.addFlashAttribute("successMessage", "¡Cuenta verificada exitosamente! Ahora puedes iniciar sesión.");
        return "redirect:/login";
    }
}
