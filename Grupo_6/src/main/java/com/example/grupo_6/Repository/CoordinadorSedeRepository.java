package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.CoordinadorSede;
import com.example.grupo_6.Entity.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
@Repository
public interface CoordinadorSedeRepository extends JpaRepository<CoordinadorSede, Integer> {
    Optional<CoordinadorSede> findByUsuario_IdusuarioAndActivoTrue(Integer idusuario);
}
