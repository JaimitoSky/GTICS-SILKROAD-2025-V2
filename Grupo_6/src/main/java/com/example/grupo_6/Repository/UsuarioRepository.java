package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Integer> {

    // Si quieres búsquedas personalizadas, agregas métodos
    // Ej: List<Usuario> findByNombresContaining(String nombre);

}
