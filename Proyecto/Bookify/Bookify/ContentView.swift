//
//  ContentView.swift
//  Bookify
//
//  Created by Facultad de Contaduría y Administración on 24/09/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        BookDetailView(libro: Book.ejemplo)
    }
}

#Preview {
    ContentView()
}
