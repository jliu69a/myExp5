//
//  EditExpsViewModel.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 10/19/22.
//  Copyright © 2022 Home Office. All rights reserved.
//

import UIKit
import Foundation
import Combine


class EditExpsViewModel: NSObject {
    
    let maxCardNumberLength: Int = 4
    let maxZipcodeLength: Int = 5
    
//    @Published var last4CardNumber: String = ""
//    @Published var ownerZipCode: String = ""
    
    @Published var priceValueText: String = ""
    @Published var selectedPaymentType: String = ""
    @Published var selectedVendor: String = ""
    
    var isValidUserInputVerification: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest($priceValueText)
            .receive(on: DispatchQueue.main)
            .map { priceValue in
                return (priceValue.count > 0)
            }
            .eraseToAnyPublisher()
    }
    
//    var isValidUserInputVerification: AnyPublisher<Bool, Never> {
//        return Publishers.CombineLatest($last4CardNumber, $ownerZipCode)
//            .receive(on: DispatchQueue.main)
//            .map { last4Digits, ownerZipCode in
//                return ((last4Digits.count == self.maxCardNumberLength) && (ownerZipCode.count == self.maxZipcodeLength))
//            }
//            .eraseToAnyPublisher()
//    }
}
