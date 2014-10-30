//
//  SlotBrain.swift
//  SlotMachine
//
//  Created by Kamlesh Nanda on 10/27/14.
//  Copyright (c) 2014 Kamlesh Nanda. All rights reserved.
//

import Foundation
import UIKit

class SlotBrain {
    class func unpackSlotsIntoSlotRows(slots: [[Slot]]) -> [[Slot]] {
        var slotRow1: [Slot] = []
        var slotRow2: [Slot] = []
        var slotRow3: [Slot] = []
        
        for slotArray in slots {
            for var index = 0; index < slotArray.count; index++ {
                let slot = slotArray[index]
                if index == 0 {
                    slotRow1.append(slot)
                } else if index == 1 {
                    slotRow2.append(slot)
                } else if index == 2 {
                    slotRow3.append(slot)
                } else {
                    println("Error ")
                }
            }
        }
        var slotsInRows: [[Slot]] = [slotRow1, slotRow2, slotRow3]
        
        return slotsInRows
    }
    
    class func computeWinnings(slots: [[Slot]], inout resultString: String?) -> Int {
        var slotsInRows = unpackSlotsIntoSlotRows(slots)
        var winnings = 0
        
        var flushWinCount = 0
        var threeOfAKindWinCount = 0
        var straightWinCount = 0
        
        for slotRow in slotsInRows {
            if checkFlush(slotRow) {
                resultString = "Flush"
                flushWinCount++
                winnings++
            }
            
            if checkThreeInARow(slotRow) {
                resultString = "Three in a row"
                winnings++
                straightWinCount++
            }
            
            if checkThreeOfAKind(slotRow) {
                winnings+=3
                threeOfAKindWinCount++
            }
        }
        
        if flushWinCount == 3 {
            resultString = "Royal Flush"
            winnings += 15
        }
        
        if(straightWinCount == 3) {
            resultString = "Epic Straight"
            winnings += 1000
        }
        
        if(threeOfAKindWinCount == 3) {
            resultString = "Three all around"
            winnings += 50
        }
        
        return winnings
    }
    
    class func checkFlush(slotRow: [Slot]) -> Bool {
        let slot1 = slotRow[0]
        let slot2 = slotRow[1]
        let slot3 = slotRow[2]
        if slot1.isRed && slot2.isRed && slot3.isRed {
            return true
        } else if !slot1.isRed && !slot2.isRed && !slot3.isRed {
            return true
        } else {
            return false
        }
        
    }
    
    class func checkThreeInARow(slotRow: [Slot]) -> Bool {
        let slot1 = slotRow[0]
        let slot2 = slotRow[1]
        let slot3 = slotRow[2]
        if slot1.value == slot2.value - 1 && slot2.value == slot3.value - 1 {
            return true
        } else if slot1.value == slot2.value + 1 && slot2.value == slot3.value + 1 {
            return true
        } else {
            return false
        }
        
    }
    
    class func checkThreeOfAKind(slotRow: [Slot]) -> Bool {
        let slot1 = slotRow[0]
        let slot2 = slotRow[1]
        let slot3 = slotRow[2]
        if slot1.value == slot2.value && slot2.value == slot3.value {
            return true
        } else {
            return false
        }
        
    }
}