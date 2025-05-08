package com.example.grupo_6.Entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "rol")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Rol {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idrol;

    private String nombre;

    private String descripcion;

    @Column(name = "nivel_acceso")
    private int nivelAcceso;
}
