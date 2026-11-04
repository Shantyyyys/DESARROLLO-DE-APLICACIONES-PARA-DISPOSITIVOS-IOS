# Bookify: refactorización, pruebas unitarias y favoritos persistentes

Cambios hechos sobre la entrega del 29/10/2026, a partir de las notas del profesor. El objetivo es dejar el proyecto ordenado, probado y listo para conectar la API de libros.

| Módulo | Estado |
|---|---|
| Refactorización en carpetas (modularidad) | ✅ Hecho |
| Pruebas unitarias (Arrange, Act, Assert) | ✅ Hecho (15 pruebas) |
| Guardado local de favoritos con inserts (SwiftData) | ✅ Hecho |
| Carga de datos desde la API | ⏳ Pendiente (el proyecto ya está preparado) |

---

## 1. Refactorización en carpetas

Se organizó el código **por capa**, siguiendo MVVM. Cada carpeta tiene una sola responsabilidad (principio de responsabilidad única, SRP).

```
Bookify/
├── App/            Punto de entrada y vista raíz
│   ├── BookifyApp.swift
│   └── ContentView.swift
├── Models/         Datos del dominio
│   ├── Book.swift
│   └── FavoriteBook.swift      (nuevo, modelo de SwiftData)
├── State/          Estado compartido (única fuente de verdad)
│   └── AppState.swift          (antes estaba en ViewModels/)
├── ViewModels/     Lógica de presentación por pantalla
│   └── CatalogoViewModel.swift
├── Views/          Interfaz
│   ├── LoginView.swift
│   ├── CatalogoView.swift
│   └── BookDetailView.swift
├── Services/       Acceso a datos (persistencia y, más adelante, la API)
│   ├── FavoritesStore.swift          (nuevo, protocolo + versión en memoria)
│   └── SwiftDataFavoritesStore.swift (nuevo, versión con SwiftData)
└── Assets.xcassets

BookifyTests/       Pruebas unitarias
Docs/               Documentación
```

**Decisiones:**
- `AppState` se movió de `ViewModels/` a `State/`. No es el ViewModel de una pantalla: es el estado que comparten todas.
- `Services/` concentra el acceso a datos, así las vistas y los ViewModels no saben de dónde vienen los datos.

## 2. Pruebas unitarias

Se usó **XCTest** (`import XCTest`, clases que heredan de `XCTestCase`, métodos `test…` y aserciones `XCTAssertEqual`, `XCTAssertTrue` y `XCTAssertFalse`). Cada prueba sigue tres bloques, marcados con comentarios:

1. **Arrange:** se prepara el escenario (estado, datos de entrada).
2. **Act:** se ejecuta la acción que se quiere probar.
3. **Assert:** se verifica el resultado.

| Archivo | Qué prueba | Pruebas |
|---|---|---|
| `AppStateTests.swift` | Marcar y desmarcar favoritos, inserts y deletes en el almacén, carga de favoritos al iniciar | 6 |
| `CatalogoViewModelTests.swift` | Catálogo completo, filtro de favoritos, búsqueda por título y autor, búsqueda vacía o sin resultados | 6 |
| `SwiftDataFavoritesStoreTests.swift` | Insert, delete, control de duplicados y borrado de un id inexistente en SwiftData (base de datos en memoria) | 5 |

Para que `AppState` se pueda probar sin tocar la base de datos real, recibe su almacén de favoritos **desde afuera** (inyección de dependencias). En las pruebas se le pasa `InMemoryFavoritesStore`.

## 3. Guardado local de favoritos (inserts)

Antes los favoritos solo vivían en memoria y se perdían al cerrar la app. Ahora se guardan con **SwiftData**:

- **Modelo:** `FavoriteBook` (`@Model`) guarda `bookId` (único) y `addedAt`.
- **Al marcar un favorito:** `AppState.toggleFavorite` llama a `insert(bookId:)`, y este hace `context.insert(FavoriteBook(...))` y `save()`.
- **Al desmarcarlo:** se busca el registro con `#Predicate` y se hace `context.delete(...)`.
- **Al abrir la app:** `AppState` llama a `loadFavoriteIDs()` y recupera los favoritos guardados.

**Diseño (principio de inversión de dependencias, DIP):** `AppState` depende del protocolo `FavoritesStore`, no de SwiftData.

```
AppState ──usa──▶ FavoritesStore (protocolo)
                      ▲            ▲
       SwiftDataFavoritesStore   InMemoryFavoritesStore
          (la app real)          (#Preview y pruebas)
```

`BookifyApp` crea el `ModelContainer` y le pasa a `AppState` el `SwiftDataFavoritesStore`. Las vistas no cambiaron: siguen usando `state.toggleFavorite` y `state.isFavorite`.

## 4. Preparación para la API

El proyecto todavía usa los libros de ejemplo (`Book.samples`). Para conectar la API:

1. Crear `Services/BookService.swift` con un protocolo, por ejemplo `func fetchBooks() async throws -> [Book]`, y su implementación con `URLSession`.
2. Hacer que `Book` sea `Decodable`, o mapear la respuesta de la API a `Book`.
3. Cambiar el `id` de `Book`: hoy es el título, y debe ser el identificador que entregue la API. `FavoriteBook.bookId` ya está pensado para guardar ese id.
4. Inyectar `BookService` en `AppState` igual que `FavoritesStore`, y cargar `books` desde ahí.
5. Agregar pruebas con un `BookService` falso (mock) para no depender de internet.

## Otros cambios menores

- Se corrigió el título `"LaTregua"` a `"La Tregua"`.
- Se agregó `.environment(AppState())` al `#Preview` de `ContentView`. Sin eso, el preview fallaba al entrar al catálogo.
- Se agregó una etiqueta de VoiceOver al botón de favorito ("Agregar a favoritos" / "Quitar de favoritos").
- Se agregó `Book.samples`, que reúne los libros de ejemplo en un solo lugar.

## Pendientes (mejoras a futuro, fuera de esta entrega)

- Mostrar `searchResults` en la lista desplegable del buscador (la lógica ya existe y tiene pruebas).
- Botón de perfil en la esquina superior derecha.
- Cambiar el botón de hamburguesa por un filtro por género, con ícono de filtrado.
- Renombrar `gender` a `genre`.
- `BookDetailViewModel`.

## Cómo correr las pruebas

1. En Xcode, revisar si ya existe el target **BookifyTests**. Si no existe: **File → New → Target → Unit Testing Bundle**, con nombre `BookifyTests`, *Testing System:* **XCTest** y *Target to be Tested:* **Bookify**.
2. Copiar los 3 archivos de `BookifyTests/` dentro de ese target, reemplazando el archivo de ejemplo que crea Xcode.
3. Ejecutar con **⌘U**, o en el navegador de pruebas (ícono de rombo).
