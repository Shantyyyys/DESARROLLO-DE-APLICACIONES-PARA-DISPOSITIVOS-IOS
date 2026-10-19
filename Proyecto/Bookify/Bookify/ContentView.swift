//
//  ContentView.swift
//  Bookify
//
//  Created by Facultad de Contaduría y Administración on 24/09/26.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            CatalogoView()
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
}

#Preview {
    ContentView()
}
