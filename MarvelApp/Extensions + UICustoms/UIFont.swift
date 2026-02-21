//
//  UIFont.swift
//  CaptainWee
//
//  Created by Mohamed Ali on 26/06/2024.
//

import SwiftUI

enum Fonts: String {
    case mainFont = "Inter-Regular"
    case mainFontMeduim = "Inter-Medium"
    case mainFontBold = "Inter-Bold"
    case mainFontLight = "Inter-Light"
    case mainFontSemiBold = "Inter-SemiBold"
    case mainFontExtraBold = "Inter-ExtraBold"
}

struct CustomFontModifier: ViewModifier {
    var fontName: Fonts
    var size: CGFloat

    func body(content: Content) -> some View {
        content
            .font(.custom(fontName.rawValue, size: size))
    }
}

extension View {
    
    func setFont(fontName: Fonts, size: CGFloat) -> some View {
        self.modifier(CustomFontModifier(fontName: fontName, size: size))
    }
}
