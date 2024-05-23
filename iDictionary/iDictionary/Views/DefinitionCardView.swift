//
//  DefinitionCardView.swift
//  iDictionary
//
//  Created by Guren Icim on 3.01.2024.
//

import SwiftUI

struct DefinitionCard: View {
    let id = UUID()
    let definition: Definition
    let word: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25).fill(.card)
            VStack(alignment: .center) {
                Text(word)
                    .font(.largeTitle)
                    .padding()
                    .padding(.bottom,20)
                Text(definition.definition)
                    .font(.title2)
                    .padding()
                if !definition.example.isEmpty {
                    Text("Example: \(definition.example)")
                        .italic()
                        .padding()
                }
            }
        }.padding(50)
    }
}
