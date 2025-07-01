package com.example.grupo_6.Controller;


import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import java.util.Map;

@RestController
@RequestMapping("/api/reniec")
public class ReniecRestController {

    @GetMapping("/dni/{dni}")
    public ResponseEntity<?> obtenerDatosPorDni(@PathVariable String dni) {

        // ✅ Validación de formato de DNI
        if (!dni.matches("\\d{8}")) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "DNI inválido"));
        }

        String url = "https://apiperu.dev/api/dni/" + dni;
        String token = "5394cbd1d8a849d1be9e2ce6bd9b3d52cfd284272780f81cced91f3738234c46";

        try {
            RestTemplate restTemplate = new RestTemplate();
            var headers = new org.springframework.http.HttpHeaders();
            headers.set("Authorization", "Bearer " + token);

            var entity = new org.springframework.http.HttpEntity<>(headers);
            var response = restTemplate.exchange(url, org.springframework.http.HttpMethod.GET, entity, Map.class);

            return ResponseEntity.ok(response.getBody());

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Error consultando DNI"));
        }
    }
}