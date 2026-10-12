//
//  CatalogoView.swift
//  Bookify
//

import SwiftUI

struct CatalogoView: View {
    @Environment(AppState.self) private var estado

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Catálogo")
                        .font(.largeTitle)
                        .bold()

                    Text("Descubrir más...")
                        .font(.headline)

                    ForEach(estado.libros) { libro in
                        NavigationLink(value: libro) {
                            portada(de: libro)
                        }
                    }

                    Text("Favoritos")
                        .font(.headline)

                    ForEach(estado.libros.filter { estado.esFavorito($0) }) { libro in
                        NavigationLink(value: libro) {
                            portada(de: libro)
                        }
                    }
                }
                .padding()
            }
            .navigationDestination(for: Book.self) { libro in
                BookDetailView(libro: libro)
            }
        }
    }

    private func portada(de libro: Book) -> some View {
        Image(systemName: "book.closed")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 140)
            .foregroundStyle(.secondary)
            .padding()
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    CatalogoView()
        .environment(AppState())
}