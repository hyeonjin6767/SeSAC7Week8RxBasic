//
//  PhotoError.swift
//  SeSACRxThreads
//
//  Created by 박현진 on 8/18/25.
//

import Foundation

enum NetworkError: Int, Error {
    
    case badRequset = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case serverError = 500
    case unkownError = 503
    
    //연산 프로퍼티 활용해서 한줄로 줄이자
    var userResponse: String {
        switch self {
        case .badRequset:
            "BadRequset 입니다"
        case .unauthorized:
            "Unauthorized 입니다"
        case .forbidden:
            "Forbidden 입니다"
        case .notFound:
            "NotFound 입니다"
        case .serverError:
            "ServerError 입니다"
        case .unkownError:
            "UnkownError 입니다"

        }
    }
    
}

