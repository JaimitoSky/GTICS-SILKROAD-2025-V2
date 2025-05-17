package com.example.grupo_6.Repository;
import com.example.grupo_6.Dto.ServicioSimplificado;
import com.example.grupo_6.Repository.SedeServicioRepository;
import com.example.grupo_6.Dto.ServicioPorSedeDTO;
import com.example.grupo_6.Entity.SedeServicio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SedeServicioRepository extends JpaRepository<SedeServicio, Integer> {
    List<SedeServicio> findBySedeIdsede(Integer idsede);
    List<SedeServicio> findBySede_Idsede(Integer idsede);
    @Query("""
    SELECT ss.idSedeServicio AS idSedeServicio,
           s.nombre AS nombre,
           s.descripcion AS descripcion,
           t.monto AS monto
    FROM SedeServicio ss
    JOIN ss.servicio s
    JOIN ss.tarifa t
    WHERE ss.sede.idsede = :idSede
""")
    List<ServicioPorSedeDTO> obtenerServiciosPorSede(@Param("idSede") Integer idSede);
    Optional<SedeServicio> findBySede_IdsedeAndServicio_Idservicio(Integer idsede, Integer idservicio);

    @Query("""
    SELECT 
        s.nombre AS nombreServicio, 
        se.nombre AS nombreSede, 
        se.direccion AS direccion, 
        s.idservicio AS idServicio
    FROM SedeServicio ss
    JOIN ss.servicio s
    JOIN ss.sede se
    WHERE s.tipoServicio.idtipo = ?1 AND s.estado.idestado = 4
""")
    List<ServicioSimplificado> listarServiciosSimplificadosPorTipo(int idtipo);



    @Query("""
        SELECT ss
        FROM SedeServicio ss
        JOIN FETCH ss.servicio s
        JOIN FETCH ss.tarifa t
        WHERE ss.idSedeServicio = :id
    """)
    Optional<SedeServicio> obtenerDetalleComplejoPorId(@Param("id") Integer id);



}
