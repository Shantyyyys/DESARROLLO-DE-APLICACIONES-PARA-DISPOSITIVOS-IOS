import Observation

@Observable
final class AppState {
    var libros: [Book] = [Book.ejemplo]
    var favoritos: Set<String> = []

    func esFavorito(_ libro: Book) -> Bool {
        favoritos.contains(libro.id)
    }

    func alternarFavorito(_ libro: Book) {
        if favoritos.contains(libro.id) {
            favoritos.remove(libro.id)
        } else {
            favoritos.insert(libro.id)
        }
    }
}