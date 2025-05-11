package com.example.grupo_6.Controller;

import com.example.grupo_6.Dto.ServicioPorSedeDTO;
import com.example.grupo_6.Repository.SedeServicioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api")
public class SedeServicioRestController {

    @Autowired
    private SedeServicioRepository sedeServicioRepository;

    @GetMapping("/servicios-por-sede/{idSede}")
    public List<ServicioPorSedeDTO> obtenerServiciosPorSedeDTO(@PathVariable("idSede") Integer idSede) {
        return sedeServicioRepository.obtenerServiciosPorSede(idSede);
    }
}

