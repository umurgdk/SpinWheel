//
//  SpinWheel.swift
//  SpinWheel
//
//  Created by Umur Gedik on 24.12.2022.
//

import SwiftUI

public struct SpinWheelPicker<T, ID: Hashable, Content: View>: View {
    public let data: [T]
    public let id: (T) -> ID
    public var spinDuration: TimeInterval
    public var colors: [Color]
    @Binding public var value: T?
    public let content: (T) -> Content
    
    public init(
        data: [T],
        id: @escaping (T) -> ID,
        spinDuration: TimeInterval = 5,
        colors: [Color] = [ Color(white: 0.95), Color(white: 0.9) ],
        value: Binding<T?>,
        content: @escaping (T) -> Content
    ) {
        self.data = data
        self.id = id
        self.spinDuration = spinDuration
        self.colors = colors
        self._value = value
        self.content = content
    }
    
    @State var rotation = Angle.zero
    @GestureState var dragRotation = Angle.zero
    @Namespace var wheelCoordinateSpace
    
    var perSliceAngle: Angle {
       Angle(degrees: 360 / Double(data.count))
    }
    
    public var body: some View {
        GeometryReader { geom in
            ZStack(alignment: .top) {
                Wheel(
                    data: data,
                    id: id,
                    colors: colors,
                    content: content
                )
                .rotationEffect(rotation + dragRotation)
                .overlay(Circle().stroke(Color.black, lineWidth: 6))
                .overlay(
                    Color.clear
                        .contentShape(Circle())
                        .coordinateSpace(name: wheelCoordinateSpace)
                        .gesture(
                            wheelDragGesture(in: geom.frame(in: .local))
                        )
                )
                
                Ticker(
                    wheelAngle: rotation + dragRotation,
                    perSliceAngle: perSliceAngle,
                    wheelRadius: geom.size.width / 2
                )
                .frame(height: 42)
                .offset(y: -25)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    func wheelDragGesture(in bounds: CGRect) -> some Gesture {
        let radius = bounds.width / 2
        
        return DragGesture(minimumDistance: 0, coordinateSpace: .named(wheelCoordinateSpace))
            .updating($dragRotation) { value, state, transaction in
                let startAngle = value.startLocation.normalize(in: bounds).angleFromOrigin()
                let currentAngle = value.location.normalize(in: bounds).angleFromOrigin()
                let draggedAngle = currentAngle - startAngle
                
                guard draggedAngle.radians > 0 else { return }
                
                state = draggedAngle
            }
            .onEnded { value in
                let startAngle = value.startLocation.normalize(in: bounds).angleFromOrigin()
                let currentAngle = value.location.normalize(in: bounds).angleFromOrigin()
                let draggedAngle = (currentAngle - startAngle)
                
                // Get highest velocity
                let verticalVelocity = (value.predictedEndTranslation.height - value.translation.height)
                let horizontalVelocity = (value.predictedEndTranslation.width - value.translation.width)
                let velocity = abs(verticalVelocity) > abs(horizontalVelocity) ? verticalVelocity : horizontalVelocity
                
                // Its tricky to get ticker rotation for counter clockwise rotations
                guard velocity > 0 else { return }
                
                // Commit rotation caused by drag before end
                rotation += draggedAngle
                
                // Convert linear velocity to angular velocity
                let velocityFactor = Angle(radians: velocity / radius) * 10
                
                // Round final rotation to nearest slice angle so that ticker always aligned with the slice
                let finalSlice = round((rotation.radians + velocityFactor.radians) / perSliceAngle.radians)
                let finalRotation = perSliceAngle * finalSlice
                withAnimation(.easeOut(duration: 5)) {
                    rotation = finalRotation
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                    let slice = Int(finalSlice)
                    let itemIndex = slice % data.count
                    withAnimation {
                        self.value = data[itemIndex]
                    }
                }
            }
    }
}


struct SpinWheel_Previews: PreviewProvider {
    static let items = [
        "1",
        "2",
        "3",
        "4",
        "5",
    ]
    
    static var previews: some View {
        SpinWheelPicker(data: items, id: { $0 }, value: .constant(nil)) { item in
            Text(item)
        }
        .padding(20)
        .preferredColorScheme(.dark)
    }
}
