package com.example.grupo_6.Controller;

import com.example.grupo_6.Dto.ServicioPorSedeDTO;
import com.example.grupo_6.Entity.*;
import com.example.grupo_6.Repository.*;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.time.LocalDate;

import java.text.Normalizer;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;

@Controller
public class SuperAdminController {

    @Autowired
    private UsuarioRepository usuarioRepository;
    private final Map<Integer, String> mapaRoles = Map.of(
            1, "Superadmin",
            2, "Administrador",
            3, "Coordinador",
            4, "Vecino"
    );
    @Autowired
    private TarifaRepository tarifaRepository;

    @Autowired
    private ServicioRepository servicioRepository;

    @Autowired
    private SedeServicioRepository sedeServicioRepository;
    @Autowired
    private EstadoRepository estadoRepository;
    @Autowired
    private ReservaRepository reservaRepository;
    @Autowired
    private PagoRepository pagoRepository;
    @Autowired
    private SedeRepository sedeRepository;
    @Autowired
    private HorarioDisponibleRepository horarioDisponibleRepository;
    @Autowired
    private HorarioAtencionRepository horarioAtencionRepository;



    // Vista principal del superadmin
    @GetMapping("/superadmin")
    public String superadminHome(Model model) {
        model.addAttribute("rol", "superadmin");
        return "superadmin/superadmin_home";
    }

    // Vista de gestión de usuarios


    @GetMapping("/superadmin/usuarios")
    public String listarUsuarios(@RequestParam(required = false) String filtro,
                                 @RequestParam(required = false, defaultValue = "nombre") String campo,
                                 Model model) {
        List<Usuario> listaUsuarios;

        if (filtro != null && !filtro.trim().isEmpty()) {
            String valor = filtro.trim().toLowerCase();
            listaUsuarios = switch (campo) {
                case "correo" -> usuarioRepository.buscarPorCorreo(valor);
                case "estado" -> usuarioRepository.buscarPorEstado(valor);
                case "rol" -> usuarioRepository.buscarPorRol(valor);
                case "id" -> usuarioRepository.buscarPorId(valor);
                default -> usuarioRepository.buscarPorNombre(valor);
            };
        } else {
            listaUsuarios = usuarioRepository.findAll();
        }

        model.addAttribute("usuarios", listaUsuarios);
        model.addAttribute("rol", "superadmin");
        model.addAttribute("mapaRoles", mapaRoles);
        model.addAttribute("filtro", filtro);
        model.addAttribute("campo", campo);

        return "superadmin/superadmin_usuarios";
    }






    // Cambiar rol del usuario
    @PostMapping("/cambiar-rol")
    public String cambiarRol(@RequestParam Integer idusuario, @RequestParam Integer rol) {
        Usuario u = usuarioRepository.findById(idusuario).orElse(null);
        if (u != null) {
            u.setIdrol(rol);
            usuarioRepository.save(u);
        }
        return "redirect:/superadmin/usuarios";
    }


    // Banear usuario (poner inactivo)
    @PostMapping("/superadmin/usuarios/{id}/ban")
    public String banearUsuario(@PathVariable("id") Integer idusuario) {
        Usuario u = usuarioRepository.findById(idusuario).orElse(null);
        if (u != null) {
            u.setEstado("inactivo");
            usuarioRepository.save(u);
        }
        return "redirect:/superadmin/usuarios";
    }

    // Activar usuario
    @PostMapping("/superadmin/usuarios/{id}/activar")
    public String activarUsuario(@PathVariable("id") Integer idusuario) {
        Usuario usuario = usuarioRepository.findById(idusuario).orElse(null);
        if (usuario != null) {
            usuario.setEstado("activo");
            usuarioRepository.save(usuario);
        }
        return "redirect:/superadmin/usuarios";
    }

    // Eliminar usuario
    @PostMapping("/eliminar")
    public String eliminarUsuario(@RequestParam("idusuario") Integer idusuario) {
        usuarioRepository.deleteById(idusuario);
        return "redirect:/superadmin/usuarios";
    }

    // Crear usuario
    @GetMapping("/superadmin/usuarios/nuevo")
    public String mostrarFormularioNuevoUsuario(Model model) {
        model.addAttribute("usuario", new Usuario()); // objeto vacío para el form
        return "superadmin/superadmin_usuarios_formulario";
    }


