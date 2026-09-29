# DESARROLLO-DE-APLICACIONES-PARA-DISPOSITIVOS-IOS
Clases iOS 
<img width="886" height="720" alt="image" src="https://github.com/user-attachments/assets/050a2b78-92b6-41bf-8907-f38be959e71e" />
# Bookify

> Read more, stress less.

Aplicación móvil iOS para explorar un catálogo de libros, consultar su información y guardar favoritos.

## MVP



### Pantalla 1: Inicio de sesión
- Logo y lema de la app.
- Campo de correo electrónico.
- Campo de contraseña.
- Botón "Iniciar sesión".

### Pantalla 2: Catálogo
- Barra de búsqueda funcional ("¿Qué quieres leer hoy?").
- Menú de hamburguesa.
- Sección "Descubrir más...".
- Sección "Favoritos".

### Pantalla 3: Detalle del libro
- Portada y título.
- Número de páginas.
- Calificación (estrella).
- Autor, año de publicación, género e idioma.
- Botón de regreso al catálogo.
- Marcador para guardar el libro en Favoritos.
- Íconos de audio y de lectura.

## Flujo principal

1. El usuario inicia sesión con correo y contraseña.
2. Llega al catálogo, donde puede explorar las secciones o buscar un libro.
3. Toca una portada para abrir el detalle del libro.
4. Desde el detalle puede marcarlo como favorito o regresar al catálogo.

```
Inicio de sesión → Catálogo → Detalle del libro
                       ↑              |
                       └──────────────┘
                          (regresar)
```

## Accesibilidad

Bookify busca ser usable con las herramientas de accesibilidad de iOS. Estos son los compromisos del MVP.

### VoiceOver
- Todo elemento tocable tiene una etiqueta descriptiva. Ningún ícono queda sin nombre.
- Las portadas del catálogo se leen con el título y el autor del libro.
- El marcador comunica su estado ("Guardado en favoritos" / "No está en favoritos").
- La calificación se lee como valor completo (por ejemplo, "4.5 de 5 estrellas").
- Los campos de inicio de sesión tienen nombre ("Correo electrónico", "Contraseña").
- El botón de regreso se lee como "Regresar al catálogo".
- Etiquetas pendientes de definir junto con su comportamiento: menú de hamburguesa, audio y lectura.

### Dynamic Type
- Todos los textos escalan con el tamaño de letra que el usuario configure en el sistema.
- Ninguna pantalla debe romperse ni recortar texto con los tamaños de letra más grandes.

### Contraste de color
- Texto normal: contraste mínimo de 4.5:1 (WCAG AA) contra su fondo.
- Aplica en especial al botón "Iniciar sesión", a los textos de los campos y a los textos pequeños (lema, títulos de sección, datos del libro).
- Ninguna información depende solo del color (el estado de favorito no se comunica únicamente con un cambio de color).

### Áreas táctiles
- Todo elemento tocable mide al menos 44x44 pt.
- Aplica en especial a los íconos del detalle (marcador, audio, lectura), el botón de regreso y el menú de hamburguesa.

## Pendientes por definir

Estos elementos están dentro del MVP, pero el diseño actual solo muestra su ícono, no su comportamiento:

- **Menú de hamburguesa:** opciones que abre.
- **Íconos de audio y lectura:** pantalla o acción a la que llevan.
- **Calificación:** si es solo informativa o si el usuario puede calificar.
