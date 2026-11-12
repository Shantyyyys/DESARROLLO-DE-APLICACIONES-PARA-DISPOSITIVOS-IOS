//
//  BookCategory.swift
//  Bookify
//
//  Lista fija de categorías de la app. Open Library no tiene un endpoint con
//  "todas las categorías", así que elegimos estas y cada una se busca con
//  `subject:` en search.json. La misma lista alimenta el menú de hamburguesa
//  y los carruseles del catálogo.
//

enum BookCategory: String, CaseIterable, Identifiable {
    case fantasy
    case scienceFiction
    case mystery
    case romance
    case horror
    case biography
    case children
    case history

    var id: String { rawValue }

    /// Nombre que ve el usuario (la interfaz está en inglés).
    var title: String {
        switch self {
        case .fantasy: "Fantasy"
        case .scienceFiction: "Science Fiction"
        case .mystery: "Mystery"
        case .romance: "Romance"
        case .horror: "Horror"
        case .biography: "Biography"
        case .children: "Children"
        case .history: "History"
        }
    }

    /// Término que se manda a Open Library: q=subject:"<término>".
    var searchTerm: String {
        switch self {
        case .scienceFiction: "science fiction"
        default: rawValue
        }
    }

    /// Palabras que, si aparecen en un `subject` del libro, lo ubican en esta categoría.
    private var keywords: [String] {
        switch self {
        case .fantasy: ["fantasy"]
        case .scienceFiction: ["science fiction"]
        case .mystery: ["mystery", "detective"]
        case .romance: ["romance", "love stories"]
        case .horror: ["horror"]
        case .biography: ["biography", "autobiography"]
        case .children: ["children", "juvenile"]
        case .history: ["history"]
        }
    }

    /// Texto que se muestra cuando ningún subject coincide con la lista.
    static let uncategorizedTitle = "Uncategorized"

    /// Primera categoría de la lista (en orden) que coincide con los subjects del libro.
    static func matching(subjects: [String]?) -> BookCategory? {
        guard let subjects, !subjects.isEmpty else { return nil }
        let lowercased = subjects.map { $0.lowercased() }
        return allCases.first { category in
            category.keywords.contains { keyword in
                lowercased.contains { $0.contains(keyword) }
            }
        }
    }
}