    // Manejo de errores global para debugging
    @ExceptionHandler(Exception.class)
    public String handleException(Exception e) {
        e.printStackTrace(); // Log para consola
        return "error";       // Asegúrate de tener un error.html
    }
    @PostMapping("/superadmin/usuarios/guardar")
    public String guardarUsuario(@ModelAttribute Usuario usuario) {
        usuario.setEstado("activo"); // se registra como activo por defecto
        usuario.setCreate_time(new Timestamp(System.currentTimeMillis())); // registrar fecha
        usuarioRepository.save(usuario);
        return "redirect:/superadmin/usuarios";
    }

    @GetMapping("/superadmin/sedes")
    public String listarSedes(Model model) {
        List<Sede> sedes = sedeRepository.findAll();
        model.addAttribute("listaSedes", sedes);
        return "superadmin/superadmin_sedes";
    }

    @GetMapping("/superadmin/sedes/nueva")
    public String nuevaSede(Model model) {
        model.addAttribute("sede", new Sede());
        return "superadmin/superadmin_sedes_formulario";
    }
    @GetMapping("/superadmin/sedes/ver/{id}")
    public String verSede(@PathVariable("id") Integer id, Model model, RedirectAttributes attr) {
        Optional<Sede> optionalSede = sedeRepository.findById(id);
        if (optionalSede.isPresent()) {
            model.addAttribute("sede", optionalSede.get());
            return "superadmin/superadmin_sedes_detalle";
        } else {
            attr.addFlashAttribute("mensajeError", "Sede no encontrada.");
            return "redirect:/superadmin/sedes";
        }
    }
    public enum DiaSemana {
        LUNES, MARTES, MIERCOLES, JUEVES, VIERNES, SABADO, DOMINGO
    }
    public String normalizarDia(String input) {
        return Normalizer.normalize(input, Normalizer.Form.NFD)
                .replaceAll("[\\p{InCombiningDiacriticalMarks}]", "") // elimina tildes
                .toUpperCase(Locale.ROOT); // asegura mayúsculas en inglés
    }



    @GetMapping("/superadmin/sedes/configurar/{id}")
    public String configurarSede(@PathVariable("id") Integer id, Model model, RedirectAttributes attr) {

        Optional<Sede> optionalSede = sedeRepository.findById(id);
        if (optionalSede.isEmpty()) {
            attr.addFlashAttribute("mensajeError", "Sede no encontrada.");
            return "redirect:/superadmin/sedes";
        }

        Sede sede = optionalSede.get();
        model.addAttribute("sede", sede);
        model.addAttribute("listaServicios", servicioRepository.findAll());
        model.addAttribute("listaTarifas", tarifaRepository.findAll());
        model.addAttribute("dias", List.of("Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"));

        // Cargar o generar los 7 días
        List<HorarioAtencion> horarios = new ArrayList<>();
        for (HorarioAtencion.DiaSemana dia : HorarioAtencion.DiaSemana.values()) {
            Optional<HorarioAtencion> ha = horarioAtencionRepository.findBySedeAndDiaSemana(sede, dia);
            horarios.add(ha.orElse(new HorarioAtencion(null, sede, dia, null, null, false)));
        }
        model.addAttribute("listaHorariosAtencion", horarios);

        model.addAttribute("horariosDisponibles", horarioDisponibleRepository.findByHorarioAtencion_Sede_Idsede(id));

        return "superadmin/superadmin_sedes_configurar";
    }



    @PostMapping("/superadmin/sedes/configurar/servicios")
    public String asignarServicio(@RequestParam("idsede") Integer idsede,
                                  @RequestParam("idservicio") Integer idservicio,
                                  @RequestParam("idtarifa") Integer idtarifa,
                                  RedirectAttributes attr) {

        Optional<Sede> sedeOpt = sedeRepository.findById(idsede);
        Optional<Servicio> servOpt = servicioRepository.findById(idservicio);
        Optional<Tarifa> tarifaOpt = tarifaRepository.findById(idtarifa);

        if (sedeOpt.isPresent() && servOpt.isPresent() && tarifaOpt.isPresent()) {
            SedeServicio ss = new SedeServicio();
            ss.setSede(sedeOpt.get());
            ss.setServicio(servOpt.get());
            ss.setTarifa(tarifaOpt.get());
            sedeServicioRepository.save(ss);

            attr.addFlashAttribute("mensajeExito", "Servicio asignado a la sede correctamente.");
        } else {
            attr.addFlashAttribute("mensajeError", "Error al asignar servicio.");
        }

        return "redirect:/superadmin/sedes/configurar/" + idsede;
    }


