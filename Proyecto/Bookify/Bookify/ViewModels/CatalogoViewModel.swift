//
//  CatalogoViewModel.swift
//  Bookify
//
//  Coordina la pantalla principal: pide los libros al servicio, administra
//  el estado de cada sección (tendencias, categorías y búsqueda) y los favoritos.
//

import Foundation
import Observation

@MainActor
@Observable
final class CatalogoViewModel {

    /// Estados posibles de una consulta. Solo puede haber uno a la vez.
    enum LoadState: Equatable {
        case loading
        case content([Book])
        case empty
        case error(String)
    }

    /// Estado de "Discover more" (tendencias). La vista solo lo lee.
    private(set) var loadState: LoadState = .loading

    /// Estado del carrusel de cada categoría. Si no hay valor, todavía está cargando.
    private(set) var categoryStates: [BookCategory: LoadState] = [:]

    /// Estado de la búsqueda en la API. Está vacío hasta que el usuario escribe.
    private(set) var searchState: LoadState = .empty

    /// Texto de la barra de búsqueda. La vista lo usa como id de `.task(id:)`.
    var searchText: String

    /// Lista fija de categorías (menú de hamburguesa y carruseles).
    let categories = BookCategory.allCases

    private let state: AppState
    private let bookService: any BookServiceProtocol

    init(state: AppState, bookService: any BookServiceProtocol, searchText: String = "") {
        self.state = state
        self.bookService = bookService
        self.searchText = searchText
    }

    // MARK: - Carga inicial

    /// Carga el catálogo. Al regresar a la pestaña Inicio solo pide lo que falta.
    func loadCatalog() async {
        switch loadState {
        case .content:
            break
        default:
            await loadBooks()
        }
        await loadCategories()
    }

    // MARK: - Discover more (tendencias)

    func loadBooks() async {
        loadState = .loading
        do {
            let dtos = try await bookService.fetchTrendingBooks()
            let books = dtos.map { Book(from: $0) }
            // Los libros se comparten con AppState para que favoritos y detalle los usen.
            remember(books)
            loadState = books.isEmpty ? .empty : .content(books)
        } catch {
            // Se canceló porque el usuario cambió de pestaña: se reintenta al volver.
            if Task.isCancelled { return }
            // No se silencia: se registra y se muestra en la interfaz.
            print("Error al cargar libros: \(error)")
            loadState = .error("Couldn't load books. Check your connection and try again.")
        }
    }

    // MARK: - Categorías

    /// Estado del carrusel de una categoría (cargando si aún no se pide).
    func state(for category: BookCategory) -> LoadState {
        categoryStates[category] ?? .loading
    }

    /// Carga los carruseles uno por uno, en el orden de la lista.
    /// Los que ya tienen libros no se vuelven a pedir.
    func loadCategories() async {
        for category in categories {
            if case .content = state(for: category) { continue }
            await loadBooks(in: category)
        }
    }

    /// Carga (o reintenta) el carrusel de una categoría.
    func loadBooks(in category: BookCategory) async {
        categoryStates[category] = .loading
        do {
            let dtos = try await bookService.fetchBooks(in: category)
            // El libro viene de un carrusel de categoría: se usa esa categoría.
            let books = dtos.map { Book(from: $0, category: category) }
            remember(books)
            categoryStates[category] = books.isEmpty ? .empty : .content(books)
        } catch {
            if Task.isCancelled { return }
            print("Error al cargar \(category.title): \(error)")
            categoryStates[category] = .error("Couldn't load \(category.title) books.")
        }
    }

    // MARK: - Búsqueda en toda la API

    var isSearching: Bool {
        !searchText.trimmingCharacters(in: .whitespaces).isEmpty
    }

    /// Libros encontrados (vacío mientras carga, si no hay resultados o si falla).
    var searchResults: [Book] {
        if case .content(let books) = searchState {
            return books
        }
        return []
    }

    /// La vista la llama con `.task(id: searchText)`: cada vez que cambia el texto,
    /// SwiftUI cancela la búsqueda anterior y arranca una nueva.
    func searchBooks() async {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else {
            searchState = .empty
            return
        }
        searchState = .loading

        // Espera a que el usuario deje de escribir; si escribe otra letra, se cancela aquí.
        do {
            try await Task.sleep(for: .milliseconds(500))
        } catch {
            return
        }

        do {
            let dtos = try await bookService.searchBooks(query: query)
            // Si el texto cambió mientras llegaba la respuesta, se descarta.
            guard !Task.isCancelled else { return }
            let books = dtos.map { Book(from: $0) }
            remember(books)
            searchState = books.isEmpty ? .empty : .content(books)
        } catch {
            // Cancelada porque el usuario siguió escribiendo: no es un error.
            if Task.isCancelled { return }
            print("Error al buscar \"\(query)\": \(error)")
            searchState = .error("Couldn't search. Check your connection and try again.")
        }
    }

    // MARK: - Resumen (detalle)

    /// Texto que se muestra cuando el libro no tiene descripción ni primera frase.
    static let noSummaryText = "No summary available"

    /// Resumen del detalle: descripción del work → primera frase → aviso.
    func loadSummary(for book: Book) async -> String {
        // Solo los libros de la API tienen un work que consultar (ej. "/works/OL45804W").
        if book.id.hasPrefix("/works/") {
            do {
                if let description = try await bookService.fetchSummary(workKey: book.id),
                   !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    return description
                }
            } catch {
                // Si falla, se registra y se usa el respaldo para no dejar el detalle vacío.
                print("Error al cargar el resumen de \(book.title): \(error)")
            }
        }
        return book.firstSentence.isEmpty ? Self.noSummaryText : book.firstSentence
    }

    // MARK: - Catálogo y favoritos

    var books: [Book] {
        state.books
    }

    var favoriteBooks: [Book] {
        state.books.filter { state.isFavorite($0) }
    }

    // MARK: - Ayudantes

    /// Agrega a AppState los libros que aún no tiene, para que favoritos y
    /// detalle los encuentren sin importar de qué sección vinieron.
    private func remember(_ newBooks: [Book]) {
        let knownIDs = Set(state.books.map { $0.id })
        let unknown = newBooks.filter { !knownIDs.contains($0.id) }
        state.books.append(contentsOf: unknown)
    }
}
