package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.Pago;
import com.example.grupo_6.Entity.Reserva;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PagoRepository extends JpaRepository<Pago, Integer> {
    @Query("SELECT p FROM Pago p " +
            "LEFT JOIN p.usuario u " +
            "WHERE LOWER(CONCAT(u.nombres, ' ', u.apellidos)) LIKE LOWER(CONCAT('%', :nombre, '%')) " +
            "AND (:dni = '' OR u.dni LIKE CONCAT('%', :dni, '%'))")
    Page<Pago> buscarPagosFiltrados(@Param("nombre") String nombre,
                                    @Param("dni") String dni,
                                    Pageable pageable);


    @Query("SELECT COUNT(p) FROM Pago p WHERE p.idpago < :idPago")
    long contarAntesDeId(@Param("idPago") Integer idPago);



}
