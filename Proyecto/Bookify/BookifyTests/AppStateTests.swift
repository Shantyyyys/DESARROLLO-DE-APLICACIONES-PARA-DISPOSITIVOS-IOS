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

    // Límite: con 10 favoritos no se puede agregar el 11.º
    func testNoAgregaFavoritoConLimiteLleno() {
        // Arrange
        let ids = Set((1...AppState.maxFavorites).map { "fav-\($0)" })
        let state = AppState(books: [Book.example], favoritesStore: InMemoryFavoritesStore(initialIDs: ids))

        // Act
        let agregado = state.toggleFavorite(Book.example)

        // Assert
        XCTAssertFalse(agregado)
        XCTAssertFalse(state.isFavorite(Book.example))
        XCTAssertEqual(state.favorites.count, AppState.maxFavorites)
    }

    // Límite: con 10 favoritos sí se puede quitar uno
    func testQuitaFavoritoConLimiteLleno() {
        // Arrange
        var ids = Set((1...(AppState.maxFavorites - 1)).map { "fav-\($0)" })
        ids.insert(Book.example.id)
        let state = AppState(books: [Book.example], favoritesStore: InMemoryFavoritesStore(initialIDs: ids))

        // Act
        let cambiado = state.toggleFavorite(Book.example)

        // Assert
        XCTAssertTrue(cambiado)
        XCTAssertFalse(state.isFavorite(Book.example))
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

    // Al reabrir la app, los favoritos guardados se ven aunque no vengan de la API
    func testRecuperaLibrosFavoritosGuardados() {
        // Arrange
        let store = InMemoryFavoritesStore(books: [Book.tregua])

        // Act
        let state = AppState(books: [], favoritesStore: store)

        // Assert
        XCTAssertEqual(state.books, [Book.tregua])
        XCTAssertTrue(state.isFavorite(Book.tregua))
    }

    // Marcar un favorito guarda también los datos del libro
    func testToggleGuardaDatosDelLibro() {
        // Arrange
        let store = InMemoryFavoritesStore()
        let state = AppState(books: [Book.example], favoritesStore: store)

        // Act
        state.toggleFavorite(Book.example)

        // Assert
        XCTAssertEqual(store.books, [Book.example])
    }
}
