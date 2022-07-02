//
//  Card+Equatable.swift
//  Memorize
//
//  Created by Samat Gaynutdinov on 04.06.2022.
//

import Foundation

extension Card: Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
}
