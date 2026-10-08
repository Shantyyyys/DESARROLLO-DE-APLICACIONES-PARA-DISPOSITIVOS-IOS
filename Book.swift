//
//  Book.swift
//  Bookify
//
//  Created by Facultad de Contaduría y Administración on 24/09/26.
//

struct Book {
    let titulo: String
    let autor: String
    let año: Int
    let genero: String
    let idioma: String
    let paginas: Int
    let calificacion: Double
    let audio: Bool
    let portadaUrl: String
}

extension Book {
    static let ejemplo = Book(
        titulo: "Cien años de soledad",
        autor: "Gabriel García Marquez",
        año: 1967,
        genero: "Realismo Mágico",
        idioma: "Español",
        paginas: 471,
        calificacion: 4.0,
        audio: true,
        portadaUrl: "https://covers.openlibrary.org/b/id/12645114-L.jpg"
    )
}


//
//  Book.swift
//  Bookify
//
//  Created by Facultad de Contaduría y Administración on 24/09/26.
//

