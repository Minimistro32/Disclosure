//
//  JournalView.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/11/24.
//

import SwiftUI

enum PodiumLens: String, CaseIterable, Identifiable {
    var id: Self { return self }
    case frequency = "Frequency"
    case compulsivity = "Compulsivity"
}

struct JournalView: View {
    var body: some View {
        NavigationStack {
            PodiumView()
#if !os(macOS)
                .navigationTitle("Journal")
#endif
        }
    }
}

struct PodiumView: View {
    @State var selectedLens: PodiumLens = .frequency
    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                .fill(.primary)
                .frame(width: 100, height: 110)
            RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                .fill(.primary)
                .frame(width: 150, height: 75)
                .offset(x: -75)
            RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                .fill(.primary)
                .frame(width: 150, height: 50)
                .offset(x: 75)
            HStack (spacing: 0) {
                Text("Ranked by")
                    .foregroundStyle(Color.backgroundColor)
                Picker("Picker", selection: $selectedLens) {
                    ForEach(PodiumLens.allCases) { lens in
                        Text(lens.rawValue)
                    }
                }
                .grayscale(0.5)
            }
            //            .offset(x: 0, y: 30)
            
            
        }
        
    }
}
