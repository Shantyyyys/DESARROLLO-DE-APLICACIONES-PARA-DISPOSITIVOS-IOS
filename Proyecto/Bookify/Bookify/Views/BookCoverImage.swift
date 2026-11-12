//
//  BookCoverImage.swift
//  Bookify
//
//  Portada de un libro desde Covers API. Si no tiene o no carga, muestra el
//  ícono provisional. La usan el catálogo y Favoritos (antes estaba repetida).
//

import SwiftUI

struct BookCoverImage: View {
    let book: Book

    var body: some View {
        AsyncImage(url: URL(string: book.coverUrl)) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            Image(systemName: "book.closed")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.bookifyCoverIcon)
        }
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .accessibilityHidden(true)
    }
}
