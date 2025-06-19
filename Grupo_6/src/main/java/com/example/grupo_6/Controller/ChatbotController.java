package com.example.grupo_6.Controller;

import com.example.grupo_6.Entity.*;
import com.example.grupo_6.Repository.HorarioDisponibleRepository;
import com.example.grupo_6.Repository.ReservaRepository;
import com.example.grupo_6.Repository.ServicioRepository;
import com.example.grupo_6.Repository.UsuarioRepository;
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
    private ServicioRepository servicioRepository;

    @Autowired
    private HorarioDisponibleRepository horarioDisponibleRepository;

    @Autowired
    private ReservaRepository reservaRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

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

        // 🧠 Obtener el ID del usuario desde user-id
        Integer idUsuarioChatbot = null;
        try {
            Map<String, Object> originalDetectIntentRequest = (Map<String, Object>) payload.get("originalDetectIntentRequest");
            if (originalDetectIntentRequest != null) {
                Map<String, Object> dfPayload = (Map<String, Object>) originalDetectIntentRequest.get("payload");
                if (dfPayload != null && dfPayload.get("userId") != null) {
                    idUsuarioChatbot = Integer.parseInt(dfPayload.get("userId").toString());
                    System.out.println("🧾 ID usuario desde user-id: " + idUsuarioChatbot);
                }
            }
        } catch (Exception e) {
            System.out.println("⚠️ No se pudo extraer el ID del usuario desde el payload: " + e.getMessage());
        }

        // 🔄 Obtener usuario desde sesión o por ID
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null && idUsuarioChatbot != null) {
            usuario = usuarioRepository.findById(idUsuarioChatbot).orElse(null);
        }

        // 🔤 Extraer nombre del usuario
        String nombreUsuario = (usuario != null && usuario.getNombres() != null)
                ? usuario.getNombres().split(" ")[0]
                : "usuario";

        // ----- INTENT: Saludo -----
        if ("Saludo".equals(intent)) {
            return ResponseEntity.ok(Map.of(
                    "fulfillmentText", "¡Hola " + nombreUsuario + "! ¿En qué puedo ayudarte hoy?"
            ));
        }
        if ("OpcionesBot".equals(intent)) {
            String respuesta = """
🤖 *¡Hola!* Aquí tienes lo que puedo hacer por ti:

1️⃣ *Ver los servicios deportivos disponibles*  
2️⃣ *Consultar tus reservas* (hoy, mañana o todas)  
3️⃣ *Ver canchas disponibles* por sede y fecha  

💬 *Ejemplos que puedes decirme:*  
• ¿Qué servicios hay?  
• ¿Cuáles son mis reservas?  
• ¿Qué canchas hay libres mañana en Magdalena?
""";

            return ResponseEntity.ok(Map.of("fulfillmentText", respuesta));
        }



        // ----- INTENT: ConsultarServiciosDisponibles -----
        if ("ConsultarServiciosDisponibles".equals(intent)) {
            List<Servicio> servicios = servicioRepository.listarServiciosActivos();

            if (servicios.isEmpty()) {
                return ResponseEntity.ok(Map.of("fulfillmentText", "No se encontraron servicios disponibles en este momento."));
            }

            StringBuilder respuestaServicios = new StringBuilder("📋 *Estos son los servicios deportivos disponibles:*\n\n");
            for (Servicio s : servicios) {
                respuestaServicios.append("• ").append(s.getNombre()).append("\n");
            }

            return ResponseEntity.ok(Map.of("fulfillmentText", respuestaServicios.toString()));
        }


        // ----- INTENT: ConsultarReservasUsuario -----
        if ("ConsultarReservasUsuario".equals(intent)) {
            if (usuario == null) {
                return ResponseEntity.ok(Map.of("fulfillmentText", "Primero debes iniciar sesión para consultar tus reservas."));
            }

            List<Reserva> reservasUsuario = reservaRepository.findByUsuarioIdusuario(usuario.getIdusuario());

            if (reservasUsuario.isEmpty()) {
                return ResponseEntity.ok(Map.of(
                        "fulfillmentText", "No tienes reservas registradas por el momento."
                ));
            }

            StringBuilder respuestaReservas = new StringBuilder("🗓 Estas son tus reservas:\n");
            for (Reserva r : reservasUsuario) {
                String nombreServicio = r.getSedeServicio().getServicio().getNombre();
                String fecha = r.getFechaReserva().toString();
                String hora = r.getHorarioDisponible().getHoraInicio().toString();
                respuestaReservas.append("• ").append(nombreServicio)
                        .append(" el ").append(fecha)
                        .append(" a las ").append(hora).append("\n");
            }

            return ResponseEntity.ok(Map.of("fulfillmentText", respuestaReservas.toString()));
        }

        // Parámetros comunes
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

        // ----- INTENT: ConsultarCanchasLibres -----
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

            return ResponseEntity.ok(Map.of("fulfillmentText", respuesta));
        }

        // ----- INTENT desconocido -----
        return ResponseEntity.ok(Map.of("fulfillmentText", "No entendí tu solicitud. Puedes preguntarme por servicios, canchas disponibles o tus reservas."));
    }
}
