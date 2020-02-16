//
//  AdvertiserProfileViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 12/8/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class AdvertiserProfileViewController: BaseViewController {
    let viewModel = AdvertiserProfileViewModel(repository: Repository.shared)
    
    @IBOutlet weak var advertiserName: UILabel!
    @IBOutlet weak var followings: UILabel!
    @IBOutlet weak var advertiserLogo: UIImageView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var aboutAdvertiser: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.showAlertClosure = {
            
        }
        
        viewModel.updateLoadingStatus = {
            
        }
        
        viewModel.didFinishFetch = { profile in
            print(profile)
            self.advertiserName.text = profile?.advertiserName
            self.followings.text = "\(profile?.followings ?? 0)"
            self.advertiserLogo.downloaded(from: profile?.advertiserLogo ?? "")
            self.address.text = profile?.address
            self.aboutAdvertiser.text = profile?.aboutAdvertiser
            
        }
        
        viewModel.fetchProfile(advertiserID: "100")
    }
}
