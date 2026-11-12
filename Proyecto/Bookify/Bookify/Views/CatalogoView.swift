//
//  CatalogoView.swift
//  Bookify
//
//  Pantalla principal con el estilo del diseño nuevo.
//

import SwiftUI

struct CatalogoView: View {
    /// Se crea una sola vez en BookifyApp y se conserva entre renders.
    @State private var viewModel: CatalogoViewModel
    /// Estado compartido inyectado por parámetro; se pasa al detalle.
    private let state: AppState
    /// Muestra u oculta la lista de categorías del menú de hamburguesa.
    @State private var showCategories = false

    init(viewModel: CatalogoViewModel, state: AppState) {
        _viewModel = State(initialValue: viewModel)
        self.state = state
    }

    var body: some View {
        NavigationStack {
            // Permite desplazar el catálogo hasta el carrusel de una categoría.
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Contenido con margen lateral
                        Group {
                            searchBar

                            // La lista de categorías aparece al tocar el menú
                            if showCategories {
                                categoriesList(proxy: proxy)
                            }

                            // La lista aparece solo mientras se busca
                            if viewModel.isSearching {
                                searchResultsList
                            }

                            Text("Catalog")
                                .font(.system(.largeTitle, design: .serif))
                                .foregroundStyle(Color.bookifyText)

                            sectionTitle("Discover more...")
                        }
                        .padding(.horizontal)

                        // Los carruseles llegan de orilla a orilla (sin margen externo)
                        section(for: viewModel.loadState) {
                            await viewModel.loadBooks()
                        }

                        // Un carrusel por categoría; el id permite llegar desde el menú.
                        ForEach(viewModel.categories) { category in
                            VStack(alignment: .leading, spacing: 16) {
                                sectionTitle(category.title)
                                    .padding(.horizontal)

                                section(for: viewModel.state(for: category)) {
                                    await viewModel.loadBooks(in: category)
                                }
                            }
                            .id(category.id)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .background(Color.bookifyBackground.ignoresSafeArea())
            .navigationDestination(for: Book.self) { book in
                BookDetailView(book: book, state: state, viewModel: viewModel)
            }
        }
        // Carga inicial: corre sin bloquear la interfaz.
        .task {
            await viewModel.loadCatalog()
        }
        // Busca en la API cada vez que cambia el texto; SwiftUI cancela la búsqueda anterior.
        .task(id: viewModel.searchText) {
            await viewModel.searchBooks()
        }
    }

    // MARK: - Secciones

    /// Contenido de una sección (tendencias o categoría) según el estado de su consulta.
    @ViewBuilder
    private func section(for loadState: CatalogoViewModel.LoadState, retry: @escaping () async -> Void) -> some View {
        switch loadState {
        case .loading:
            ProgressView("Loading books...")
                .tint(Color.bookifyPrimary)
                .foregroundStyle(Color.bookifySecondaryText)
                .frame(maxWidth: .infinity, minHeight: 200)

        case .content(let books):
            carousel(of: books)

        case .empty:
            Text("No results")
                .foregroundStyle(Color.bookifySecondaryText)
                .frame(maxWidth: .infinity, minHeight: 200)

        case .error(let message):
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                    .foregroundStyle(Color.bookifyCoverIcon)
                    .accessibilityHidden(true)
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.bookifySecondaryText)
                Button("Retry") {
                    Task {
                        await retry()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, minHeight: 200)
        }
    }

    /// Carrusel horizontal reutilizable (tendencias y categorías).
    private func carousel(of books: [Book]) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 16) {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        cover(de: book)
                    }
                    .buttonStyle(.plain)
                }
            }
            // El margen va DENTRO del scroll: la primera tarjeta se alinea con
            // los títulos, pero al deslizar las tarjetas llegan a la orilla.
            .padding(.horizontal)
            // Espacio para que la sombra de las tarjetas no se corte.
            .padding(.vertical, 8)
        }
        .scrollIndicators(.hidden)
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.system(.title2, design: .serif))
            .foregroundStyle(Color.bookifySecondaryText)
    }

    // MARK: - Componentes

    private var searchBar: some View {
        HStack(spacing: 12) {
            Button {
                showCategories.toggle()
            } label: {
                Image(systemName: "line.3.horizontal")
                    .foregroundStyle(Color.bookifyText)
            }
            .accessibilityLabel("Categories")

            TextField("What do you want to read today?", text: $viewModel.searchText)
                .foregroundStyle(Color.bookifyText)

            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.bookifySecondaryText)
                .accessibilityHidden(true)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.05))
        .clipShape(Capsule())
    }

    /// Lista desplegable de resultados de búsqueda.
    private var searchResultsList: some View {
        VStack(alignment: .leading, spacing: 0) {
            switch viewModel.searchState {
            case .loading:
                ProgressView()
                    .tint(Color.bookifyPrimary)
                    .frame(maxWidth: .infinity)
                    .padding()

            case .empty:
                Text("No results")
                    .foregroundStyle(Color.bookifySecondaryText)
                    .padding()

            case .error(let message):
                Text(message)
                    .foregroundStyle(Color.bookifySecondaryText)
                    .padding()

            case .content(let books):
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(book.title)
                                .font(.system(.body, design: .serif))
                                .foregroundStyle(Color.bookifyText)
                            Text(book.author)
                                .font(.caption)
                                .foregroundStyle(Color.bookifySecondaryText)
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
        .background(Color.bookifyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
    }

    /// Lista desplegable de categorías (mismo estilo que la de búsqueda).
    private func categoriesList(proxy: ScrollViewProxy) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(viewModel.categories) { category in
                Button {
                    showCategories = false
                    // Baja hasta el carrusel de la categoría elegida.
                    withAnimation {
                        proxy.scrollTo(category.id, anchor: .top)
                    }
                } label: {
                    Text(category.title)
                        .font(.system(.body, design: .serif))
                        .foregroundStyle(Color.bookifyText)
                        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                        .padding(.horizontal)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                Divider()
            }
        }
        .background(Color.bookifyCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
    }

    /// Tarjeta de libro: portada + título dentro de la tarjeta.
    private func cover(de book: Book) -> some View {
        VStack(spacing: 12) {
            BookCoverImage(book: book)
                .frame(width: 80, height: 110)

            Text(book.title)
                .font(.system(.subheadline, design: .serif))
                .foregroundStyle(Color.bookifyText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(.horizontal, 8)
        .frame(width: 150, height: 210)
        .background(Color.bookifyCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 10, y: 4)
    }
}

#Preview("Contenido (mock)") {
    let state = AppState()
    CatalogoView(
        viewModel: CatalogoViewModel(state: state, bookService: MockBookService()),
        state: state
    )
}

#Preview("Error (mock)") {
    let state = AppState()
    CatalogoView(
        viewModel: CatalogoViewModel(
            state: state,
            bookService: MockBookService(error: MockBookServiceError.loadingFailed)
        ),
        state: state
    )
}
