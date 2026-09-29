//
//  BookDetailView.swift
//  Bookify
//
//  Created by Facultad de Contaduría y Administración on 24/09/26.
//

import SwiftUI

struct BookDetailView: View {
    let libro: Book

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Image(systemName: "book.closed")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 250)
                    .background(Color.gray.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Text(libro.titulo)
                    .font(.title)
                    .bold()
            }
            .padding()
        }
    }
}

#Preview {
    BookDetailView(libro: Book.ejemplo)
}
