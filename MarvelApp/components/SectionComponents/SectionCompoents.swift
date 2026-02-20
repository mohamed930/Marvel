//
//  SectionCompoents.swift
//  MarvelApp
//
//  Created by Mohamed Ali on 20/02/2026.
//

import SwiftUI

struct SectionCompoents: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text("Comics")
                .setFont(fontName: .mainFontBold, size: 20)
            
            LazyHStack(spacing: 12) {
                ForEach(0..<3) { index in
                    Image(.card3)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 150)
            .padding(.horizontal,0)
            
        }
        .padding(.horizontal)
        
    }
}

#Preview {
    SectionCompoents()
}
