//
//  BookService.swift
//  Bookify
//
//  Conoce la API de Open Library: arma la URL de cada endpoint y extrae los
//  libros de la respuesta. La comunicación HTTP la delega al APIClient.
//

// FLUJOS (ver Docs/flujos.md): F2 (tendencias y categorías), F3 (búsqueda), F5 (petición a la API), F6 (resumen)

import Foundation

protocol BookServiceProtocol {
    /// Libros en tendencia del día ("Discover more...").
    func fetchTrendingBooks() async throws -> [BookDTO]
    /// Búsqueda libre en toda la API (barra de búsqueda).
    func searchBooks(query: String) async throws -> [BookDTO]
    /// Libros de una categoría de la lista fija.
    func fetchBooks(in category: BookCategory) async throws -> [BookDTO]
    /// Descripción (resumen) de un libro. Puede no existir.
    func fetchSummary(workKey: String) async throws -> String?
}

final class BookService: BookServiceProtocol {

    private let apiClient: APIClientProtocol
    private let baseURL = "https://openlibrary.org"

    /// Campos que se le piden a search.json (los mismos que lee BookDTO).
    private let searchFields = "key,title,author_name,first_publish_year,cover_i,language,number_of_pages_median,subject,first_sentence,ratings_average"

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    /// GET https://openlibrary.org/trending/daily.json?limit=<n>
    /// Tendencias no trae páginas, calificación ni temas: se completan con una
    /// búsqueda por sus claves en search.json (q=key:("/works/A" OR "/works/B" ...)).
    func fetchTrendingBooks() async throws -> [BookDTO] {
        // [F2.4a] Se piden los 20 libros en tendencia del día.
        let url = try makeURL(path: "/trending/daily.json", queryItems: [
            URLQueryItem(name: "limit", value: "20")
        ])
        let response: TrendingResponseDTO = try await apiClient.get(from: url)
        let trending = response.works
        guard !trending.isEmpty else { return [] }

        // [F2.4b] Se vuelven a pedir esos mismos libros a search.json, en UNA sola
        // consulta, para tener páginas, calificación y temas (subject → categoría).
        let keys = trending.map { "\"\($0.key)\"" }.joined(separator: " OR ")
        do {
            let complete = try await search(q: "key:(\(keys))", limit: trending.count)
            // [F2.4c] Se respeta el orden de tendencias; si un libro no vino en la búsqueda, se deja como estaba.
            return trending.map { work in
                complete.first { $0.key == work.key } ?? work
            }
        } catch {
            // [F2.4d] Si la búsqueda falla, se muestran las tendencias aunque les falten datos.
            print("No se pudieron completar las tendencias: \(error)")
            return trending
        }
    }

    /// GET https://openlibrary.org/search.json?q=<texto>&limit=20&fields=...
    // [F3.5] Búsqueda escrita: q=<texto>.
    func searchBooks(query: String) async throws -> [BookDTO] {
        try await search(q: query, limit: 20)
    }

    /// GET https://openlibrary.org/search.json?q=subject:"<categoría>"&limit=15&fields=...
    // [F2.9] Carrusel de categoría: q=subject:"<categoría>".
    func fetchBooks(in category: BookCategory) async throws -> [BookDTO] {
        try await search(q: "subject:\"\(category.searchTerm)\"", limit: 15)
    }

    /// GET https://openlibrary.org/works/{id}.json → campo "description".
    // [F6.5] Descripción del libro en /works/{id}.json (puede no existir).
    func fetchSummary(workKey: String) async throws -> String? {
        // workKey ya trae el prefijo, ej. "/works/OL45804W"
        let url = try makeURL(path: "\(workKey).json", queryItems: [])
        let work: WorkDTO = try await apiClient.get(from: url)
        return work.description?.value
    }

    // MARK: - Ayudantes

    /// Búsqueda compartida por la barra de búsqueda y las categorías.
    // [F5.1] Arma la URL de search.json con los campos que lee BookDTO y llama al APIClient.
    private func search(q: String, limit: Int) async throws -> [BookDTO] {
        let url = try makeURL(path: "/search.json", queryItems: [
            URLQueryItem(name: "q", value: q),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "fields", value: searchFields)
        ])
        let response: BookSearchResponseDTO = try await apiClient.get(from: url)
        return response.docs
    }

    private func makeURL(path: String, queryItems: [URLQueryItem]) throws -> URL {
        var components = URLComponents(string: baseURL + path)
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        return url
    }
}

// MARK: - Mock para Previews y pruebas

enum MockBookServiceError: Error {
    case loadingFailed
}

/// Servicio falso: no usa internet. Devuelve los libros indicados o lanza el error indicado.
struct MockBookService: BookServiceProtocol {

    var booksToReturn: [BookDTO] = MockBookService.sampleDTOs
    var summaryToReturn: String? = "A sample summary for previews."
    var error: Error? = nil

    func fetchTrendingBooks() async throws -> [BookDTO] {
        try result()
    }

    func searchBooks(query: String) async throws -> [BookDTO] {
        try result()
    }

    func fetchBooks(in category: BookCategory) async throws -> [BookDTO] {
        try result()
    }

    func fetchSummary(workKey: String) async throws -> String? {
        if let error {
            throw error
        }
        return summaryToReturn
    }

    private func result() throws -> [BookDTO] {
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
            pagesMedian: 471,
            subjects: ["Fantasy fiction"],
            ratingsAverage: 4.2
        ),
        BookDTO(
            key: "/works/mock-2",
            title: "El amor en los tiempos del cólera",
            authorNames: ["Gabriel García Márquez"],
            firstPublishYear: 1985,
            coverId: nil,
            languages: ["spa"],
            pagesMedian: 368,
            subjects: ["Love stories"],
            ratingsAverage: 4.0
        )
    ]
}
