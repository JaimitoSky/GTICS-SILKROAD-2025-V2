package com.example.grupo_6.Entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalTime;

@Entity
@Table(name = "coordinador_horario")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class CoordinadorHorario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_coordinador_horario")
    private Integer idCoordinadorHorario;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "id_coordinador_sede", nullable = false)
    private CoordinadorSede coordinadorSede;

    // QUITAMOS: private String diaSemana;

    @Enumerated(EnumType.STRING)
    @Column(name = "dia_semana", nullable = false)
    private HorarioAtencion.DiaSemana diaSemana;

    @Column(name = "hora_entrada", nullable = false)
    private LocalTime horaEntrada;

    @Column(name = "hora_salida", nullable = false)
    private LocalTime horaSalida;

    @Column(nullable = false)
    private boolean activo = true;

    public CoordinadorHorario(CoordinadorSede cs, HorarioAtencion.DiaSemana dia) {
        this.coordinadorSede = cs;
        this.diaSemana       = dia;
        this.activo          = true;
    }
}


