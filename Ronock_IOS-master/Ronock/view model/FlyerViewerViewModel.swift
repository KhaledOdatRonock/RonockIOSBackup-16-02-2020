//
//  FlyerViewerViewModel.swift
//  Ronock
//
//  Created by Khaled Odat on 10/20/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
class FlyerViewerViewModel{
    // MARK: - Properties
    //    private var ToDoList: [TodoResponse]? {
    //        didSet {
    //            guard let p = ToDoList else { return }
    //            self.didFinishFetch?(p)
    //        }
    //    }
    var error: Error? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    private var repository: Repository?
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: ((_ sliceClippedResponse: String?) -> ())?
    
    // MARK: - Constructor
    init(repository: Repository) {
        self.repository = repository
    }
    
    func clipSLice(clipped: ClippedSliceParams){
        repository?.cartRepository.clipSlice(clipped: clipped, completion: { response, error in
            self.didFinishFetch!(response ?? "")
        })
    }
    
    func unClipSLice(unclipped: UnClipSliceParams){
        repository?.cartRepository.unClipSlice(clipped: unclipped, completion: { response, error in
            self.didFinishFetch!(response ?? "")
        })
    }
    
}
