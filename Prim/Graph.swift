//
//  Graph.swift
//  Prim
//
//  Created by Andrew Wang on 3/18/15.
//  Copyright (c) 2015 Andrew Wang. All rights reserved.
//

import Cocoa

struct Point: Hashable, Printable {
    let x: Int, y: Int
    var hashValue: Int {
        return x * 1000 + y
    }
    var description: String {
        return "(\(x), \(y))"
    }
}
func ==(a: Point, b: Point) -> Bool {
    return a.x == b.x && a.y == b.y
}

class Edge: Comparable {
    let a: Node
    let b: Node
    let weight: Double
    var totalDist: Double = 0.0
    init(a: Node, b: Node, weight: Double) {
        self.a = a
        self.b = b
        self.weight = weight
    }
}
func <(a: Edge, b: Edge) -> Bool {
    return a.weight < b.weight
}
func ==(a: Edge, b: Edge) -> Bool {
    return a.weight == b.weight
}

class Node: Hashable, Equatable {
    let point: Point
    var edges = [Edge]()
    
    init(x: Int, y: Int) {
        self.point = Point(x: x, y: y)
    }
    
    var hashValue: Int {
        return point.hashValue
    }
}
func ==(a: Node, b: Node) -> Bool {
    return a.point == b.point
}