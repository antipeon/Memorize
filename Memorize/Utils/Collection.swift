//
//  Collection.swift
//  Memorize
//
//  Created by Samat Gaynutdinov on 03.07.2022.
//

import Foundation

extension Collection {
    func index(matching element: Element) -> Self.Index? where Element: Identifiable {
        self.firstIndex { element.id == $0.id}
    }
    
    func indexOfOneAndOnly(_ predicate: (Element) -> Bool) -> Self.Index? {
        let filteredIndices = indices.filter {
            predicate(self[$0])
        }
        guard filteredIndices.count == 1 else {
            return nil
        }
        return filteredIndices.first
        
    }
}

extension RangeReplaceableCollection where Element: Identifiable {
    mutating func remove(_ element: Element) {
        if let index = index(matching: element) {
            remove(at: index)
        }
    }
    
    subscript(_ element: Element) -> Element {
        get {
            if let index = index(matching: element) {
                return self[index]
            }
            return element
        }
        set {
            if let index = index(matching: element) {
                replaceSubrange(index...index, with: [newValue])
            }
        }
    }
}

extension Int {
    func random() -> Int {
        Int(arc4random_uniform(UInt32(self)))
    }
}
