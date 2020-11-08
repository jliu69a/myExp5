//
//  Constants.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 11/8/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

struct MEConstants {
    
    static let kHomePageStoryboardName = "expense"
    static let kHomePageStoryboardId = "MyExpHomeViewController"
    
    static let kChangeDateStoryboardId = "ChangeDateViewController"
}

enum MEStoryboard {
    case home(MEHomePage)
    
    var board: UIStoryboard {
        switch self {
        case .home: return UIStoryboard(name: MEConstants.kHomePageStoryboardName, bundle: nil)
        }
    }
    
    var vc: UIViewController {
        switch self {
        case .home(let page): return self.board.instantiateViewController(identifier: page.vcId)
        }
    }
}

enum MEHomePage {
    case home, changeDate
    
    var vcId: String {
        switch self {
        case .home: return MEConstants.kHomePageStoryboardId
        case .changeDate: return MEConstants.kChangeDateStoryboardId
        }
    }
}
