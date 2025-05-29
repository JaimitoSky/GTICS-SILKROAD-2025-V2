package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.CoordinadorSede;
import com.example.grupo_6.Entity.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
@Repository
public interface CoordinadorSedeRepository extends JpaRepository<CoordinadorSede, Integer> {
    List<CoordinadorSede> findByUsuario_IdusuarioAndActivoTrue(Integer idusuario);
    Optional<CoordinadorSede> findByUsuario_IdusuarioAndSede_Idsede(Integer idusuario, Integer idsede);
    List<CoordinadorSede> findBySede_Idsede(Integer idsede);

    // Opcional: obtener todos los usuarios coordinadores activos en una sede
    List<CoordinadorSede> findBySede_IdsedeAndActivoTrue(Integer idsede);
}
