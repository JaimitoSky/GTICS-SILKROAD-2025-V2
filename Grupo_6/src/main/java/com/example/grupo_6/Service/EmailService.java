package com.example.grupo_6.Service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    @Async
    public void enviarCodigoVerificacion(String destinatario, String codigo) throws MessagingException {
        String asunto = "Código de verificación - Sistema de Reservas";
        String contenido = "<h3>Hola,</h3>"
                + "<p>Tu código de verificación es:</p>"
                + "<h2 style='color:blue;'>" + codigo + "</h2>"
                + "<p>Ingresa este código para verificar tu cuenta.</p>"
                + "<p><small>Si no solicitaste este registro, ignora este mensaje.</small></p>";

        MimeMessage mensaje = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mensaje, true);

        helper.setTo(destinatario);
        helper.setSubject(asunto);
        helper.setText(contenido, true); // true = HTML

        mailSender.send(mensaje);
    }
}
