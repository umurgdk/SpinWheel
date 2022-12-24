//
//  CGPoint+polar.swift
//  SpinWheel
//
//  Created by Umur Gedik on 24.12.2022.
//

import SwiftUI

extension CGPoint {
    func angleFromOrigin() -> Angle {
        Angle(radians: atan2(y, x))
    }
    
    func normalize(in bounds: CGRect) -> CGPoint {
        CGPoint(
            x: (x / bounds.width) * 2 - 1,
            y: (y / bounds.height) * 2 - 1
        )
    }
}
