//
//  BookDetailView.swift
//  Bookify
//
//  Detalle del libro con el estilo del diseño nuevo.
//

// FLUJOS (ver Docs/flujos.md): F6 (detalle y resumen), F7 (marcar favorito)

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
                    // [F7.1] El marcador llama a toggleFavorite. Si regresa false (límite lleno),
                    // se muestra el aviso (F7.5).
                    if !state.toggleFavorite(book) {
                        showLimitAlert = true
                    }
                } label: {
                    // [F7.6] El ícono se actualiza solo porque AppState es @Observable.
                    Image(systemName: state.isFavorite(book) ? "bookmark.fill" : "bookmark")
                }
                .accessibilityLabel(state.isFavorite(book) ? "Remove from favorites" : "Add to favorites")
            }
        }
        // [F7.5] Aviso cuando ya hay 10 favoritos.
        .alert("Favorites limit reached", isPresented: $showLimitAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You can save up to \(AppState.maxFavorites) books. Remove one to add another.")
        }
        // Carga el resumen sin bloquear la interfaz.
        .task {
            // [F6.3] Al abrir el detalle se pide el resumen; mientras llega se ve un indicador de carga.
            summary = await viewModel.loadSummary(for: book)
        }
    }

    // MARK: - Partes de la vista

    /// Portada con su propia forma (más alta que ancha), centrada.
    /// Si no hay portada, el ícono provisional en un rectángulo con forma de libro.
    private var coverCard: some View {
        AsyncImage(url: URL(string: book.coverUrl)) { image in
            image
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 12))
        } placeholder: {
            Image(systemName: "book.closed")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.bookifyCoverIcon)
                .padding(40)
                .frame(width: 220, height: 330)
                .background(Color.bookifyCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .frame(height: 360)
        .frame(maxWidth: .infinity)
        .shadow(color: .black.opacity(0.12), radius: 12, y: 6)
        .accessibilityHidden(true)
    }

    /// Resumen del libro (descripción, primera frase o aviso).
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Summary")
                .font(.system(.title3, design: .serif))
                .foregroundStyle(Color.bookifyText)

            // [F6.6] Cuando llega el resumen, se muestra el texto.
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
            Text(book.pages > 0 ? "\(book.pages) pages" : "— pages")

            Spacer()

            HStack(spacing: 12) {
                Image(systemName: "book")
                    .accessibilityHidden(true)
            }

            Spacer()

            HStack(spacing: 4) {
                // Si la API no trae calificación (0), se muestra "—" en lugar de "0.0".
                if book.rating > 0 {
                    Text(book.rating, format: .number.precision(.fractionLength(1)))
                } else {
                    Text("—")
                }
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
