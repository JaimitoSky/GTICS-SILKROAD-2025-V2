package com.example.grupo_6.Entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@Table(name = "asignacion_sede")
@Getter
@Setter
public class AsignacionSede {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "idusuario")
    private Integer idUsuario;

    @Column(name = "idsede")
    private Integer idSede;

    private LocalDate fecha;

    @Column(name = "entrada")
    private Boolean entrada;

    @Column(name = "salida")
    private Boolean salida;

    @ManyToOne
    @JoinColumn(name = "idsede", referencedColumnName = "idsede", insertable = false, updatable = false)
    private Sede sede;
}
