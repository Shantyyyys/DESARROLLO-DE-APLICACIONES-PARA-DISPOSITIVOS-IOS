//
//  Theme.swift
//  Bookify
//
//  Paleta de colores del diseño nuevo. Todas las vistas usan estos colores
//  para que la app se vea consistente y se cambien en un solo lugar.
//

import SwiftUI

extension Color {
    /// Fondo crema de todas las pantallas (#F8F3EE).
    static let bookifyBackground = Color(red: 248/255, green: 243/255, blue: 238/255)

    /// Fondo de tarjetas, un poco más claro que el fondo (#FCF9F6).
    static let bookifyCard = Color(red: 252/255, green: 249/255, blue: 246/255)

    /// Café principal: botones e íconos activos (#7F6B5A).
    static let bookifyPrimary = Color(red: 127/255, green: 107/255, blue: 90/255)

    /// Beige de los íconos provisionales de portada (#BFAE9C).
    static let bookifyCoverIcon = Color(red: 191/255, green: 174/255, blue: 156/255)

    /// Texto principal: títulos (#3E3A35).
    static let bookifyText = Color(red: 62/255, green: 58/255, blue: 53/255)

    /// Texto secundario: subtítulos y datos (#7A6B5F).
    static let bookifySecondaryText = Color(red: 122/255, green: 107/255, blue: 95/255)
}
