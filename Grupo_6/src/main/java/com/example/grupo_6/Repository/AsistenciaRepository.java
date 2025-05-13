package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.Asistencia;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.Optional;

@Repository
public interface AsistenciaRepository extends JpaRepository<Asistencia, Integer> {

    Optional<Asistencia> findByIdusuarioAndFecha(Integer idusuario, LocalDate fecha);

    boolean existsByIdusuarioAndFecha(Integer idusuario, LocalDate fecha);
}
