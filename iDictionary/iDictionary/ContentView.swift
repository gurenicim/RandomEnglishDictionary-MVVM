//
//  ContentView.swift
//  iDictionary
//
//  Created by Guren Icim on 3.01.2024.
//

import SwiftUI

let gradientStart = Color(.neonRed)
let gradientEnd = Color(.neonPurple)

func gradientBackground() -> some View {
    RoundedRectangle(cornerRadius: 25).fill(LinearGradient(
        gradient: .init(colors: [gradientStart, gradientEnd]),
        startPoint: .init(x: 0.5, y: 0),
        endPoint: .init(x: 0.5, y: 0.6)
    ))
}

func radialBackground () -> some View {
    Ellipse()
        .fill(
            AngularGradient(gradient: Gradient(colors: [.red, .yellow, .blue]), center: .center)
        )
}

struct ContentView: View {
    var lvm: LaunchViewModel = .shared
    @StateObject var wordViewModel: WordViewModel = .shared
    @State private var offset: CGFloat = 0.0
    @State private var translation: CGSize = .zero
    @State private var cardOffsets: [UUID: CGFloat] = [:]
    
    var body: some View {
        ZStack {
            gradientBackground().ignoresSafeArea(.all)
            if wordViewModel.defArray.isEmpty {
                Text("Loading definitions...").onAppear{
                    wordViewModel.callWordService()
                }
            } else {
                GeometryReader { geometry in
                    ZStack(alignment: .center) {
                        ForEach(wordViewModel.defArray.reversed(), id: \.id) { definition in
                            DefinitionCard(definition: definition, word: wordViewModel.tWord)
                                .offset(x: cardOffsets[definition.id] ?? 0)
                                .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 25), anchor: .bottom)
                                .gesture(
                                    DragGesture(minimumDistance: 50)
                                        .onChanged { value in
                                            cardOffsets[definition.id] = value.translation.width
                                            self.translation = value.translation
                                        }
                                        .onEnded { value in
                                            if abs(value.translation.width) > geometry.size.width / 2 {
                                                // Swipe right - like (action here)
                                                wordViewModel.defArray.removeFirst()
                                                withAnimation(.easeInOut(duration: 0.5 )) {
                                                    offset = 0
                                                    self.translation = .zero
                                                }
                                            } else {
                                                // Reset offset on small swipe
                                                withAnimation(.easeInOut(duration: 0.5 )) {
                                                    cardOffsets[definition.id] = 0
                                                    self.translation = .zero
                                                }
                                            }
                                        }
                                )
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            if !lvm.isLaunchedBefore() {
                Task {
                    do {
                        let wordList = try await lvm.readWordsFromTextFile(fileName: "words")
                        lvm.setTheWordList(words: wordList)
                        lvm.setLaunchedBefore()
                    } catch {
                        print("Error reading file or storing data: \(error.localizedDescription)")
                    }
                }
            }
        })
        .onAppear {
            wordViewModel.callWordService() // Call on initial view
        }
    }
}
