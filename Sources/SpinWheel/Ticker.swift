//
//  Ticker.swift
//  SpinWheel
//
//  Created by Umur Gedik on 24.12.2022.
//

import SwiftUI

struct Ticker: View {
    let wheelAngle: Angle
    let perSliceAngle: Angle
    let wheelRadius: CGFloat
    
    var body: some View {
        TickerShape()
            .fill(Color.red, style: FillStyle(eoFill: true))
            .modifier(
                TickerRotation(
                    wheelRotation: wheelAngle,
                    perSliceAngle: perSliceAngle,
                    wheelRadius: wheelRadius
                )
            )
            .aspectRatio(0.55, contentMode: .fit)
    }
}

struct TickerShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            let topRadius = rect.midX
            let topCenter = CGPoint(x: rect.midX, y: rect.midX)
            p.addArc(
                center: topCenter,
                radius: rect.midX,
                startAngle: Angle(radians: .pi - .pi/10),
                endAngle: Angle(radians: .pi * 2 + .pi/10),
                clockwise: false
            )
            
            let bottomRadius = topRadius / 6
            let bottomCenter = CGPoint(x: rect.midX, y: rect.maxY - bottomRadius)
            p.addArc(
                center: bottomCenter,
                radius: bottomRadius,
                startAngle: Angle(radians: .pi/10),
                endAngle: Angle(radians: .pi - .pi/10),
                clockwise: false
            )
            
            p.closeSubpath()
            
            let holeRadius = topRadius / 2.5
            
            p.addEllipse(
                in: CGRect(
                    origin: CGPoint(x: rect.midX - holeRadius, y: rect.midX - holeRadius),
                    size: CGSize(width: holeRadius * 2, height: holeRadius * 2)
                )
            )
        }
    }
}
