

struct CatalogoViewModel {
    let state: AppState

    var books: [Book] {
        state.books
    }

    var favoriteBooks: [Book] {
        state.books.filter { state.isFavorite($0) }
    }
}