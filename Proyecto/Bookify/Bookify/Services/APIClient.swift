//
//  APIClient.swift
//  Bookify
//
//  Cliente HTTP genérico: hace la petición, valida la respuesta y decodifica el JSON.
//  No sabe nada de libros; el BookService le dice qué tipo quiere recibir.
//

import Foundation

/// Errores posibles al comunicarse con la API.
enum APIError: Error {
    case invalidURL                    // No se pudo construir la URL
    case connectivity(URLError)        // Sin internet, timeout, etc.
    case invalidResponse               // La respuesta no es HTTP
    case httpError(statusCode: Int)    // El servidor respondió fuera de 200...299
    case decodingFailed(Error)         // El JSON no coincide con el DTO
}

protocol APIClientProtocol {
    func get<T: Decodable>(from url: URL) async throws -> T
}

final class APIClient: APIClientProtocol {

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func get<T: Decodable>(from url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // 1. Ejecutar la petición (errores de conectividad)
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch let urlError as URLError {
            throw APIError.connectivity(urlError)
        }

        // 2. Validar que sea una respuesta HTTP
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        // 3. Validar el código de estado
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }

        // 4. Decodificar el JSON al tipo pedido
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }
}
