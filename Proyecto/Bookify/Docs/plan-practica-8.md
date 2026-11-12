# Plan de trabajo · Práctica 8 — Bookify (actualizado 12 nov 2026)

**Cierre:** domingo 15 nov 2026, 23:59. **Mac disponible:** solo jueves 12.
**Alcance (cambió el 11 nov):** la práctica 8 **es la entrega final**; todo lo que se quiera agregar tiene que quedar antes del domingo. Ver `pendientes.md` (pendientes 1–21 y decisiones).
**Carpeta de trabajo:** laptop, `C:\Users\mende\OneDrive\Universidad\Semestre 7\IOS\Proyecto\bookify\bookify` (no es repositorio de Git; el código se pasa a la Mac/repo para compilar). La copia del proyecto de Claude está sincronizada con la laptop al 12 nov.
**Reglas de código:** usar solo lo visto en clase (sin explicaciones); donde la clase no cubrió algo (TabView, cuadrícula, desplazamiento a una sección), usar lo más estándar y simple de SwiftUI. La preferencia cuadrícula/lista vive en `AppState` (no `@AppStorage`). Búsqueda con `.task(id:)` + `Task.sleep` (visto en clase). Interfaz en inglés; comentarios y docs en español.

## Hecho
1. ✅ Martes 10 (con Mac): paleta `Theme.swift`, login sin correo/contraseña con `LoginFondo`, modo claro forzado, rediseño de detalle y catálogo, año sin separador (#14), carruseles sin barra lateral (#6), carrusel reutilizable `carousel(of:)`.
2. ✅ Miércoles 11 · #2 State por inyección: `BookifyApp` → `ContentView(state:catalogoViewModel:)` → `CatalogoView(viewModel:state:)` → `BookDetailView(book:state:)`; se quitó `.environment(state)`.
3. ✅ Miércoles 11 · Pasos 1 y 2, capa de datos (#7, #15, base de #1, #16 y #19):
   - `Models/BookCategory.swift` (nuevo): 8 categorías fijas (Fantasy, Science Fiction, Mystery, Romance, Horror, Biography, Children, History), con `title`, `searchTerm`, palabras clave y `matching(subjects:)`; si no coincide, "Uncategorized".
   - `Models/BookDTO.swift`: campos `subject`, `first_sentence`, `ratings_average`; `TrendingResponseDTO`, `WorkDTO`; `OpenLibraryText` acepta `"texto"`, `["texto"]` o `{"value": ...}`.
   - `Models/Book.swift`: `gender` → `category`, se quitó `audio`, se agregó `firstSentence`, `rating` real; `init(from:category:)`.
   - `Services/BookService.swift`: `fetchTrendingBooks()`, `searchBooks(query:)`, `fetchBooks(in:)`, `fetchSummary(workKey:)`; búsqueda compartida `search(q:limit:)`; mock actualizado.
   - Ajustes: `CatalogoViewModel` llama a `fetchTrendingBooks()`; el detalle dice "Categoría:" y ya no muestra audio; `SecuenciaBookService` en pruebas implementa el protocolo nuevo.
   - `BookifyTests/BookCategoryTests.swift` (nuevo): 5 pruebas AAA.

## Siguiente (en orden, un paso a la vez)
4. ✅ Jueves 12 · Paso 3 · `CatalogoViewModel`: secciones por categoría (`categoryStates`, `state(for:)`, `loadCategories()`, `loadBooks(in:)`), "Discover more" con tendencias (`loadBooks()`), búsqueda en toda la API mientras se escribe (`searchState`, `searchBooks()` con `Task.sleep` de 500 ms, la vista la llama con `.task(id:)`) (#1). Los libros de las 3 secciones se juntan en `AppState` sin duplicados (`remember(_:)`). Pruebas: se quitaron `testBuscaPorTitulo` y `testBuscaPorAutor` (búsqueda local); nueva `testSearchBooksConsultaLaAPI`.
5. ✅ Jueves 12 · Paso 4 · `CatalogoView`: carruseles por categoría (#19) con estado y Reintentar propios (`section(for:retry:)` reutilizable para tendencias y categorías), menú de hamburguesa con lista de categorías que desplaza al carrusel con `ScrollViewReader` (#20), portadas con AsyncImage (#12), se quitó la sección Favoritos del catálogo, búsqueda conectada con `.task(id: searchText)` y lista de resultados según `searchState`.
6. ✅ Jueves 12 · Paso 5 · Detalle: portada con AsyncImage (#13), categoría, sección "Summary" = descripción → primera frase → "No summary available" (#16). El resumen lo carga `CatalogoViewModel.loadSummary(for:)` (decisión de Shanty); el detalle recibe el ViewModel. 3 pruebas nuevas del resumen.
7. ✅ Jueves 12 · Paso 6 · Barra de pestañas Home/Favorites/Settings (`TabView` en `ContentView`; Settings provisional); `FavoritesView` (nuevo) en cuadrícula de 2 columnas o lista, preferencia `favoritesLayout` en `AppState`; límite `maxFavorites = 10` (`toggleFavorite` regresa false) con aviso en el detalle (#9, #18). `loadCatalog()` evita recargar el catálogo al volver a Home. Diseño de Favoritos y decisiones en `diseno-nuevo.md` §4.
   - Persistencia completa de favoritos (opción 1, decisión de Shanty): `FavoriteBook` guarda los datos del libro (con valores por defecto para migrar los registros viejos); `FavoritesStore` tiene `loadFavoriteBooks()` e `insert(book:)`; `AppState` agrega los favoritos guardados a `books` al iniciar, así Favoritos se ve completo al reabrir la app. Pruebas nuevas: `testInsertGuardaDatosDelLibro`, `testRecuperaLibrosFavoritosGuardados`, `testToggleGuardaDatosDelLibro`.
8. ✅ Jueves 12 · Paso 7 · `SettingsView` (nuevo) según el diseño (§5 de `diseno-nuevo.md`): tarjetas Mode, Language y About Us. Mode (claro/oscuro) y Language (English/Spanish) abren una pantalla con las opciones desactivadas ("Coming soon"); About Us muestra la foto del equipo (`AboutUsPhoto`, antes en el set duplicado `Applcon.appiconset`, que se quitó) y la descripción de Bookify (#10, #17). La preferencia grid/list solo se cambia desde Favoritos.
9. ✅ Jueves 12 · Paso 8 · Interfaz en inglés (#21): catálogo, detalle, mensajes de error e idiomas del modelo ("Spanish", "English", "Unknown", "Unknown author"); `BookMappingTests` actualizado. Duplicados (#5): la portada con AsyncImage del catálogo y de Favoritos ahora es la vista compartida `BookCoverImage` (nuevo). Se quitaron los libros de ejemplo de la app (`Book.samples`): `AppState` empieza sin libros y los `#Preview` usan `MockBookService`; las pruebas usan los mismos libros desde `BookifyTests/BookFixtures.swift` (nuevo).

## Con Mac
Lista detallada para revisar en la Mac: `Docs/pendientes-mac.md` (se actualiza en cada paso; antes de usar la Mac se entrega en PDF).

10. Copiar el código a la Mac/repo (solo `.swift` y `Docs`, no los Assets de la laptop), compilar (⌘B), corregir y correr pruebas (⌘U).
11. Revisar Assets: AccentColor vacío en la copia, set duplicado `Applcon.appiconset`, agregar `.gitignore` para `xcuserdata`.
12. Verificar endpoint de tendencias (`/trending/daily.json`, no documentado); si falla, cambiar "Discover more" a una búsqueda general.
13. Flujos: inicio → catálogo → categoría → detalle → favorito (límite 10) → reabrir la app.
14. Quitar saltos de línea con ruido (#3), carpeta `Claude outputs` y archivos temporales.
15. Capturas de pantalla y commit de la entrega final.

## Documentación (sin Mac)
16. README (parte 1).
17. Documentación técnica: arquitectura, networking, persistencia, decisiones y limitaciones (parte 2).
18. Revisar que la documentación coincida con la app.

## Domingo 15
19. Rama → PR (evidencias, pruebas, limitaciones, commit final) → enlace en Moodle.

## Decisiones previas
- Inicio de sesión sin correo ni contraseña, como en el diseño (10 nov).
- Colores con extensión `Color`; fondo del inicio como imagen en Assets (10 nov).
- App siempre en modo claro con fondo crema (10 nov).
- Portadas: `cover_i` + Covers API (`covers.openlibrary.org/b/id/{id}-L.jpg`) con AsyncImage.
