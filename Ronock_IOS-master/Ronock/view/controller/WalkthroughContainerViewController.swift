//
//  WalkthroughContainerViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 1/9/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import Pageboy

class WalkthroughContainerViewController: PageboyViewController, PageboyViewControllerDataSource {

    var walkthroughPages: [UIViewController]?{
        didSet{
            reloadData()
            
            pageIndicator.numberOfPages = walkthroughPages?.count ?? 1
            pageIndicator.currentPage = 0
            view.bringSubviewToFront(pageIndicator)
        }
    }
    // MARK: - Injection
    let viewModel = WalkthroughContainerViewModel(repository: Repository.shared)
    
    @IBOutlet weak var pageIndicator: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        delegate = self
        dataSource = self
        viewModel.didFinishFetch = { pages in
            
            var controllers: [UIViewController] = []
            
            //THis if statement to show list of walkthrough pages just if the use first time enter the app, else show just login page
            if !UserDefaults.standard.bool(forKey: Constants.SharedPreferencesKeys.PREFS_KEY_NOT_FIRST_TIME) {
                for page in pages {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "WalkthroughPageViewController") as! WalkthroughPageViewController
                    vc.walkthrough = page
                    controllers.append(vc)
                    
                }
            }
            
             let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            controllers.append(loginVC!)
            self.walkthroughPages = controllers
        }
        
        viewModel.fetchWalkthroughPages()
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return walkthroughPages?.count ?? 0
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return walkthroughPages?[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    func pageboyViewController(_ pageboyViewController: PageboyViewController, willScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIDs.WALKTHOUGH_TO_MAIN_SEGUE{
            UserDefaults.standard.set(true, forKey: Constants.SharedPreferencesKeys.PREFS_KEY_NOT_FIRST_TIME)
        }
    }
}

// MARK: PageboyViewControllerDelegate
extension WalkthroughContainerViewController: PageboyViewControllerDelegate {
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didReloadWith currentViewController: UIViewController, currentPageIndex: PageboyViewController.PageIndex) {
        
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didCancelScrollToPageAt index: PageboyViewController.PageIndex,
                               returnToPageAt previousIndex: PageboyViewController.PageIndex) {
//        print("didCancelScrollToPageAt: \(index), returnToPageAt: \(previousIndex)")
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollTo position: CGPoint,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
        
        
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToPageAt index: PageboyViewController.PageIndex,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
        self.pageIndicator.currentPage = index
        
    }
    
}
