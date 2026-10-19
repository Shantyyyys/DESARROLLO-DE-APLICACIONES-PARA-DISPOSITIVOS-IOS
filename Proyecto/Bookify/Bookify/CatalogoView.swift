//
//  CatalogoView.swift
//  Bookify
//

import SwiftUI

struct CatalogoView: View {
    @Environment(AppState.self) private var state

    private var viewModel: CatalogoViewModel {
        CatalogoViewModel(state: state)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Catálogo")
                        .font(.largeTitle)
                        .bold()

                    Text("Descubrir más...")
                        .font(.headline)

                    ForEach(viewModel.books) { book in
                        NavigationLink(value: book) {
                            cover(de: book)
                        }
                    }

                    Text("Favoritos")
                        .font(.headline)

                    ForEach(viewModel.favoriteBooks) { book in
                        NavigationLink(value: book) {
                            cover(de: book)
                        }
                    }
                }
                .padding()
            }
            .navigationDestination(for: Book.self) { book in
                BookDetailView(book: book)
            }
        }
    }

    private func cover(de book: Book) -> some View {
        Image(systemName: "book.closed")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 140)
            .foregroundStyle(.secondary)
            .padding()
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    CatalogoView()
        .environment(AppState())
}