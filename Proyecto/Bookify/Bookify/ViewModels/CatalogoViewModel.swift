//
//  CatalogoViewModel.swift
//  Bookify
//
//  Coordina la pantalla principal: pide los libros al servicio, administra
//  el estado de la consulta y resuelve la búsqueda local y los favoritos.
//

import Foundation
import Observation

@MainActor
@Observable
final class CatalogoViewModel {

    /// Estados posibles de la consulta. Solo puede haber uno a la vez.
    enum LoadState: Equatable {
        case loading
        case content([Book])
        case empty
        case error(String)
    }

    /// Única fuente de verdad del estado de la consulta. La vista solo lo lee.
    private(set) var loadState: LoadState = .loading

    /// Texto de la barra de búsqueda (filtra los libros ya cargados).
    var searchText: String

    private let state: AppState
    private let bookService: any BookServiceProtocol

    init(state: AppState, bookService: any BookServiceProtocol, searchText: String = "") {
        self.state = state
        self.bookService = bookService
        self.searchText = searchText
    }

    // MARK: - Consulta a la API

    func loadBooks() async {
        loadState = .loading
        do {
            let dtos = try await bookService.fetchBooks()
            let books = dtos.map { Book(from: $0) }
            // Los libros se comparten con AppState para que favoritos y detalle los usen.
            state.books = books
            loadState = books.isEmpty ? .empty : .content(books)
        } catch {
            // No se silencia: se registra y se muestra en la interfaz.
            print("Error al cargar libros: \(error)")
            loadState = .error("No se pudieron cargar los libros. Revisa tu conexión e intenta de nuevo.")
        }
    }

    // MARK: - Catálogo, favoritos y búsqueda local

    var books: [Book] {
        state.books
    }

    var favoriteBooks: [Book] {
        state.books.filter { state.isFavorite($0) }
    }

    var isSearching: Bool {
        !searchText.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var searchResults: [Book] {
        let query = searchText
            .trimmingCharacters(in: .whitespaces)
            .lowercased()

        if query.isEmpty {
            return []
        }

        return state.books.filter { book in
            book.title.lowercased().contains(query) ||
            book.author.lowercased().contains(query)
        }
    }
}
