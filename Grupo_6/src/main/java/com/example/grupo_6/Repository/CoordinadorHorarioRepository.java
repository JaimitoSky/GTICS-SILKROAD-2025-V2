package com.example.grupo_6.Repository;


import com.example.grupo_6.Entity.CoordinadorHorario;
import com.example.grupo_6.Entity.CoordinadorSede;
import com.example.grupo_6.Entity.HorarioAtencion;
import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
@Repository

public interface CoordinadorHorarioRepository
        extends JpaRepository<CoordinadorHorario, Integer> {


    Optional<CoordinadorHorario> findByCoordinadorSedeAndDiaSemana(CoordinadorSede cs, HorarioAtencion.DiaSemana diaSemana);


    // Listado de todos los turnos activos para un CoordinadorSede
    List<CoordinadorHorario> findByCoordinadorSedeAndActivoTrue(CoordinadorSede cs);


    List<CoordinadorHorario> findAllByCoordinadorSede(CoordinadorSede cs);
    Optional<CoordinadorHorario> findByCoordinadorSede_IdAndDiaSemanaAndActivoTrue(Integer idCoordinadorSede, HorarioAtencion.DiaSemana diaSemana);




}






