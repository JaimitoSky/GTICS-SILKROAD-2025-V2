package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.Estado;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EstadoRepository extends JpaRepository<Estado, Integer> {
    Estado findByNombreAndTipoAplicacion(String nombre, Estado.TipoAplicacion tipoAplicacion);
    // para usarlo correctamente con enum




}

