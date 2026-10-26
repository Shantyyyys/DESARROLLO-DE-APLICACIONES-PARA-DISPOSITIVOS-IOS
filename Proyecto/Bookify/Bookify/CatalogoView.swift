//
//  CatalogoView.swift
//  Bookify
//

import SwiftUI

struct CatalogoView: View {
    @Environment(AppState.self) private var state
    @State private var searchText = ""

    private var viewModel: CatalogoViewModel {
        CatalogoViewModel(state: state)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    searchBar // NUEVO

                    Text("Catálogo")
                        .font(.largeTitle)
                        .bold()

                    Text("Descubrir más...")
                        .font(.headline)

                    ScrollView(.horizontal) {
                        HStack(spacing: 20) {
                            ForEach(viewModel.books) { book in
                                NavigationLink(value: book) {
                                    cover(de: book)
                                }
                            }
                        }
                    }
                    .scrollIndicators(.visible)

                    Text("Favoritos")
                        .font(.headline)

                    ScrollView(.horizontal) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.favoriteBooks) { book in
                                NavigationLink(value: book) {
                                    cover(de: book)
                                }
                            }
                        }
                    }
                    .scrollIndicators(.visible)
                }
                .padding()
            }
            .navigationDestination(for: Book.self) { book in
                BookDetailView(book: book)
            }
        }
    }

    
    private var searchBar: some View {
        HStack(spacing: 12) {
            Button {
                // Paso 4: mostrar el menú
            } label: {
                Image(systemName: "line.3.horizontal")
            }
            .accessibilityLabel("Menú")

            TextField("¿Qué quieres leer hoy?", text: $searchText)

            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.gray.opacity(0.15))
        .clipShape(Capsule())
    }

    private func cover(de book: Book) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "book.closed")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 140)
                .foregroundStyle(.secondary)
                .padding()
                .background(Color.gray.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(book.title)
                .font(.caption)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 132)
        }
    }
}

#Preview {
    CatalogoView()
        .environment(AppState())
}
