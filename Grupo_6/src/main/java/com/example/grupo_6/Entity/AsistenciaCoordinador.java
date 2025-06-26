package com.example.grupo_6.Entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalTime;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "asistencia_coordinador")
public class AsistenciaCoordinador {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idasistencia;

    @ManyToOne(optional = false)
    @JoinColumn(name = "idusuario", nullable = false)
    @NotNull(message = "El usuario es obligatorio")
    private Usuario usuario;

    @ManyToOne(optional = false)
    @JoinColumn(name = "idsede", nullable = false)
    @NotNull(message = "La sede es obligatoria")
    private Sede sede;

    @ManyToOne
    @JoinColumn(name = "id_coordinador_horario")
    private CoordinadorHorario coordinadorHorario;

    @Column(nullable = false)
    @NotNull(message = "La fecha es obligatoria")
    private Date fecha;

    @Column(name = "hora_marcacion_entrada")
    private LocalTime horaMarcacionEntrada;

    @Column(name = "hora_marcacion_salida")
    private LocalTime horaMarcacionSalida;

    @Column(name = "hora_programada_entrada")
    private LocalTime horaProgramadaEntrada;

    @Column(name = "hora_programada_salida")
    private LocalTime horaProgramadaSalida;

    @Column(precision = 18, scale = 8)
    @Digits(integer = 10, fraction = 8, message = "Latitud no válida")
    private BigDecimal latitud;

    @Column(precision = 19, scale = 8)
    @Digits(integer = 11, fraction = 8, message = "Longitud no válida")
    private BigDecimal longitud;

    @Column(name = "latitud_salida", precision = 18, scale = 8)
    @Digits(integer = 10, fraction = 8, message = "Latitud de salida no válida")
    private BigDecimal latitudSalida;

    @Column(name = "longitud_salida", precision = 19, scale = 8)
    @Digits(integer = 11, fraction = 8, message = "Longitud de salida no válida")
    private BigDecimal longitudSalida;

    public enum EstadoAsistencia {
        presente,
        tarde,
        falta,
        no_trabaja
    }

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, columnDefinition = "ENUM('presente','tarde','falta','no_trabaja')")
    private EstadoAsistencia estado = EstadoAsistencia.no_trabaja;

    // Getters y Setters ...


}

