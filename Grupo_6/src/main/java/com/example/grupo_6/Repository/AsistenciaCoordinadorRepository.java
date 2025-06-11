package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.AsistenciaCoordinador;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.util.Optional;

@Repository
public interface AsistenciaCoordinadorRepository extends JpaRepository<AsistenciaCoordinador, Integer> {
    boolean existsByUsuario_IdusuarioAndFechaAndSede_Idsede(Integer idusuario, Date fecha, Integer idsede);
    Optional<AsistenciaCoordinador> findByUsuario_IdusuarioAndFechaAndSede_Idsede(Integer idusuario, Date fecha, Integer idsede);

}
