package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.AsignacionSede;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.Optional;

@Repository
public interface AsignacionSedeRepository extends JpaRepository<AsignacionSede, Integer> {
    Optional<AsignacionSede> findByIdUsuarioAndFecha(Integer idUsuario, LocalDate fecha);
}
