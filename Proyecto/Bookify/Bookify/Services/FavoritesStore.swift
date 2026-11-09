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
    func insert(bookId: String)
    func delete(bookId: String)
}

/// Implementación en memoria: no guarda nada en disco.
/// Se usa en los #Preview y en las pruebas unitarias.
@MainActor
final class InMemoryFavoritesStore: FavoritesStore {
    private(set) var ids: Set<String>

    init(initialIDs: Set<String> = []) {
        self.ids = initialIDs
    }

    func loadFavoriteIDs() -> Set<String> {
        ids
    }

    func insert(bookId: String) {
        ids.insert(bookId)
    }

    func delete(bookId: String) {
        ids.remove(bookId)
    }
}
