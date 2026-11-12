//
//  BookDetailView.swift
//  Bookify
//
//  Detalle del libro con el estilo del diseño nuevo.
//

import SwiftUI

struct BookDetailView: View {
    let book: Book
    /// Estado compartido inyectado por parámetro. Como AppState es @Observable,
    /// la vista se actualiza sola cuando cambian los favoritos.
    let state: AppState
    /// ViewModel del catálogo; carga el resumen del libro.
    let viewModel: CatalogoViewModel
    /// Resumen ya resuelto; mientras es nil se muestra cargando.
    @State private var summary: String?
    /// Se activa cuando se intenta agregar un favorito con el límite lleno.
    @State private var showLimitAlert = false

    init(book: Book, state: AppState, viewModel: CatalogoViewModel) {
        self.book = book
        self.state = state
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                coverCard

                Text(book.title)
                    .font(.system(.largeTitle, design: .serif))
                    .foregroundStyle(Color.bookifyText)

                statsRow

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    infoRow("Author:", book.author)
                    infoRow("Published:", yearText)
                    infoRow("Category:", book.category)
                    infoRow("Language:", book.language)
                }

                Divider()

                summarySection
            }
            .padding()
        }
        .background(Color.bookifyBackground.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if !state.toggleFavorite(book) {
                        showLimitAlert = true
                    }
                } label: {
                    Image(systemName: state.isFavorite(book) ? "bookmark.fill" : "bookmark")
                }
                .accessibilityLabel(state.isFavorite(book) ? "Remove from favorites" : "Add to favorites")
            }
        }
        .alert("Favorites limit reached", isPresented: $showLimitAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You can save up to \(AppState.maxFavorites) books. Remove one to add another.")
        }
        // Carga el resumen sin bloquear la interfaz.
        .task {
            summary = await viewModel.loadSummary(for: book)
        }
    }

    // MARK: - Partes de la vista

    /// Tarjeta de portada: la portada de Covers API o, si no hay, el ícono provisional.
    private var coverCard: some View {
        AsyncImage(url: URL(string: book.coverUrl)) { image in
            image
                .resizable()
                .scaledToFit()
                .padding()
        } placeholder: {
            Image(systemName: "book.closed")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.bookifyCoverIcon)
                .padding(40)
        }
        .frame(maxWidth: .infinity, maxHeight: 280)
        .background(Color.bookifyCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 10, y: 4)
        .accessibilityHidden(true)
    }

    /// Resumen del libro (descripción, primera frase o aviso).
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Summary")
                .font(.system(.title3, design: .serif))
                .foregroundStyle(Color.bookifyText)

            if let summary {
                Text(summary)
                    .font(.subheadline)
                    .foregroundStyle(Color.bookifySecondaryText)
            } else {
                ProgressView()
                    .tint(Color.bookifyPrimary)
            }
        }
    }

    /// Fila: páginas · formato · calificación.
    private var statsRow: some View {
        HStack {
            Text("\(book.pages) pages")

            Spacer()

            HStack(spacing: 12) {
                Image(systemName: "book")
                    .accessibilityHidden(true)
            }

            Spacer()

            HStack(spacing: 4) {
                Text(book.rating, format: .number.precision(.fractionLength(1)))
                Image(systemName: "star")
                    .accessibilityHidden(true)
            }
        }
        .font(.subheadline)
        .foregroundStyle(Color.bookifySecondaryText)
    }

    /// Año sin separador de miles. Si la API no lo trae (0), lo indica.
    private var yearText: String {
        book.year > 0 ? String(book.year) : "Unknown"
    }

    /// Una línea de dato con la etiqueta en negritas.
    private func infoRow(_ label: String, _ value: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text(label)
                .bold()
            Text(value)
        }
        .font(.subheadline)
        .foregroundStyle(Color.bookifySecondaryText)
    }
}

#Preview {
    NavigationStack {
        let state = AppState()
        BookDetailView(
            book: Book(from: MockBookService.sampleDTOs[0]),
            state: state,
            viewModel: CatalogoViewModel(state: state, bookService: MockBookService())
        )
    }
}
