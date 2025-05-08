package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.Servicio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ServicioRepository extends JpaRepository<Servicio, Integer> {
    // Puedes agregar métodos personalizados si es necesario, como buscar por nombre
}

