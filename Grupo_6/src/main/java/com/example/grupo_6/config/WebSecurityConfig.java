package com.example.grupo_6.config;

import com.example.grupo_6.Repository.UsuarioRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.JdbcUserDetailsManager;
import org.springframework.security.provisioning.UserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.sql.DataSource;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig {

    private final DataSource dataSource;

    public WebSecurityConfig(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.ignoringRequestMatchers("/api/chatbot/procesar")) // 👈 CSRF desactivado para ese endpoint

                .formLogin(form -> form
                        .loginPage("/login")
                        .loginProcessingUrl("/processLogin")
                        .successHandler((request, response, authentication) -> {
                            System.out.println("LOGIN EXITOSO: " + authentication.getName());
                            for (GrantedAuthority auth : authentication.getAuthorities()) {
                                System.out.println(" - " + auth.getAuthority());
                            }

                            HttpSession session = request.getSession();
                            var context = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
                            UsuarioRepository usuarioRepo = context.getBean(UsuarioRepository.class);
                            var usuario = usuarioRepo.findByEmail(authentication.getName());

                            if (usuario == null) {
                                response.sendRedirect("/login?error");
                                return;
                            }

                            // ✅ Aquí está la corrección
                            if ("inactivo".equalsIgnoreCase(usuario.getEstado())) {
                                response.sendRedirect("/login?inhabilitado");
                                return;
                            }

                            session.setAttribute("usuario", usuario);
                            session.setAttribute("idusuario", usuario.getIdusuario());
                            session.removeAttribute("SPRING_SECURITY_SAVED_REQUEST");

                            String rol = authentication.getAuthorities().iterator().next().getAuthority();
                            switch (rol) {
                                case "Superadmin" -> response.sendRedirect("/superadmin");
                                case "Administrador" -> response.sendRedirect("/admin");
                                case "Coordinador" -> response.sendRedirect("/coordinador/home");
                                case "Vecino" -> response.sendRedirect("/vecino");
                                default -> response.sendRedirect("/");
                            }
                        })
                        .failureHandler((request, response, exception) -> {
                            String errorParam = "error";
                            if (exception.getMessage().toLowerCase().contains("El usuario está inhabilitado")) {
                                errorParam = "inactivo";
                            }
                            response.sendRedirect("/login?" + errorParam);
                        })

                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutRequestMatcher(new AntPathRequestMatcher("/logout", "GET"))
                        .logoutSuccessUrl("/login?logout")
                        .invalidateHttpSession(true)
                        .deleteCookies("JSESSIONID")
                )
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(
                                "/login", "/registro", "/registro/enviar-codigo", "/registro/verificar-codigo",
                                "/recuperar/**", "/css/**", "/js/**", "/img/**", "/fonts/**", "/favicon.ico", "/error"
                        ).permitAll()

                        .requestMatchers(HttpMethod.POST, "/api/chatbot/procesar").permitAll()

                        .requestMatchers(HttpMethod.GET, "/api/reniec/dni/**").permitAll()

                        .requestMatchers("/superadmin/**").hasAuthority("Superadmin")
                        .requestMatchers("/admin/**").hasAuthority("Administrador")
                        .requestMatchers("/coordinador/**").hasAuthority("Coordinador")
                        .requestMatchers("/vecino/**").hasAuthority("Vecino")
                        .requestMatchers(HttpMethod.GET, "/api/horarios-disponibles").hasAnyAuthority("Superadmin", "Vecino")
                        .requestMatchers(HttpMethod.POST, "/api/horarios-disponibles").hasAuthority("Superadmin")
                        .requestMatchers(HttpMethod.DELETE, "/api/horarios-disponibles/**").hasAuthority("Superadmin")


                        .anyRequest().authenticated()
                );

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public UserDetailsManager users(DataSource dataSource) {
        JdbcUserDetailsManager users = new JdbcUserDetailsManager(dataSource);
        users.setUsersByUsernameQuery("""
        SELECT email, password_hash, true
        FROM usuario WHERE email = ?
        """);

        users.setAuthoritiesByUsernameQuery("""
        SELECT u.email, r.nombre
        FROM usuario u JOIN rol r ON u.idrol = r.idrol
        WHERE u.email = ?
    """);
        users.setRolePrefix(""); // <- Previene que se agregue automáticamente "ROLE_"
        return users;
    }

}
