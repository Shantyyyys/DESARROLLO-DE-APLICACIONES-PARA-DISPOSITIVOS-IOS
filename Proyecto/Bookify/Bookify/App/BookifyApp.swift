//
//  BookifyApp.swift
//  Bookify
//
//  Created by Facultad de Contaduría y Administración on 24/09/26.
//

// FLUJOS (ver Docs/flujos.md): F1 (arranque)

import SwiftUI
import SwiftData

@main
struct BookifyApp: App {
    /// Contenedor de SwiftData: guarda los favoritos en el dispositivo.
    let container: ModelContainer
    @State private var state: AppState
    @State private var catalogoViewModel: CatalogoViewModel

    init() {
        // [F1.1] Se crea la base de datos de SwiftData donde se guardan los favoritos.
        let container: ModelContainer
        do {
            container = try ModelContainer(for: FavoriteBook.self)
        } catch {
            fatalError("No se pudo crear el ModelContainer: \(error)")
        }
        self.container = container

        // AppState recibe el almacén de favoritos desde afuera (inyección de dependencias).
        // [F1.2] El almacén de favoritos usa esa base de datos.
        let favoritesStore = SwiftDataFavoritesStore(context: container.mainContext)
        // Arranca sin libros locales: el catálogo real llega de Open Library.
        // [F1.3] Se crea el estado compartido; al crearse recupera los favoritos guardados (ver F9).
        let appState = AppState(books: [], favoritesStore: favoritesStore)
        _state = State(initialValue: appState)

        // El ViewModel recibe el servicio real (inyección de dependencias).
        // [F1.4] Se crea el ViewModel del catálogo con el servicio real de Open Library.
        _catalogoViewModel = State(initialValue: CatalogoViewModel(
            state: appState,
            bookService: BookService()
        ))
    }

    var body: some Scene {
        WindowGroup {
            // El state también se inyecta por parámetro, igual que el catálogo.
            // [F1.5] Primera vista: ContentView recibe el estado y el ViewModel.
            ContentView(state: state, catalogoViewModel: catalogoViewModel)
                // El diseño solo tiene versión clara: se fuerza en toda la app.
                .preferredColorScheme(.light)
        }
        .modelContainer(container)
    }
}
