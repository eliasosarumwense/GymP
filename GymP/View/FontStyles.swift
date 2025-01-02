//
//  FontStyles.swift
//  GymP
//
//  Created by Elias Osarumwense on 19.06.24.
//

import SwiftUI

enum FontWeight {
    case light
    case regular
    case medium
    case semiBold
    case bold
    case black
}

extension Font {
    static let customFont: (FontWeight, CGFloat) -> Font = { fontType, size in
        switch fontType {
        case .light:
            Font.custom("Lexend-Light", size: size)
        case .regular:
            Font.custom("Lexend-Regular", size: size)
        case .medium:
            Font.custom("Lexend-Medium", size: size)
        case .semiBold:
            Font.custom("Lexend-SemiBold", size: size)
        case .bold:
            Font.custom("Lexend-Bold", size: size)
        case .black:
            Font.custom("Lexend-Black", size: size)
        }
    }
}

extension Text {
    func customFont(_ fontWeight: FontWeight? = .regular, _ size: CGFloat? = nil) -> Text {
        return self.font(.customFont(fontWeight ?? .regular, size ?? 16))
    }
}
