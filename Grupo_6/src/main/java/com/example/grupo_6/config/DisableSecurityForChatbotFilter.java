package com.example.grupo_6.config;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import java.io.IOException;

@Component
public class DisableSecurityForChatbotFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;

        // Permitir directamente las peticiones del chatbot
        if (req.getRequestURI().equals("/api/chatbot/procesar")) {
            ((HttpServletResponse) response).setHeader("X-CSRF-Token", "disabled");
        }

        chain.doFilter(request, response);
    }
}
