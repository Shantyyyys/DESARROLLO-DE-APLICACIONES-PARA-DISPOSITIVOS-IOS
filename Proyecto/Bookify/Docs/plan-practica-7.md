# Plan de trabajo · Práctica 7 (Networking e integración de API) — Bookify

**Cierre:** domingo 8 nov 2026, 23:59
**Condición:** sin acceso a Mac hoy → se entrega sin compilar (igual que la práctica 6) y se declara en el PR.
**Rama sugerida:** `practica-7` → PR hacia `main`.
**API:** Open Library (sin token → cumple "no publicar claves").

## Estado actual del proyecto (punto de partida)
- Carpetas por capa: App/, Models/, State/, ViewModels/, Views/, Services/.
- `Book` es struct con `id = title`; datos salen de `Book.samples` (locales).
- `AppState` (@Observable) tiene `books` y `favorites`; recibe `FavoritesStore` por inyección.
- Favoritos persistidos con SwiftData (`FavoriteBook.bookId`, hoy = título).
- `CatalogoViewModel` es un **struct** que la vista recrea en cada render (no puede guardar estado asíncrono).
- Pruebas XCTest con Arrange-Act-Assert (CatalogoViewModelTests, AppStateTests, SwiftDataFavoritesStoreTests).

## Referencia del profe (código clase 24, proyecto TMDB)
`APIClient` (protocolo + URLSession + HTTPURLResponse + status 200...299 + JSONDecoder) →
`MovieService` (protocolo + mock) → `MovieDTO` (Decodable + CodingKeys) →
`Movie(from: dto)` → `MovieViewModel` (@Observable class, enum `error/loading/loaded`) →
vista con `switch` + `.task { await viewModel.fetchMovies() }`.
**Regla de hoy:** copiar esta estructura lo más fiel posible para reducir errores de compilación.

## Pasos (uno a la vez, validar antes de avanzar)

### Paso 1 · Endpoint + DTO
- Decidir endpoint de la pantalla principal (recomendado: opción A, `https://openlibrary.org/search.json?q=<término>&limit=20`).
- Decidir término de búsqueda fijo.
- Verificar la respuesta JSON real y elegir campos (candidatos: `key`, `title`, `author_name`, `first_publish_year`, `cover_i`, `language`, `number_of_pages_median`, `subject`).
- Crear `Models/BookDTO.swift`: `BookSearchResponseDTO` + `BookDTO` con `CodingKeys`.
- Pendiente: confirmar si Shanty ya domina DTO / CodingKeys o se explica primero.

### Paso 2 · Modelo de dominio
- `Book(from: BookDTO)`.
- Cambiar id a `key` de la API (decisión pendiente; afecta `FavoriteBook.bookId` y pruebas que usan títulos).
- Decidir qué hacer con campos que la API no trae (`rating`, `audio`, `pages`, `gender`): opcional, valor por defecto o quitar.
- `Book.samples` se queda solo para Previews y pruebas.

### Paso 3 · Capa de red
- `Services/APIClient.swift`: protocolo `APIClientProtocol` + `APIClient` con `enum APIError` (URL inválida, respuesta inválida, HTTP con status, decodificación).
- `Services/BookService.swift`: `BookServiceProtocol` + `BookService` (arma la URL con `URLComponents`) + `MockBookService`.
- Errores se propagan con `throws`, nada de `try?` silencioso.

### Paso 4 · ViewModel con estados
- Decisión pendiente: dónde vive el estado de la consulta (opciones a discutir: convertir `CatalogoViewModel` en `@Observable class` creado una vez con `@State`, o poner la carga en `AppState`).
- `enum` de estados: `loading`, `content([Book])`, `empty`, `error(String)`.
- Función `func loadBooks() async`; una sola fuente de verdad para el estado.
- La búsqueda local y los favoritos deben seguir funcionando sobre los libros cargados.

### Paso 5 · Vista
- `switch` sobre el estado en `CatalogoView`: `ProgressView` / contenido actual / mensaje "Sin resultados" / mensaje de error + botón **Reintentar**.
- `.task { await ... }` para la carga inicial (la interfaz no se bloquea).
- Verificar que `NavigationStack` → `BookDetailView` sigue igual.
- Inyectar `BookService` real en `BookifyApp`; mock en `#Preview`.

### Paso 6 · Pruebas (XCTest, AAA, con mock)
- Éxito: el mock devuelve libros → estado `content` con esos libros.
- Error: el mock lanza error → estado `error`.
- Sin resultados: el mock devuelve `[]` → estado `empty`.
- Ajustar pruebas existentes si cambia el id o el ViewModel.
- Hoy no se pueden ejecutar → declararlo en el PR.

### Paso 7 · Rama + Pull Request (Git Bash)
Secciones del PR: descripción · endpoint y qué alimenta · componentes (Service, ViewModel, View) · estados contemplados · escenarios probados y resultados (pendiente de ejecutar en Mac) · decisiones técnicas · problemas conocidos/pendientes.

## Fuera de esta práctica (anotar como pendientes en el PR)
- Que la barra de búsqueda consulte a la API (hoy filtra la lista local).
- Favoritos que no aparecen en la lista descargada.
- Portadas reales con `cover_i`.
- Renombrar `gender` → `genre`; filtro por género; botón de perfil.
- Proyecto no compilado ni pruebas ejecutadas (sin Mac el día de la entrega).
