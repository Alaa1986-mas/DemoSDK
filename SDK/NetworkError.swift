//
//  NetworkError.swift
//  HalfTunes
//
//  Created by עלאא דאהר on 10/02/2020.
//  Copyright © 2020 עלאא דאהר. All rights reserved.
//

import Foundation

public enum NetworkError : Error {
    case invalidPath
    case requestError(String)
    case parseError
}
