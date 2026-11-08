//
//  Book.swift
//  Bookify
//
//  Created by Facultad de Contaduría y Administración on 24/09/26.
//

struct Book: Identifiable, Hashable {
    /// Identificador único. Con la API es el `key` del work (ej. "/works/OL274505W").
    let id: String
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

// MARK: - Datos de ejemplo (solo para Previews y pruebas)

extension Book {
    /// Catálogo local para Previews y pruebas. La app real carga los libros de la API.
    static let samples: [Book] = [example, example2, theMiserable, tregua]

    static let example = Book(
        id: "sample-cien-anos",
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

    static let example2 = Book(
        id: "sample-habitos-atomicos",
        title: "Hábitos Atomicos",
        author: "Santiago Mendez Del Valle",
        year: 2026,
        gender: "Crecimiento personal",
        language: "Español",
        pages: 471,
        rating: 5.0,
        audio: true,
        coverUrl: "https://covers.openlibrary.org/b/id/12645114-L.jpg"
    )

    static let theMiserable = Book(
        id: "sample-los-miserables",
        title: "Los Miserables",
        author: "Victor Hugo",
        year: 1862,
        gender: "Novela",
        language: "Español",
        pages: 471,
        rating: 5.0,
        audio: true,
        coverUrl: "https://covers.openlibrary.org/b/id/12645114-L.jpg"
    )

    static let tregua = Book(
        id: "sample-la-tregua",
        title: "La Tregua",
        author: "Mario Benedetti",
        year: 1960,
        gender: "Novela",
        language: "Español",
        pages: 561,
        rating: 5.0,
        audio: true,
        coverUrl: "https://covers.openlibrary.org/b/id/12645114-L.jpg"
    )
}

// MARK: - Conversión desde la API

extension Book {
    /// Convierte el DTO de Open Library al modelo de dominio.
    /// Los campos que la API no trae (género, rating, audio) usan valores por defecto.
    init(from dto: BookDTO) {
        self.id = dto.key
        self.title = dto.title
        self.author = dto.authorNames?.first ?? "Autor desconocido"
        self.year = dto.firstPublishYear ?? 0
        self.gender = "Sin género"
        self.language = Book.languageName(for: dto.languages)
        self.pages = dto.pagesMedian ?? 0
        self.rating = 0
        self.audio = false
        if let coverId = dto.coverId {
            self.coverUrl = "https://covers.openlibrary.org/b/id/\(coverId)-L.jpg"
        } else {
            self.coverUrl = ""
        }
    }

    /// Open Library entrega códigos ISO 639-2 ("spa", "eng"...). Se prioriza español.
    private static func languageName(for codes: [String]?) -> String {
        guard let codes, !codes.isEmpty else { return "Desconocido" }
        if codes.contains("spa") { return "Español" }
        if codes.contains("eng") { return "Inglés" }
        return codes[0].uppercased()
    }
}
