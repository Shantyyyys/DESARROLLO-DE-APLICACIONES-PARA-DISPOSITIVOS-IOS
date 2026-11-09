//
//  CatalogoViewModelTests.swift
//  BookifyTests
//
//  Pruebas de la lógica del catálogo (catálogo, favoritos y búsqueda).
//  Estructura: Arrange → Act → Assert.
//

import XCTest
@testable import Bookify

@MainActor
final class CatalogoViewModelTests: XCTestCase {

    /// Crea un AppState con los libros de ejemplo y sin favoritos.
    private func makeState() -> AppState {
        AppState(books: Book.samples, favoritesStore: InMemoryFavoritesStore())
    }

    // Caso normal: books devuelve todo el catálogo
    func testBooksDevuelveCatalogo() {
        // Arrange
        let viewModel = CatalogoViewModel(state: makeState(), bookService: MockBookService(), searchText: "")

        // Act
        let libros = viewModel.books

        // Assert
        XCTAssertEqual(libros.count, Book.samples.count)
    }

    // Caso normal: favoriteBooks solo incluye los libros marcados
    func testFavoriteBooksFiltra() {
        // Arrange
        let state = makeState()
        state.toggleFavorite(Book.theMiserable)
        let viewModel = CatalogoViewModel(state: state, bookService: MockBookService(), searchText: "")

        // Act
        let favoritos = viewModel.favoriteBooks

        // Assert
        XCTAssertEqual(favoritos, [Book.theMiserable])
    }

    // Caso límite: búsqueda vacía o con solo espacios no regresa resultados
    func testBusquedaVaciaSinResultados() {
        // Arrange
        let viewModel = CatalogoViewModel(state: makeState(), bookService: MockBookService(), searchText: "   ")

        // Act
        let resultados = viewModel.searchResults

        // Assert
        XCTAssertTrue(resultados.isEmpty, "Una búsqueda de solo espacios no debe regresar libros")
    }

    // Caso normal: busca por título sin importar mayúsculas
    func testBuscaPorTitulo() {
        // Arrange
        let viewModel = CatalogoViewModel(state: makeState(), bookService: MockBookService(), searchText: "CIEN años")

        // Act
        let resultados = viewModel.searchResults

        // Assert
        XCTAssertEqual(resultados, [Book.example])
    }

    // Caso normal: busca por autor
    func testBuscaPorAutor() {
        // Arrange
        let viewModel = CatalogoViewModel(state: makeState(), bookService: MockBookService(), searchText: "benedetti")

        // Act
        let resultados = viewModel.searchResults

        // Assert
        XCTAssertEqual(resultados, [Book.tregua])
    }

    // Caso sin resultados: un texto que no coincide regresa una lista vacía
    func testBusquedaSinCoincidencias() {
        // Arrange
        let viewModel = CatalogoViewModel(state: makeState(), bookService: MockBookService(), searchText: "zzzz")

        // Act
        let resultados = viewModel.searchResults

        // Assert
        XCTAssertTrue(resultados.isEmpty)
    }
}

