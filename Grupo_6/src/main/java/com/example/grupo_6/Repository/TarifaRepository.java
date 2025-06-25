package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.Tarifa;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TarifaRepository extends JpaRepository<Tarifa, Integer> {

    // Método personalizado para obtener todas las tarifas con el nombre del servicio y su tipo
    @Query("SELECT t FROM Tarifa t " +
            "JOIN FETCH t.sedeServicios ss " +
            "JOIN FETCH ss.servicio s " +
            "JOIN FETCH s.tipoServicio ts " +
            "JOIN FETCH ss.sede se")
    List<Tarifa> findAllWithSedeYTipo();

    Page<Tarifa> findByDescripcionContainingIgnoreCase(String descripcion, Pageable pageable);



}

