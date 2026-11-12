//
//  FavoriteBook.swift
//  Bookify
//
//  Created by Facultad de Contaduría y Administración on 05/11/26.
//
//  Registro persistente de un favorito. Cada vez que el usuario marca
//  un libro se hace un insert de este modelo en SwiftData. Guarda los datos
//  del libro para que Favoritos se vea completo al reabrir la app.
//

import Foundation
import SwiftData

@Model
final class FavoriteBook {
    /// Identificador del libro (el `key` del work de Open Library).
    @Attribute(.unique) var bookId: String
    var addedAt: Date
    // Datos del libro. Tienen valor por defecto para que SwiftData pueda
    // migrar los favoritos que se guardaron antes solo con el id.
    var title: String = ""
    var author: String = ""
    var year: Int = 0
    var category: String = ""
    var language: String = ""
    var pages: Int = 0
    var rating: Double = 0
    var coverUrl: String = ""
    var firstSentence: String = ""

    init(book: Book, addedAt: Date = .now) {
        self.bookId = book.id
        self.addedAt = addedAt
        self.title = book.title
        self.author = book.author
        self.year = book.year
        self.category = book.category
        self.language = book.language
        self.pages = book.pages
        self.rating = book.rating
        self.coverUrl = book.coverUrl
        self.firstSentence = book.firstSentence
    }

    /// Reconstruye el libro para mostrarlo en Favoritos y en el detalle.
    var book: Book {
        Book(
            id: bookId,
            title: title,
            author: author,
            year: year,
            category: category,
            language: language,
            pages: pages,
            rating: rating,
            coverUrl: coverUrl,
            firstSentence: firstSentence
        )
    }
}
