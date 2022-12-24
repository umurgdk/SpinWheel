//
//  TickerRotation.swift
//  SpinWheel
//
//  Created by Umur Gedik on 24.12.2022.
//

import SwiftUI

struct TickerRotation: AnimatableModifier {
    var wheelRotation: Angle
    let perSliceAngle: Angle
    let wheelRadius: CGFloat
    
    var animatableData: Double {
        get { wheelRotation.radians }
        set { wheelRotation = Angle(radians: newValue) }
    }
    
    private func deriveRotation() -> Angle {
        /// Map overall wheel rotation angle (0...infinity) to [-1 to 1]
        /// where the edge of a slice is 0 and the next slice's middle point is 1.
        let rotationFraction = (wheelRotation.radians / perSliceAngle.radians)
                .truncatingRemainder(dividingBy: 1)
        
        let sliceLength = perSliceAngle.radians * wheelRadius
        let edgePosition = sliceLength / 2
        let tickerPosition = sliceLength * rotationFraction
        
        /// Arc length position to start dropping the ticker down
        /// Magic number 25 can be calculated from the ticker size and max rotation angle
        let dropOffStart = edgePosition + 25
        
        /// How far the ticker will drop (ticker drop animation length in arc lengths)
        let dropOffLength = min(CGFloat(15), sliceLength - dropOffStart)
        
        /// Where in arc length position ticker should increase (start rotating with the edge)
        /// Magic number 5 can be calculated from the ticker size and max rotation angle
        let liftUpStart = edgePosition - 5
        
        /// How far the ticker will increase its height (ticker lift up animation length in arc lengths)
        let liftUpLength = dropOffStart - liftUpStart
        
        /// Maximum allowed ticker rotation angle in radians
        let maxRotation = CGFloat.pi / 3.25
        
        if tickerPosition <= dropOffStart {
            /// Approaching to slice edge from right, so the ticker height will increase if it is close enough to threshold
            let liftUpFactor = max(0, (tickerPosition - liftUpStart) / liftUpLength)
            
            return Angle(radians: -min(maxRotation, liftUpFactor * maxRotation))
        } else {
            /// Ticker passing through the edge after a certain threshold it should drop
            let liftUpFactor = max(0, 1 - (tickerPosition - dropOffStart) / dropOffLength)
            return Angle(radians: -max(0, liftUpFactor * maxRotation))
        }
    }
    
    func body(content: Content) -> some View {
        content.rotationEffect(
            deriveRotation(),
            
            /// Unit position of the hole in the ticker
            anchor: UnitPoint(x: 0.5, y: 0.25)
        )
    }
}
