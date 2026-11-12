//
//  FavoritesView.swift
//  Bookify
//
//  Pestaña Favoritos: los libros guardados en cuadrícula o en lista.
//  Un favorito se quita desde el detalle del libro.
//

import SwiftUI

struct FavoritesView: View {
    /// Estado compartido: favoritos y preferencia de cuadrícula o lista.
    let state: AppState
    /// ViewModel del catálogo; da los libros favoritos y se pasa al detalle.
    let viewModel: CatalogoViewModel

    /// Dos columnas iguales para la cuadrícula.
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header

                    if viewModel.favoriteBooks.isEmpty {
                        Text("No favorites yet. Tap the bookmark on a book to save it.")
                            .font(.subheadline)
                            .foregroundStyle(Color.bookifySecondaryText)
                    } else if state.favoritesLayout == .grid {
                        grid
                    } else {
                        list
                    }
                }
                .padding()
            }
            .background(Color.bookifyBackground.ignoresSafeArea())
            .navigationDestination(for: Book.self) { book in
                BookDetailView(book: book, state: state, viewModel: viewModel)
            }
        }
    }

    // MARK: - Encabezado

    private var header: some View {
        HStack {
            Text("Favorites")
                .font(.system(.largeTitle, design: .serif))
                .foregroundStyle(Color.bookifyText)

            Spacer()

            layoutPicker
        }
    }

    /// Selector lista / cuadrícula con forma de cápsula, como en el diseño.
    private var layoutPicker: some View {
        HStack(spacing: 0) {
            layoutButton(.list, systemImage: "list.bullet", label: "List")
            layoutButton(.grid, systemImage: "square.grid.2x2.fill", label: "Grid")
        }
        .overlay(Capsule().stroke(Color.black.opacity(0.08)))
        .clipShape(Capsule())
    }

    private func layoutButton(_ layout: FavoritesLayout, systemImage: String, label: String) -> some View {
        Button {
            state.favoritesLayout = layout
        } label: {
            Image(systemName: systemImage)
                .foregroundStyle(Color.bookifyText)
                .frame(width: 48, height: 36)
                .background(state.favoritesLayout == layout ? Color.bookifyCoverIcon.opacity(0.35) : Color.clear)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }

    // MARK: - Cuadrícula

    private var grid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(viewModel.favoriteBooks) { book in
                NavigationLink(value: book) {
                    gridCard(book)
                }
                .buttonStyle(.plain)
            }
        }
    }

    /// Tarjeta: portada, título y autor.
    private func gridCard(_ book: Book) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            BookCoverImage(book: book)
                .frame(height: 170)
                .frame(maxWidth: .infinity)

            Text(book.title)
                .font(.system(.headline, design: .serif))
                .foregroundStyle(Color.bookifyText)
                .lineLimit(2)

            Text(book.author)
                .font(.caption)
                .foregroundStyle(Color.bookifySecondaryText)
                .lineLimit(1)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bookifyCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 10, y: 4)
    }

    // MARK: - Lista

    private var list: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(viewModel.favoriteBooks) { book in
                NavigationLink(value: book) {
                    HStack(spacing: 12) {
                        BookCoverImage(book: book)
                            .frame(width: 44, height: 64)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(book.title)
                                .font(.system(.body, design: .serif))
                                .foregroundStyle(Color.bookifyText)
                            Text(book.author)
                                .font(.caption)
                                .foregroundStyle(Color.bookifySecondaryText)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
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
}

#Preview {
    let books = MockBookService.sampleDTOs.map { Book(from: $0) }
    let state = AppState(favoritesStore: InMemoryFavoritesStore(books: books))
    FavoritesView(
        state: state,
        viewModel: CatalogoViewModel(state: state, bookService: MockBookService())
    )
}
