# Navegación y estado — Bookify

> Estado del documento: borrador. Las secciones marcadas como **Pendiente** se completan en los siguientes pasos.

## 1. Mapa de navegación

### Pantallas del MVP

1. Inicio de sesión
2. Catálogo
3. Detalle del libro

El Catálogo tiene dos estados dentro de la misma pantalla:

- **Normal:** secciones "Descubrir más..." y "Favoritos".
- **Búsqueda activa:** al escribir en la barra de búsqueda, se muestra una lista de resultados sobre el catálogo.

### Diagrama

```
Inicio de sesión → Catálogo → Detalle del libro
                       ↑              |
                       └──────────────┘
                          (regresar)
```

### Transiciones

| Origen | Acción del usuario | Destino |
|---|---|---|
| Inicio de sesión | Toca "Iniciar sesión" | Catálogo |
| Catálogo | Toca una portada | Detalle del libro |
| Detalle del libro | Toca el botón de regreso | Catálogo |

### Elementos sin comportamiento definido

El diseño actual no define estos elementos, por lo que no se incluyen en el mapa hasta definirlos:

- **Menú de hamburguesa:** opciones que abre. **Pendiente.**
- **Íconos de audio y lectura (Detalle):** pantalla o acción a la que llevan. **Pendiente.**
- **Resultado de búsqueda:** qué ocurre al tocar un resultado de la lista. **Pendiente.**
- **Validación del inicio de sesión:** cómo se comprueban el correo y la contraseña. **Pendiente.**

## 2. Información por pantalla

### Inicio de sesión

- **Muestra:** logo y lema "Read more, stress less", campo de correo electrónico, campo de contraseña y botón "Iniciar sesión".
- **Recibe:** el valor `isLoggedIn` mediante `@Binding` (decisión de la sección 4).
- **Modifica:** el correo y la contraseña que escribe el usuario, y `isLoggedIn`, que pasa a `true` al iniciar sesión.
- **Conserva:** el texto del correo y la contraseña mientras la pantalla está visible. Si la sesión debe recordarse al cerrar la app depende de cómo se valide el inicio de sesión, que aún no está definido. **Pendiente.**

### Catálogo

- **Muestra:** barra de búsqueda ("¿Qué quieres leer hoy?"), menú de hamburguesa, título "Catálogo", sección "Descubrir más..." con portadas y sección "Favoritos" con portadas. Con la búsqueda activa, muestra una lista de resultados.
- **Recibe:** la lista de libros, leída desde un archivo JSON local, y la información de qué libros son favoritos (de ahí sale la sección "Favoritos").
- **Modifica:** el texto de búsqueda, que escribe el usuario. No modifica la lista de libros.
- **Conserva:** la lista de libros mientras la app está abierta, el texto de búsqueda mientras la búsqueda está activa y los favoritos, que deben recordarse incluso después de cerrar la app. El mecanismo para guardarlos se decide en la sección 3.

### Detalle del libro

- **Muestra:** portada, título, número de páginas, calificación, autor, año de publicación, género, idioma, botón de regreso, marcador de favorito e íconos de audio y lectura.
- **Recibe:** el libro seleccionado en el Catálogo, con sus datos (portada, título, páginas, calificación general, autor, año, género e idioma), si ese libro es favorito y la calificación del usuario, si ya calificó.
- **Modifica:** el estado de favorito del libro (marcador) y la calificación del usuario.
- **Conserva:** el estado de favorito y la calificación del usuario, ambos de forma persistente (deben recordarse después de cerrar la app). El mecanismo para guardarlos se decide en la sección 3.

## 3. Organización del estado

**Pendiente.**

## 4. Estrategia de navegación

La app combina dos mecanismos de SwiftUI: un cambio de vista raíz controlado por un `Bool` para entrar a la app, y un `NavigationStack` para moverse dentro del catálogo.

### Inicio de sesión → Catálogo: cambio de vista raíz con un Bool

**Cómo funciona:** la vista padre (raíz de la app) guarda un `@State` llamado `isLoggedIn`. Si vale `false` muestra el Inicio de sesión; si vale `true` muestra el Catálogo. La pantalla de inicio de sesión recibe ese valor como `@Binding` y lo cambia a `true` al iniciar sesión.

**Justificación:**
- El diseño no incluye un botón de regreso del Catálogo hacia el login, y este mecanismo no genera uno.
- Usa únicamente `@State` y `@Binding`.
- Es el de menor complejidad de las opciones consideradas.

**Alternativas descartadas:**
- `NavigationStack` con push: agregaría un botón de regreso hacia el login que el diseño no contempla.
- `fullScreenCover`: es una presentación modal pensada para contenido temporal, no para el flujo principal de la app.

### Catálogo ↔ Detalle del libro: NavigationStack + NavigationLink

**Cómo funciona:** el Catálogo se envuelve en un `NavigationStack`, y el Inicio de sesión queda fuera de él. Cada portada es un `NavigationLink` que apila el Detalle del libro seleccionado sobre el Catálogo. Para regresar se usa el mecanismo del propio stack (botón de regreso y gesto de deslizar), que quita el Detalle y vuelve al Catálogo.

**Justificación:**
- Representa el flujo del diseño (abrir un detalle y volver) con un mecanismo creado para eso.
- SwiftUI maneja el regreso, sin que haya que guardar manualmente qué pantalla se está mostrando.
- El botón de regreso nativo se ve distinto al del diseño (flecha circular gris), pero se puede personalizar.

**Alternativas descartadas:**
- `sheet`: presenta el Detalle como hoja modal desde abajo, lo que no coincide con la flecha de regreso del diseño.
- Cambio de vista con un `Bool`: obliga a manejar manualmente el botón de regreso, la animación y cuál libro está seleccionado.

### Elementos sin mecanismo definido

La búsqueda no es navegación: es un estado del Catálogo, y su manejo se documenta en la sección 3. Para los siguientes elementos no se puede elegir un mecanismo hasta definir su comportamiento:

- Menú de hamburguesa. **Pendiente.**
- Íconos de audio y lectura. **Pendiente.**
- Toque sobre un resultado de búsqueda. **Pendiente.**
