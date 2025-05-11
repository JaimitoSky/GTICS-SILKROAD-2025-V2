package com.example.grupo_6.Entity;

import jakarta.persistence.*;
import lombok.Data;
import java.sql.Timestamp;

@Entity
@Table(name = "usuario")
@Data // Genera getters, setters, toString, equals y hashCode
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idusuario;

    @Column(length = 8)
    private String dni;

    @Column(length = 100)
    private String nombres;

    @Column(length = 100)
    private String apellidos;

    @Column(length = 255)
    private String email;

    @Column(name = "password_hash", length = 255)
    private String passwordHash;


    @Column(length = 20)
    private String telefono;

    @Column(length = 255)
    private String direccion;

    private Integer idrol;

    private String estado; // Puede ser "activo" o "inactivo"

    private Boolean notificar_recordatorio;
    private Boolean notificar_disponibilidad;

    private Timestamp create_time;
}

