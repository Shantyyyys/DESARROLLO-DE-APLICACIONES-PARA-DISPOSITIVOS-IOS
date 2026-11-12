# Pendientes de Bookify (actualizado 12 nov 2026)

## Pendientes de Shanty
1. Que consulte toda la API, no solo "gabriel garcia marquez".
2. Enviar el state por inyección de dependencias.
3. Quitar los saltos de línea que meten ruido en el PR.
4. Darle estética a la app con el nuevo diseño (ver `Docs/diseno-nuevo.md`).
5. Revisar si hay código duplicado.
6. Arreglar el espacio de las barras de desplazamiento laterales.
7. Ver qué campos tiene la API y alinear la app con ellos.
8. Ver qué categorías tiene la API para agregarlas con el botón de hamburguesa. Debe desplegar la lista de categorías; cada una lleva a una vista con los libros de esa categoría sacados de la API.
9. Vista de favoritos: quitarla del catálogo y pasarla a una vista propia.
10. Vista de configuración: ver qué ajustes tienen sentido en una app de libros.
11. ~~Que los libros se puedan leer.~~ **Descartado (11 nov):** en su lugar va un resumen en el detalle (#16).
12. Que las portadas de los libros se vean en el catálogo.
13. Adaptar la vista de detalle para que también muestre la portada.
14. Mostrar el año como "1925" y no como "1,925".

## Pendientes nuevos (11 nov 2026)
15. Detalle: cambiar "Género" por **"Categoría"**, para clasificar los libros según las categorías de la API.
16. Detalle: agregar un **resumen/sinopsis** del libro en la parte de abajo.
17. Configuración: mostrar las opciones **sin funcionalidad** (no da tiempo de armarlas); solo debe quedar la idea. Precisa el #10.
18. Favoritos: pasarlos a su propia vista, funcionando igual que ahora, con un **límite de 10 libros** guardados. Precisa el #9.
19. Catálogo: debajo de "Descubrir más...", mostrar las **categorías de la API**, cada una con su carrusel horizontal.
20. Menú de hamburguesa: que despliegue una lista de categorías de la API, con el mismo estilo que la lista de búsqueda. Precisa el #8.
21. Cambiar la app a **inglés** (solo la interfaz; comentarios, docs y README siguen en español).

## Decisiones (11 nov 2026)
- **Fuente de datos (opción A):** todo sale del buscador `search.json`. La búsqueda escrita usa `q=<texto>` y cada categoría usa `q=subject:"<categoría>"`. Un solo DTO para todo. Se descartó `/subjects/{categoría}.json` (otro formato y API experimental).
- **Categorías:** lista fija: Fantasy, Science Fiction, Mystery, Romance, Horror, Biography, Children, History (`Models/BookCategory.swift`). Es la misma lista para el menú de hamburguesa y para los carruseles del catálogo.
- **Categoría de un libro:** la primera de la lista fija que coincida con su `subject`; si ninguna coincide, "Uncategorized". Si el libro viene de un carrusel de categoría, se usa esa.
- **Búsqueda (#1):** la barra busca en **toda la API** (ya no filtra la lista local), **mientras el usuario escribe**, esperando a que deje de escribir para no saturar la API.
- **"Descubrir más...":** muestra las **tendencias** de Open Library (`/trending/daily.json`).
- **Resumen (#16):** la descripción del work (`/works/{id}.json`, puede llegar como texto o como objeto); si no hay, la primera frase del libro (`first_sentence`); si tampoco, "No summary available".
- **Menú de hamburguesa:** al tocar una categoría, el catálogo se desplaza hasta el carrusel de esa categoría (en la misma vista).
- **Barra de pestañas:** Inicio / Favoritos / Configuración, como en el diseño.
- **Favoritos:** vista propia en cuadrícula de tarjetas, con opción para cambiar a lista. Máximo 10; al intentar agregar el 11.º se muestra un aviso.
- **Persistencia de favoritos (12 nov, opción 1):** SwiftData guarda los datos del libro (no solo el id), para que Favoritos se vea completo al reabrir la app aunque el libro ya no venga en tendencias ni categorías. Los favoritos viejos guardados solo con id no se muestran.
- **Configuración (actualizado 12 nov, con el diseño):** 3 tarjetas: Mode (claro/oscuro, solo idea), Language (solo idea) y About Us (foto del equipo y descripción). Mode y Language abren una pantalla con opciones desactivadas. La preferencia cuadrícula/lista solo está en la pestaña Favoritos.
- **Leer libros (#11):** descartado; se sustituye por el resumen en el detalle.
- **Código:** solo lo visto en clase; lo que no se vio, lo más estándar y simple de SwiftUI.
- **Riesgo:** no se pudo consultar Open Library en vivo al planear; los campos se validan al correr la app. El código acepta campos faltantes.

## Estado (12 nov 2026)
- Hechos: 2, 6, 7, 14; 1, 4, 5, 8/20, 9/18, 10/17, 12, 13, 15, 16, 19 y 21 (12 nov). Sin compilar aún los del 11 y 12 nov.
- Pendientes: 3 (se hace en la Mac).
- Descartado: 11.

## Alcance acordado (actualizado 11 nov 2026)
- **Cambio:** el profe dijo el 10 nov que la práctica 8 **es la entrega final** y se califica el estado del proyecto ese día. Todo lo que se quiera agregar tiene que quedar **antes del domingo 15**. (Reemplaza la nota anterior de que la entrega final era después.)
- Por lo tanto, todos los pendientes entran en esta semana, incluidas las funciones nuevas. Lo que no alcance a quedar compilado y probado se documenta como limitación.
- Mac disponible solo el jueves 12.
- La carpeta de trabajo en la laptop (`OneDrive\...\Proyecto\bookify\bookify`) no es repositorio de Git; el código se pasa a la Mac/repo para compilar.

## Práctica 8 · Documentación y preparación de la entrega final
- Abre lunes 9 nov 2026. **Cierra domingo 15 nov 2026, 23:59.**
- El enunciado dice: **no se espera agregar funcionalidades nuevas**, sino documentar, revisar y estabilizar lo que ya existe. (Aun así el profe pidió agregar todo antes de esta entrega.)
- Parte 1 · README: nombre y descripción breve, problema y propósito, funcionalidades, tecnologías, requisitos, instalación y configuración, ejecución, servicios externos (sin claves) e integrantes.
- Parte 2 · Documentación técnica: arquitectura, networking (API, endpoints, modelos de respuesta), persistencia, decisiones técnicas y limitaciones conocidas. Tiene que coincidir con lo que está implementado.
- Parte 3 · Revisión del repositorio: que compile y corra, quitar archivos temporales y código de prueba que sobre, que no haya claves ni tokens, documentar la configuración, revisar nombres y estructura, correr las pruebas unitarias y verificar los flujos principales.
- Parte 4 · Preparación de la entrega: verificar compilación y funcionalidades del MVP, confirmar que el README sirva para correr el proyecto, lista de limitaciones e identificar el commit de la entrega final.
- Parte 5 · Pull Request: resumen de la documentación, cambios en la organización, resultados de la revisión funcional, pruebas ejecutadas, limitaciones, commit final y **capturas de pantalla** de la app funcionando.
- Entrega: rama independiente → PR hacia main → pegar el enlace del PR en Moodle.
