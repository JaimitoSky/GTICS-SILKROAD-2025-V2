package com.example.grupo_6.Repository;
import com.example.grupo_6.Entity.Estado;
import com.example.grupo_6.Entity.HorarioDisponible;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HorarioDisponibleRepository extends JpaRepository<HorarioDisponible, Integer> {

    @Query("SELECT h FROM HorarioDisponible h WHERE h.sedeServicio.idSedeServicio = :id AND h.activo = true")
    List<HorarioDisponible> buscarPorSedeServicioId(@Param("id") Integer id);
    List<HorarioDisponible> findByActivoTrue();


}
