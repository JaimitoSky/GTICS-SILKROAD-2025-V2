package com.example.grupo_6.Controller;

import com.example.grupo_6.Dto.ServicioPorSedeDTO;
import com.example.grupo_6.Repository.SedeServicioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api")
public class SedeServicioRestController {

    @Autowired
    private SedeServicioRepository sedeServicioRepository;

    @GetMapping("/servicios-por-sede/{idSede}")
    public List<Map<String, Object>> obtenerServiciosPorSedeDTO(@PathVariable("idSede") Integer idSede) {
        System.out.println("Consultando servicios para sede: " + idSede); // Debug
        List<ServicioPorSedeDTO> lista = sedeServicioRepository.obtenerServiciosPorSede(idSede);

        lista.forEach(dto -> System.out.println(
                "Servicio: " + dto.getNombre() +
                        ", Estado: " + dto.getEstadoServicio()
        )); // Verifica si el servicio activado aparece aquí

        return lista.stream()
                .filter(dto -> Boolean.TRUE.equals(dto.getEstadoServicio()))  // Filtra solo activos (true)
                .map(dto -> {
                    Map<String, Object> m = new HashMap<>();
                    m.put("idSedeServicio", dto.getIdSedeServicio());
                    String nombreMostrado = (dto.getNombrePersonalizado() != null && !dto.getNombrePersonalizado().isEmpty())
                            ? dto.getNombrePersonalizado()
                            : dto.getNombre();
                    m.put("nombre", nombreMostrado);
                    return m;
                }).collect(Collectors.toList());
    }


}

