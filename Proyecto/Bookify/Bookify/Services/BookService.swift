//
//  BookService.swift
//  Bookify
//
//  Conoce la API de Open Library: arma la URL del endpoint y extrae los libros
//  de la respuesta. La comunicación HTTP la delega al APIClient.
//

import Foundation

protocol BookServiceProtocol {
    func fetchBooks() async throws -> [BookDTO]
}

final class BookService: BookServiceProtocol {

    private let apiClient: APIClientProtocol
    private let searchTerm: String
    private let limit: Int

    init(
        apiClient: APIClientProtocol = APIClient(),
        searchTerm: String = "gabriel garcia marquez",
        limit: Int = 20
    ) {
        self.apiClient = apiClient
        self.searchTerm = searchTerm
        self.limit = limit
    }

    /// GET https://openlibrary.org/search.json?q=<término>&limit=<n>&fields=...
    func fetchBooks() async throws -> [BookDTO] {
        var components = URLComponents(string: "https://openlibrary.org/search.json")
        components?.queryItems = [
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(
                name: "fields",
                value: "key,title,author_name,first_publish_year,cover_i,language,number_of_pages_median"
            )
        ]

        guard let url = components?.url else {
            throw APIError.invalidURL
        }

        let response: BookSearchResponseDTO = try await apiClient.get(from: url)
        return response.docs
    }
}

// MARK: - Mock para Previews y pruebas

enum MockBookServiceError: Error {
    case loadingFailed
}

/// Servicio falso: no usa internet. Devuelve los libros indicados o lanza el error indicado.
struct MockBookService: BookServiceProtocol {

    var booksToReturn: [BookDTO] = MockBookService.sampleDTOs
    var error: Error? = nil

    func fetchBooks() async throws -> [BookDTO] {
        if let error {
            throw error
        }
        return booksToReturn
    }

    static let sampleDTOs: [BookDTO] = [
        BookDTO(
            key: "/works/mock-1",
            title: "Cien años de soledad",
            authorNames: ["Gabriel García Márquez"],
            firstPublishYear: 1967,
            coverId: nil,
            languages: ["spa"],
            pagesMedian: 471
        ),
        BookDTO(
            key: "/works/mock-2",
            title: "El amor en los tiempos del cólera",
            authorNames: ["Gabriel García Márquez"],
            firstPublishYear: 1985,
            coverId: nil,
            languages: ["spa"],
            pagesMedian: 368
        )
    ]
}
