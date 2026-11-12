# Pendientes para la Mac · Bookify (actualizado 12 nov 2026)

Lista de lo que hay que hacer y revisar con la Mac (jueves 12, 4 pm). Se va llenando en cada paso; antes de usar la Mac se entrega en PDF.

## 1. Pasar el código y compilar
- [ ] Bajar el código: en la Mac, dentro del repo, `git fetch origin` y `git checkout preultimo`; abrir `Proyecto/Bookify/Bookify.xcodeproj`. (La rama ya trae los `.swift`, los Docs, `Theme.swift`, `LoginFondo` y la foto `AboutUsPhoto`.)
- [ ] Compilar (⌘B) y corregir errores.
- [ ] Correr las pruebas (⌘U) y anotar resultados para el PR.
  - `testSearchBooksConsultaLaAPI` tarda ~0.5 s (espera el `Task.sleep`); es normal.
  - `testBusquedaSinCoincidencias` pasa siempre porque ya no ejecuta una búsqueda: decidir si se borra o se reescribe.
  - Nuevas del Paso 5: `testLoadSummaryUsaLaDescripcion`, `testLoadSummarySinDescripcionUsaPrimeraFrase` y `testLoadSummarySinDatosMuestraAviso`.
  - Nuevas del Paso 6 (`AppStateTests`): `testNoAgregaFavoritoConLimiteLleno`, `testQuitaFavoritoConLimiteLleno`, `testRecuperaLibrosFavoritosGuardados` y `testToggleGuardaDatosDelLibro`.
  - `SwiftDataFavoritesStoreTests`: ahora usan `insert(book:)`; nueva `testInsertGuardaDatosDelLibro`.
  - `BookMappingTests`: ahora esperan "Spanish", "Unknown" y "Unknown author" (Paso 8).
- [ ] Revisar que `FavoritesView.swift`, `SettingsView.swift` y `BookCoverImage.swift` (archivos nuevos) aparezcan en el target Bookify, y `BookFixtures.swift` en el target BookifyTests (las carpetas están sincronizadas, deberían entrar solos).
- [ ] Revisar que los `#Preview` se vean: ya no hay libros de ejemplo en la app; el detalle y Favoritos usan los libros de `MockBookService`.

## 2. Assets y repositorio
- [ ] AccentColor vacío en la copia.
- [ ] Revisar en `Assets.xcassets` que estén `LoginFondo` y `AboutUsPhoto` (ya vienen en la rama `preultimo`; `Applcon.appiconset` ya se quitó). El ícono de la app sigue siendo `AppIcon`.
- [ ] Agregar `.gitignore` para `xcuserdata`.

## 3. API en vivo (Open Library)
- [ ] "Descubrir más..." carga las tendencias (`/trending/daily.json`, endpoint no documentado). Si falla, cambiarlo a una búsqueda general.
- [ ] Los campos `subject`, `first_sentence` y `ratings_average` se decodifican sin error (en `search.json` y en tendencias).
- [ ] Los 8 carruseles de categoría cargan libros (`q=subject:"<categoría>"`).

## 4. Catálogo (Paso 4)
- [ ] Búsqueda mientras se escribe: espera ~0.5 s, no muestra error al seguir escribiendo, muestra cargando / sin resultados / resultados, y cada resultado abre el detalle.
- [ ] Menú de hamburguesa: abre la lista de categorías y, al elegir una, baja al carrusel correcto. Riesgo: la lista se cierra y el catálogo se desplaza en el mismo toque; si queda mal posicionado, ajustar.
- [ ] Portadas con AsyncImage en las tarjetas; los libros sin portada muestran el ícono provisional.
- [ ] Botón Reintentar de cada carrusel (probar con el simulador sin internet y luego reconectar).
- [ ] Un libro marcado como favorito desde la búsqueda o desde una categoría se conserva (los libros de las 3 secciones se juntan en `AppState`).

