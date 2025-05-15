package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.Estado;
import com.example.grupo_6.Entity.Pago;
import com.example.grupo_6.Entity.Reserva;
import com.example.grupo_6.Entity.Servicio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@Repository

public interface ReservaRepository extends JpaRepository<Reserva, Integer> {
    Reserva findByPago(Pago pago);

    @Query("SELECT r.fechaReserva, COUNT(r) FROM Reserva r GROUP BY r.fechaReserva")
    List<Object[]> countReservasPorDia();


    @Query("SELECT r.sedeServicio.servicio.nombre, COUNT(r) FROM Reserva r GROUP BY r.sedeServicio.servicio.nombre")
    List<Object[]> countReservasPorServicio();


    @Query("SELECT r.estado.nombre, COUNT(r) FROM Reserva r GROUP BY r.estado.nombre")
    List<Object[]> countReservasPorEstado();

    List<Reserva> findByEstadoAndFechaLimitePagoBefore(Estado estado, LocalDateTime fechaLimite);

    @Query("""
    SELECT COUNT(r) FROM Reserva r
    WHERE r.horarioDisponible.idhorario = :idHorario
      AND r.fechaReserva = :fecha
      AND r.estado.nombre != 'cancelada'
    """)
    int contarReservasEnHorario(
            @Param("idHorario") Integer idHorario,
            @Param("fecha") LocalDate fecha
    );

    List<Reserva> findByUsuarioIdusuario(Integer idusuario);  // ✅ Correcto

    List<Reserva> findByUsuario_Idusuario(Integer idusuario);

    @Query("""
    SELECT r FROM Reserva r 
    WHERE r.sedeServicio.sede.idsede = :idSede 
      AND r.fechaReserva = :fecha
""")
    List<Reserva> buscarReservasPorSedeYFecha(@Param("idSede") Integer idSede, @Param("fecha") LocalDate fecha);

    @Query("""
    SELECT r FROM Reserva r 
    WHERE r.sedeServicio.sede.idsede = :idSede 
    ORDER BY r.fechaReserva DESC
""")
    List<Reserva> buscarHistorialReservasPorSede(@Param("idSede") Integer idSede);




}

