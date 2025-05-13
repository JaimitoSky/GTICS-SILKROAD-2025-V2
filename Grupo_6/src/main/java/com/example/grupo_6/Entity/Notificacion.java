package com.example.grupo_6.Entity;

import jakarta.persistence.*;
import lombok.Data;

import java.sql.Timestamp;

@Entity
@Table(name = "notificacion")
@Data
public class Notificacion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idnotificacion;

    @Column(name = "idusuario")
    private Integer idusuario;

    private String titulo;

    @Column(columnDefinition = "text")
    private String mensaje;

    private Boolean leido;

    @Column(name = "fecha_envio")
    private Timestamp fechaEnvio;
}
