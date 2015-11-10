//
//  PrimView.swift
//  Prim
//
//  Created by Andrew Wang on 3/18/15.
//  Copyright (c) 2015 Andrew Wang. All rights reserved.
//

import Cocoa

func normRand() -> Double {
    return Double(arc4random()) / Double(Int.max)
}

class PrimView: NSView {
    let Width = 128
    let Height = 128
    
    var explored = Set<Node>()
    var frontier = MinHeap<Edge>()
    
    var rep: NSImage!
    
    override func viewDidMoveToWindow() {
        _ = NSTimer.scheduledTimerWithTimeInterval(1.0/60.0, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
        var graph = [[Node]]()
        
        // make nodes
        for y in 0..<Height {
            var row = [Node]()
            for x in 0..<Width {
                let node = Node(x: x, y: y)
                row.append(node)
            }
            graph.append(row)
        }
        
        // make edges
        for y in 0..<Height {
            for x in 0..<Width {
                if x+1<Width { graph[y][x].edges.append(Edge(a: graph[y][x], b: graph[y][x+1], weight: normRand())) }
                if y+1<Height { graph[y][x].edges.append(Edge(a: graph[y][x], b: graph[y+1][x], weight: normRand())) }
                if x-1>=0 { graph[y][x].edges.append(Edge(a: graph[y][x], b: graph[y][x-1], weight: normRand())) }
                if y-1>=0 { graph[y][x].edges.append(Edge(a: graph[y][x], b: graph[y-1][x], weight: normRand())) }
            }
        }
        
        let startNode = graph[Height/2][Width/2]
        explored.insert(startNode)
        startNode.edges.forEach { self.frontier.insert($0) }
        
        rep = NSImage(size: frame.size)
    }
    
    func update() {
        needsDisplay = true
    }
    
    var didFirst = false
    override func drawRect(dirtyRect: NSRect) {
        rep.lockFocus()
        
        if !didFirst {
            didFirst = true
            NSColor(calibratedHue: 0.0, saturation: 1.0, brightness: 0.75, alpha: 1.0).set()
            let dx = frame.size.width / CGFloat(Width)
            let dy = frame.size.height / CGFloat(Height)
            let rect = NSRect(x: CGFloat(floor(CGFloat(Width) / 2.0)) * dx, y: CGFloat(floor(CGFloat(Height) / 2.0)) * dy, width: dx, height: dy)
            NSRectFill(rect)
        }
        
        for _ in 1...4000 {
            if !frontier.isEmpty {
                let edge = frontier.extractMin()
                //println("\(edge.a.point) -> \(edge.b.point)")
                //println(explored.contains(edge.a))
                //println(explored.contains(edge.b))
                
                if explored.contains(edge.a) && !explored.contains(edge.b) {
                    explored.insert(edge.b)
                    
                    edge.b.edges.forEach { (x: Edge) -> Void in
                        x.totalDist = edge.totalDist + edge.weight
                        self.frontier.insert(x)
                    }
                    
                    let dx = frame.size.width / CGFloat(Width)
                    let dy = frame.size.height / CGFloat(Height)
                    NSColor(calibratedHue: CGFloat((edge.totalDist * 2500000 * 11) % 1.0), saturation: 1.0, brightness: 0.75, alpha: 1.0).set()
                    let rect = NSRect(x: CGFloat(edge.b.point.x) * dx, y: CGFloat(edge.b.point.y) * dy, width: dx, height: dy)
                    NSRectFill(rect)
                }
            }
        }
        
        rep.unlockFocus()
        rep.drawInRect(frame)
    }
    
    
    /*

let pixelRect = NSRect(origin: CGPoint(x: x, y: y), size: CGSize(width: dx, height: dy))
NSColor(calibratedHue: CGFloat(random() % 1000) / 1000.0, saturation: 1.0, brightness: 1.0, alpha: 1.0).set()
NSRectFill(pixelRect)
*/
}