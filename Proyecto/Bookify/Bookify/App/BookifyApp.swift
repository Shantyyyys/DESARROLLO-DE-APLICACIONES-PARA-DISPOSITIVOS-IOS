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
        _state = State(initialValue: AppState(favoritesStore: favoritesStore))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(state)
        }
        .modelContainer(container)
    }
}
