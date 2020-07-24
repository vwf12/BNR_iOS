//
//  DrawView.swift
//  TouchTracker
//
//  Created by FARIT GATIATULLIN on 13.07.2020.
//  Copyright © 2020 vwf. All rights reserved.
//

import UIKit

class DrawView: UIView, UIGestureRecognizerDelegate {
    
    
    var currentLines = [NSValue: Line]()
    var finishedLines = [Line]()
    var selectedLineIndex: Int? {
        didSet {
            if selectedLineIndex == nil {
                let menu = UIMenuController.shared
                menu.hideMenu(from: self)
            }
        }
    }
    var moveRecognizer: UIPanGestureRecognizer!
    var longPressRecognizer: UILongPressGestureRecognizer!
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var selectedLineColor: UIColor = UIColor.green {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func stroke(_ line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round

        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {

        finishedLineColor.setStroke()
        for line in finishedLines {
            //line.color.setStroke()
            stroke(line)
        }
        
        currentLineColor.setStroke()
        for (_, line) in currentLines {
            //line.color.setStroke()
            stroke(line)
            
            selectedLineColor.setStroke()
            
            if let index = selectedLineIndex {
                UIColor.green.setStroke()
                let selectedLine = finishedLines[index]
                stroke(selectedLine)
                setNeedsDisplay()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        Log statement to see the order of events
        print(#function)
        
        for touch in touches {
            let location = touch.location(in: self)
            
            let newLine = Line(begin: location, end: location)
            
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       //        Log statement to see the order of events
       print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        Log statement to see the order of events
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)
                
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        Log statement to see the order of events
        print(#function)
        
        currentLines.removeAll()
        setNeedsDisplay()
    }
    
    // MARK: init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
         longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DrawView.longPress(_:)))
        
        addGestureRecognizer(longPressRecognizer)
        
        moveRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DrawView.moveLine(_:)))
        moveRecognizer.delegate = self
        moveRecognizer.cancelsTouchesInView = false
        
        addGestureRecognizer(moveRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
       

    }
    
    @objc func doubleTap(_ gestureRegognizer: UIGestureRecognizer) {
        print("Recognized a double tap")
        
        selectedLineIndex = nil
        currentLines.removeAll()
        finishedLines.removeAll()
        setNeedsDisplay()
    }
    
    @objc func tap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a tap")
        
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLine(at: point)
        
//        Grab the menu controller
        let menu = UIMenuController.shared
        
        if selectedLineIndex != nil {
            
//            Make DrawView the target
            becomeFirstResponder()
            
//            Create a new "Delete" UIMenuItem
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(DrawView.deleteLine(_:)))
            menu.menuItems = [deleteItem]
            
//            Tell the menu where it should come from and show it
            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            //menu.setTargetRect(targetRect, in: self)
            menu.showMenu(from: self, rect: targetRect)
            //menu.setMenuVisible(true, animated: true)
        } else {
//            Hide the menu if no line is selected
            menu.hideMenu(from: self)

        }
        
        setNeedsDisplay()
    }
    
    func indexOfLine(at point: CGPoint) -> Int? {
//        Find a line close to point
        for (index, line) in finishedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            
//            Check a few points on the line
            for t in stride(from: CGFloat(0), to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
//                If tapped point is within 20 points, let's return this line
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
            
        }
//        If nothing is close enough to the tapped point, when we did not select a line
        return nil
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func deleteLine(_ sender: UIMenuController) {
//        Remove the selected line from the list of finished lines
        if let index = selectedLineIndex {
            finishedLines.remove(at: index)
            selectedLineIndex = nil
            
//            Redraw
            setNeedsDisplay()
        }
    }
    
    @objc func longPress(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a long press")
        
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: self)
            selectedLineIndex = indexOfLine(at: point)
            
            if selectedLineIndex != nil {
                currentLines.removeAll()
            }
        } else if gestureRecognizer.state == .ended {
            selectedLineIndex = nil
        }
        setNeedsDisplay()
    }
    @objc func moveLine(_ gestureRecognizer: UIPanGestureRecognizer) {
        print("Recognized a pan")
        guard longPressRecognizer.state == .changed || longPressRecognizer.state == .ended else {
        return
        }
//        If a line is selected...
        if let index = selectedLineIndex {
//            Whenthe pan recognizer changes its position...
            if gestureRecognizer.state == .changed {
//                How gar has the pan moved?
                let translation = gestureRecognizer.translation(in: self)
                
//                Add the translation to current beginning and end points of the line
                finishedLines[index].begin.x += translation.x
                finishedLines[index].begin.y += translation.y
                finishedLines[index].end.x += translation.x
                finishedLines[index].end.y += translation.y
                
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
                
//                Redraw the screen
                setNeedsDisplay()
            }
            else {
//                If no line is selected, do not do anything
                return
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
