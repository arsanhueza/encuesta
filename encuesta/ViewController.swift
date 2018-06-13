//
//  ViewController.swift
//  encuesta
//
//  Created by Arturo Sanhueza on 13-06-18.
//  Copyright © 2018 Arturo Sanhueza. All rights reserved.
//

import UIKit
import SurveyNative

class ViewController: SurveyViewController, SurveyAnswerDelegate, CustomConditionDelegate, ValidationFailedDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSurveyAnswerDelegate(self)
        self.setCustomConditionDelegate(self)
        self.setValidationFailedDelegate(self)
    }
    
    override func surveyJsonFile() -> String {
        return "ExampleQuestions"
    }
    
    override func surveyTitle() -> String {
        return "Encuesta"
    }
    
    func question(for id: String, answer: Any) {
        print("Pregunta: \(id) has answer: \(answer)")
    }
    
    func isConditionMet(answers: [String: Any], extra: [String: Any]?) -> Bool {
        let id = extra!["id"] as! String
        if id == "check_age" {
            if let birthYearStr = answers["birthyear"] as? String, let ageStr = answers["age"] as? String {
                let birthYear = Int(birthYearStr)
                let age = Int(ageStr)
                let wiggleRoom = extra!["wiggle_room"] as? Int
                let date = Date()
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year], from: date)
                let currentYear =  components.year
                return abs(birthYear! + age! - currentYear!) > wiggleRoom!
            } else {
                return false
            }
        } else {
            Logger.log("Unknown custom condition check: \(id)")
            return false
        }
    }
    
    func validationFailed(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

