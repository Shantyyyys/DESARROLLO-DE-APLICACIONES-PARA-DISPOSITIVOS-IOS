# Nuevo diseño de Bookify (referencia visual oficial)

Fecha: 10 nov 2026. Es el diseño que se usará en la app. Son 3 pantallas: inicio, catálogo y detalle. El 12 nov se agregó la pantalla de Favoritos (sección 4).
(Las imágenes originales las tiene Shanty; este documento describe lo que muestran.)

## Estilo general
- Fondo crema/beige claro (aprox. #F8F3EE) en todas las pantallas.
- Color principal café/taupe (aprox. #8B7765) para el botón principal y los íconos activos.
- Íconos de portada provisionales en beige tostado (aprox. #BFAE9C).
- Títulos con tipografía **serif** ("Bookify", "Catálogo", "Descubrir más...", "Favoritos", títulos de libros y del detalle).
- Texto de cuerpo y etiquetas en **sans-serif** gris oscuro o gris medio.
- Tarjetas con fondo un poco más claro que el fondo general, esquinas muy redondeadas y sombra suave.
- Los colores son aproximados (tomados de las capturas).

## 1. Inicio (Login)
- Fondo con formas onduladas (arriba a la derecha y abajo a la derecha) e ilustración de libros apilados abajo a la izquierda.
- Centrado: "Bookify" (serif grande), ícono de libro abierto en contorno café y la frase "Read more, stress less" (serif, gris café, con espaciado entre letras).
- Botón cápsula café con el texto "Start Reading →" en blanco.
- **No hay campos de correo ni de contraseña** (la versión actual sí los tiene; hay que decidir si se quitan).

## 2. Catálogo (pestaña Inicio)
- Barra de búsqueda tipo cápsula: ícono de hamburguesa a la izquierda, placeholder "¿Qué quieres leer hoy?" y lupa a la derecha.
- "Catálogo": título serif grande.
- "Descubrir más...": subtítulo serif gris café. Carrusel horizontal de tarjetas (portada + título serif centrado en 2 líneas).
- "Favoritos": subtítulo serif con carrusel de tarjetas del mismo estilo.
- **Barra de pestañas abajo** con 3 pestañas: Inicio (libro, seleccionada en café oscuro), Favoritos (corazón) y Configuración (engrane).
- Ojo: en el diseño la sección Favoritos sigue dentro del catálogo **y además** hay una pestaña Favoritos. Hay que decidir si la sección se queda o se quita (el pendiente dice quitarla).

## 3. Detalle del libro
- Arriba: botón circular de regresar (chevron) a la izquierda y botón circular de marcador (bookmark relleno) a la derecha, los dos con fondo beige.
- Tarjeta grande con la portada (en la captura sale el ícono provisional), esquinas redondeadas y sombra suave.
- Título del libro en serif grande.
- Fila: "432 págs." (izquierda) · ícono de libro abierto (centro) · "0.0 ☆" (derecha). Luego una línea divisoria.
- Datos con la etiqueta en negritas: **Autor:**, **Año de publicación:**, **Género:**, **Idioma:**.
- Error que se ve en la captura: el año sale "1,967" (con separador de miles). Debe decir "1967".

## 4. Favoritos (pestaña Favoritos) · agregado 12 nov 2026
- Encabezado: flecha ← a la izquierda, "Favoritos" en serif grande y, a la derecha, un selector en cápsula con dos íconos: lista y cuadrícula (la opción activa con fondo beige).
- Cuadrícula de 2 columnas con tarjetas claras, esquinas redondeadas y sombra suave: portada grande, título en serif, autor en gris; corazón relleno arriba a la derecha y "..." abajo a la derecha.
- Barra de pestañas con Favoritos seleccionada (corazón relleno en café oscuro).
- **Decisiones de Shanty (12 nov):** se quita la flecha ← (es una pestaña principal); se quita el "..." (no tiene función); las tarjetas **no llevan corazón** (el favorito se desmarca desde el detalle del libro); el modo lista (sin diseño) usa filas con portada chica, título serif y autor, con el estilo de la lista de búsqueda.

## 5. Configuración (pestaña Configuración) · agregado 12 nov 2026
- Encabezado: flecha ←, "Configuración" en serif grande y el subtítulo "Personaliza tu experiencia" en serif gris café.
- Tres tarjetas claras, redondeadas y con sombra suave. Cada una: ícono en beige a la izquierda, línea divisoria vertical, título serif y subtítulo gris, y flecha › a la derecha.
  - Modo · "Elige tu modo de visualización" (engrane).
  - Idioma · "Selecciona tu idioma" (globo).
  - About Us · "Conoce más sobre nosotros" (ícono de información).
- Barra de pestañas con Configuración activa en una cápsula beige; el ícono de Inicio es una casa.
- **Decisiones de Shanty (12 nov):** se ignora la flecha ←; Modo = claro/oscuro, solo idea; Idioma solo idea; los dos abren una pantalla con las opciones desactivadas; About Us muestra la foto del equipo (la que estaba en `Applcon.appiconset`); la barra de pestañas se queda estándar (sin cápsula y con el ícono de libro). Textos en inglés.
