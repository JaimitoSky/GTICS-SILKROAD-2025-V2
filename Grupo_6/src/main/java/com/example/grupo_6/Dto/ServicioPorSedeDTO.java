package com.example.grupo_6.Dto;

public interface ServicioPorSedeDTO {
    Integer getIdSedeServicio();   // ID clave para los formularios
    String getNombre();            // Nombre del servicio
    String getDescripcion();       // Descripción del servicio
    Double getMonto();
}