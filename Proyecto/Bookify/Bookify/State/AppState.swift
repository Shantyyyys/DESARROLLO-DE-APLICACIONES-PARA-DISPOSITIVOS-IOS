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
        books: [Book]? = nil,
        favoritesStore: FavoritesStore? = nil
    ) {
        let store = favoritesStore ?? InMemoryFavoritesStore()
        self.books = books ?? Book.samples
        self.favoritesStore = store
        //Al abrir la app se recuperan los favoritos guardados
        self.favorites = store.loadFavoriteIDs()
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
