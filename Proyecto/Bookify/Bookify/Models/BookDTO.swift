//
//  BookDTO.swift
//  Bookify
//

import Foundation

/// Respuesta completa de https://openlibrary.org/search.json
struct BookSearchResponseDTO: Decodable {
    let docs: [BookDTO]
}

/// Respuesta de https://openlibrary.org/trending/daily.json
struct TrendingResponseDTO: Decodable {
    let works: [BookDTO]
}

/// Respuesta de https://openlibrary.org/works/{id}.json (solo lo que usa la app).
struct WorkDTO: Decodable {
    let description: OpenLibraryText?
}

/// Un libro (work) dentro de "docs", tal como lo entrega Open Library.
struct BookDTO: Decodable {
    let key: String
    let title: String
    let authorNames: [String]?
    let firstPublishYear: Int?
    let coverId: Int?
    let languages: [String]?
    let pagesMedian: Int?
    /// Etiquetas de tema; se usan para asignar la categoría.
    var subjects: [String]? = nil
    /// Primera frase del libro; es el respaldo del resumen.
    var firstSentence: OpenLibraryText? = nil
    /// Calificación promedio de los usuarios de Open Library.
    var ratingsAverage: Double? = nil

    enum CodingKeys: String, CodingKey {
        case key
        case title
        case authorNames = "author_name"
        case firstPublishYear = "first_publish_year"
        case coverId = "cover_i"
        case languages = "language"
        case pagesMedian = "number_of_pages_median"
        case subjects = "subject"
        case firstSentence = "first_sentence"
        case ratingsAverage = "ratings_average"
    }
}

/// Open Library entrega algunos textos en formatos distintos:
/// "texto", ["texto"] o {"type": "/type/text", "value": "texto"}.
/// Este tipo acepta los tres y se queda solo con el texto.
struct OpenLibraryText: Decodable {
    let value: String

    private struct TextObject: Decodable {
        let value: String
    }

    init(value: String) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let text = try? container.decode(String.self) {
            value = text
        } else if let texts = try? container.decode([String].self), let first = texts.first {
            value = first
        } else {
            // Si tampoco es un objeto con "value", el error sí se propaga.
            value = try container.decode(TextObject.self).value
        }
    }
}
