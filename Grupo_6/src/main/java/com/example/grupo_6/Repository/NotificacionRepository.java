package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.Notificacion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NotificacionRepository extends JpaRepository<Notificacion, Integer> {
    List<Notificacion> findByUsuario_IdusuarioOrderByFechaEnvioDesc(Integer idusuario);
    long countByUsuario_IdusuarioAndLeidoFalse(Integer idusuario);
}
