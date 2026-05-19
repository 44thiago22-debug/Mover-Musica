package com.mi_app.movermusica;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;
import java.io.File;

public class MainActivity extends AppCompatActivity {

    // Ruta de origen (Memoria interna - Snaptube)
    private final String RUTA_SNAPTUBE = "/storage/emulated/0/Snaptube/Download/Snaptube_Music/";
    
    // Ruta de destino (Intenta usar la SD genérica, si no funciona luego la cambiamos por el ID)
    private final String RUTA_SD = "/storage/sdcard1/Musica/"; 

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // Botón gigante directo por código para que la app no pese nada
        Button btnMover = new Button(this);
        btnMover.setText("PULSAR AQUÍ PARA PASAR MÚSICA A LA SD");
        btnMover.setTextSize(20);
        setContentView(btnMover);

        btnMover.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                moverArchivos();
            }
        });
    }

    private void moverArchivos() {
        File origen = new File(RUTA_SNAPTUBE);
        File destino = new File(RUTA_SD);

        if (!destino.exists()) {
            destino.mkdirs(); // Si la carpeta Musica en la SD no existe, la crea
        }

        if (origen.exists() && origen.isDirectory()) {
            File[] archivos = origen.listFiles();
            if (archivos != null && archivos.length > 0) {
                int contador = 0;
                for (File archivo : archivos) {
                    File nuevoArchivo = new File(destino, archivo.getName());
                    if (archivo.renameTo(nuevoArchivo)) {
                        contador++;
                    }
                }
                Toast.makeText(this, "¡Listo! Se movieron " + contador + " canciones.", Toast.LENGTH_LONG).show();
            } else {
                Toast.makeText(this, "No hay música nueva para mover.", Toast.LENGTH_SHORT).show();
            }
        } else {
            Toast.makeText(this, "No se encontró la carpeta de Snaptube.", Toast.LENGTH_SHORT).show();
        }
    }
}
