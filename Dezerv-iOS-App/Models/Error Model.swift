//
//  Error Model.swift
//  Dezerv-iOS-App
//
//  Created by Harsh Kumar Agrawal on 17/04/23.
//

import Foundation

enum NetworkError: Error {
    case unableToParse
    case apiError
    case BadURL
}