    @PostMapping("/superadmin/sedes/configurar/atencion/guardar")
    public String guardarHorariosAtencion(@RequestParam("idsede") Integer idsede,
                                          HttpServletRequest request,
                                          RedirectAttributes attr) {
        Optional<Sede> sedeOpt = sedeRepository.findById(idsede);
        if (sedeOpt.isEmpty()) {
            attr.addFlashAttribute("mensajeError", "Sede no encontrada.");
            return "redirect:/superadmin/sedes";
        }

        Sede sede = sedeOpt.get();

        for (HorarioAtencion.DiaSemana dia : HorarioAtencion.DiaSemana.values()) {
            String nombreDia = dia.name(); // Ej. "LUNES"

            String inicioParam = request.getParameter("horaInicio_" + nombreDia);
            String finParam = request.getParameter("horaFin_" + nombreDia);
            boolean activo = request.getParameter("activo_" + nombreDia) != null;

            LocalTime horaInicio = null;
            LocalTime horaFin = null;

            if (inicioParam != null && !inicioParam.isEmpty()) {
                horaInicio = LocalTime.parse(inicioParam);
            }
            if (finParam != null && !finParam.isEmpty()) {
                horaFin = LocalTime.parse(finParam);
            }

            // Buscar o crear el horario para ese día
            HorarioAtencion horario = horarioAtencionRepository.findBySedeAndDiaSemana(sede, dia)
                    .orElse(new HorarioAtencion(null, sede, dia, null, null, false));

            horario.setHoraInicio(horaInicio);
            horario.setHoraFin(horaFin);
            horario.setActivo(activo);

            horarioAtencionRepository.save(horario);
        }

        attr.addFlashAttribute("mensajeExito", "Horarios de atención actualizados.");
        return "redirect:/superadmin/sedes/configurar/" + idsede;
    }



    @PostMapping("/superadmin/sedes/configurar/intervalos")
    public String agregarHorarioDisponible(@RequestParam("idhorarioAtencion") Integer idHorarioAtencion,
                                           @RequestParam("idservicio") Integer idservicio,
                                           @RequestParam("horaInicio") String horaInicio,
                                           @RequestParam("horaFin") String horaFin,
                                           RedirectAttributes attr) {

        Optional<HorarioAtencion> haOpt = horarioAtencionRepository.findById(idHorarioAtencion);
        Optional<Servicio> servOpt = servicioRepository.findById(idservicio);

        if (haOpt.isPresent() && servOpt.isPresent()) {
            HorarioDisponible intervalo = new HorarioDisponible();
            intervalo.setHorarioAtencion(haOpt.get());
            intervalo.setServicio(servOpt.get());
            intervalo.setHoraInicio(LocalTime.parse(horaInicio));
            intervalo.setHoraFin(LocalTime.parse(horaFin));
            intervalo.setActivo(true);

            horarioDisponibleRepository.save(intervalo);
            attr.addFlashAttribute("mensajeExito", "Intervalo agregado correctamente.");
        } else {
            attr.addFlashAttribute("mensajeError", "No se encontró el horario o servicio asociado.");
        }

        return "redirect:/superadmin/sedes/configurar/" + haOpt.map(h -> h.getSede().getIdsede()).orElse(-1);
    }






    @GetMapping("/superadmin/sedes/editar/{id}")
    public String mostrarFormularioEdicion(@PathVariable("id") Integer id, Model model, RedirectAttributes attr) {
        Optional<Sede> optionalSede = sedeRepository.findById(id);
        if (optionalSede.isPresent()) {
            model.addAttribute("sede", optionalSede.get());
            return "superadmin/superadmin_sedes_update"; // ¡nombre corregido!
        } else {
            attr.addFlashAttribute("mensajeError", "Sede no encontrada.");
            return "redirect:/superadmin/sedes";
        }
    }

    @PostMapping("/superadmin/sedes/actualizar")
    public String actualizarSede(@ModelAttribute("sede") Sede sede, RedirectAttributes attr) {
        sedeRepository.save(sede);
        attr.addFlashAttribute("mensajeExito", "Sede actualizada correctamente.");
        return "redirect:/superadmin/sedes";
    }



    @PostMapping("/superadmin/sedes/guardar")
    public String guardarSede(@ModelAttribute Sede sede, RedirectAttributes attr) {
        sede.setActivo(true);
        sedeRepository.save(sede);
        attr.addFlashAttribute("mensaje", "Sede registrada exitosamente.");
        return "redirect:/superadmin/sedes";
    }

