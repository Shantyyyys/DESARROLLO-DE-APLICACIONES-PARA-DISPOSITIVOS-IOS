//
//  Book.swift
//  Bookify
//
//  Created by Facultad de Contaduría y Administración on 24/09/26.
//
// FLUJOS (ver Docs/flujos.md): F5 (conversión DTO → Book)

struct Book: Identifiable, Hashable {
    /// Identificador único. Con la API es el `key` del work (ej. "/works/OL274505W").
    let id: String
    let title : String
    let author: String
    let year: Int
    /// Nombre de la categoría (de la lista fija) o "Uncategorized".
    let category: String
    let language: String
    let pages: Int
    let rating: Double
    let coverUrl: String
    /// Primera frase del libro; se muestra si el libro no tiene descripción.
    let firstSentence: String
}

// MARK: - Conversión desde la API

extension Book {
    /// Convierte el DTO de Open Library al modelo de dominio.
    /// - Parameter category: si el libro se pidió desde una categoría, se usa esa;
    ///   si no, se busca la primera que coincida con sus `subjects`.
    // [F5.7] Convierte el DTO (datos de la API, opcionales) en Book (datos listos para mostrar).
    init(from dto: BookDTO, category: BookCategory? = nil) {
        self.id = dto.key
        self.title = dto.title
        self.author = dto.authorNames?.first ?? "Unknown author"
        self.year = dto.firstPublishYear ?? 0
        let matched = category ?? BookCategory.matching(subjects: dto.subjects)
        self.category = matched?.title ?? BookCategory.uncategorizedTitle
        self.language = Book.languageName(for: dto.languages)
        self.pages = dto.pagesMedian ?? 0
        self.rating = dto.ratingsAverage ?? 0
        if let coverId = dto.coverId {
            self.coverUrl = "https://covers.openlibrary.org/b/id/\(coverId)-L.jpg"
        } else {
            self.coverUrl = ""
        }
        self.firstSentence = dto.firstSentence?.value ?? ""
    }

    /// Open Library entrega códigos ISO 639-2 ("spa", "eng"...). Se prioriza español.
    private static func languageName(for codes: [String]?) -> String {
        guard let codes, !codes.isEmpty else { return "Unknown" }
        if codes.contains("spa") { return "Spanish" }
        if codes.contains("eng") { return "English" }
        return codes[0].uppercased()
    }
}
