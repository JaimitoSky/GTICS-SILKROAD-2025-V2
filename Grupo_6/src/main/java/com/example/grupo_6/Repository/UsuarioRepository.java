package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Integer> {
    List<Usuario> findByEstado(String estado);
    List<Usuario> findByIdrol(Integer idrol);



}
