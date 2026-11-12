//
//  ContentView.swift
//  Bookify
//
//  Created by Facultad de Contaduría y Administración on 24/09/26.
//

// FLUJOS (ver Docs/flujos.md): F1 (arranque), F10 (pestañas)

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    let state: AppState
    let catalogoViewModel: CatalogoViewModel

    var body: some View {
        // [F1.6] Mientras no se toca "Start Reading" se muestra LoginView; después, las pestañas.
        if isLoggedIn {
            // Barra de pestañas del diseño: Inicio, Favoritos y Configuración.
            // [F1.8] Tres pestañas. Home y Favorites comparten el mismo state y ViewModel,
            // por eso un favorito marcado en Home aparece en Favorites.
            TabView {
                CatalogoView(viewModel: catalogoViewModel, state: state)
                    .tabItem {
                        Label("Home", systemImage: "book")
                    }

                FavoritesView(state: state, viewModel: catalogoViewModel)
                    .tabItem {
                        Label("Favorites", systemImage: "heart")
                    }

                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
            }
            .tint(Color.bookifyText)
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
}

#Preview {
    let state = AppState()
    ContentView(state: state, catalogoViewModel: CatalogoViewModel(state: state, bookService: MockBookService()))
}
