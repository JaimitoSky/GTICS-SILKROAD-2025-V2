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

    // ✅ Relación con la entidad Usuario
    @ManyToOne
    @JoinColumn(name = "idusuario", nullable = false)
    private Usuario usuario;

    private String titulo;

    @Column(columnDefinition = "text")
    private String mensaje;

    @Column(columnDefinition = "BOOLEAN DEFAULT false")
    private Boolean leido;


    @Column(name = "fecha_envio")
    private Timestamp fechaEnvio;

    private String tipo;

    @Column(name = "id_referencia")
    private Integer idReferencia;

}
