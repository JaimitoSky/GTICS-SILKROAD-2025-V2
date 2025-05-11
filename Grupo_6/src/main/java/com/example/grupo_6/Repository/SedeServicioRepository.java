package com.example.grupo_6.Repository;

import com.example.grupo_6.Dto.ServicioPorSedeDTO;
import com.example.grupo_6.Entity.SedeServicio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

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









    // Puedes agregar métodos personalizados si los necesitas
}
