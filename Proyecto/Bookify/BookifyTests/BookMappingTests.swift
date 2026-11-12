//
//  BookMappingTests.swift
//  BookifyTests
//
//  Pruebas de la conversión BookDTO → Book.
//  Estructura: Arrange → Act → Assert.
//

import XCTest
@testable import Bookify

@MainActor
final class BookMappingTests: XCTestCase {

    // Caso normal: los campos del DTO pasan al modelo
    func testInitDesdeDTOCompleto() {
        // Arrange
        let dto = BookDTO(
            key: "/works/OL1W",
            title: "Crónica de una muerte anunciada",
            authorNames: ["Gabriel García Márquez"],
            firstPublishYear: 1981,
            coverId: 123,
            languages: ["eng", "spa"],
            pagesMedian: 120
        )

        // Act
        let book = Book(from: dto)

        // Assert
        XCTAssertEqual(book.id, "/works/OL1W")
        XCTAssertEqual(book.author, "Gabriel García Márquez")
        XCTAssertEqual(book.year, 1981)
        XCTAssertEqual(book.language, "Spanish")
        XCTAssertEqual(book.pages, 120)
        XCTAssertEqual(book.coverUrl, "https://covers.openlibrary.org/b/id/123-L.jpg")
    }

    // Caso límite: el DTO viene sin campos opcionales → valores por defecto
    func testInitDesdeDTOIncompletoUsaValoresPorDefecto() {
        // Arrange
        let dto = BookDTO(
            key: "/works/OL2W",
            title: "Sin datos",
            authorNames: nil,
            firstPublishYear: nil,
            coverId: nil,
            languages: nil,
            pagesMedian: nil
        )

        // Act
        let book = Book(from: dto)

        // Assert
        XCTAssertEqual(book.author, "Unknown author")
        XCTAssertEqual(book.year, 0)
        XCTAssertEqual(book.language, "Unknown")
        XCTAssertEqual(book.pages, 0)
        XCTAssertEqual(book.coverUrl, "")
    }
}
