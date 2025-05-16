package com.example.grupo_6;

import jakarta.annotation.PostConstruct;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
public class SessionCleanup {

    private final JdbcTemplate jdbcTemplate;

    public SessionCleanup(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @PostConstruct
    public void clearSessions() {
        try {
            jdbcTemplate.queryForObject("SELECT 1 FROM SPRING_SESSION LIMIT 1", Integer.class);
            jdbcTemplate.update("DELETE FROM SPRING_SESSION_ATTRIBUTES");
            jdbcTemplate.update("DELETE FROM SPRING_SESSION");
            System.out.println("🧹 Sesiones eliminadas al iniciar el servidor.");
        } catch (Exception e) {
            System.err.println("⚠️ Las tablas de sesión no existen o no se pueden limpiar: " + e.getMessage());
        }
    }

}
