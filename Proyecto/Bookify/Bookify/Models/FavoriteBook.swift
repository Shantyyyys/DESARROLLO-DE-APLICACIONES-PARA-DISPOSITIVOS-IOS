//
//  FavoriteBook.swift
//  Bookify
//
//  Created by Facultad de Contaduría y Administración on 05/11/26.
//
//  Registro persistente de un favorito. Cada vez que el usuario marca
//  un libro se hace un insert de este modelo en SwiftData.
//

import Foundation
import SwiftData

@Model
final class FavoriteBook {
    /// Identificador del libro (hoy es el título; con la API será su id real).
    @Attribute(.unique) var bookId: String
    var addedAt: Date

    init(bookId: String, addedAt: Date = .now) {
        self.bookId = bookId
        self.addedAt = addedAt
    }
}
