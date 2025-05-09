package com.example.grupo_6.Controller;
import com.example.grupo_6.Entity.Usuario;
import com.example.grupo_6.Repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.Map;

@Controller
public class VecinoController {

    @Autowired
    private UsuarioRepository usuarioRepository;
    private final Map<Integer, String> mapaRoles = Map.of(
            1, "Superadmin",
            2, "Administrador",
            3, "Coordinador",
            4, "Vecino"
    );
    @Autowired
    private TarifaRepository tarifaRepository;

    @Autowired
    private ServicioRepository servicioRepository;

    @Autowired
    private SedeServicioRepository sedeServicioRepository;
    @Autowired
    private EstadoRepository estadoRepository;
    @Autowired
    private ReservaRepository reservaRepository;
    @Autowired
    private PagoRepository pagoRepository;



    // Vista principal del superadmin
    @GetMapping("/vecino")
    public String vecinoHome(Model model) {
        model.addAttribute("rol", "vecino");
        return "vecino/vecino_home";

    }
}