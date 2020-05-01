//
//  Array+Extension.swift
//  Nicea
//
//  Created by Stephen Bodnar on 4/18/20.
//  Copyright © 2020 Stephen Bodnar. All rights reserved.
//

import Foundation
import APIClient

extension Array where Element == Comment {
    
    func flattenedArray() -> [Comment] {
        var myArray = [Comment]()
        for element in self {
            myArray.append(element)
            if let commentReplies = element.data.replies?.data?.children {
                let newFlattenedArray = commentReplies.flattenedArray()
                for i in newFlattenedArray {
                    myArray.append(i)
                }
            }
        }
        
        return myArray
    }
}
