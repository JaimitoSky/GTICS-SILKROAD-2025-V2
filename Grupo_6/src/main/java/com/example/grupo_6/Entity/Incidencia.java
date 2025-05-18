package com.example.grupo_6.Entity;
import jakarta.persistence.*;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@Table(name = "incidencia")
public class Incidencia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idincidencia;

    @ManyToOne
    @JoinColumn(name = "idreserva")
    private Reserva reserva;

    @ManyToOne
    @JoinColumn(name = "idusuario")
    private Usuario coordinador;

    private String descripcion;

    private Timestamp fecha;

    public LocalDateTime getFechaLocal() {
        return getFecha().toLocalDateTime();
    }

}
