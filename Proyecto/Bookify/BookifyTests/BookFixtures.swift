//
//  BookFixtures.swift
//  BookifyTests
//
//  Libros fijos para las pruebas. La app ya no tiene libros de ejemplo:
//  todo sale de la API; aquí solo sirven para comparar resultados.
//

@testable import Bookify

extension Book {
    /// Catálogo fijo para las pruebas.
    static let samples: [Book] = [example, example2, theMiserable, tregua]

    static let example = Book(
        id: "sample-cien-anos",
        title: "Cien años de soledad",
        author: "Gabriel García Marquez",
        year: 1967,
        category: "Fantasy",
        language: "Spanish",
        pages: 471,
        rating: 4.0,
        coverUrl: "https://covers.openlibrary.org/b/id/12645114-L.jpg",
        firstSentence: "Muchos años después, frente al pelotón de fusilamiento..."
    )

    static let example2 = Book(
        id: "sample-habitos-atomicos",
        title: "Hábitos Atomicos",
        author: "Santiago Mendez Del Valle",
        year: 2026,
        category: BookCategory.uncategorizedTitle,
        language: "Spanish",
        pages: 471,
        rating: 5.0,
        coverUrl: "https://covers.openlibrary.org/b/id/12645114-L.jpg",
        firstSentence: ""
    )

    static let theMiserable = Book(
        id: "sample-los-miserables",
        title: "Los Miserables",
        author: "Victor Hugo",
        year: 1862,
        category: "History",
        language: "Spanish",
        pages: 471,
        rating: 5.0,
        coverUrl: "https://covers.openlibrary.org/b/id/12645114-L.jpg",
        firstSentence: ""
    )

    static let tregua = Book(
        id: "sample-la-tregua",
        title: "La Tregua",
        author: "Mario Benedetti",
        year: 1960,
        category: "Romance",
        language: "Spanish",
        pages: 561,
        rating: 5.0,
        coverUrl: "https://covers.openlibrary.org/b/id/12645114-L.jpg",
        firstSentence: ""
    )
}
