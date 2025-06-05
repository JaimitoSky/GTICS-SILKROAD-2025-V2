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
    @JoinColumn(name = "idhorario_atencion", nullable = false)
    private HorarioAtencion horarioAtencion;

    @ManyToOne
    @JoinColumn(name = "idservicio", nullable = false)
    private Servicio servicio;


    @Column(name = "hora_inicio", nullable = false)
    private LocalTime horaInicio;

    @Column(name = "hora_fin", nullable = false)
    private LocalTime horaFin;

    @Column(nullable = false)
    private Boolean activo;

    @Column(name = "aforo_maximo")
    private Integer aforoMaximo;

    // Getters y Setters
    public Integer getAforoMaximo() {
        return aforoMaximo;
    }
    public void setAforoMaximo(Integer aforoMaximo) {
        this.aforoMaximo = aforoMaximo;
    }

}
