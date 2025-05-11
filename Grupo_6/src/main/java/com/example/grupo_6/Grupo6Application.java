package com.example.grupo_6;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

import org.springframework.context.annotation.ComponentScan;
@EnableScheduling

@SpringBootApplication
public class Grupo6Application {
    public static void main(String[] args) {
        SpringApplication.run(Grupo6Application.class, args);
    }
}

