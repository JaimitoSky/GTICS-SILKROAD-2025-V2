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
        return "session/registro";
    }

    @PostMapping("/enviar-codigo")
    public String enviarCodigo(@RequestParam String nombres,
                               @RequestParam String apellidos,
                               @RequestParam String email,
                               @RequestParam String telefono,
                               @RequestParam String direccion,
                               @RequestParam String dni,
                               @RequestParam String password,
                               @RequestParam(required = false) String codigoCoordinador,
                               HttpSession session,
                               Model model,
                               RedirectAttributes redirectAttributes) {

        if (usuarioRepository.findByEmail(email) != null) {
            model.addAttribute("error", "Ya existe una cuenta con ese correo.");
            return "session/registro";
        }

        if (usuarioRepository.findByDni(dni) != null) {
            model.addAttribute("error", "Ya existe una cuenta con ese DNI.");
            return "session/registro";
        }

        String codigo = String.format("%06d", new Random().nextInt(999999));

        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setNombres(nombres);
        nuevoUsuario.setApellidos(apellidos);
        nuevoUsuario.setEmail(email);
        nuevoUsuario.setTelefono(telefono);
        nuevoUsuario.setDireccion(direccion);
        nuevoUsuario.setDni(dni);
        nuevoUsuario.setPasswordHash(passwordEncoder.encode(password));
        nuevoUsuario.setEstado("activo");
        session.setAttribute("codigo", codigo);
        session.setAttribute("nuevoUsuario", nuevoUsuario);
        session.setAttribute("codigoCoordinador", codigoCoordinador);

        try {
            emailService.enviarCodigoVerificacion(email, codigo);
        } catch (MessagingException e) {
            e.printStackTrace();
            model.addAttribute("error", "No se pudo enviar el correo de verificación.");
            return "session/registro";
        }

        // ✅ Aquí agregas el mensaje de éxito para mostrar en verificar-codigo.html
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

        usuario.setIdrol((codigoCoordinador != null && codigoCoordinador.equals("CODIGO-COORDI-2025")) ? 3 : 4); // 3 = Coordinador, 4 = Vecino
        usuarioRepository.save(usuario);

        // Limpieza de sesión
        session.removeAttribute("codigo");
        session.removeAttribute("nuevoUsuario");
        session.removeAttribute("codigoCoordinador");

        // Agregar mensaje flash para login
        redirectAttributes.addFlashAttribute("successMessage", "¡Cuenta verificada exitosamente! Ahora puedes iniciar sesión.");
        return "redirect:/login";
    }
}
