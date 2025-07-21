package com.example.grupo_6.Repository;
import com.example.grupo_6.Dto.HorarioDisponibleDTO;
import com.example.grupo_6.Entity.Estado;
import com.example.grupo_6.Entity.HorarioAtencion;
import com.example.grupo_6.Entity.HorarioDisponible;
import com.example.grupo_6.Entity.Servicio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface HorarioDisponibleRepository extends JpaRepository<HorarioDisponible, Integer> {

    @Query("SELECT h FROM HorarioDisponible h " +
            "WHERE h.servicio IN (SELECT ss.servicio FROM SedeServicio ss WHERE ss.sede.nombre = :sede) " +
            "AND h.horaInicio = :hora AND h.horarioAtencion.diaSemana = :diaSemana")
    List<HorarioDisponible> buscarHorarioDisponible(
            @Param("sede") String sede,
            @Param("hora") LocalTime hora,
            @Param("diaSemana") HorarioAtencion.DiaSemana diaSemana);




    @Query("""
    SELECT h FROM HorarioDisponible h
    WHERE h.horarioAtencion.sede.idsede = :idSede
      AND h.servicio.idservicio = :idServicio
      AND h.activo = true
""")
    List<HorarioDisponible> buscarPorSedeServicioId(
            @Param("idSede") Integer idSede,
            @Param("idServicio") Integer idServicio
    );

    List<HorarioDisponible> findByHorarioAtencion_Sede_Idsede(Integer idsede);
    boolean existsByHorarioAtencionAndHoraInicioAndHoraFinAndServicio(
            HorarioAtencion ha, LocalTime inicio, LocalTime fin, Servicio servicio);

    List<HorarioDisponible> findByServicio_IdservicioAndHorarioAtencion_Sede_IdsedeAndHorarioAtencion_DiaSemanaAndActivoTrue(
            Integer idServicio,
            Integer idSede,
            HorarioAtencion.DiaSemana diaSemana
    );
    @Query("SELECT h FROM HorarioDisponible h WHERE h.horarioAtencion.sede.idsede = :idSede AND h.activo = true")
    List<HorarioDisponible> buscarPorIdSede(@Param("idSede") Integer idSede);



    List<HorarioDisponible> findByActivoTrue();

    @Query("""
    SELECT h FROM HorarioDisponible h
    WHERE h.servicio.idservicio = :idServicio
    AND h.horarioAtencion.sede.idsede = :idSede
    AND h.horarioAtencion.diaSemana = :dia
    AND h.activo = true
""")
    List<HorarioDisponible> findBySedeAndServicioAndDiaSemanaActivos(
            @Param("idSede") Integer idSede,
            @Param("idServicio") Integer idServicio,
            @Param("dia") HorarioAtencion.DiaSemana dia
    );
    @Query("""
    SELECT h FROM HorarioDisponible h
    WHERE h.horarioAtencion.sede.idsede = :idSede
      AND h.servicio.idservicio = :idServicio
""")
    List<HorarioDisponible> buscarTodosPorSedeYServicio(
            @Param("idSede") Integer idSede,
            @Param("idServicio") Integer idServicio
    );


    @Query(value = """
    SELECT 
        h.idhorario AS idhorario,
        ha.dia_semana AS diaSemana,
        h.hora_inicio AS horaInicio,
        h.hora_fin AS horaFin,
        h.aforo_maximo AS aforoMaximo,
        h.activo AS activo,
        CASE 
            WHEN ha.activo = true 
             AND h.hora_inicio >= ha.hora_inicio 
             AND h.hora_fin <= ha.hora_fin 
            THEN true ELSE false 
        END AS editable
    FROM horario_disponible h
    JOIN horario_atencion ha ON h.idhorario_atencion = ha.idhorario_atencion
    WHERE ha.idsede = :idsede
    """, nativeQuery = true)
    List<HorarioDisponibleDTO> listarPorSede(@Param("idsede") Integer idsede);

    @Query("""
    SELECT h FROM HorarioDisponible h
    WHERE h.activo = true
      AND h.horarioAtencion.sede.nombre = :nombreSede
      AND h.horarioAtencion.diaSemana = :diaSemana
      AND NOT EXISTS (
          SELECT r FROM Reserva r
          WHERE r.horarioDisponible = h
            AND r.estado.nombre NOT IN ('Cancelado', 'Expirado')
      )
""")
    List<HorarioDisponible> listarHorariosDisponiblesPorSedeYDiaSemana(@Param("nombreSede") String nombreSede,
                                                                       @Param("diaSemana") HorarioAtencion.DiaSemana diaSemana);





}


