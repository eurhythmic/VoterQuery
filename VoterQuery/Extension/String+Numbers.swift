//
//  String+Numbers.swift
//  VoterQuery
//
//  Created by RnD on 9/1/20.
//  Copyright © 2020 RnD. All rights reserved.
//

import Foundation

extension String {
    var numbers: String {
        return filter { "0"..."9" ~= $0}
    }
}