## 5. Detalle (Paso 5)
- [ ] La portada del detalle carga con AsyncImage; sin portada se ve el ícono provisional.
- [ ] El resumen aparece primero como cargando y luego con la descripción del work (`/works/{id}.json`).
- [ ] Libro sin descripción: muestra la primera frase; sin ninguna de las dos: "No summary available".
- [ ] Descripciones largas o con formato raro (enlaces, saltos de línea, texto entre corchetes) se leen bien; si no, decidir si se recortan.

## 6. Pestañas y Favoritos (Paso 6)
- [ ] La barra de pestañas muestra Home / Favorites / Settings con el color café oscuro en la seleccionada.
- [ ] Al cambiar de pestaña y regresar a Home, el catálogo no se vuelve a cargar completo (solo lo que falte o haya fallado).
- [ ] Si se cambia de pestaña mientras el catálogo carga, al regresar se reintenta y no se queda en error.
- [ ] Favoritos en cuadrícula (2 columnas) y en lista; el selector cambia entre ambos y la opción activa se ve marcada.
- [ ] Sin favoritos se muestra el mensaje "No favorites yet...".
- [ ] Tocar un favorito abre el detalle; al desmarcarlo ahí, desaparece de Favoritos al regresar.
- [ ] Límite de 10: al intentar agregar el 11.º aparece el aviso "Favorites limit reached" y no se agrega.
- [ ] **Migración de SwiftData:** si el simulador ya tenía favoritos de la versión anterior, revisar que la app abra. Si truena al crear el `ModelContainer`, borrar la app del simulador y volver a correrla. Los favoritos viejos (solo id) no se muestran; es esperado.
- [ ] Al cerrar y reabrir la app, Favoritos se ve completo (portada, título, autor), incluso con libros marcados desde la búsqueda.

## 7. Configuración (Paso 7)
- [ ] Settings se ve como el diseño: título, subtítulo y 3 tarjetas (Mode, Language, About Us) con ícono, línea divisoria y flecha.
- [ ] Mode y Language abren su pantalla con la primera opción marcada, la otra desactivada y la nota "Coming soon".
- [ ] About Us muestra la foto del equipo (si sale vacía, revisar que el Image Set se llame `AboutUsPhoto`).

## 8. Flujos completos
- [ ] Inicio → catálogo → categoría → detalle → favorito (límite 10) → cerrar y reabrir la app.

## 9. Interfaz en inglés (Paso 8)
- [ ] Recorrer todas las pantallas y confirmar que no quede texto en español (salvo títulos y autores que vienen de la API).
- [ ] El detalle muestra "Author:", "Published:", "Category:", "Language:" y "N pages"; el idioma sale como "Spanish", "English" o el código del idioma.
- [ ] Las portadas del catálogo y de Favoritos se siguen viendo igual (ahora usan `BookCoverImage`).

## 10. Ajustes después de compilar (12 nov, 5 pm)
- [ ] Tendencias: los libros de "Discover more" ya muestran páginas, calificación y categoría (se completan con `search.json`). Si siguen en "— pages", revisar en Safari: `https://openlibrary.org/search.json?q=key:("/works/OL82563W")&fields=key,title,number_of_pages_median`.
- [ ] Detalle: sin páginas o sin calificación se ve "—" en lugar de 0.
- [ ] Detalle: la portada se ve con su forma (más alta) y sin la tarjeta beige ancha.
- [ ] Menú de categorías: se cierra al empezar a escribir.
- [ ] Comentarios de flujo `[F#.#]` en el código y `Docs/flujos.md`: que compile igual (solo son comentarios).

## 11. Limpieza y entrega
- [ ] Quitar saltos de línea con ruido (#3), la carpeta `Claude outputs` y archivos temporales.
- [ ] Revisar el diff del PR: el cuerpo de `CatalogoView` sale reindentado por el `ScrollViewReader` (es esperado).
- [ ] Capturas de pantalla de la app funcionando.
- [ ] Commit de la entrega final.
