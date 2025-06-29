package com.example.grupo_6.Service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.auth.credentials.ProfileCredentialsProvider;
import software.amazon.awssdk.core.ResponseBytes;
import software.amazon.awssdk.core.exception.SdkException;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectResponse;
import software.amazon.awssdk.services.s3.model.NoSuchKeyException;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.IOException;
import java.net.URLConnection;
import java.util.UUID;

@Service
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
// PARA COMPROBANTES UNICAMENTE, ES CONSIDERANDO UUID
    public String subirArchivo(MultipartFile file, String carpetaDestino) {
        String nombreFinal = carpetaDestino + "/" + UUID.randomUUID() + "-" + file.getOriginalFilename();

        try {
            PutObjectRequest request = PutObjectRequest.builder()
                    .bucket(bucket)
                    .key(nombreFinal)
                    .contentType(file.getContentType())
                    .build();

            s3Client.putObject(request, RequestBody.fromBytes(file.getBytes()));

            return nombreFinal; // SOLO LA KEY, no incluir la URL aquí
        } catch (IOException e) {
            throw new RuntimeException("Error al subir archivo a S3", e);
        }
    }


    public byte[] descargarArchivo(String key) {
        try {
            GetObjectRequest getRequest = GetObjectRequest.builder()
                    .bucket(bucket)
                    .key(key)
                    .build();

            ResponseBytes<GetObjectResponse> objectBytes = s3Client.getObjectAsBytes(getRequest);
            return objectBytes.asByteArray();

        } catch (NoSuchKeyException e) {
            throw new RuntimeException("El archivo no existe en S3: " + key, e);
        } catch (SdkException e) {
            throw new RuntimeException("Error al acceder a S3", e);
        }
    }

    public String obtenerMimeDesdeKey(String key) {
        String mime = URLConnection.guessContentTypeFromName(key);
        return mime != null ? mime : "application/octet-stream";
    }


    //PARA OTROS TIPOS DE IMAGENES

    public String subirArchivoSobrescribible(MultipartFile file, String carpetaDestino, String nombreArchivo) {
        String key = carpetaDestino + "/" + nombreArchivo;
        try {
            PutObjectRequest request = PutObjectRequest.builder()
                    .bucket(bucket)
                    .key(key)
                    .contentType(file.getContentType())
                    .build();
            s3Client.putObject(request, RequestBody.fromBytes(file.getBytes()));
            return key;
        } catch (IOException e) {
            throw new RuntimeException("Error al subir archivo a S3", e);
        }
    }

    public byte[] descargarArchivoSobrescribible(String carpetaDestino, String nombreArchivo) {
        String key = carpetaDestino + "/" + nombreArchivo;
        return descargarArchivo(key);
    }


}
