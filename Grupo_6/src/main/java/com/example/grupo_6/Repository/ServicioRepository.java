package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.Servicio;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ServicioRepository extends JpaRepository<Servicio, Integer> {

    @Query("SELECT DISTINCT s.nombre FROM Servicio s ORDER BY s.nombre ASC")
    List<String> obtenerNombres();

    // Puedes agregar métodos personalizados si es necesario, como buscar por nombre
}

