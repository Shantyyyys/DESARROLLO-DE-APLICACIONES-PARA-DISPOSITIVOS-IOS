//
//  AppStateTests.swift
//  BookifyTests
//
//  Pruebas del estado compartido (gestión de favoritos).
//  Estructura: Arrange → Act → Assert.
//

import XCTest
@testable import Bookify

@MainActor
final class AppStateTests: XCTestCase {

    // Caso normal: sin favoritos guardados, ningún libro es favorito
    func testLibroNoEsFavoritoAlIniciar() {
        // Arrange
        let state = AppState(books: [Book.example], favoritesStore: InMemoryFavoritesStore())

        // Act
        let resultado = state.isFavorite(Book.example)

        // Assert
        XCTAssertFalse(resultado, "Un libro no debe ser favorito si no hay favoritos guardados")
    }

    // Caso normal: marcar un libro lo agrega a favoritos
    func testToggleAgregaFavorito() {
        // Arrange
        let state = AppState(books: [Book.example], favoritesStore: InMemoryFavoritesStore())

        // Act
        state.toggleFavorite(Book.example)

        // Assert
        XCTAssertTrue(state.isFavorite(Book.example))
        XCTAssertEqual(state.favorites.count, 1)
    }

    // Caso límite: marcar dos veces el mismo libro lo quita
    func testToggleDosVecesQuitaFavorito() {
        // Arrange
        let state = AppState(books: [Book.example], favoritesStore: InMemoryFavoritesStore())
        state.toggleFavorite(Book.example)

        // Act
        state.toggleFavorite(Book.example)

        // Assert
        XCTAssertFalse(state.isFavorite(Book.example))
        XCTAssertTrue(state.favorites.isEmpty)
    }

    // Marcar un favorito hace un insert en el almacén
    func testToggleHaceInsertEnAlmacen() {
        // Arrange
        let store = InMemoryFavoritesStore()
        let state = AppState(books: [Book.example], favoritesStore: store)

        // Act
        state.toggleFavorite(Book.example)

        // Assert
        XCTAssertTrue(store.ids.contains(Book.example.id), "El favorito debe insertarse en el almacén")
    }

    // Desmarcar un favorito lo borra del almacén
    func testToggleHaceDeleteEnAlmacen() {
        // Arrange
        let store = InMemoryFavoritesStore(initialIDs: [Book.example.id])
        let state = AppState(books: [Book.example], favoritesStore: store)

        // Act
        state.toggleFavorite(Book.example)

        // Assert
        XCTAssertFalse(store.ids.contains(Book.example.id), "El favorito debe borrarse del almacén")
    }

    // Al iniciar, AppState recupera los favoritos guardados
    func testCargaFavoritosGuardados() {
        // Arrange
        let store = InMemoryFavoritesStore(initialIDs: [Book.tregua.id])

        // Act
        let state = AppState(books: Book.samples, favoritesStore: store)

        // Assert
        XCTAssertTrue(state.isFavorite(Book.tregua))
        XCTAssertFalse(state.isFavorite(Book.example))
    }
}