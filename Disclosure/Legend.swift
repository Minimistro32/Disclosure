//
//  Legend.swift
//  Disclosure
//
//  Created by Tyson Freeze on 3/20/24.
//

import SwiftUI

struct Legend: View {
    @State var legendDrag: CGPoint?
    let lens: ChartLens
    let segmentWidth: CGFloat
    let cornerRadius: CGFloat = 10
    
    private var categoricalIntensity: String {
        Relapse.categoricalIntensity(for: Double(legendDrag?.x ?? 0) / segmentWidth)
    }
    
    private var intensityAnnotationWidth: CGFloat {
        switch categoricalIntensity {
        case "New Material":
            120
        case "Nudity":
            70
        case "Revealing Clothes":
            160
        case "Masturbation":
            130
        default:
            0
        }
    }
    
    private var dragLegend: some Gesture {
        DragGesture(minimumDistance: 5)
            .onChanged { value in
                if (0..<(segmentWidth * 10)).contains(value.location.x) {
                    legendDrag = value.location
                } else {
                    legendDrag = nil
                }
            }
            .onEnded { _ in legendDrag = nil }
    }
    
    private func gradation(index: Int) -> some View {
        ZStack(alignment: .leading) {
            UnevenRoundedRectangle(cornerRadii: .init(topLeading: index == 0 ? cornerRadius : 0,
                                                      bottomLeading: index == 0 ? cornerRadius : 0,
                                                      bottomTrailing: index == 9 ? cornerRadius : 0,
                                                      topTrailing: index == 9 ? cornerRadius : 0),
                                   style: .continuous)
            .frame(width: segmentWidth, height: cornerRadius)
            .foregroundStyle(lens.color)
            .opacity(Double(index + 1) / 10)
            
            if lens == .intensity && [2,4,8].contains(index) {
                Rectangle()
                    .fill(Color(UIColor.label).opacity(0.4))
                    .frame(width: 2, height: cornerRadius)
            }
        }
    }
    
    var body: some View {
        HStack {
            Text("1").fontWeight(.ultraLight)
            HStack(spacing: 0) {
                ForEach(0..<10, id: \.self) { index in
                    gradation(index: index)
                }
            }
            .gesture(dragLegend)
            Text("10").fontWeight(.ultraLight)
        }
        .padding(.top, 5)
        .if(legendDrag != nil && lens == .intensity) {
            $0.overlay(alignment: .leading) {
                VStack(spacing: 0) {
                    Text(categoricalIntensity)
                        .frame(width: intensityAnnotationWidth, height: 40)
                        .background(.debugGray6)
                        .clipShape(.rect(cornerSize: CGSize(width: 15, height: 15)))
                    Rectangle()
                        .foregroundStyle(Color.gray.opacity(0.3))
                        .frame(width: 2, height: cornerRadius + 10)
                    
                }
                .offset(x: legendDrag!.x - (intensityAnnotationWidth / 2) + 15, y: -22)
            }
        }
    }
}
