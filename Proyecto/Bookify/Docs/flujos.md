# Flujos de Bookify (cómo funciona el código)

Cada flujo tiene un número (F1…F10) y cada paso un número dentro del flujo. En el código, cada paso está marcado con un comentario `// [F2.3] ...`; si buscas `[F2.` en Xcode (⌘⇧F) encuentras todo el flujo 2 en orden. Al inicio de cada archivo, la línea `// FLUJOS: ...` dice en qué flujos participa.

## F1 · Arranque de la app
1. `BookifyApp.init`: crea la base de datos de SwiftData (`ModelContainer`).
2. Crea `SwiftDataFavoritesStore` sobre esa base de datos.
3. Crea `AppState` (estado compartido); al crearse recupera los favoritos guardados (F9).
4. Crea `CatalogoViewModel` con el `BookService` real.
5. Muestra `ContentView` y le pasa el estado y el ViewModel (inyección de dependencias).
6. `ContentView`: mientras `isLoggedIn` es falso muestra `LoginView`.
7. `LoginView`: "Start Reading" pone `isLoggedIn = true`.
8. `ContentView` muestra las pestañas Home / Favorites / Settings, que comparten el mismo estado.

## F2 · Carga del catálogo (tendencias y categorías)
1. `CatalogoView` `.task`: al aparecer llama a `loadCatalog()`.
2. `CatalogoViewModel.loadCatalog()`: pide tendencias si faltan y luego las categorías que falten (al volver a Home no se recarga todo).
3. `loadBooks()`: pide las tendencias al servicio.
4. `BookService.fetchTrendingBooks()`:
   a. pide `/trending/daily.json`;
   b. vuelve a pedir esos libros a `search.json` en una sola consulta (`q=key:(...)`) para tener páginas, calificación y temas;
   c. respeta el orden de tendencias;
   d. si esa consulta falla, regresa las tendencias tal cual.
5. Convierte a `Book`, los guarda en `AppState` (`remember`) y cambia `loadState`; como el ViewModel es `@Observable`, la vista se redibuja.
6. `CatalogoView` dibuja "Discover more" según `loadState`.
7. `section(for:retry:)`: cargando / carrusel / sin resultados / error con Retry.
8. `loadCategories()`: recorre las 8 categorías en orden.
9. `loadBooks(in:)` → `BookService.fetchBooks(in:)` (`q=subject:"<categoría>"`) → `Book` con esa categoría → estado de su carrusel.
10. `CatalogoView` dibuja un título y un carrusel por categoría.

## F3 · Búsqueda en la API mientras se escribe
1. `TextField`: lo escrito va a `viewModel.searchText`.
2. `.task(id: searchText)`: cada cambio cancela la búsqueda anterior y llama a `searchBooks()`.
3. `searchBooks()`: si el texto está vacío no busca.
4. Espera 500 ms (`Task.sleep`); si llega otra letra, se cancela ahí y no se hace la petición.
5. `BookService.searchBooks(query:)` (`q=<texto>`) → `Book` → `remember` → `searchState`.
6. `CatalogoView`: si hay texto, se muestra la lista de resultados.
7. La lista muestra cargando / sin resultados / error / libros; cada resultado abre el detalle (F6).

## F4 · Menú de categorías
1. La hamburguesa cambia `showCategories`.
2. Con `showCategories` en true aparece la lista (mismo estilo que la búsqueda).
3. Al elegir una categoría se cierra la lista y `proxy.scrollTo(category.id)` baja hasta su carrusel.
4. El carrusel tiene `.id(category.id)`: ese es el destino del desplazamiento.
5. Al empezar a escribir (`onChange` de `searchText`) la lista se cierra.

## F5 · Petición a la API (red y conversión de datos)
1. `BookService.search(q:limit:)` / `makeURL`: arma la URL con `URLComponents`.
2. `APIClient.get(from:)`: petición GET genérica.
3. Ejecuta la petición con `URLSession` (error de conectividad → `APIError.connectivity`).
4. Valida que sea respuesta HTTP.
5. Valida el código 200…299 (si no, `APIError.httpError`).
6. Decodifica el JSON a los DTO (`BookDTO`, `TrendingResponseDTO`, `WorkDTO`).
7. `Book(from:)` convierte el DTO en `Book` (con valores por defecto si falta algo).
8. `BookCategory.matching(subjects:)` deduce la categoría si el libro no viene de un carrusel.

## F6 · Detalle del libro y resumen
1. Cada tarjeta o resultado es un `NavigationLink(value: book)`.
2. `.navigationDestination` abre `BookDetailView` con ese libro.
3. `BookDetailView` `.task`: pide el resumen; mientras, se ve un indicador de carga.
4. `CatalogoViewModel.loadSummary(for:)`: descripción → primera frase → "No summary available".
5. `BookService.fetchSummary(workKey:)` pide `/works/{id}.json`.
6. El detalle muestra el resumen. Si no hay páginas o calificación se muestra "—".

## F7 · Marcar / desmarcar favorito (límite de 10)
1. Botón de marcador del detalle → `AppState.toggleFavorite`.
2. Si ya es favorito se quita; si no, se agrega.
3. Si ya hay 10, no se agrega y regresa `false`.
4. Se guarda o borra en SwiftData (`SwiftDataFavoritesStore.insert/delete`), con los datos del libro (`FavoriteBook`).
5. Si regresó `false`, el detalle muestra el aviso "Favorites limit reached".
6. El ícono del marcador se actualiza solo (`AppState` es `@Observable`).

## F8 · Pestaña Favoritos
1. `FavoritesView`: sin favoritos muestra un mensaje; con favoritos, cuadrícula o lista.
2. `CatalogoViewModel.favoriteBooks`: libros conocidos cuyo id está en `AppState.favorites`.
3. El selector cambia `AppState.favoritesLayout` y la vista se redibuja.
4. Tocar un favorito abre su detalle (F6); ahí se puede desmarcar (F7).

## F9 · Favoritos al reabrir la app
1. `AppState.init` lee los ids guardados (`loadFavoriteIDs`).
2. Lee también los libros guardados (`loadFavoriteBooks` → `FavoriteBook.book`) y los agrega a `books`, así Favoritos se ve completo aunque esos libros ya no vengan de la API.

## F10 · Configuración
1. `SettingsView`: tres tarjetas, cada una abre su pantalla.
2. Mode y Language: solo la idea (primera opción marcada, la otra desactivada, "Coming soon").
3. About Us: foto del equipo (`AboutUsPhoto`) y descripción de Bookify.
