package com.example.grupo_6.Entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@Table(name = "sede_servicio")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SedeServicio {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idsede_servicio;

    @ManyToOne
    @JoinColumn(name = "idsede", nullable = false)
    private Sede sede;

    @ManyToOne
    @JoinColumn(name = "idservicio", nullable = false)
    private Servicio servicio;

    @ManyToOne
    @JoinColumn(name = "idtarifa", nullable = false)
    private Tarifa tarifa;
}
