package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.Pago;
import com.example.grupo_6.Entity.Reserva;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository

public interface ReservaRepository extends JpaRepository<Reserva, Integer> {
    Reserva findByPago(Pago pago);

    @Query("SELECT r.fechaReserva, COUNT(r) FROM Reserva r GROUP BY r.fechaReserva")
    List<Object[]> countReservasPorDia();


    @Query("SELECT r.servicio.nombre, COUNT(r) FROM Reserva r GROUP BY r.servicio.nombre")
    List<Object[]> countReservasPorServicio();

    @Query("SELECT r.estado.nombre, COUNT(r) FROM Reserva r GROUP BY r.estado.nombre")
    List<Object[]> countReservasPorEstado();



}

