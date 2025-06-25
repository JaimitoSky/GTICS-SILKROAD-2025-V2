package com.example.grupo_6.Repository;

import com.example.grupo_6.Dto.ServicioSimplificado;
import com.example.grupo_6.Entity.*;
import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

@Repository

public interface ReservaRepository extends JpaRepository<Reserva, Integer> {
    Reserva findByPago(Pago pago);

    @Query("SELECT r.fechaReserva, COUNT(r) FROM Reserva r GROUP BY r.fechaReserva")
    List<Object[]> countReservasPorDia();
    default List<Map<String, Object>> countReservasPorDiaFormatted() {
        return countReservasPorDia().stream()
                .map(row -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("dia", ((LocalDate) row[0]).toString());
                    map.put("cantidad", ((Number) row[1]).intValue());
                    return map;
                })
                .collect(Collectors.toList());
    }
    long countByHorarioDisponibleAndEstado(HorarioDisponible h, Estado estado);

    @Query("""
    SELECT s.nombre AS nombreServicio,
           se.nombre AS nombreSede,
           se.direccion AS direccion,
           s.idservicio AS idServicio
    FROM SedeServicio ss
    JOIN ss.servicio s
    JOIN ss.sede se
    WHERE s.tipoServicio.idtipo = ?1 AND s.estado.idestado = 4
    """)
    List<ServicioSimplificado> listarServiciosSimplificadosPorTipo(int idtipo);




    long countByHorarioDisponibleAndEstadoAndFechaReserva(HorarioDisponible horario, Estado estado, LocalDate fechaReserva);
    boolean existsByUsuarioAndHorarioDisponibleAndFechaReserva(Usuario usuario, HorarioDisponible horario, LocalDate fechaReserva);

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
    boolean existsByHorarioDisponibleAndFechaReserva(HorarioDisponible horario, LocalDate fechaReserva);


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


    // ReservaRepository.java
    long countByFechaCreacionBetween(LocalDateTime inicio, LocalDateTime fin);

    @Query("SELECT COUNT(u) FROM Usuario u JOIN Rol r ON u.idrol = r.idrol WHERE LOWER(r.nombre) = LOWER(:nombre)")
    long countUsuariosPorNombreRol(@Param("nombre") String nombre);


    @Query("SELECT r FROM Reserva r WHERE r.sedeServicio.sede.idsede = :idSede")
    List<Reserva> buscarReservasPorIdSede(@Param("idSede") Integer idSede);

//reservas con filtro

    @Query("""
SELECT r FROM Reserva r
JOIN r.usuario u
JOIN r.sedeServicio ss
JOIN ss.sede s
WHERE (:estado = '' OR LOWER(r.estado.nombre) = LOWER(:estado))
AND (:vecino = '' OR LOWER(CONCAT(u.nombres, ' ', u.apellidos)) LIKE LOWER(CONCAT('%', :vecino, '%')))
AND (:sede IS NULL OR s.idsede = :sede)
AND (:fechaInicio IS NULL OR r.fechaReserva >= :fechaInicio)
AND (:fechaFin IS NULL OR r.fechaReserva <= :fechaFin)
""")
    Page<Reserva> buscarConFiltros(@Param("estado") String estado,
                                   @Param("fechaInicio") LocalDate fechaInicio,
                                   @Param("fechaFin") LocalDate fechaFin,
                                   @Param("vecino") String vecino,
                                   @Param("sede") Integer sede,
                                   Pageable pageable);


    @Query("SELECT r FROM Reserva r WHERE LOWER(CONCAT(r.usuario.nombres, ' ', r.usuario.apellidos)) LIKE %:valor%")
    Page<Reserva> filtrarPorVecino(@Param("valor") String valor, Pageable pageable);

    @Query("SELECT r FROM Reserva r WHERE LOWER(r.estado.nombre) LIKE %:valor%")
    Page<Reserva> filtrarPorEstado(@Param("valor") String valor, Pageable pageable);

    @Query("SELECT r FROM Reserva r WHERE LOWER(r.sedeServicio.sede.nombre) LIKE %:valor%")
    Page<Reserva> filtrarPorSede(@Param("valor") String valor, Pageable pageable);

    @Query("SELECT r FROM Reserva r WHERE DATE(r.fechaReserva) = :valor")
    Page<Reserva> filtrarPorFecha(@Param("valor") LocalDate valor, Pageable pageable);

    @Query("SELECT r FROM Reserva r WHERE r.sedeServicio.sede.idsede IN :ids")
    List<Reserva> buscarReservasPorIdsSede(@Param("ids") List<Integer> ids);

    @Query("SELECT r FROM Reserva r WHERE r.sedeServicio.sede.idsede IN :idsSede ORDER BY r.fechaCreacion DESC")
    Page<Reserva> buscarReservasPorIdsSedePaginado(@Param("idsSede") List<Integer> idsSede, Pageable pageable);

    long countByHorarioDisponibleAndEstadoInAndFechaReserva(
            HorarioDisponible horario,
            List<Estado> estados,
            LocalDate fecha
    );
    List<Reserva> findByUsuario_IdusuarioAndSedeServicio_IdSedeServicio(Integer idUsuario, Integer idSedeServicio);
    List<Reserva> findByEstado(Estado estado);


    boolean existsByUsuarioAndHorarioDisponibleAndFechaReservaAndEstadoNot(
            Usuario usuario,
            HorarioDisponible horario,
            LocalDate fechaReserva,
            Estado estado
    );

}

