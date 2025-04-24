package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.Usuario;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import java.util.List;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Integer> {

    @Query("SELECT u FROM Usuario u WHERE " +
            "LOWER(CONCAT(u.nombres, ' ', u.apellidos)) LIKE %:filtro% OR " +
            "LOWER(u.email) LIKE %:filtro% OR " +
            "CAST(u.idrol AS string) LIKE %:filtro%")
    List<Usuario> buscarPorNombreCorreoORol(@Param("filtro") String filtro);

    @Query("SELECT u FROM Usuario u WHERE LOWER(u.nombres) LIKE %:valor% OR LOWER(u.apellidos) LIKE %:valor%")
    List<Usuario> buscarPorNombre(@Param("valor") String valor);

    @Query("SELECT u FROM Usuario u WHERE LOWER(u.email) LIKE %:valor%")
    List<Usuario> buscarPorCorreo(@Param("valor") String valor);

    @Query("SELECT u FROM Usuario u WHERE LOWER(u.estado) LIKE %:valor%")
    List<Usuario> buscarPorEstado(@Param("valor") String valor);

    @Query("SELECT u FROM Usuario u WHERE CAST(u.idusuario AS string) LIKE %:valor%")
    List<Usuario> buscarPorId(@Param("valor") String valor);

    @Query("SELECT u FROM Usuario u WHERE CAST(u.idrol AS string) LIKE %:valor%")
    List<Usuario> buscarPorRol(@Param("valor") String valor);
}


