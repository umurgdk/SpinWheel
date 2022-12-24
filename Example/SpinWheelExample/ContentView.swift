//
//  ContentView.swift
//  SpinWheel
//
//  Created by Umur Gedik on 22.12.2022.
//

import SwiftUI
import SpinWheel

struct ContentView: View {
    @State var prize: String?
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(CGColor(gray: 0.1, alpha: 1))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            SpinWheelPicker(data: items, id: { $0 }, value: $prize) { item in
                Text(item)
                    .foregroundColor(.black)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .padding(.trailing, 18)
            }
            .padding(20)
            .frame(maxHeight: .infinity)
            
            if let prize = prize {
                VStack {
                    Text("Congrats!").font(.system(size: 15, weight: .bold, design: .rounded))
                    Text(prize)
                        .font(.system(size: 21))
                        .foregroundColor(.white)
                }
                .padding(.vertical, 32)
                .id(prize)
                .transition(.opacity.combined(with: .scale(scale: 2)))
            }
            
        }
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
