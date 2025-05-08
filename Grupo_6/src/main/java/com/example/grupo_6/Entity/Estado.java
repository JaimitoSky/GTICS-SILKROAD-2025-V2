package com.example.grupo_6.Entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "estado")
@Data
public class Estado {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idestado;

    private String nombre;

    private String descripcion;

    @Enumerated(EnumType.STRING)
    @Column(name = "tipo_aplicacion", nullable = false)
    private TipoAplicacion tipoAplicacion;

    public enum TipoAplicacion {
        reserva, servicio, incidencia, pago, reembolso, taller, usuario
    }
}
