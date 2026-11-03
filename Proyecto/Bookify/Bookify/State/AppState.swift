//
//  AppState.swift
//  Bookify
//
//  Única fuente de verdad compartida por todas las pantallas.
//

import Observation

@MainActor
@Observable
final class AppState {
    var books: [Book]
    private(set) var favorites: Set<String>

    private let favoritesStore: FavoritesStore

    init(
        books: [Book] = Book.samples,
        favoritesStore: FavoritesStore = InMemoryFavoritesStore()
    ) {
        self.books = books
        self.favoritesStore = favoritesStore
        // Al abrir la app se recuperan los favoritos guardados.
        self.favorites = favoritesStore.loadFavoriteIDs()
    }

    func isFavorite(_ book: Book) -> Bool {
        favorites.contains(book.id)
    }

    func toggleFavorite(_ book: Book) {
        if favorites.contains(book.id) {
            favorites.remove(book.id)
            favoritesStore.delete(bookId: book.id)
        } else {
            favorites.insert(book.id)
            favoritesStore.insert(bookId: book.id)
        }
    }
}
