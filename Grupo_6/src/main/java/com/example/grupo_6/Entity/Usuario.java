package com.example.grupo_6.Entity;

import jakarta.persistence.*;
import lombok.Data;

import java.io.Serializable;
import java.sql.Timestamp;

@Entity
@Table(name = "usuario")
@Data
public class Usuario implements Serializable {

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

    @Column(name = "idrol")
    private Integer idrol;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idrol", referencedColumnName = "idrol", insertable = false, updatable = false)
    private Rol rol;


    private String estado;

    private Boolean notificar_recordatorio;
    private Boolean notificar_disponibilidad;

    public Boolean getNotificarRecordatorio() {
        return notificar_recordatorio;
    }

    public void setNotificarRecordatorio(Boolean notificar_recordatorio) {
        this.notificar_recordatorio = notificar_recordatorio;
    }

    public Boolean getNotificarDisponibilidad() {
        return notificar_disponibilidad;
    }

    public void setNotificarDisponibilidad(Boolean notificar_disponibilidad) {
        this.notificar_disponibilidad = notificar_disponibilidad;
    }


    @Column(name = "create_time")
    private Timestamp createTime;


    public void setRol(Rol r) {
    }

}
