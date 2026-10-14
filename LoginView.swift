//
//  LoginView.swift
//  Bookify
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var correo = ""
    @State private var contrasena = ""

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 8) {
                Text("Bookify")
                    .font(.largeTitle)
                    .bold()
                Image(systemName: "book")
                    .font(.largeTitle)
                Text("Read more, stress less")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 12) {
                TextField("Correo electrónico", text: $correo)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)

                SecureField("Contraseña", text: $contrasena)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal, 40)

            Button("Iniciar sesión") {
                isLoggedIn = true
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
}