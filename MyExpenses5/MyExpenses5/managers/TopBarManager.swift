//
//  TopBarManager.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 3/5/21.
//  Copyright © 2021 Home Office. All rights reserved.
//

import UIKit

class TopBarManager: NSObject {
    
    static let sharedInstance = TopBarManager()
    
    func createTopHeader(frame: CGRect, title: String, isForAdmin: Bool) -> TopHeaderViewController? {
        var topHeader: TopHeaderViewController? = nil
        
        let storyboard = UIStoryboard(name: "topheader", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "TopHeaderViewController") as? TopHeaderViewController {
            vc.view.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
            vc.headerTitle = title
            vc.isForAdmin = isForAdmin
            topHeader = vc
        }
        return topHeader
    }
}
