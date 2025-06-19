package com.example.grupo_6.Controller;

import com.example.grupo_6.Entity.HorarioDisponible;
import com.example.grupo_6.Entity.HorarioAtencion;
import com.example.grupo_6.Entity.Usuario;
import com.example.grupo_6.Repository.HorarioDisponibleRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.*;

@RestController
@RequestMapping("/api/chatbot")
@CrossOrigin(origins = "*")
public class ChatbotController {

    @Autowired
    private HorarioDisponibleRepository horarioDisponibleRepository;

    @PostMapping("/procesar")
    public ResponseEntity<Map<String, Object>> procesarMensaje(
            @RequestBody Map<String, Object> payload,
            HttpSession session) {

        System.out.println("📥 Payload recibido desde Dialogflow:");
        System.out.println(payload);

        Map<String, Object> queryResult = (Map<String, Object>) payload.get("queryResult");
        String intent = (String) ((Map<String, Object>) queryResult.get("intent")).get("displayName");
        Map<String, Object> parametros = (Map<String, Object>) queryResult.get("parameters");

        System.out.println("🔎 Intent detectado: " + intent);

        // 🧠 Detectar nombre desde user-id
        String nombreUsuario = "usuario";
        try {
            Map<String, Object> originalDetectIntentRequest = (Map<String, Object>) payload.get("originalDetectIntentRequest");
            if (originalDetectIntentRequest != null) {
                Map<String, Object> dfPayload = (Map<String, Object>) originalDetectIntentRequest.get("payload");
                if (dfPayload != null && dfPayload.get("userId") != null) {
                    nombreUsuario = dfPayload.get("userId").toString().split(" ")[0];
                    System.out.println("👤 Nombre recibido por userId: " + nombreUsuario);
                }
            }
        } catch (Exception e) {
            System.out.println("⚠️ No se pudo extraer el userId desde el payload: " + e.getMessage());
        }

        // Fallback desde sesión
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario != null && usuario.getNombres() != null && !usuario.getNombres().isBlank()) {
            nombreUsuario = usuario.getNombres().split(" ")[0];
            System.out.println("👤 Nombre extraído desde sesión: " + nombreUsuario);
        }

        if ("Saludo".equals(intent)) {
            return ResponseEntity.ok(Map.of(
                    "fulfillmentText", "¡Hola " + nombreUsuario + "! ¿En qué puedo ayudarte hoy?"
            ));
        }

        // 📍 Parámetros
        String sede = "";
        if (parametros.containsKey("sede")) {
            sede = (String) parametros.get("sede");
        } else if (parametros.containsKey("location")) {
            Map<String, Object> locationMap = (Map<String, Object>) parametros.get("location");
            if (locationMap != null) {
                sede = (String) locationMap.getOrDefault("city", "");
            }
        }

        String fechaStr = "";
        if (parametros.containsKey("fecha")) {
            fechaStr = (String) parametros.get("fecha");
        } else if (parametros.containsKey("date")) {
            fechaStr = (String) parametros.get("date");
        }

        System.out.println("📍 Sede: " + sede);
        System.out.println("📅 Fecha: " + fechaStr);

        String respuesta;

        if ("ConsultarCanchasLibres".equals(intent)) {
            if (fechaStr.isBlank() || sede.isBlank()) {
                respuesta = "Por favor indica una sede y una fecha válidas para consultar disponibilidad.";
            } else {
                try {
                    LocalDate fecha = LocalDate.parse(fechaStr);
                    DayOfWeek dow = fecha.getDayOfWeek();
                    HorarioAtencion.DiaSemana diaSemana = switch (dow) {
                        case MONDAY -> HorarioAtencion.DiaSemana.Lunes;
                        case TUESDAY -> HorarioAtencion.DiaSemana.Martes;
                        case WEDNESDAY -> HorarioAtencion.DiaSemana.Miércoles;
                        case THURSDAY -> HorarioAtencion.DiaSemana.Jueves;
                        case FRIDAY -> HorarioAtencion.DiaSemana.Viernes;
                        case SATURDAY -> HorarioAtencion.DiaSemana.Sábado;
                        case SUNDAY -> HorarioAtencion.DiaSemana.Domingo;
                    };

                    List<HorarioDisponible> disponibles = horarioDisponibleRepository
                            .listarHorariosDisponiblesPorSedeYDiaSemana(sede, diaSemana);

                    if (disponibles.isEmpty()) {
                        respuesta = "Lo siento " + nombreUsuario + ", no se encontraron canchas disponibles en la sede " + sede + " para el " + fecha + ".";
                    } else {
                        StringBuilder sb = new StringBuilder();
                        sb.append("¡Perfecto, ").append(nombreUsuario).append("! Estas son las canchas disponibles en la sede ")
                                .append(sede).append(" para el ").append(fecha).append(":\n");
                        for (HorarioDisponible h : disponibles) {
                            sb.append("- ")
                                    .append(h.getServicio().getNombre())
                                    .append(" de ")
                                    .append(h.getHoraInicio())
                                    .append(" a ")
                                    .append(h.getHoraFin())
                                    .append("\n");
                        }
                        respuesta = sb.toString();
                    }

                } catch (Exception e) {
                    respuesta = "La fecha ingresada no tiene el formato correcto (yyyy-MM-dd).";
                    System.out.println("❌ Error al parsear la fecha: " + e.getMessage());
                }
            }
        } else {
            respuesta = "No entendí tu solicitud. Puedes preguntarme por canchas disponibles, por ejemplo.";
        }

        return ResponseEntity.ok(Map.of("fulfillmentText", respuesta));
    }

}
