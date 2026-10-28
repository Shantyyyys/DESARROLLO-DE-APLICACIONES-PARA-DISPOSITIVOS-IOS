import Foundation

struct CatalogoViewModel {
    let state: AppState
    let searchText: String

    var books: [Book] {
        state.books
    }

    var favoriteBooks: [Book] {
        state.books.filter { state.isFavorite($0) }
    }

    var searchResults: [Book] {
        let query = searchText
            .trimmingCharacters(in: .whitespaces)
            .lowercased()

        if query.isEmpty {
            return []
        }

        return state.books.filter { book in
            book.title.lowercased().contains(query) ||
            book.author.lowercased().contains(query)
        }
    }
}
