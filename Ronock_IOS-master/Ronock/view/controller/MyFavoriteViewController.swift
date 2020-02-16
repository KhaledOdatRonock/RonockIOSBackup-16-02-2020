//
//  MyFavoriteViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 1/15/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import Pageboy

extension UIPageViewController {

    func goToNextPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: animated, completion: nil)
    }

    func goToPreviousPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
        setViewControllers([previousViewController], direction: .reverse, animated: animated, completion: nil)
    }

}
class MyFavoriteViewController: PageboyViewController, PageboyViewControllerDataSource {

    var myFavoritePages: [UIViewController] = []
    var didPageChanged: ((_ currentPage: Int) -> ())?
   
    var vc1: FavoriteAdsViewController?
    var vc2: MyCouponsViewController?
    var vc3: CartViewController?
    
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let userManagmentStoryboard = UIStoryboard(name: "UserManagment", bundle: nil)
    let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
    let flyersStoryboard = UIStoryboard(name: "Flyer", bundle: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        delegate = self
        dataSource = self
        
        vc1 = (profileStoryboard.instantiateViewController(withIdentifier: "FavoriteAdsViewController")) as? FavoriteAdsViewController
        vc2 = (profileStoryboard.instantiateViewController(withIdentifier: "MyCouponsViewController")) as? MyCouponsViewController
        vc3 = (flyersStoryboard.instantiateViewController(withIdentifier: "CartViewController")) as? CartViewController
           
        myFavoritePages.append(vc1!)
        myFavoritePages.append(vc2!)
        myFavoritePages.append(vc3!)
        
        reloadData()
    }
    
    func changeCurrentPage(index: Int) {
        scrollToPage(.at(index: index), animated: true)
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return myFavoritePages.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return myFavoritePages[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    func pageboyViewController(_ pageboyViewController: PageboyViewController, willScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        
    }
    
}


// MARK: PageboyViewControllerDelegate
extension MyFavoriteViewController: PageboyViewControllerDelegate {
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

        //TODO: update tab view
        if didPageChanged != nil {
            self.didPageChanged!(index)
        }
        
    }
    
}
