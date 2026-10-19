import Observation

@Observable
final class AppState {
    var books: [Book] = [Book.example]
    var favorites: Set<String> = []

    func isFavorite(_ book: Book) -> Bool {
        favorites.contains(book.id)
    }

    func toggleFavorite(_ book: Book) {
        if favorites.contains(book.id) {
            favorites.remove(book.id)
        } else {
            favorites.insert(book.id)
        }
    }
}