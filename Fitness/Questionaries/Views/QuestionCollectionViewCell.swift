//
//  QuestionCollectionViewCell.swift
//  Fitness
//
//  Created by Shubham Garg on 12/12/19.
//  Copyright © 2019 Shubham Garg. All rights reserved.
//

import UIKit

protocol SlideScrollDelegate {
    func scrollSlide(direction:Direction)
}

protocol AnswerValueDelegate{
    func valueChanged(index:Int, percentage:CGFloat)
}

class QuestionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var selectedViewHeight: NSLayoutConstraint!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var topLbl: UILabel!
    @IBOutlet weak var bottomLbl: UILabel!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var selectedView: AnimationView!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    var scrollDelegate:SlideScrollDelegate?
    var answerDelegate:AnswerValueDelegate?
    var index:Int?
    var offSet:CGPoint!
    var heightMinval:CGFloat = 70.0
    var heightMaxVal:CGFloat = 100.0
    var maxFontSize:CGFloat = 30.0
    var minFontSize:CGFloat = 20.0
    
    func setQuestion(index: Int, percentValue:CGFloat){
        self.index = index
        questionLbl.text = Questions.allCases[index].rawValue
        topLbl.text = TopOptoins.allCases[index].rawValue
        bottomLbl.text = BottomOptions.allCases[index].rawValue
        self.heightMaxVal = questionView.bounds.height
        self.setupPanGestureRecognizer(in: selectedView)
        let heightDiff = heightMaxVal - heightMinval
        let finalVal = (heightDiff * percentValue) + heightMinval
        self.setValue(finalVal: finalVal)
    }
    
    private func setupPanGestureRecognizer(in targetView: UIView) {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panRecognizerDidChange(_:)))
        targetView.addGestureRecognizer(panGestureRecognizer)
        self.panGestureRecognizer = panGestureRecognizer
    }
    
    @objc func panRecognizerDidChange(_ panRecognizer: UIPanGestureRecognizer) {
        self.layoutIfNeeded()
        let translation = panGestureRecognizer.translation(in: selectedView)
        switch panRecognizer.state {
        case .began:
            offSet = CGPoint(x: self.selectedView.bounds.minX, y: selectedViewHeight.constant)
            break
        case .changed:
            let finalVal = CGFloat(offSet.y - translation.y)
            let panningDirection = self.getScrollDirection()
            if(finalVal < self.heightMaxVal && finalVal > heightMinval) && (panningDirection == .up || panningDirection == .down){
                self.animate(finalVal: finalVal)
            }
            break
        case .ended, .failed:
            let panningDirection = self.getScrollDirection()
            if panningDirection == .left || panningDirection == .right{
                scrollDelegate?.scrollSlide(direction: panningDirection)
            }
            answerDelegate?.valueChanged(index: self.index ?? 0, percentage: self.getPercentageChange())
            break
        default: break
        }
    }
    
    func getScrollDirection()->Direction{
        let translation = self.panGestureRecognizer.translation(in: selectedView)
        let panningAngle: Degrees = atan2(Double(translation.y), Double(translation.x)) * 360 / (Double.pi * 2)
        let panningDirection = direction(for: panningAngle > 0 ? panningAngle : (panningAngle*(-1)))
        return panningDirection
    }
    
    func getPercentageChange()->CGFloat{
        let heightDiff = heightMaxVal - heightMinval
        let currentHeight = self.selectedViewHeight.constant - heightMinval
        return (currentHeight / heightDiff)
    }
    
    func animate(finalVal :CGFloat){
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.4,
                       options: [.beginFromCurrentState,.allowUserInteraction],
                       animations: {
                        self.selectedViewHeight.constant = CGFloat((finalVal))
                        self.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.1) {
            self.setValue(finalVal: finalVal)
        }
    }
    
    
    func setValue(finalVal :CGFloat){
        let percentAchive = self.getPercentageChange()
        let bottomFontColor = UIColor.white.toColor(UIColor.darkGray, percentage:CGFloat(percentAchive * 100))
        let topFontColor =  UIColor.darkGray.toColor(UIColor.white, percentage:CGFloat(percentAchive * 100))
        let fontSideDiff = (self.maxFontSize - self.minFontSize) * percentAchive
        self.bottomLbl.font = self.bottomLbl.font.withSize(self.maxFontSize - fontSideDiff)
        self.bottomLbl.textColor = bottomFontColor
        self.topLbl.font = self.topLbl.font.withSize(self.minFontSize + fontSideDiff)
        self.topLbl.textColor = topFontColor
    }
    
}

extension QuestionCollectionViewCell {
    private typealias Degrees = Double
    
    private func direction(for angle: Degrees) -> Direction {
        switch angle {
        case 45.0...135.0: return .down
        case 135.0...225.0: return .left
        case 225.0...315.0: return .up
        default: return .right
        }
    }
}

enum Direction {
    case up, down, left, right
}
