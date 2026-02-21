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
                        
                        CustomAsyncImage(img: viewmodel.characterModel.thumbnail.path) { img in
                            img
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
                            
                        }
                            
                        
                        VStack {
                            Text(viewmodel.characterModel.name)
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
                    
                    Text(viewmodel.characterModel.description)
                        .padding(.horizontal,12)
                        .setFont(fontName: .mainFont, size: 14)
                        .padding(.bottom,20)
                    
                    // 1. Comics
                    if !viewmodel.characterModel.comics.items.isEmpty {
                        SectionCompoents(title: "Comics",
                                         data: viewmodel.characterModel.comics.items)
                    }
                    
                    
                    // 2. Series
                    if !viewmodel.characterModel.series.items.isEmpty {
                        SectionCompoents(title: "Series",
                                         data: viewmodel.characterModel.series.items)
                    }
                    
                    // 3. Stories
                    if !viewmodel.characterModel.stories.items.isEmpty {
                        SectionCompoents(title: "Stories",
                                         data: viewmodel.characterModel.stories.items)
                    }
                    
                    // 4. Events
                    if !viewmodel.characterModel.events.items.isEmpty {
                        SectionCompoents(title: "Events",
                                         data: viewmodel.characterModel.events.items)
                    }

                    Spacer()
                }
            }
        }
        
        
    }
}

#Preview {
    CharacterDetailsView(viewmodel: CharacterDetailsViewModel(characterModel: .mock))
}
