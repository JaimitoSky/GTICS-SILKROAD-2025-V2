package com.example.grupo_6.Controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PingController {

    @GetMapping("/")
    public String ping() {
        return "Hola Manuel, mi rey ya está eñ spring";
    }
}
