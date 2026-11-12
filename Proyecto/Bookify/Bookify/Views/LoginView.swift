//
//  LoginView.swift
//  Bookify
//
//  Pantalla de bienvenida según el diseño nuevo.
//  No pide correo ni contraseña: el botón entra directo al catálogo.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool

    /// Tamaño del título que crece o se reduce con Dynamic Type.
    @ScaledMetric(relativeTo: .largeTitle) private var titleSize: CGFloat = 56
    @ScaledMetric(relativeTo: .title) private var iconSize: CGFloat = 40

    var body: some View {
        ZStack {
            // Capa 1: color de fondo
            Color.bookifyBackground
                .ignoresSafeArea()

            // Capa 2: ilustración decorativa (ondas y libros)
            Image("LoginFondo")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .accessibilityHidden(true)

            // Capa 3: contenido
            VStack(spacing: 20) {
                Text("Bookify")
                    .font(.system(size: titleSize, design: .serif))
                    .foregroundStyle(Color.bookifyText)

                Image(systemName: "book")
                    .font(.system(size: iconSize, weight: .light))
                    .foregroundStyle(Color.bookifyPrimary)
                    .accessibilityHidden(true)

                Text("Read more, stress less")
                    .font(.system(.title3, design: .serif))
                    .tracking(1.5)
                    .foregroundStyle(Color.bookifySecondaryText)

                Button {
                    isLoggedIn = true
                } label: {
                    HStack(spacing: 12) {
                        Text("Start Reading")
                        Image(systemName: "arrow.right")
                    }
                    .font(.system(.title3, design: .serif))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(Color.bookifyPrimary)
                    .clipShape(Capsule())
                }
                .padding(.top, 16)
            }
            .padding()
        }
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
}
