//
//  Data.swift
//  SpinWheel
//
//  Created by Umur Gedik on 24.12.2022.
//

import Foundation

let items: [String] = {
    let maxPoint = 250
    let points = [5, 10, 50, 100, 250]
    let emojis = ["😡", "😢", "🤷‍♀️", "🎁", "🎉"]
    
    let pointItems = points.enumerated().map { i, point in
        "\(point == maxPoint ? "🎉 " : "")\(point) pts \(emojis[i])"
    }
    
    let extras = ["Free Spin! 🎲"]
    let items = (0..<15).map { i in pointItems[i % pointItems.count] }
    return (items + extras).shuffled()
}()
