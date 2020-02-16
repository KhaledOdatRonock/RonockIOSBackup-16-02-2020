//
//  WalkthroughPageViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 1/9/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import Lottie

class WalkthroughPageViewController: BaseViewController {

    var walkthrough: WalkthroughPage?
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptioText: UITextView!
    @IBOutlet weak var animationViewLogo: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animationViewLogo.loopMode = .loop
        animationViewLogo.backgroundBehavior = .pauseAndRestore

        Animation.loadedFrom(url: URL(string: walkthrough!.imageURL)!, closure: {animation in
                    self.animationViewLogo.animation = animation
            self.animationViewLogo.play()
        }, animationCache: LRUAnimationCache())

        titleLbl.text = walkthrough?.titleEn
        descriptioText.text = walkthrough?.descriptionEn
        
        // Do any additional setup after loading the view.
    }
    
}
