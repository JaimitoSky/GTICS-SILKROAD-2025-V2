package com.example.grupo_6.Repository;
import com.example.grupo_6.Entity.Estado;
import com.example.grupo_6.Entity.HorarioAtencion;
import com.example.grupo_6.Entity.HorarioDisponible;
import com.example.grupo_6.Entity.Servicio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalTime;
import java.util.List;

@Repository
public interface HorarioDisponibleRepository extends JpaRepository<HorarioDisponible, Integer> {

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


}
