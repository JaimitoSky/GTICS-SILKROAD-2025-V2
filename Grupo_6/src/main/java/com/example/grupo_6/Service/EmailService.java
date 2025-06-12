package com.example.grupo_6.Service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.FileSystemResource;
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
        String asunto = "Código de verificación - Municipalidad de San Miguel";

        String contenido = "<div style='font-family: Arial, sans-serif; color: #333;'>"
                + "<h2>Bienvenido(a) al Sistema de Reservas Deportivas</h2>"
                + "<p>Estimado(a) usuario:</p>"
                + "<p>Gracias por registrarte en el sistema de reservas de canchas deportivas de la <strong>Municipalidad de San Miguel</strong>.</p>"
                + "<p>Para completar tu registro, por favor ingresa el siguiente código de verificación:</p>"
                + "<div style='margin: 20px 0; font-size: 28px; font-weight: bold; color: #0066cc;'>" + codigo + "</div>"
                + "<p>Este código es válido por unos minutos.</p>"
                + "<p>Si tú no solicitaste este registro, puedes ignorar este mensaje.</p>"
                + "<br><br>"
                + "<p>Atentamente,</p>"
                + "<p><strong>Municipalidad de San Miguel - Lima</strong></p>"
                + "<img src='cid:logoSanMiguel' style='margin-top:20px; width:180px;'/>"
                + "</div>";

        MimeMessage mensaje = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mensaje, true);

        helper.setTo(destinatario);
        helper.setSubject(asunto);
        helper.setText(contenido, true); // true = HTML

        // Adjuntar imagen del logo (asegúrate de tener el archivo en el path indicado)
        ClassPathResource logo = new ClassPathResource("static/img/photos/logo-san-miguel.png");
        helper.addInline("logoSanMiguel", logo);

        mailSender.send(mensaje);
    }

}
