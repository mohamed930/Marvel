//
//  SectionCompoents.swift
//  MarvelApp
//
//  Created by Mohamed Ali on 20/02/2026.
//

import SwiftUI

struct SectionCompoents: View {
    
    let title: String
    let data: [Item]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .setFont(fontName: .mainFontBold, size: 20)
            
            LazyHStack(spacing: 12) {
                ForEach(data,id: \.resourceURI) { model in
                    CustomAsyncImage(img: model.resourceURI) { img in
                        img
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                    }
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
    SectionCompoents(title: "Comics", data: [])
}
