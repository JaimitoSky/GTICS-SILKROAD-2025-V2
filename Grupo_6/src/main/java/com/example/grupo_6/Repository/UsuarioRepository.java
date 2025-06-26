package com.example.grupo_6.Repository;

import com.example.grupo_6.Dto.CoordinadorPerfilDTO;
import com.example.grupo_6.Dto.VecinoPerfilDTO;
import com.example.grupo_6.Entity.Usuario;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

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


    //

    // Para contar usuarios nuevos en el mes
    long countByCreateTimeBetween(Timestamp inicio, Timestamp fin);

    // Para contar usuarios por nombre de rol
    @Query("""
    SELECT COUNT(u)
    FROM Usuario u
    JOIN Rol r ON u.idrol = r.idrol
    WHERE LOWER(r.nombre) = LOWER(:nombre)
""")
    long countUsuariosPorNombreRol(@Param("nombre") String nombre);

    @Query("SELECT r.nombre, COUNT(u) FROM Usuario u JOIN u.rol r GROUP BY r.nombre")
    List<Object[]> countUsuariosPorRolRaw();
    default List<java.util.Map<String, Object>> countUsuariosPorRolFormatted() {
        return countUsuariosPorRolRaw().stream()
                .map(row -> {
                    java.util.Map<String, Object> map = new java.util.HashMap<>();
                    map.put("rol", row[0]);
                    map.put("total", row[1]);
                    return map;
                })
                .collect(java.util.stream.Collectors.toList());
    }

//usuarios con paginacion

    @Query("SELECT u FROM Usuario u WHERE LOWER(u.nombres) LIKE %:valor% OR LOWER(u.apellidos) LIKE %:valor%")
    Page<Usuario> buscarPorNombre(@Param("valor") String valor, Pageable pageable);

    @Query("SELECT u FROM Usuario u WHERE LOWER(u.email) LIKE %:valor%")
    Page<Usuario> buscarPorCorreo(@Param("valor") String valor, Pageable pageable);

    @Query("SELECT u FROM Usuario u WHERE LOWER(u.estado) LIKE %:valor%")
    Page<Usuario> buscarPorEstado(@Param("valor") String valor, Pageable pageable);

    @Query("SELECT u FROM Usuario u WHERE CAST(u.idusuario AS string) LIKE %:valor%")
    Page<Usuario> buscarPorId(@Param("valor") String valor, Pageable pageable);

    @Query("SELECT u FROM Usuario u WHERE CAST(u.idrol AS string) LIKE %:valor%")
    Page<Usuario> buscarPorRol(@Param("valor") String valor, Pageable pageable);

    // Versión paginada de findAll
    Page<Usuario> findAll(Pageable pageable);
    @Query("SELECT u FROM Usuario u WHERE u.rol.nombre = 'COORDINADOR' AND u.estado = 'activo'")
    List<Usuario> obtenerCoordinadoresActivos();

    List<Usuario> findByRol_Nombre(String nombre);


}


