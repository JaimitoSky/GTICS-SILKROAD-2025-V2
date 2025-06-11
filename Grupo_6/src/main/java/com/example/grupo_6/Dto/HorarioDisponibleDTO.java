package com.example.grupo_6.Dto;

public interface HorarioDisponibleDTO {
    Integer getIdhorario();
    String getDiaSemana();
    String getHoraInicio();
    String getHoraFin();
    Integer getAforoMaximo();
    Boolean getActivo();
    Boolean getEditable(); // <- nuevo campo calculado
}
