//
//  SettingsView.swift
//  Bookify
//
//  Pestaña Configuración con el estilo del diseño. Modo e Idioma solo
//  muestran la idea (opciones desactivadas); About Us muestra al equipo.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Settings")
                        .font(.system(.largeTitle, design: .serif))
                        .foregroundStyle(Color.bookifyText)

                    Text("Customize your experience")
                        .font(.system(.title3, design: .serif))
                        .foregroundStyle(Color.bookifySecondaryText)
                        .padding(.bottom, 8)

                    NavigationLink {
                        ComingSoonOptionsView(
                            title: "Mode",
                            options: ["Light", "Dark"],
                            note: "Coming soon. Bookify uses light mode for now."
                        )
                    } label: {
                        settingsCard(systemImage: "gearshape", title: "Mode", subtitle: "Choose your display mode")
                    }

                    NavigationLink {
                        ComingSoonOptionsView(
                            title: "Language",
                            options: ["English", "Spanish"],
                            note: "Coming soon. Bookify is available in English for now."
                        )
                    } label: {
                        settingsCard(systemImage: "globe", title: "Language", subtitle: "Select your language")
                    }

                    NavigationLink {
                        AboutUsView()
                    } label: {
                        settingsCard(systemImage: "info.circle", title: "About Us", subtitle: "Learn more about us")
                    }
                }
                .padding()
            }
            .background(Color.bookifyBackground.ignoresSafeArea())
        }
    }

    /// Tarjeta del diseño: ícono · línea divisoria · título y subtítulo · flecha.
    private func settingsCard(systemImage: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 34))
                .foregroundStyle(Color.bookifyCoverIcon)
                .frame(width: 56)
                .accessibilityHidden(true)

            Rectangle()
                .fill(Color.bookifyCoverIcon.opacity(0.4))
                .frame(width: 1, height: 44)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.title3, design: .serif))
                    .foregroundStyle(Color.bookifyText)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Color.bookifySecondaryText)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(Color.bookifySecondaryText)
                .accessibilityHidden(true)
        }
        .padding()
        .background(Color.bookifyCard)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.06), radius: 10, y: 4)
    }
}

/// Opciones que solo muestran la idea: la primera está marcada y no se puede cambiar.
private struct ComingSoonOptionsView: View {
    let title: String
    let options: [String]
    let note: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(options, id: \.self) { option in
                    HStack {
                        Text(option)
                            .font(.system(.body, design: .serif))
                            .foregroundStyle(Color.bookifyText)
                        Spacer()
                        if option == options.first {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.bookifyPrimary)
                        }
                    }
                    .frame(minHeight: 44)
                    .padding(.horizontal)
                    // Las demás opciones se ven desactivadas.
                    .opacity(option == options.first ? 1 : 0.4)

                    Divider()
                }
            }
            .background(Color.bookifyCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.06), radius: 8, y: 4)

            Text(note)
                .font(.footnote)
                .foregroundStyle(Color.bookifySecondaryText)

            Spacer()
        }
        .padding()
        .background(Color.bookifyBackground.ignoresSafeArea())
        .navigationTitle(title)
    }
}

/// Acerca de: foto del equipo y descripción de la app.
private struct AboutUsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image("AboutUsPhoto")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.06), radius: 10, y: 4)
                    .accessibilityLabel("Bookify team photo")

                Text("Bookify")
                    .font(.system(.largeTitle, design: .serif))
                    .foregroundStyle(Color.bookifyText)

                Text("Read more, stress less")
                    .font(.system(.title3, design: .serif))
                    .foregroundStyle(Color.bookifySecondaryText)

                Text("Discover trending books, explore categories and keep your favorites in one place. Book data comes from Open Library.")
                    .font(.subheadline)
                    .foregroundStyle(Color.bookifySecondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
        .background(Color.bookifyBackground.ignoresSafeArea())
        .navigationTitle("About Us")
    }
}

#Preview {
    SettingsView()
}
