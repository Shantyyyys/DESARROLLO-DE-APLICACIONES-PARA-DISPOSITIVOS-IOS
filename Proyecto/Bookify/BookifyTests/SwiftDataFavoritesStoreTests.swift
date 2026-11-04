//
//  SwiftDataFavoritesStoreTests.swift
//  BookifyTests
//
//  Pruebas del guardado de favoritos con SwiftData.
//  Cada prueba crea su propio contenedor en memoria: no toca los datos
//  reales del dispositivo y siempre empieza con una base de datos vacía.
//  Estructura: Arrange → Act → Assert.
//

import XCTest
import SwiftData
@testable import Bookify

@MainActor
final class SwiftDataFavoritesStoreTests: XCTestCase {

    /// Crea un almacén nuevo con una base de datos en memoria.
    /// Regresa también el contenedor para que no se libere durante la prueba.
    private func makeStore() throws -> (container: ModelContainer, store: SwiftDataFavoritesStore) {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: FavoriteBook.self, configurations: config)
        let store = SwiftDataFavoritesStore(context: container.mainContext)
        return (container, store)
    }

    /// Cuenta los registros FavoriteBook guardados (detecta duplicados).
    private func numeroDeRegistros(en container: ModelContainer) throws -> Int {
        try container.mainContext.fetchCount(FetchDescriptor<FavoriteBook>())
    }

    // Caso sin resultados: un almacén nuevo no tiene favoritos
    func testAlmacenNuevoVacio() throws {
        // Arrange
        let sut = try makeStore()

        // Act
        let ids = sut.store.loadFavoriteIDs()

        // Assert
        XCTAssertTrue(ids.isEmpty)
    }

    // Caso normal: insert guarda el favorito y se puede volver a leer
    func testInsertGuardaFavorito() throws {
        // Arrange
        let sut = try makeStore()
        let bookId = Book.example.id

        // Act
        sut.store.insert(bookId: bookId)

        // Assert
        XCTAssertEqual(sut.store.loadFavoriteIDs(), [bookId])
    }

    // Caso normal: delete borra solo el favorito indicado
    func testDeleteBorraFavorito() throws {
        // Arrange
        let sut = try makeStore()
        sut.store.insert(bookId: Book.example.id)
        sut.store.insert(bookId: Book.tregua.id)

        // Act
        sut.store.delete(bookId: Book.example.id)

        // Assert
        XCTAssertEqual(sut.store.loadFavoriteIDs(), [Book.tregua.id])
    }

    // Caso límite: insertar el mismo libro dos veces guarda un solo registro
    func testInsertDuplicadoNoSeGuardaDosVeces() throws {
        // Arrange
        let sut = try makeStore()
        sut.store.insert(bookId: Book.example.id)

        // Act
        sut.store.insert(bookId: Book.example.id)

        // Assert
        XCTAssertEqual(try numeroDeRegistros(en: sut.container), 1,
                       "Un libro no debe guardarse dos veces")
    }

    // Entrada inválida: borrar un id que no existe no afecta a los demás
    func testDeleteDeIdInexistenteNoBorraOtros() throws {
        // Arrange
        let sut = try makeStore()
        sut.store.insert(bookId: Book.tregua.id)

        // Act
        sut.store.delete(bookId: "id-que-no-existe")

        // Assert
        XCTAssertEqual(sut.store.loadFavoriteIDs(), [Book.tregua.id])
    }
}