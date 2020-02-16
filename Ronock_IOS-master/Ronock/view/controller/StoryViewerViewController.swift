//
//  StoryViewerViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 1/6/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import ImageSlideshow
import SRCountdownTimer

class StoryViewerViewController: BaseViewController {

    var stories: [Story]?
    var pos: Int = 0

    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var timer: SRCountdownTimer!
    @IBOutlet weak var seeAdButton: UIButton!
    
    var didRegularAdClicked: (() -> ())?
    var didVideoAdClicked: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewer(position: pos, storyiesList: stories ?? [])

        timer.start(beginingValue: 10, interval: 1)
        timer.delegate = self
        timer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        timer.lineWidth = 3.0
        timer.labelTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        timer.lineColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapHandler))
        tap.minimumPressDuration = 0
        slideshow.addGestureRecognizer(tap)
        
    }
    
    func setupViewer(position: Int, storyiesList: [Story]) {
        
        var imageSources: [AlamofireSource] = []
        for img in storyiesList {
            imageSources.append(AlamofireSource(urlString: img.detailsImage ?? "") ?? AlamofireSource(urlString: "https://procuredigitalmedia.com/wp-content/uploads/2017/03/pricing_497_ads-1.jpg")!)
        }
        
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideshow.draggingEnabled = false
        slideshow.pageIndicator = nil
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.delegate = self

        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        slideshow.setImageInputs(imageSources)

        slideshow.setCurrentPage(position, animated: false)
        
    }

    
    @objc func tapHandler(gesture: UITapGestureRecognizer) {

           // handle touch down and touch up events separately
           if gesture.state == .began {
            self.timer.pause()
           } else if gesture.state == .ended { // optional for touch up event catching
              self.timer.resume()
           }
       }
    
    @IBAction func closeVIewerCLicked(_ sender: Any) {
        dismiss(animated: true, completion: {})
    }
    
    var currentTimestamp = Date().timeIntervalSince1970
    @IBAction func holdTimerClicked(_ sender: Any) {
        currentTimestamp = Date().timeIntervalSince1970
        self.timer.pause()
    }
    
    @IBAction func releaseTimerClicked(_ sender: Any) {
        let interval = Date().timeIntervalSince1970 - currentTimestamp
        print(interval)
        
        if interval > 0.4 {
            self.timer.resume()
        }else{
            slideshow.nextPage(animated: true)
        }
        
    }
    @IBAction func prevHoldTimerClicked(_ sender: Any) {
        currentTimestamp = Date().timeIntervalSince1970
        self.timer.pause()
    }
    
    @IBAction func prevReleaseTimerClicked(_ sender: Any) {
        let interval = Date().timeIntervalSince1970 - currentTimestamp
        print(interval)
        
        if interval > 0.4 {
            self.timer.resume()
        }else{
            slideshow.previousPage(animated: true)
        }
    }
    
    @IBAction func seeAdOrVideoClicked(_ sender: Any) {
        dismiss(animated: true, completion: {})
        if self.stories![pos].type == 1 { // Regular Ad
            print("Regualr Ad")
            didRegularAdClicked!()
        }else if self.stories![pos].type == 2{ // Video Ad
            print("Video Ad")
            didVideoAdClicked!()
        }
    }
}

extension StoryViewerViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
        self.pos = page
        self.timer.start(beginingValue: 10, interval: 1)
        
        if self.stories![pos].type == 1 { // Regular Ad
            self.seeAdButton.setTitle("See Ad", for: .normal)
        }else if self.stories![pos].type == 2{ // Video Ad
            self.seeAdButton.setTitle("Play Video", for: .normal)
        }
    }
}

extension StoryViewerViewController: SRCountdownTimerDelegate{
    func timerDidStart() {
        
    }
    func timerDidEnd() {
        self.slideshow.nextPage(animated: true)
    }
    func timerDidPause() {
        
    }
    func timerDidResume() {
        
    }
}
