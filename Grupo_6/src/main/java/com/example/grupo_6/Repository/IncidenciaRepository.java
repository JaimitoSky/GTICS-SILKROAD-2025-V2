package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.Incidencia;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
@Repository

public interface IncidenciaRepository extends JpaRepository<Incidencia, Integer> {
    List<Incidencia> findByReserva_Idreserva(Integer idreserva);

    List<Incidencia> findAllByReserva_Idreserva(Integer idreserva);

}
