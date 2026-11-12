//
//  AppState.swift
//  Bookify
//
//  Única fuente de verdad compartida por todas las pantallas.
//

import Observation

/// Cómo se muestran los favoritos (se cambia desde la pestaña Favoritos).
enum FavoritesLayout {
    case grid
    case list
}

@MainActor
@Observable
final class AppState {
    var books: [Book]
    private(set) var favorites: Set<String>
    /// Preferencia de la vista de Favoritos: cuadrícula o lista.
    var favoritesLayout: FavoritesLayout = .grid

    /// Máximo de libros que se pueden guardar como favoritos.
    static let maxFavorites = 10

    private let favoritesStore: FavoritesStore

    init(
        books: [Book] = [],
        favoritesStore: FavoritesStore? = nil
    ) {
        let store = favoritesStore ?? InMemoryFavoritesStore()
        self.books = books
        self.favoritesStore = store
        //Al abrir la app se recuperan los favoritos guardados
        self.favorites = store.loadFavoriteIDs()
        // Sus datos se agregan a los libros para que Favoritos se vea completo
        // aunque esos libros ya no vengan en tendencias ni en las categorías.
        let knownIDs = Set(self.books.map { $0.id })
        self.books += store.loadFavoriteBooks().filter { !knownIDs.contains($0.id) }
    }

    func isFavorite(_ book: Book) -> Bool {
        favorites.contains(book.id)
    }

    /// Marca o desmarca un favorito. Regresa false si no se pudo agregar
    /// porque ya se llegó al límite (la vista muestra el aviso).
    @discardableResult
    func toggleFavorite(_ book: Book) -> Bool {
        if favorites.contains(book.id) {
            favorites.remove(book.id)
            favoritesStore.delete(bookId: book.id)
        } else {
            guard favorites.count < AppState.maxFavorites else { return false }
            favorites.insert(book.id)
            favoritesStore.insert(book: book)
        }
        return true
    }
}
