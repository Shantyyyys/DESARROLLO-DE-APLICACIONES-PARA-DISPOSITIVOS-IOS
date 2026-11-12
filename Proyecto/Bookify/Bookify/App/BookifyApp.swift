//
//  BookifyApp.swift
//  Bookify
//
//  Created by Facultad de Contaduría y Administración on 24/09/26.
//

import SwiftUI
import SwiftData

@main
struct BookifyApp: App {
    /// Contenedor de SwiftData: guarda los favoritos en el dispositivo.
    let container: ModelContainer
    @State private var state: AppState
    @State private var catalogoViewModel: CatalogoViewModel

    init() {
        let container: ModelContainer
        do {
            container = try ModelContainer(for: FavoriteBook.self)
        } catch {
            fatalError("No se pudo crear el ModelContainer: \(error)")
        }
        self.container = container

        // AppState recibe el almacén de favoritos desde afuera (inyección de dependencias).
        let favoritesStore = SwiftDataFavoritesStore(context: container.mainContext)
        // Arranca sin libros locales: el catálogo real llega de Open Library.
        let appState = AppState(books: [], favoritesStore: favoritesStore)
        _state = State(initialValue: appState)

        // El ViewModel recibe el servicio real (inyección de dependencias).
        _catalogoViewModel = State(initialValue: CatalogoViewModel(
            state: appState,
            bookService: BookService()
        ))
    }

    var body: some Scene {
        WindowGroup {
            // El state también se inyecta por parámetro, igual que el catálogo.
            ContentView(state: state, catalogoViewModel: catalogoViewModel)
                // El diseño solo tiene versión clara: se fuerza en toda la app.
                .preferredColorScheme(.light)
        }
        .modelContainer(container)
    }
}
