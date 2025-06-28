package com.example.grupo_6.Entity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "tarjeta_virtual")
@Getter
@Setter
public class TarjetaVirtual {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "idtarjeta")
    private Integer idtarjeta;

    @Column(name = "numero_tarjeta", length = 16, nullable = false)
    private String numeroTarjeta;

    @Column(nullable = false)
    private LocalDate vencimiento;

    @Column(length = 4, nullable = false)
    private String cvv;

    @Column(length = 100, nullable = false)
    private String titular;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal saldo;
}