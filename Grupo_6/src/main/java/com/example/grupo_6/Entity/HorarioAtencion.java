package com.example.grupo_6.Entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalTime;
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "horario_atencion")
@Getter
@Setter
public class HorarioAtencion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idhorarioAtencion;

    @ManyToOne
    @JoinColumn(name = "idsede", nullable = false)
    private Sede sede;


    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private DiaSemana diaSemana;

    @Column(nullable = false)
    private LocalTime horaInicio;

    @Column(nullable = false)
    private LocalTime horaFin;

    @Column
    private Boolean activo = true;



    public enum DiaSemana {
        Lunes, Martes, Miércoles, Jueves, Viernes, Sábado, Domingo
    }
    public HorarioAtencion(Integer id, Sede sede, DiaSemana diaSemana, LocalTime horaInicio, LocalTime horaFin, boolean activo) {
        this.idhorarioAtencion = id;
        this.sede = sede;
        this.diaSemana = diaSemana;
        this.horaInicio = horaInicio;
        this.horaFin = horaFin;
        this.activo = activo;
    }
    public Boolean isActivo() {
        return activo;
    }


}