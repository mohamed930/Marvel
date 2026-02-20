//
//  CharacterDetailsView.swift
//  MarvelApp
//
//  Created by Mohamed Ali on 20/02/2026.
//

import SwiftUI

struct CharacterDetailsView: View {
    
    @ObservedObject var viewmodel: CharacterDetailsViewModel
    
    var body: some View {
        
        VStack(spacing: 10) {
            HStack {
                Button {
                    viewmodel.moveToCharactersListScreen()
                } label: {
                    Image(.back)
                }
                .frame(width: 30,height: 30)
                
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView {
                VStack {
                    
                    ZStack {
                        Image(.card3)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, minHeight: 560, maxHeight: 560)
                            .clipped()
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: .black.opacity(0), location: 0),
                                        .init(color: .black.opacity(1), location: 1)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        VStack {
                            Text("Wanda Vision")
                                .setFont(fontName: .mainFontExtraBold, size: 20)
                                .padding(.top, 30)
                            
                            Spacer()
                            
                            Button {
                                viewmodel.moveToDetailsInSafariScreen()
                            } label: {
                                Image(.playButton)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                            }
                            .padding(.bottom, 30)
                        }
                    }
                    
                    Text("The series is a blend of classic television and the Marvel Cinematic Universe in which Wanda Maximoff and Vision—two super-powered beings living idealized suburban lives—begin to suspect that everything is not as it seems.")
                        .padding(.horizontal,12)
                        .setFont(fontName: .mainFont, size: 14)
                        .padding(.bottom,20)
                    
                    // 1. Comics
                    SectionCompoents()
                    
                    // 2. Series
                    SectionCompoents()
                    
                    // 3. Stories
                    SectionCompoents()
                    
                    // 4. Events
                    SectionCompoents()

                    Spacer()
                }
            }
        }
        
        
    }
}

#Preview {
    CharacterDetailsView(viewmodel: CharacterDetailsViewModel())
}
