//
//  FavoritesStore.swift
//  Bookify
//
//  Created by Facultad de Contaduría y Administración on 05/11/26.
//  Contrato para guardar favoritos. AppState depende de este protocolo,
//  no de SwiftData directamente (principio de inversión de dependencias).
//

@MainActor
protocol FavoritesStore {
    func loadFavoriteIDs() -> Set<String>
    /// Libros guardados, para mostrar Favoritos sin volver a consultar la API.
    func loadFavoriteBooks() -> [Book]
    func insert(book: Book)
    func delete(bookId: String)
}

/// Implementación en memoria: no guarda nada en disco.
/// Se usa en los #Preview y en las pruebas unitarias.
@MainActor
final class InMemoryFavoritesStore: FavoritesStore {
    private(set) var ids: Set<String>
    private(set) var books: [Book]

    init(initialIDs: Set<String> = [], books: [Book] = []) {
        self.ids = initialIDs.union(books.map { $0.id })
        self.books = books
    }

    func loadFavoriteIDs() -> Set<String> {
        ids
    }

    func loadFavoriteBooks() -> [Book] {
        books
    }

    func insert(book: Book) {
        guard !ids.contains(book.id) else { return }
        ids.insert(book.id)
        books.append(book)
    }

    func delete(bookId: String) {
        ids.remove(bookId)
        books.removeAll { $0.id == bookId }
    }
}
