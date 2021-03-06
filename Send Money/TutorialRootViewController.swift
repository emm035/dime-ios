//
//  TutorialRootViewController.swift
//  Send Money
//
//  Created by Eric Marshall on 8/17/15.
//  Copyright (c) 2015 Eric Marshall. All rights reserved.
//

import UIKit

class TutorialRootViewController: UIViewController {
    
    var imageNames = ["AppIconText","ExpenseContent", "ExpenseTable", "ReportTable", "ReportContent"]
    var currentIndex = 0
    var shownAtBeginning = true
    var pageViewController: UIPageViewController!
    var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !shownAtBeginning {
            imageNames.remove(at: 0)
        }
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.backgroundColor = .barTintColor()
        pageViewController.dataSource = self
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: view.bounds.height - 40, width: view.bounds.width, height: 40))
        pageControl.backgroundColor = .clear
        
        self.view.addSubview(pageControl)
        
        let firstVC = viewControllerAtIndex(0)!
        pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        pageViewController!.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height + 40)
        
        
        self.addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParentViewController: self)
    }
}

extension TutorialRootViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TutorialContentViewController).page
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index! -= 1
        
        return viewControllerAtIndex(index!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TutorialContentViewController).page
        
        if index == NSNotFound {
            return nil
        }
        
        index! += 1
        
        if (index == imageNames.count) {
            return nil
        }
        
        return viewControllerAtIndex(index!)
    }
    
    func viewControllerAtIndex(_ index: Int) -> TutorialContentViewController? {
        
        if self.imageNames.count == 0 || index >= self.imageNames.count {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "TutorialContentViewController") as! TutorialContentViewController
        pageContentViewController.page = index
        pageContentViewController.image = UIImage(named: imageNames[index])
        pageContentViewController.shownAtBeginning = shownAtBeginning
        
        currentIndex = index
        
        return pageContentViewController
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.imageNames.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        pageControl.updateCurrentPageDisplay()
        return currentIndex
    }
}
