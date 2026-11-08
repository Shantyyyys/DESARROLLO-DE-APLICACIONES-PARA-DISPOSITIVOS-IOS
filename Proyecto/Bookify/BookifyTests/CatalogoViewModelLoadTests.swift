//
//  CatalogoViewModelLoadTests.swift
//  BookifyTests
//
//  Pruebas de la integración con la API usando MockBookService (sin internet).
//  Escenarios: éxito, error y sin resultados.
//  Estructura: Arrange → Act → Assert.
//

import XCTest
@testable import Bookify

@MainActor
final class CatalogoViewModelLoadTests: XCTestCase {

    private func makeState() -> AppState {
        AppState(books: [], favoritesStore: InMemoryFavoritesStore())
    }

    // Estado inicial: antes de consultar, la pantalla está cargando
    func testEstadoInicialEsLoading() {
        // Arrange
        let viewModel = CatalogoViewModel(state: makeState(), bookService: MockBookService())

        // Act
        let estado = viewModel.loadState

        // Assert
        XCTAssertEqual(estado, .loading)
    }

    // Éxito: el servicio devuelve libros → estado content con esos libros
    func testLoadBooksExitosoMuestraContenido() async {
        // Arrange
        let state = makeState()
        let mock = MockBookService(booksToReturn: MockBookService.sampleDTOs)
        let viewModel = CatalogoViewModel(state: state, bookService: mock)
        let esperados = MockBookService.sampleDTOs.map { Book(from: $0) }

        // Act
        await viewModel.loadBooks()

        // Assert
        XCTAssertEqual(viewModel.loadState, .content(esperados))
        XCTAssertEqual(state.books, esperados, "Los libros deben compartirse con AppState")
    }

    // Error: el servicio falla → estado error con mensaje
    func testLoadBooksConErrorMuestraError() async {
        // Arrange
        let mock = MockBookService(error: MockBookServiceError.loadingFailed)
        let viewModel = CatalogoViewModel(state: makeState(), bookService: mock)

        // Act
        await viewModel.loadBooks()

        // Assert
        guard case .error(let mensaje) = viewModel.loadState else {
            return XCTFail("Se esperaba estado error, se obtuvo \(viewModel.loadState)")
        }
        XCTAssertFalse(mensaje.isEmpty)
    }

    // Error HTTP: el servidor responde fuera de 200...299 → estado error
    func testLoadBooksConErrorHTTPMuestraError() async {
        // Arrange
        let mock = MockBookService(error: APIError.httpError(statusCode: 500))
        let viewModel = CatalogoViewModel(state: makeState(), bookService: mock)

        // Act
        await viewModel.loadBooks()

        // Assert
        guard case .error = viewModel.loadState else {
            return XCTFail("Un status 500 debe mostrarse como error")
        }
    }

    // Sin resultados: el servicio responde bien pero sin libros → estado empty
    func testLoadBooksSinResultadosMuestraEmpty() async {
        // Arrange
        let mock = MockBookService(booksToReturn: [])
        let viewModel = CatalogoViewModel(state: makeState(), bookService: mock)

        // Act
        await viewModel.loadBooks()

        // Assert
        XCTAssertEqual(viewModel.loadState, .empty)
    }

    // Reintentar: el mismo ViewModel falla primero y al reintentar muestra contenido
    func testReintentarDespuesDeErrorMuestraContenido() async {
        // Arrange
        let servicio = SecuenciaBookService(resultados: [
            .failure(MockBookServiceError.loadingFailed),
            .success(MockBookService.sampleDTOs)
        ])
        let viewModel = CatalogoViewModel(state: makeState(), bookService: servicio)
        await viewModel.loadBooks()
        guard case .error = viewModel.loadState else { return XCTFail("Primero debe fallar") }

        // Act: lo mismo que hace el botón Reintentar
        await viewModel.loadBooks()

        // Assert
        guard case .content = viewModel.loadState else {
            return XCTFail("Al reintentar debe mostrar contenido")
        }
    }
}

/// Servicio de prueba que devuelve un resultado distinto en cada llamada.
private final class SecuenciaBookService: BookServiceProtocol {
    private var resultados: [Result<[BookDTO], Error>]

    init(resultados: [Result<[BookDTO], Error>]) {
        self.resultados = resultados
    }

    func fetchBooks() async throws -> [BookDTO] {
        try resultados.removeFirst().get()
    }
}
