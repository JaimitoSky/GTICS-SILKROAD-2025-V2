package com.example.grupo_6.Repository;

import com.example.grupo_6.Entity.TarjetaVirtual;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.Optional;

@Repository
public interface TarjetaVirtualRepository extends JpaRepository<TarjetaVirtual, Integer> {
    Optional<TarjetaVirtual> findByNumeroTarjetaAndVencimientoAndCvv(String numero, LocalDate vencimiento, String cvv);
}
