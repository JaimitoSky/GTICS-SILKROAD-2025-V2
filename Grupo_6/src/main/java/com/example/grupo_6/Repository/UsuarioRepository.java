package com.example.grupo_6.Repository;

import com.example.grupo_6.Dto.CoordinadorPerfilDTO;
import com.example.grupo_6.Dto.VecinoPerfilDTO;
import com.example.grupo_6.Entity.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Integer> {

    @Query("SELECT u FROM Usuario u WHERE " +
            "LOWER(CONCAT(u.nombres, ' ', u.apellidos)) LIKE %:filtro% OR " +
            "LOWER(u.email) LIKE %:filtro% OR " +
            "CAST(u.idrol AS string) LIKE %:filtro%")
    List<Usuario> buscarPorNombreCorreoORol(@Param("filtro") String filtro);

    //int countByActivoTrue();
    //int countBySesionIniciadaTrue(); // opcional, si tienes ese campo


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
    Usuario findByDni(String dni);

    @Query("SELECT u.idrol, COUNT(u) FROM Usuario u GROUP BY u.idrol")
    List<Object[]> countUsuariosPorRol();

    @Query("SELECT u.nombres AS nombres, u.apellidos AS apellidos, u.email AS correo, u.direccion AS direccion, u.telefono AS telefono FROM Usuario u WHERE u.idusuario = ?1")
    VecinoPerfilDTO obtenerPerfilVecinoPorId(int id);

    Usuario findByEmail(String email);

    @Query("SELECT u.email AS email, u.nombres AS nombres, u.apellidos AS apellidos, u.telefono AS telefono, u.direccion AS direccion FROM Usuario u WHERE u.idusuario = ?1")
    CoordinadorPerfilDTO obtenerPerfilCoordinadorPorId(Integer id);

    Usuario findByIdusuario(Integer idusuario);

}


