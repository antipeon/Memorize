//
//  Cardify.swift
//  Memorize
//
//  Created by Samat Gaynutdinov on 05.07.2022.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    
    var angle: CGFloat // angle of card rotation between 0 an 180 in degrees
    
    var animatableData: CGFloat {
        get {
            angle
        }
        set(newAngle) {
            angle = newAngle
        }
    }
    
    init(isFaceUp: Bool) {
        angle = isFaceUp ? 0 : 180
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            if isFaceUp {
                shape
                    .fill()
                    .foregroundColor(.white)
                shape
                    .strokeBorder(lineWidth: Constants.borderWidth)
            } else {
                shape.fill()
            }
            content.opacity(isFaceUp ? 1.0 : 0.0)
        }
        .rotation3DEffect(Angle(degrees: angle), axis: (0, 1, 0))
    }
    
    var isFaceUp: Bool {
        angle < 90.0 ? true : false
    }
    
    struct Constants {
        static let cornerRadius = 30.0
        static let borderWidth = 3.0
    }

}

extension View {
    func cardify(isFaceUp: Bool, isMatched: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
