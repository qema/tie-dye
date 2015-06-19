//
//  Heap.swift
//  DataStructures
//
//  Created by Andrew Wang on 3/17/15.
//  Copyright (c) 2015 Andrew Wang. All rights reserved.
//

import Foundation

struct MinHeap<T: Comparable> {
    private var items = [T]()
    
    var size: Int {
        return items.count
    }
    
    var isEmpty: Bool {
        return size == 0
    }
    
    init(array: [T]) {
        buildHeap(array)
    }
    
    init() {
        
    }
    
    func findMin() -> T {
        assert(size > 0, "Trying to find min of empty heap")
        return items[0]
    }
    
    mutating func removeMin() {
        if size > 0 {
            // move last element to root
            items[0] = items[items.endIndex.predecessor()]
            items.removeLast()  // delete old root item
            
            percDown(0)
        }
    }
    
    mutating func extractMin() -> T {
        let minItem = findMin()
        removeMin()
        return minItem
    }
    
    mutating func insert(item: T) {
        items.append(item)
        
        percUp(items.endIndex.predecessor())
    }
    
    // helper
    private mutating func buildHeap(array: [T]) {
        items = array
        var i = size / 2 - 1
        while i >= 0 {
            percDown(i)
            i--
        }
    }
    
    private mutating func percDown(i: Int) {
        var minChild = i * 2 + 1
        if minChild < size {
            if minChild + 1 < size && items[minChild + 1] < items[minChild] {
                minChild++
            }
            
            if items[i] > items[minChild] {
                swap(&items[i], &items[minChild])
                percDown(minChild)
            }
        }
    }
    
    private mutating func percUp(i: Int) {
        if i > 0 {
            let parent = (i - 1) / 2
            if items[i] < items[parent] {
                swap(&items[i], &items[parent])
                percUp(parent)
            }
        }
    }
}