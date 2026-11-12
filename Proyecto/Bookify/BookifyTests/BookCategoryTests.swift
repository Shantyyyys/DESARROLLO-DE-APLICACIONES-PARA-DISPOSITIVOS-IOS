//
//  BookCategoryTests.swift
//  BookifyTests
//
//  Pruebas de la asignación de categoría y de los textos de Open Library.
//  Estructura: Arrange → Act → Assert.
//

import XCTest
@testable import Bookify

@MainActor
final class BookCategoryTests: XCTestCase {

    private func makeDTO(subjects: [String]?) -> BookDTO {
        BookDTO(
            key: "/works/OL1W",
            title: "Libro",
            authorNames: nil,
            firstPublishYear: nil,
            coverId: nil,
            languages: nil,
            pagesMedian: nil,
            subjects: subjects
        )
    }

    // Caso normal: un subject de la lista asigna la categoría
    func testSubjectAsignaCategoria() {
        // Arrange
        let dto = makeDTO(subjects: ["Fiction", "Fantasy fiction"])

        // Act
        let book = Book(from: dto)

        // Assert
        XCTAssertEqual(book.category, "Fantasy")
    }

    // Caso sin resultados: ningún subject coincide → "Uncategorized"
    func testSinCoincidenciaEsUncategorized() {
        // Arrange
        let dto = makeDTO(subjects: ["Cooking"])

        // Act
        let book = Book(from: dto)

        // Assert
        XCTAssertEqual(book.category, BookCategory.uncategorizedTitle)
    }

    // Caso límite: sin subjects → "Uncategorized"
    func testSinSubjectsEsUncategorized() {
        // Arrange
        let dto = makeDTO(subjects: nil)

        // Act
        let book = Book(from: dto)

        // Assert
        XCTAssertEqual(book.category, BookCategory.uncategorizedTitle)
    }

    // Si el libro viene de un carrusel de categoría, se respeta esa categoría
    func testCategoriaExplicitaTienePrioridad() {
        // Arrange
        let dto = makeDTO(subjects: ["Love stories"])

        // Act
        let book = Book(from: dto, category: .horror)

        // Assert
        XCTAssertEqual(book.category, "Horror")
    }

    // OpenLibraryText acepta texto, lista de textos y objeto con "value"
    func testOpenLibraryTextAceptaLosTresFormatos() throws {
        // Arrange
        let formatos = [
            #""Hola""#,
            #"["Hola", "Adiós"]"#,
            #"{"type": "/type/text", "value": "Hola"}"#
        ]

        for json in formatos {
            // Act
            let texto = try JSONDecoder().decode(OpenLibraryText.self, from: Data(json.utf8))

            // Assert
            XCTAssertEqual(texto.value, "Hola", "Falló con: \(json)")
        }
    }
}
