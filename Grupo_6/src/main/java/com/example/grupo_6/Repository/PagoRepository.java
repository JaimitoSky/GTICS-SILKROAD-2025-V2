package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.Pago;
import com.example.grupo_6.Entity.Reserva;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PagoRepository extends JpaRepository<Pago, Integer> {
    List<Pago> findByUsuario_Idusuario(Integer idusuario);
    List<Pago> findByEstado_Nombre(String nombre);


}
