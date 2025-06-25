package com.example.grupo_6.Entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Pago {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idpago;

    @ManyToOne
    @JoinColumn(name = "idusuario", nullable = false)
    private Usuario usuario;

    @OneToOne(mappedBy = "pago", fetch = FetchType.LAZY)
    private Reserva reserva;


    private BigDecimal monto;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Metodo metodo; // 'online' o 'banco'

    @Lob
    @Column(name = "comprobante", columnDefinition = "LONGBLOB")
    private byte[] comprobante;

    @ManyToOne
    @JoinColumn(name = "idestado", nullable = false)
    private Estado estado;

    @Column(name = "fecha_pago")
    private LocalDateTime fechaPago;

    public enum Metodo {
        online, banco
    }


}
