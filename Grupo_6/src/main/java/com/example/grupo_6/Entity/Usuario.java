package com.example.grupo_6.Entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.Data;

import java.io.Serializable;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@Entity
@Table(name = "usuario")
@Data
public class Usuario implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idusuario;

    @NotBlank(message = "El DNI no puede estar vacío")
    @Pattern(regexp = "\\d{8}", message = "El DNI debe tener 8 dígitos")
    @Column(length = 8)
    private String dni;

    @NotBlank(message = "El nombre no puede estar vacío")
    @Size(max = 100, message = "Máximo 100 caracteres")
    @Column(length = 100)
    private String nombres;

    @NotBlank(message = "El apellido no puede estar vacío")
    @Size(max = 100, message = "Máximo 100 caracteres")
    @Column(length = 100)
    private String apellidos;

    @Pattern(
            regexp = ".*@.*",
            message = "Formato de correo inválido"
    )
    @Size(max = 255)
    @Column(length = 255)
    private String email;


    @NotBlank(message = "La contraseña no puede estar vacía")
    @Size(min = 6, message = "Mínimo 6 caracteres")
    @Column(name = "password_hash", length = 255)
    private String passwordHash;

    @NotBlank(message = "El teléfono no puede estar vacío")
    @Pattern(regexp = "\\d{9}", message = "El teléfono debe tener 9 dígitos")
    @Column(length = 20)
    private String telefono;

    @NotBlank(message = "La dirección no puede estar vacía")
    @Size(max = 255)
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

    @Column(name = "create_time")
    private Timestamp createTime;

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

    public void setRol(Rol r) {}

    @Column(name = "imagen")
    private String imagen;


    @Column(name="photo_updated_at")
    private LocalDateTime photoUpdatedAt;
}
