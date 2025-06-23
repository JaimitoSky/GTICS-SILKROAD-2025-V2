package com.example.grupo_6.Entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalTime;

@Getter
@Setter
@Entity
@Table(name = "asistencia_coordinador") // ✅ sin uniqueConstraints aquí
public class AsistenciaCoordinador {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idasistencia;

    @ManyToOne
    @JoinColumn(name = "idusuario", nullable = false)
    @NotNull(message = "El usuario es obligatorio")
    private Usuario usuario;

    @Column(nullable = false)
    @NotNull(message = "La fecha es obligatoria")
    private Date fecha;

    @Column(name = "hora_entrada")
    private Time horaEntrada;



    @Column(precision = 10, scale = 8)
    @Digits(integer = 10, fraction = 8, message = "Latitud no válida")
    private BigDecimal latitud;

    @Column(precision = 11, scale = 8)
    @Digits(integer = 11, fraction = 8, message = "Longitud no válida")
    private BigDecimal longitud;

    @ManyToOne
    @JoinColumn(name = "idsede", nullable = false)
    private Sede sede;

    public enum EstadoAsistencia {
        PRESENTE,
        TARDE,
        FALTA
    }
    // 1) Salida (opcional)
    @Column(name = "hora_salida")
    private LocalTime horaSalida;

    @Column(name = "latitud_salida", precision = 10, scale = 8)
    private BigDecimal latitudSalida;

    @Column(name = "longitud_salida", precision = 11, scale = 8)
    private BigDecimal longitudSalida;

    // 2) Relación al horario de atención usado para esta asistencia
    @ManyToOne
    @JoinColumn(name = "idhorario_atencion", foreignKey = @ForeignKey(name = "fk_asist_horario"))
    private HorarioAtencion horarioAtencion;

    // 3) Estado de la marcación de entrada
    @Enumerated(EnumType.STRING)
    @Column(name = "estado", nullable = false, columnDefinition = "ENUM('presente','tarde','falta')")
    private EstadoAsistencia estado = EstadoAsistencia.FALTA;
}
