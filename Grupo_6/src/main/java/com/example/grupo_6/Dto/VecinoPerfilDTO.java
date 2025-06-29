package com.example.grupo_6.Dto;

import java.time.LocalDateTime;

public interface VecinoPerfilDTO {
    String getNombres();
    String getApellidos();
    String getCorreo();
    String getDireccion();
    String getTelefono();
    String getImagen();               // apunta a Usuario.imagen
    LocalDateTime getPhotoUpdatedAt(); // apunta a Usuario.photoUpdatedAt
}

