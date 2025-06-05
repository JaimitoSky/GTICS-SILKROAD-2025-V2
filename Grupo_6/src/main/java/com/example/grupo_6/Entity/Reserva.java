package com.example.grupo_6.Entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Getter
@Setter
@Table(name = "reserva")
public class Reserva {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idreserva")
    private Integer idreserva;

    @ManyToOne
    @JoinColumn(name = "idusuario")
    private Usuario usuario;



    @Column(name = "fecha_reserva")
    private LocalDate fechaReserva;

    @ManyToOne
    @JoinColumn(name = "idhorario", nullable = false)
    private HorarioDisponible horarioDisponible;

    @ManyToOne
    @JoinColumn(name = "idestado")
    private Estado estado;

    @Column(name = "fecha_creacion")
    private LocalDateTime fechaCreacion;

    @Column(name = "fecha_limite_pago")
    private LocalDateTime fechaLimitePago;

    @OneToOne
    @JoinColumn(name = "idpago", unique = true)
    private Pago pago;

    @ManyToOne
    @JoinColumn(name = "idsede_servicio", nullable = false)
    private SedeServicio sedeServicio;

    @Transient
    private Asistencia asistenciaTemporal;

    public Asistencia getAsistenciaTemporal() {
        return asistenciaTemporal;
    }

    public void setAsistenciaTemporal(Asistencia asistenciaTemporal) {
        this.asistenciaTemporal = asistenciaTemporal;
    }

}
