package com.example.grupo_6.Entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Entity
@Table(name = "sede")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Sede {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idsede;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(length = 255)
    private String direccion;

    @Column(length = 100)
    private String distrito;

    @Column(length = 255)
    private String referencia;

    private Double latitud;

    private Double longitud;

    @Column
    private Boolean activo = true;

    @OneToMany(mappedBy = "sede")
    private List<SedeServicio> sedeServicios;
}
