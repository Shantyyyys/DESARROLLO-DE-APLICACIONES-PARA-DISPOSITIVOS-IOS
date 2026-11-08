//
//  ContentView.swift
//  Bookify
//
//  Created by Facultad de Contaduría y Administración on 24/09/26.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    let catalogoViewModel: CatalogoViewModel

    var body: some View {
        if isLoggedIn {
            CatalogoView(viewModel: catalogoViewModel)
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
}

#Preview {
    let state = AppState()
    ContentView(catalogoViewModel: CatalogoViewModel(state: state, bookService: MockBookService()))
        .environment(state)
}
