package com.example.grupo_6.Controller;

import com.example.grupo_6.Entity.Usuario;
import com.example.grupo_6.Repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class UsuarioController {

    @Autowired
    private UsuarioRepository usuarioRepository;

    // Mapeo actualizado a "/usuarios" (ya no hay conflicto)
    @GetMapping("/usuarios")
    public String index(Model model) {
        List<Usuario> listaUsuarios = usuarioRepository.findAll();
        model.addAttribute("listaUsuarios", listaUsuarios);
        return "usuario/lista"; // Este valor se usa para resolver la plantilla en: /templates/usuario/lista.html
    }

    // Si deseas que la raíz ("/") redireccione a /usuarios, agrega otro método:
    @GetMapping("/")
    public String homeRedirect() {
        return "redirect:/usuarios";
    }
}
