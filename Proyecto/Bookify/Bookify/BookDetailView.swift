import SwiftUI

struct BookDetailView: View {
    let book: Book
    @Environment(AppState.self) private var state

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

                Text(book.title)
                    .font(.title)
                    .bold()

                HStack {
                    Text("\(book.pages) págs.")

                    Spacer()

                    HStack(spacing: 12) {
                        if book.audio {
                            Image(systemName: "headphones")
                        }
                        Image(systemName: "book")
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        Text(book.rating, format: .number.precision(.fractionLength(1)))
                        Image(systemName: "star")
                    }
                }
                .font(.subheadline)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Autor: \(book.author)")
                    Text("Año de publicación \(book.year)")
                    Text("Género: \(book.gender)")
                    Text("Idioma: \(book.language)")
                }
                .font(.subheadline)
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    state.toggleFavorite(book)
                } label: {
                    Image(systemName: state.isFavorite(book) ? "bookmark.fill" : "bookmark")
                }
            }
        }
    }
}

#Preview {
    BookDetailView(book: Book.example)
        .environment(AppState())
}