    @PostMapping("/superadmin/sedes/desactivar/{id}")
    public String desactivarSede(@PathVariable("id") Integer id) {
        Optional<Sede> optional = sedeRepository.findById(id);
        optional.ifPresent(sede -> {
            sede.setActivo(false);
            sedeRepository.save(sede);
        });
        return "redirect:/superadmin/sedes";
    }


    @GetMapping("/superadmin/reservas")
    public String listarReservas(Model model) {
        List<Reserva> reservas = reservaRepository.findAll();
        model.addAttribute("listaReservas", reservas);

        model.addAttribute("reserva", new Reserva()); // para evitar errores con th:field si se reutiliza
        return "superadmin/superadmin_reservas";
    }


    @GetMapping("/superadmin/reservas/nueva")
    public String nuevaReserva(Model model) {
        model.addAttribute("reserva", new Reserva());

        List<Sede> sedes = sedeRepository.findAll();
        model.addAttribute("listaSedes", sedes);

        List<HorarioDisponible> listaHorarios = horarioDisponibleRepository.findByActivoTrue();
        model.addAttribute("listaHorarios", listaHorarios);

        return "superadmin/superadmin_reservas_formulario";
    }



    @PostMapping("/superadmin/reservas/guardar")
    public String guardarReserva(@RequestParam("dni") String dni,
                                 @ModelAttribute("reserva") Reserva reserva,
                                 RedirectAttributes redirectAttributes) {

        Usuario usuario = usuarioRepository.findByDni(dni);
        Estado estadoPendienteReserva = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.reserva);
        Estado estadoPendientePago = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.pago);
        Estado estadoAprobadaReserva = estadoRepository.findByNombreAndTipoAplicacion("aprobada", Estado.TipoAplicacion.reserva);
        Estado estadoPagado = estadoRepository.findByNombreAndTipoAplicacion("pagado", Estado.TipoAplicacion.pago);

        SedeServicio sedeServicio = reserva.getSedeServicio(); // ← ya viene mapeado

        if (usuario != null && sedeServicio != null && estadoPendienteReserva != null && estadoPendientePago != null) {

            // Crear pago asociado
            Pago pago = new Pago();
            pago.setUsuario(usuario);
            pago.setMetodo(Pago.Metodo.banco); // o online si lo implementas
            pago.setMonto(BigDecimal.valueOf(sedeServicio.getTarifa().getMonto()));
            pago.setEstado(estadoPendientePago);
            pago.setFechaPago(null);
            pagoRepository.save(pago);

            // Configurar la reserva
            reserva.setUsuario(usuario);
            reserva.setFechaCreacion(LocalDateTime.now());
            reserva.setFechaLimitePago(reserva.getFechaCreacion().plusHours(4));
            reserva.setPago(pago);

            // Estado según pago
            if (pago.getEstado().equals(estadoPagado)) {
                reserva.setEstado(estadoAprobadaReserva);
            } else {
                reserva.setEstado(estadoPendienteReserva);
            }

            reservaRepository.save(reserva);
            redirectAttributes.addFlashAttribute("mensajeExito", "Reserva y pago creados correctamente.");
        } else {
            redirectAttributes.addFlashAttribute("mensajeError", "Error al crear la reserva. Verifique los datos.");
        }

        return "redirect:/superadmin/reservas";
    }



    @GetMapping("/api/sede-servicios")
    public List<SedeServicio> listarServiciosPorSedePorParam(@RequestParam("sedeId") Integer sedeId) {
        return sedeServicioRepository.findBySedeIdsede(sedeId);
    }


    //@GetMapping("/api/servicios-por-sede/{idsede}")
    //  @ResponseBody
    // public List<ServicioPorSedeDTO> listarServiciosDTOporSede(@PathVariable Integer idsede) {
    // return sedeServicioRepository.obtenerServiciosPorSede(idsede);
    // }







    @GetMapping("/superadmin/reservas/ver/{id}")
    public String verReserva(@PathVariable("id") Integer id, Model model) {
        Reserva reserva = reservaRepository.findById(id).orElse(null);
        model.addAttribute("reserva", reserva);
        return "superadmin/superadmin_reservas_detalle";
    }

    @PostMapping("/superadmin/reservas/aprobar-pago/{id}")
    public String aprobarPago(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        Reserva reserva = reservaRepository.findById(id).orElse(null);

        if (reserva != null && reserva.getPago() != null) {
            Estado aprobadoReserva = estadoRepository.findByNombreAndTipoAplicacion("aprobada", Estado.TipoAplicacion.reserva);
            Estado confirmadoPago = estadoRepository.findByNombreAndTipoAplicacion("confirmado", Estado.TipoAplicacion.pago);

            if (aprobadoReserva != null && confirmadoPago != null) {
                reserva.setEstado(aprobadoReserva);
                reservaRepository.save(reserva);

                Pago pago = reserva.getPago();
                pago.setEstado(confirmadoPago);
                pago.setFechaPago(LocalDateTime.now());
                pagoRepository.save(pago);

                redirectAttributes.addFlashAttribute("mensajeExito", "Pago aprobado exitosamente.");
            } else {
                redirectAttributes.addFlashAttribute("mensajeError", "Estados no encontrados.");
            }
        } else {
            redirectAttributes.addFlashAttribute("mensajeError", "Reserva sin pago asociado.");
        }

        return "redirect:/superadmin/reservas";
    }


    @PostMapping("/superadmin/reservas/desaprobar-pago/{id}")
    public String desaprobarPago(@PathVariable("id") Integer id) {
        Reserva reserva = reservaRepository.findById(id).orElse(null);
        if (reserva != null && reserva.getPago() != null) {
            Estado pendienteReserva = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.reserva);
            Estado pendientePago = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.pago);

            reserva.setEstado(pendienteReserva);
            reservaRepository.save(reserva);

            Pago pago = reserva.getPago();
            pago.setEstado(pendientePago);
            pagoRepository.save(pago);
        }
        return "redirect:/superadmin/reservas";
    }

    @PostMapping("/superadmin/reservas/cancelar/{id}")
    public String cancelarReserva(@PathVariable("id") Integer id) {
        Reserva reserva = reservaRepository.findById(id).orElse(null);
        if (reserva != null) {
            Estado cancelada = estadoRepository.findByNombreAndTipoAplicacion("cancelada", Estado.TipoAplicacion.reserva);
            reserva.setEstado(cancelada);
            reservaRepository.save(reserva);
        }
        return "redirect:/superadmin/reservas";
    }


    @PostMapping("/superadmin/reservas/habilitar/{id}")
    public String habilitarReserva(@PathVariable("id") Integer id) {
        Reserva reserva = reservaRepository.findById(id).orElse(null);
        if (reserva != null) {
            Estado pendienteReserva = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.reserva);
            reserva.setEstado(pendienteReserva);
            reservaRepository.save(reserva);

            if (reserva.getPago() != null) {
                Estado pendientePago = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.pago);
                reserva.getPago().setEstado(pendientePago);
                pagoRepository.save(reserva.getPago());
            }
        }
        return "redirect:/superadmin/reservas";
    }


    @GetMapping("/superadmin/tarifas")
    public String listarTarifas(Model model) {
        List<Tarifa> tarifas = tarifaRepository.findAll();
        model.addAttribute("listaTarifas", tarifas);
        return "superadmin/superadmin_tarifas";
    }

    @GetMapping("/superadmin/tarifas/nueva")
    public String nuevaTarifa(Model model) {
        model.addAttribute("tarifa", new Tarifa());
        return "superadmin/superadmin_tarifas_formulario";
    }

    // Guardar nueva tarifa
    @PostMapping("/superadmin/tarifas/guardar")
    public String guardarTarifa(@ModelAttribute Tarifa tarifa) {
        tarifa.setFechaActualizacion(LocalDate.now());
        tarifaRepository.save(tarifa);
        return "redirect:/superadmin/tarifas";
    }

    // Mostrar formulario para editar tarifa
    @GetMapping("/superadmin/tarifas/editar/{id}")
    public String editarTarifa(@PathVariable("id") Integer id, Model model) {
        Tarifa tarifa = tarifaRepository.findById(id).orElse(null);
        if (tarifa != null) {
            model.addAttribute("tarifa", tarifa);
            return "superadmin/superadmin_tarifas_update";
        } else {
            return "redirect:/superadmin/tarifas";
        }
    }

    // Guardar cambios en tarifa existente
    @PostMapping("/superadmin/tarifas/actualizar")
    public String actualizarTarifa(@ModelAttribute Tarifa tarifa) {
        tarifa.setFechaActualizacion(LocalDate.now());
        tarifaRepository.save(tarifa);
        return "redirect:/superadmin/tarifas";
    }
    @GetMapping("/superadmin/tarifas/eliminar/{id}")
    public String eliminarTarifa(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        if (tarifaRepository.existsById(id)) {
            tarifaRepository.deleteById(id);
            redirectAttributes.addFlashAttribute("mensajeExito", "Tarifa eliminada correctamente.");
        } else {
            redirectAttributes.addFlashAttribute("mensajeError", "La tarifa no existe.");
        }
        return "redirect:/superadmin/tarifas";
    }
    @Autowired
    private RolRepository rolRepository;



    @GetMapping("/superadmin/estadisticas")
    public String verEstadisticas(Model model) {
        model.addAttribute("reservasPorDia", reservaRepository.countReservasPorDia());
        model.addAttribute("serviciosPopulares", reservaRepository.countReservasPorServicio());
        model.addAttribute("estadoReservas", reservaRepository.countReservasPorEstado());

        // convertir idrol -> nombre
        List<Object[]> usuariosPorRolRaw = usuarioRepository.countUsuariosPorRol();
        Map<String, Long> usuariosPorRol = new LinkedHashMap<>();
        for (Object[] row : usuariosPorRolRaw) {
            Integer idrol = (Integer) row[0];
            Long count = (Long) row[1];
            String nombreRol = rolRepository.findById(idrol).map(Rol::getNombre).orElse("Desconocido");
            usuariosPorRol.put(nombreRol, count);
        }

        model.addAttribute("usuariosPorRol", usuariosPorRol);

        return "superadmin/superadmin_estadisticas";
    }


    @GetMapping("/superadmin/sistema")
    public String configuracionSistema() {
        return "superadmin/superadmin_sistema";
    }

    @GetMapping("/superadmin/registros")
    public String verRegistros() {
        return "superadmin/superadmin_registros";
    }
    @GetMapping("/superadmin/pagos")
    public String listarPagos(Model model) {
        List<Pago> listaPagos = pagoRepository.findAll();
        model.addAttribute("listaPagos", listaPagos);
        return "superadmin/superadmin_pagos";
    }
    @PostMapping("/superadmin/pagos/aprobar/{id}")
    public String aprobarPagoDesdePagos(@PathVariable("id") Integer id) {
        Pago pago = pagoRepository.findById(id).orElse(null);
        if (pago == null) return "redirect:/superadmin/pagos";

        Estado estadoConfirmado = estadoRepository.findByNombreAndTipoAplicacion("confirmado", Estado.TipoAplicacion.pago);
        Estado estadoAprobadoReserva = estadoRepository.findByNombreAndTipoAplicacion("aprobada", Estado.TipoAplicacion.reserva);
        if (estadoConfirmado == null || estadoAprobadoReserva == null) return "redirect:/superadmin/pagos";

        pago.setEstado(estadoConfirmado);
        pagoRepository.save(pago);

        Reserva reserva = reservaRepository.findByPago(pago);
        if (reserva != null) {
            reserva.setEstado(estadoAprobadoReserva);
            reservaRepository.save(reserva);
        }

        return "redirect:/superadmin/pagos";
    }

    @PostMapping("/superadmin/pagos/rechazar/{id}")
    public String rechazarPago(@PathVariable("id") Integer id) {
        Pago pago = pagoRepository.findById(id).orElse(null);
        if (pago == null) return "redirect:/superadmin/pagos";

        Estado estadoRechazado = estadoRepository.findByNombreAndTipoAplicacion("rechazado", Estado.TipoAplicacion.pago);
        Estado estadoPendienteReserva = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.reserva);
        if (estadoRechazado == null || estadoPendienteReserva == null) return "redirect:/superadmin/pagos";

        pago.setEstado(estadoRechazado);
        pagoRepository.save(pago);

        Reserva reserva = reservaRepository.findByPago(pago);
        if (reserva != null) {
            reserva.setEstado(estadoPendienteReserva);
            reservaRepository.save(reserva);
        }

        return "redirect:/superadmin/pagos";
    }

    @PostMapping("/superadmin/pagos/pendiente/{id}")
    public String volverPagoAPendiente(@PathVariable("id") Integer id) {
        Pago pago = pagoRepository.findById(id).orElse(null);
        if (pago == null) return "redirect:/superadmin/pagos";

        Estado estadoPendientePago = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.pago);
        Estado estadoPendienteReserva = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.reserva);
        if (estadoPendientePago == null || estadoPendienteReserva == null) return "redirect:/superadmin/pagos";

        pago.setEstado(estadoPendientePago);
        pagoRepository.save(pago);

        Reserva reserva = reservaRepository.findByPago(pago);
        if (reserva != null) {
            reserva.setEstado(estadoPendienteReserva);
            reservaRepository.save(reserva);
        }

        return "redirect:/superadmin/pagos";
    }









}
