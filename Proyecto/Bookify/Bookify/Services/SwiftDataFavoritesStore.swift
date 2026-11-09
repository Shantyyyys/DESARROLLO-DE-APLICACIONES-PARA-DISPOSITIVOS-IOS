///
//  SwiftDataFavoritesStore.swift
//  Bookify
//
//  Guarda los favoritos en el dispositivo con SwiftData (inserts y deletes).
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataFavoritesStore: FavoritesStore {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func loadFavoriteIDs() -> Set<String> {
        let descriptor = FetchDescriptor<FavoriteBook>()
        let saved = (try? context.fetch(descriptor)) ?? []
        return Set(saved.map { $0.bookId })
    }

    func insert(bookId: String) {
        // Evita guardar el mismo libro dos veces
        guard !contains(bookId: bookId) else { return }
        context.insert(FavoriteBook(bookId: bookId))
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
