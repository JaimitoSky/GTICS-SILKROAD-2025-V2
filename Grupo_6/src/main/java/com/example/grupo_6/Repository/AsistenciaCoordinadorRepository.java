package com.example.grupo_6.Repository;

import com.example.grupo_6.Dto.DetalleCoordinadorDTO;
import com.example.grupo_6.Entity.AsistenciaCoordinador;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.example.grupo_6.Entity.Usuario;  // Ajusta según tu estructura

import java.sql.Date;
import java.util.List;
import java.util.Optional;

@Repository
public interface AsistenciaCoordinadorRepository extends JpaRepository<AsistenciaCoordinador, Integer> {


    Optional<AsistenciaCoordinador> findByUsuario_IdusuarioAndFechaAndSede_Idsede(Integer idusuario, Date fecha, Integer idsede);



    @Query("SELECT a FROM AsistenciaCoordinador a " +
            "WHERE LOWER(CONCAT(a.usuario.nombres, ' ', a.usuario.apellidos)) LIKE LOWER(CONCAT('%', :filtro, '%')) " +
            "AND (:mes IS NULL OR :mes = '' OR FUNCTION('DATE_FORMAT', a.fecha, '%Y-%m') = :mes)")
    Page<AsistenciaCoordinador> buscarPorNombreYMes(@Param("filtro") String filtro,
                                                    @Param("mes") String mes,
                                                    Pageable pageable);

    @Query("SELECT a FROM AsistenciaCoordinador a " +
            "WHERE LOWER(a.sede.nombre) LIKE LOWER(CONCAT('%', :filtro, '%')) " +
            "AND (:mes IS NULL OR :mes = '' OR FUNCTION('DATE_FORMAT', a.fecha, '%Y-%m') = :mes)")
    Page<AsistenciaCoordinador> buscarPorSedeYMes(@Param("filtro") String filtro,
                                                  @Param("mes") String mes,
                                                  Pageable pageable);

    @Query("SELECT a FROM AsistenciaCoordinador a " +
            "WHERE a.estado = :estado " +
            "AND (:mes IS NULL OR :mes = '' OR FUNCTION('DATE_FORMAT', a.fecha, '%Y-%m') = :mes)")
    Page<AsistenciaCoordinador> buscarPorEstadoYMes(@Param("estado") AsistenciaCoordinador.EstadoAsistencia estado,
                                                    @Param("mes") String mes,
                                                    Pageable pageable);

    @Query("SELECT a FROM AsistenciaCoordinador a " +
            "WHERE a.usuario.dni LIKE CONCAT('%', :filtro, '%') " +
            "AND (:mes IS NULL OR :mes = '' OR FUNCTION('DATE_FORMAT', a.fecha, '%Y-%m') = :mes)")
    Page<AsistenciaCoordinador> buscarPorDniYMes(@Param("filtro") String filtro,
                                                 @Param("mes") String mes,
                                                 Pageable pageable);





    @Query("""
    SELECT 
        u.idusuario AS idusuario,
        u.nombres AS nombres,
        u.apellidos AS apellidos,
        u.dni AS dni,
        SUM(CASE WHEN a.estado = 'presente' THEN 1 ELSE 0 END) AS presente,
        SUM(CASE WHEN a.estado = 'tarde' THEN 1 ELSE 0 END) AS tarde,
        SUM(CASE WHEN a.estado = 'falta' THEN 1 ELSE 0 END) AS falta,
        COUNT(DISTINCT i.idincidencia) AS incidencias
    FROM Usuario u
    LEFT JOIN AsistenciaCoordinador a ON a.usuario = u 
        AND FUNCTION('DATE_FORMAT', a.fecha, '%Y-%m') = :mes
        AND a.estado != 'no_trabaja'
            LEFT JOIN Incidencia i ON i.coordinador = u\s
                                                    AND FUNCTION('DATE_FORMAT', i.fecha, '%Y-%m') = :mes
    WHERE u.rol.nombre = 'COORDINADOR'
    GROUP BY u.idusuario, u.nombres, u.apellidos, u.dni
""")
    List<DetalleCoordinadorDTO> obtenerResumenCoordinadoresPorMes(@Param("mes") String mes);






}


