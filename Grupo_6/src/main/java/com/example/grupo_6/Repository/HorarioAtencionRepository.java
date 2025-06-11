package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.HorarioAtencion;
import com.example.grupo_6.Entity.Sede;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface HorarioAtencionRepository extends JpaRepository<HorarioAtencion, Integer> {
        List<HorarioAtencion> findBySede_IdsedeAndActivoTrue(Integer idsede);
    List<HorarioAtencion> findBySede_Idsede(Integer idsede);
    Optional<HorarioAtencion> findBySedeAndDiaSemana(Sede sede, HorarioAtencion.DiaSemana diaSemana);
    int countBySede(Sede sede);
    boolean existsBySedeAndDiaSemanaAndActivoTrue(Sede sede, HorarioAtencion.DiaSemana diaSemana);

    List<HorarioAtencion> findBySedeAndActivoTrue(Sede sede);




}
