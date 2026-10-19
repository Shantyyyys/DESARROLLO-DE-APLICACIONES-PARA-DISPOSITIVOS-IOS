//
//  Book.swift
//  Bookify
//
//  Created by Facultad de Contaduría y Administración on 24/09/26.
//

struct Book: Identifiable, Hashable {
    var id: String { title }

    let title : String
    let author: String
    let year: Int
    let gender: String
    let language: String
    let pages: Int
    let rating: Double
    let audio: Bool
    let coverUrl: String
}

extension Book {
    static let example = Book(
        title: "Cien años de soledad",
        author: "Gabriel García Marquez",
        year: 1967,
        gender: "Realismo Mágico",
        language: "Español",
        pages: 471,
        rating: 4.0,
        audio: true,
        coverUrl: "https://covers.openlibrary.org/b/id/12645114-L.jpg"
    )
}
