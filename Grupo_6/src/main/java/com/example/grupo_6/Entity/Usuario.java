package com.example.grupo_6.Entity;

import jakarta.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "usuario")
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

    @Column(name = "password_salt", length = 255)
    private String passwordSalt;

    @Column(length = 20)
    private String telefono;

    @Column(length = 255)
    private String direccion;

    private Integer idrol;

    // Aquí mapeamos el ENUM('activo','inactivo').
    // Usamos un EnumType.STRING para almacenar el literal 'activo' o 'inactivo'.
    // Alternativamente, puedes guardar como String sin enum, pero así es más limpio.

    public enum EstadoUsuario {
        activo,
        inactivo
    }


    // notificar_recordatorio y notificar_disponibilidad son tinyint(1),
    // que en Java se suelen mapear como booleans:
    private Boolean notificar_recordatorio;
    private Boolean notificar_disponibilidad;

    // create_time es de tipo timestamp
    private Timestamp create_time;

    // Getters y setters

    public Integer getIdusuario() {
        return idusuario;
    }

    public void setIdusuario(Integer idusuario) {
        this.idusuario = idusuario;
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getPasswordSalt() {
        return passwordSalt;
    }

    public void setPasswordSalt(String passwordSalt) {
        this.passwordSalt = passwordSalt;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public Integer getIdrol() {
        return idrol;
    }

    public void setIdrol(Integer idrol) {
        this.idrol = idrol;
    }


    public Boolean getNotificar_recordatorio() {
        return notificar_recordatorio;
    }

    public void setNotificar_recordatorio(Boolean notificar_recordatorio) {
        this.notificar_recordatorio = notificar_recordatorio;
    }

    public Boolean getNotificar_disponibilidad() {
        return notificar_disponibilidad;
    }

    public void setNotificar_disponibilidad(Boolean notificar_disponibilidad) {
        this.notificar_disponibilidad = notificar_disponibilidad;
    }

    public Timestamp getCreate_time() {
        return create_time;
    }

    public void setCreate_time(Timestamp create_time) {
        this.create_time = create_time;
    }
}
