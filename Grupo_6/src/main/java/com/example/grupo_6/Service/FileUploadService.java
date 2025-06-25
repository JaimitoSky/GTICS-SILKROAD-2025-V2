package com.example.grupo_6.Service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.auth.credentials.ProfileCredentialsProvider;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.IOException;
import java.util.UUID;

//@Service
public class FileUploadService {

    @Value("${aws.s3.bucket}")
    private String bucket;

    private final S3Client s3Client;

    public FileUploadService(@Value("${aws.region}") String region) {
        this.s3Client = S3Client.builder()
                .region(Region.of(region))
                .credentialsProvider(ProfileCredentialsProvider.create())
                .build();
    }

    public String subirArchivo(MultipartFile file, String carpetaDestino) {
        String nombreFinal = carpetaDestino + "/" + UUID.randomUUID() + "-" + file.getOriginalFilename();

        try {
            PutObjectRequest request = PutObjectRequest.builder()
                    .bucket(bucket)
                    .key(nombreFinal)
                    .acl("public-read")
                    .contentType(file.getContentType())
                    .build();

            s3Client.putObject(request, RequestBody.fromBytes(file.getBytes()));

            return "https://" + bucket + ".s3.amazonaws.com/" + nombreFinal;
        } catch (IOException e) {
            throw new RuntimeException("Error al subir archivo a S3", e);
        }
    }
}
