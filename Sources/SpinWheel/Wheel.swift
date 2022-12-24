//
//  Wheel.swift
//  SpinWheel
//
//  Created by Umur Gedik on 24.12.2022.
//

import SwiftUI

struct Wheel<T, ID: Hashable, Content: View>: View {
    let data: [T]
    let id: (T) -> ID
    let colors: [Color]
    let content: (T) -> Content
    
    var perSliceAngle: Angle { Angle(degrees: 360 / Double(data.count)) }
    
    var body: some View {
        GeometryReader { geom in
            let radius = geom.size.width / 2
            
            ZStack {
                ForEach(0..<data.count) { index in
                    let item = data[index]
                    
                    Slice(
                        content: content(item),
                        perSliceAngle: perSliceAngle,
                        wheelRadius: radius,
                        color: colors[index % colors.count]
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .rotationEffect(-perSliceAngle * Double(index))
                    .rotationEffect(Angle(radians: .pi / 2))
                    .id(id(item))
                }
                
                Circle().fill(Color.white).frame(width: 24, height: 24).shadow(radius: 2)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct Wheel_Previews: PreviewProvider {
    static var previews: some View {
        Wheel(
            data: PreviewItems,
            id: { $0 },
            colors: [
                Color(white: 0.95),
                Color(white: 0.90),
            ]
        ) { item in
            Text(item)
        }.padding(20)
    }
}
