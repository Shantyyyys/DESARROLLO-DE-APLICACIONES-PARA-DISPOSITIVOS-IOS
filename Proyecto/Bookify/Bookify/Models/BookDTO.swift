//
//  BookDTO.swift
//  Bookify
//

import Foundation

/// Respuesta completa de https://openlibrary.org/search.json
struct BookSearchResponseDTO: Decodable {
    let docs: [BookDTO]
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

    enum CodingKeys: String, CodingKey {
        case key
        case title
        case authorNames = "author_name"
        case firstPublishYear = "first_publish_year"
        case coverId = "cover_i"
        case languages = "language"
        case pagesMedian = "number_of_pages_median"
    }
}
