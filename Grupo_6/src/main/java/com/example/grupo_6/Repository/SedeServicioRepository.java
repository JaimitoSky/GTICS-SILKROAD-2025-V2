package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.SedeServicio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SedeServicioRepository extends JpaRepository<SedeServicio, Integer> {
    // Puedes agregar métodos personalizados si los necesitas
}
