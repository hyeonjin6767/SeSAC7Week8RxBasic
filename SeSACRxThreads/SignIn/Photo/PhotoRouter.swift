//
//  PhotoRouter.swift
//  SeSACRxThreads
//
//  Created by Jack on 8/18/25.
//

import Foundation
import Alamofire

enum PhotoRouter {
    
    case random
    
    var baseURL: String {
        return "https://api.unsplash.com/"
    }
     
    var endPoint: URL {
        switch self {
        case .random:
            URL(string: baseURL + "photos/random")!
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters {
        switch self {
        case .random:
            return ["client_id": "\(PhotoKey.access)"]
        }
    }
}

