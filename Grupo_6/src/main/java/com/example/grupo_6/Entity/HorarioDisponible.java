package com.example.grupo_6.Entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalTime;

@Entity
@Table(name = "horario_disponible")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class HorarioDisponible {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idhorario;

    @ManyToOne
    @JoinColumn(name = "idsede_servicio", nullable = false)
    private SedeServicio sedeServicio;

    @Column(name = "hora_inicio", nullable = false)
    private LocalTime horaInicio;

    @Column(name = "hora_fin", nullable = false)
    private LocalTime horaFin;

    @Column(nullable = false)
    private Boolean activo;
}
