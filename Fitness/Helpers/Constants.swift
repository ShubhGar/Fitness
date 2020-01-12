//
//  Constants.swift
//  Fitness
//
//  Created by Shubham Garg on 12/12/19.
//  Copyright © 2019 Shubham Garg. All rights reserved.
//

import Foundation
//MARK: Questions
enum Questions:String, CaseIterable{
    case question1 = "Did you think about what you wanted to do and how to do it?"
    case question2 = "Did you concentrate or was your mind somewhere else?"
    case question3 = "Did you practice the way you want to play?"
    case question4 = "Did the way you ate totally made you feel...?"
    case question5 = "Did you wake up feeling...?"
}


//MARK: Top labels
enum TopOptoins:String, CaseIterable{
    case topOption1 = "BRINGING IT"
    case topOption2 = "DEALED IN"
    case topOption3 = "TOTALLY INTO IT"
    case topOption4 = "FUELED"
    case topOption5 = "TOTALLY RESTED"
}


//MARK: Bootom labels
enum BottomOptions:String, CaseIterable{
    case bottomOption1 = "WINGING IT"
    case bottomOption2 = "DISTRACTED"
    case bottomOption3 = "JUST GOT THROUGH IT"
    case bottomOption4 = "DRAINED"
    case bottomOption5 = "TIRED"
}

let DONE = "Done"
