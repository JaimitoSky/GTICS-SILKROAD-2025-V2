package com.example.grupo_6.config;

import com.example.grupo_6.Repository.UsuarioRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.JdbcUserDetailsManager;
import org.springframework.security.provisioning.UserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.savedrequest.DefaultSavedRequest;
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
                .formLogin(form -> form
                        .loginPage("/login")
                        .loginProcessingUrl("/processLogin")
                        .successHandler((request, response, authentication) -> {
                            System.out.println("LOGIN EXITOSO: " + authentication.getName());
                            System.out.println("🛡 ROLES:");
                            for (GrantedAuthority auth : authentication.getAuthorities()) {
                                System.out.println(" - " + auth.getAuthority());
                            }

                            HttpSession session = request.getSession();
                            var context = WebApplicationContextUtils
                                    .getRequiredWebApplicationContext(request.getServletContext());
                            UsuarioRepository usuarioRepo = context.getBean(UsuarioRepository.class);
                            var usuario = usuarioRepo.findByEmail(authentication.getName());

                            if (usuario == null) {
                                System.out.println(" Usuario no encontrado en BD");
                                response.sendRedirect("/login?error");
                                return;
                            }

                            session.setAttribute("usuario", usuario);

                            // Eliminar cualquier savedRequest inválido como /.well-known
                            session.removeAttribute("SPRING_SECURITY_SAVED_REQUEST");

                            // Redirección por rol
                            String rol = authentication.getAuthorities().iterator().next().getAuthority();
                            System.out.println("🟡 Rol detectado: " + rol);

                            switch (rol) {
                                case "Superadmin" -> {
                                    System.out.println("➡️ Redirigiendo a: /superadmin");
                                    response.sendRedirect("/superadmin");
                                }
                                case "Administrador" -> response.sendRedirect("/admin");
                                case "Coordinador" -> response.sendRedirect("/coordinador");
                                case "Vecino" -> response.sendRedirect("/vecino");
                                default -> {
                                    System.out.println("⚠ Rol no reconocido, redirigiendo a inicio");
                                    response.sendRedirect("/");
                                }
                            }
                        })
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/")
                        .invalidateHttpSession(true)
                        .deleteCookies("JSESSIONID")
                )
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/login", "/css/**", "/img/**", "/js/**").permitAll()
                        .requestMatchers("/superadmin/**").hasAuthority("Superadmin")
                        .requestMatchers("/admin/**").hasAuthority("Administrador")

                        .requestMatchers("/coordinador/**").permitAll()

                        .requestMatchers("/vecino/**").hasAuthority("Vecino")
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
        users.setUsersByUsernameQuery("SELECT email, password_hash, CASE WHEN estado = 'activo' THEN true ELSE false END FROM usuario WHERE email = ?");
        users.setAuthoritiesByUsernameQuery(
                "SELECT u.email, r.nombre FROM usuario u JOIN rol r ON u.idrol = r.idrol WHERE u.email = ?"
        );
        return users;
    }
}
