package com.example.grupo_6.Entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "tarifa")
@Data
public class Tarifa {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idtarifa;

    @OneToMany(mappedBy = "tarifa")
    private List<SedeServicio> sedeServicios;

    private String descripcion;

    private Double monto;

    @Column(name = "fecha_actualizacion")
    private LocalDate fechaActualizacion;
}
