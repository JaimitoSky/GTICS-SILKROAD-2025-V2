package com.example.grupo_6.Entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@Table(name = "sede_servicio")
@NoArgsConstructor
@AllArgsConstructor
public class SedeServicio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idsede_servicio")
    private Integer idSedeServicio;


    @ManyToOne
    @JoinColumn(name = "idsede", nullable = false)
    @JsonIgnoreProperties("sedeServicios") // evita recursión
    private Sede sede;

    @ManyToOne
    @JoinColumn(name = "idservicio", nullable = false)
    @JsonIgnoreProperties("listaSedeServicio") // idem en Servicio
    private Servicio servicio;

    @ManyToOne
    @JoinColumn(name = "idtarifa", nullable = false)
    @JsonIgnoreProperties("sedeServicio") // si Tarifa apunta de regreso a SedeServicio
    private Tarifa tarifa;
}
