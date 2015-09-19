//
//  Array2DTyped.swift
//  SARAssist
//
//  Created by V-FEXrt on 9/18/15.
//  Copyright (c) 2015 V-FEXrt. All rights reserved.
//

import UIKit

class Array2DTyped<T>{
    
    var cols:Int, rows:Int
    var matrix:[T]
    
    private let defaultValue:T
    
    init(cols:Int, rows:Int, defaultValue:T){
        self.cols = cols
        self.rows = rows
        self.defaultValue = defaultValue
        
        matrix = Array(count:cols*rows,repeatedValue:defaultValue)
    }
    
    subscript(col:Int, row:Int) -> T {
        get{
            return matrix[cols * row + col]
        }
        set{
            matrix[cols * row + col] = newValue
        }
    }
    
    subscript(col:Int)-> [T] {
        get{
            var arr:[T] = Array(count: self.rows, repeatedValue: self.defaultValue)
            for( var i:Int = 0; i < self.rows; i++){
                arr[i] = self[col, i]
            }
            return arr
        }
    }
    
    func colCount() -> Int {
        return self.cols
    }
    
    func rowCount() -> Int {
        return self.rows
    }
}