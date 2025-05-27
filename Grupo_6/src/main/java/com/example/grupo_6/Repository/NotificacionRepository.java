package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.Notificacion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.jpa.repository.*;
import java.util.List;

@Repository
public interface NotificacionRepository extends JpaRepository<Notificacion, Integer> {
    List<Notificacion> findByUsuario_IdusuarioOrderByFechaEnvioDesc(Integer idusuario);
    long countByUsuario_IdusuarioAndLeidoFalse(Integer idusuario);

    boolean existsByUsuario_IdusuarioAndTituloAndMensajeContaining(Integer idUsuario, String titulo, String mensaje);

    @Modifying
    @Transactional
    @Query("UPDATE Notificacion n SET n.leido = true WHERE n.usuario.idusuario = :idUsuario")
    void marcarTodasComoLeidas(@Param("idUsuario") Integer idUsuario);

    @Modifying
    @Transactional
    void deleteByUsuario_Idusuario(Integer idusuario);
}
