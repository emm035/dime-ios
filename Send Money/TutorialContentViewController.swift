//
//  TutorialContentViewController.swift
//  Send Money
//
//  Created by Eric Marshall on 8/16/15.
//  Copyright (c) 2015 Eric Marshall. All rights reserved.
//

import UIKit
import RealmSwift

class TutorialContentViewController: UIViewController {
    
    @IBAction func doneWithTutorial(_ sender: UIButton) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "mainAppRootTabController") as! CustomTabViewController
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func stopShowingTutorial(_ sender: UIButton) {
        let realm = try! Realm()
        try! realm.write {
            realm.objects(Settings.self)[0].showTutorial = false
        }
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "mainAppRootTabController") as! CustomTabViewController
        self.present(nextVC, animated: true, completion: nil)
    }

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var dontShowAgainButton: UIButton!
    @IBOutlet weak var tutorialImage: UIImageView!
    
    var page: Int!
    var image: UIImage!
    var shownAtBeginning = true
    
    override func viewDidLoad() {
        tutorialImage.image = self.image
        
        doneButton.alpha = 0.0
        doneButton.isEnabled = false
        view.bringSubview(toFront: doneButton)
        dontShowAgainButton.alpha = 0.0
        dontShowAgainButton.isEnabled = false
        view.bringSubview(toFront: dontShowAgainButton)
        
        switch page {
            case 0:
                if shownAtBeginning {
                    view.backgroundColor = .blueTintColor()
//                    view.backgroundColor = .barTintColor()
                }
                else {
                    view.backgroundColor = .blueTintColor()
                }
            case 1:
                view.backgroundColor = .blueTintColor()
            case 2:
                if shownAtBeginning {
                    view.backgroundColor = .blueTintColor()
                }
                else {
                    view.backgroundColor = .greenTintColor()
                }
            case 3:
                view.backgroundColor = .greenTintColor()
            case 4:
                view.backgroundColor = .greenTintColor()
            default:
                fatalError("Should never have more than 5 controllers")
        }
        
        if shownAtBeginning {
            performButtonSetup()
        }
    }

    func performButtonSetup() {
        doneButton.titleLabel?.textColor = .white
        doneButton.layer.backgroundColor = UIColor.blueTintColor().cgColor
        doneButton.layer.borderColor = doneButton.titleLabel?.textColor.cgColor
        doneButton.layer.cornerRadius = doneButton.frame.height / 7
        doneButton.layer.borderWidth = 1.0
        
        dontShowAgainButton.titleLabel?.textColor = .white
        dontShowAgainButton.layer.backgroundColor = UIColor.blueTintColor().cgColor
        dontShowAgainButton.layer.borderColor = dontShowAgainButton.titleLabel?.textColor.cgColor
        dontShowAgainButton.layer.cornerRadius = dontShowAgainButton.frame.height / 7
        dontShowAgainButton.layer.borderWidth = 1.0
        
        if page == 4{
            doneButton.alpha = 1.0
            doneButton.isEnabled = true
            dontShowAgainButton.alpha = 1.0
            dontShowAgainButton.isEnabled = true
        }
    }
}
