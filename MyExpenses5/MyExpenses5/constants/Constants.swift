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
    static let kPaymentsVendorsStoryboardName = "pandv"
    
    static let kHomePageStoryboardId = "MyExpHomeViewController"
    static let kChangeDateStoryboardId = "ChangeDateViewController"
    static let kEditExpenseStoryboardId = "EditExpensesViewController"
    static let kPaymentsVendorsStoryboardId = "PaymentsVendorsViewController"
}


enum MEStoryboard {
    case home(MEHomePage), pv
    
    var board: UIStoryboard {
        switch self {
        case .home: return UIStoryboard(name: MEConstants.kHomePageStoryboardName, bundle: nil)
        case .pv: return UIStoryboard(name: MEConstants.kPaymentsVendorsStoryboardName, bundle: nil)
        }
    }
    
    var vc: UIViewController {
        switch self {
        case .home(let page): return self.board.instantiateViewController(identifier: page.vcId)
        case .pv: return self.board.instantiateViewController(identifier: MEConstants.kPaymentsVendorsStoryboardId)
        }
    }
}


enum MEHomePage {
    case home, changeDate, saveExp
    
    var vcId: String {
        switch self {
        case .home: return MEConstants.kHomePageStoryboardId
        case .changeDate: return MEConstants.kChangeDateStoryboardId
        case .saveExp: return MEConstants.kEditExpenseStoryboardId
        }
    }
}
