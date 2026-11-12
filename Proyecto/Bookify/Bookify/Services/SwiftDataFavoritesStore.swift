///
//  SwiftDataFavoritesStore.swift
//  Bookify
//
//  Guarda los favoritos en el dispositivo con SwiftData (inserts y deletes).
//

// FLUJOS (ver Docs/flujos.md): F7 (guardar/borrar favorito), F9 (favoritos al reabrir)

import Foundation
import SwiftData

@MainActor
final class SwiftDataFavoritesStore: FavoritesStore {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // [F9.1] Lee los ids de todos los favoritos guardados.
    func loadFavoriteIDs() -> Set<String> {
        let descriptor = FetchDescriptor<FavoriteBook>()
        let saved = (try? context.fetch(descriptor)) ?? []
        return Set(saved.map { $0.bookId })
    }

    // [F9.2] Lee los favoritos completos en el orden en que se marcaron.
    func loadFavoriteBooks() -> [Book] {
        let descriptor = FetchDescriptor<FavoriteBook>(sortBy: [SortDescriptor(\.addedAt)])
        let saved = (try? context.fetch(descriptor)) ?? []
        // Los favoritos guardados antes (solo con el id) no tienen título: se omiten.
        return saved.filter { !$0.title.isEmpty }.map { $0.book }
    }

    // [F7.4] Guarda el favorito (con los datos del libro) en SwiftData.
    func insert(book: Book) {
        // Evita guardar el mismo libro dos veces
        guard !contains(bookId: book.id) else { return }
        context.insert(FavoriteBook(book: book))
        save()
    }

    private func contains(bookId: String) -> Bool {
        let id = bookId
        let descriptor = FetchDescriptor<FavoriteBook>(
            predicate: #Predicate { $0.bookId == id }
        )
        let count = (try? context.fetchCount(descriptor)) ?? 0
        return count > 0
    }

    // [F7.4] Borra el favorito de SwiftData.
    func delete(bookId: String) {
        let id = bookId
        let descriptor = FetchDescriptor<FavoriteBook>(
            predicate: #Predicate { $0.bookId == id }
        )
        let matches = (try? context.fetch(descriptor)) ?? []
        for favorite in matches {
            context.delete(favorite)
        }
        save()
    }

    private func save() {
        do {
            try context.save()
        } catch {
            print("Error al guardar favoritos: \(error)")
        }
    }
}
