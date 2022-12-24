//
//  SliceShape.swift
//  SpinWheel
//
//  Created by Umur Gedik on 24.12.2022.
//

import SwiftUI

struct SliceShape: Shape {
    let radius: Double
    let angle: Angle
    
    func path(in rect: CGRect) -> Path {
        Path { p in
            let startAngle = Angle(radians: .pi) - angle / 2
            let endAngle = Angle(radians: .pi) + angle / 2
            let startPoint = CGPoint(x: rect.maxX, y: rect.midY)
            p.move(to: startPoint)
            p.addArc(
                center: startPoint,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )
            p.closeSubpath()
        }
    }
}
