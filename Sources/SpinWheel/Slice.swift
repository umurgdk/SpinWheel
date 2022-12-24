//
//  Slice.swift
//  SpinWheel
//
//  Created by Umur Gedik on 24.12.2022.
//

import SwiftUI

struct Slice<Content: View>: View {
    let content: Content
    let perSliceAngle: Angle
    let wheelRadius: CGFloat
    let color: Color
    
    var body: some View {
        content
            .rotationEffect(Angle(radians: .pi))
            .frame(height: wheelRadius * perSliceAngle.radians)
            .frame(width: wheelRadius, alignment: .leading)
            .background(color)
            .clipShape(
                SliceShape(radius: wheelRadius, angle: perSliceAngle)
            )
    }
}
