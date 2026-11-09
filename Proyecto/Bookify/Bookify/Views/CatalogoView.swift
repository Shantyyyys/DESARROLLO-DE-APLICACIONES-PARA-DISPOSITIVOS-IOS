//
//  CatalogoView.swift
//  Bookify
//

import SwiftUI

struct CatalogoView: View {
    /// Se crea una sola vez en BookifyApp y se conserva entre renders.
    @State private var viewModel: CatalogoViewModel

    init(viewModel: CatalogoViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    searchBar

                    // NUEVO: la lista aparece solo mientras se busca
                    if viewModel.isSearching {
                        searchResultsList
                    }

                    Text("Catálogo")
                        .font(.largeTitle)
                        .bold()

                    Text("Descubrir más...")
                        .font(.headline)

                    catalogSection

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
        // Carga inicial: corre sin bloquear la interfaz.
        .task {
            await viewModel.loadBooks()
        }
    }

    // Zona del carrusel "Descubrir más...": cambia según el estado de la consulta.
    @ViewBuilder
    private var catalogSection: some View {
        switch viewModel.loadState {
        case .loading:
            ProgressView("Cargando libros...")
                .frame(maxWidth: .infinity, minHeight: 180)

        case .content(let books):
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(books) { book in
                        NavigationLink(value: book) {
                            cover(de: book)
                        }
                    }
                }
            }
            .scrollIndicators(.visible)

        case .empty:
            Text("Sin resultados")
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, minHeight: 180)

        case .error(let message):
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                Button("Reintentar") {
                    Task {
                        await viewModel.loadBooks()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, minHeight: 180)
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

            TextField("¿Qué quieres leer hoy?", text: $viewModel.searchText)

            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.gray.opacity(0.15))
        .clipShape(Capsule())
    }

    // NUEVO: lista desplegable de resultados
    private var searchResultsList: some View {
        VStack(alignment: .leading, spacing: 0) {
            if viewModel.searchResults.isEmpty {
                Text("Sin resultados")
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                ForEach(viewModel.searchResults) { book in
                    NavigationLink(value: book) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(book.title)
                            Text(book.author)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                        .padding(.horizontal)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    Divider()
                }
            }
        }
        .background(Color.gray.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 12))
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

#Preview("Contenido (mock)") {
    let state = AppState()
    CatalogoView(viewModel: CatalogoViewModel(state: state, bookService: MockBookService()))
        .environment(state)
}

#Preview("Error (mock)") {
    let state = AppState()
    CatalogoView(viewModel: CatalogoViewModel(
        state: state,
        bookService: MockBookService(error: MockBookServiceError.loadingFailed)
    ))
    .environment(state)
}
