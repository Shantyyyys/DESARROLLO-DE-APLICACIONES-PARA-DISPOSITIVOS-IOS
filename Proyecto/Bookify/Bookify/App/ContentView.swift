//
//  ContentView.swift
//  Bookify
//
//  Created by Facultad de Contaduría y Administración on 24/09/26.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    let state: AppState
    let catalogoViewModel: CatalogoViewModel

    var body: some View {
        if isLoggedIn {
            // Barra de pestañas del diseño: Inicio, Favoritos y Configuración.
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
