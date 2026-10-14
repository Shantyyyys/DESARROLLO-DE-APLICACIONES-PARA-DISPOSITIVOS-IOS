import SwiftUI

struct BookDetailView: View {
    let libro: Book
    @Environment(AppState.self) private var estado

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16){
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

                HStack{
                    Text("\(libro.paginas) págs.")

                    Spacer()

                    HStack(spacing: 12){
                        if libro.audio{
                            Image(systemName: "headphones")
                        }
                        Image(systemName: "book")
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        Text(libro.calificacion, format: .number.precision(.fractionLength(1)))
                        Image(systemName: "star")
                    }
                }
                .font(.subheadline)

                VStack(alignment: .leading, spacing: 4){
                    Text("Autor: \(libro.autor)")
                    Text("Año de publicación \(libro.año)")
                    Text("Género: \(libro.genero)")
                    Text("Idioma: \(libro.idioma)")
                }
                .font(.subheadline)
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    estado.alternarFavorito(libro)
                } label: {
                    Image(systemName: estado.esFavorito(libro) ? "bookmark.fill" : "bookmark")
                }
            }
        }
    }
}

#Preview {
    BookDetailView(libro: Book.ejemplo)
        .environment(AppState())
}