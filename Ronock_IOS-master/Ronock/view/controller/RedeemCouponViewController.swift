//
//  RedeemCouponViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 12/25/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class RedeemCouponViewController: BaseViewController {

    // MARK: - Injection
    let viewModel = RedeemCouponViewModel(repository: Repository.shared)
    
    var countTimer:Timer!
    var counter = 10
    
    var couponID: String?
    
    @IBOutlet weak var startRedeemButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    @objc func changeTitle()
    {
         if counter != 0
         {
             startRedeemButton.setTitle("\(counter)", for: .normal)
             counter -= 1
         }
         else
         {
              countTimer.invalidate()

              startRedeemButton.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            startRedeemButton.setTitle("Redeemed Success", for: .normal)
            startRedeemButton.isEnabled = false
         }

    }
    
    @IBAction func redeemNowClicked(_ sender: Any) {
        self.countTimer = Timer.scheduledTimer(timeInterval: 1 ,
        target: self,
        selector: #selector(self.changeTitle),
        userInfo: nil,
        repeats: true)
        startRedeemButton.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    }
}
