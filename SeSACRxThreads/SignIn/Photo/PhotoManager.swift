//
//  PhotoManager.swift
//  SeSACRxThreads
//
//  Created by Jack on 8/18/25.
//

import Foundation
import Alamofire

class PhotoManager {
    
    static let shared = PhotoManager()

    private init() { }
    
    func getRandomPhoto(api: PhotoRouter, success: @escaping (Photo) -> Void) {
        AF.request(api.endPoint,
                   method: api.method,
                   parameters: api.parameters, //키를 깜빡하고 입력안하면 401에러가 오는데 이때도 성공시때처럼 실패시에도 제이슨구조로 잘 알려주긴함 그러면 실패시에 오는 이 제이슨도 디코딩할 수는 없을까?
                   encoding: URLEncoding(destination: .queryString))
        .validate(statusCode: 200..<300) //"200번대 일때 성공으로 떨어진다고 설정"// validate : 기본 내장되어 있어서 안써도 괜춘은 함(success status code(성공 판단 기준을 지정))
//웬만하면 다 성공하게 범주를 늘리기도( 200..<500)
        .responseDecodable(of: Photo.self) { response in
            switch response.result {
            case .success(let value):
                dump(value)
                success(value)
            case .failure(let error):
                print("fail", error)
                
                let code = response.response?.statusCode ?? 500 //혹시 문제발생시 500으로 대체
            
                let errorType = NetworkError(rawValue: code) ?? .unkownError
                print(errorType.userResponse) //아래 스위치문을 한줄로
                
//                switch errorType {
//                case .badRequset: print("Bad Requset") //에러가 숫자로 되어있으니 열거형도 고려해볼 수 있겠다
//                case .unauthorized: print("Unauthorized")
//                case .forbidden: print("Forbidden")
//                case .notFound: print("Not Found")
//                case .serverError, .UnkownError: print("Server Error")
//                }
                
            }
        }
        
        
        
        
        
//        .responseDecodable(of: Photo.self) { response in
//                   switch response.result {
//                   case .success(let value):
//                       dump(value)
//       
//                       success(value)
//       
//                   case .failure(let error):
//                       print("fail", error)
//                       //아예 실패케이스에 똑같이 두트라이캐치 넣기
//                       guard let code = response.response?.statusCode,
//                                let data = response.data else {
//                           return
//                       }
//                       do {
//                           let result = try JSONDecoder().decode(PhotoError.self, from: data) // 포토 그릇에 잘 담겼는지 확인
//                           dump(result)
//                       } catch {
//                           
//                           print("에러 구조체에 담기 실패, 200-299 디코딩 실패도 이쪽으로 옴")
//                       }
//                   }
//       
//               }
        
        
        
        
        
        
//        .responseString { response in
//            
//            let code = response.response?.statusCode ?? 500
//            
//            //성공실패와 관계없이 데이터를 기준으로 나눌 수 있는
//            guard let data = response.data else {
//                return
//            }
//            switch code {
//            case 200..<300 : //성공에 대한 식판(Photo)에 담기
//                do {
//                    let result = try JSONDecoder().decode(Photo.self, from: data) // 포토 그릇에 잘 담겼는지 확인
//                    dump(result)
//                } catch {
//                    //식판에 잘 담지 못한 상황
//                    print("Photo 구조체에 담기 실패")
//                }
//            default: //실패에 대한 식판(PhotoError)에 담기
//                do {
//                    let result = try JSONDecoder().decode(PhotoError.self, from: data) // 포토 그릇에 잘 담겼는지 확인
//                    dump(result)
//                } catch {
//                    //식판에 잘 담지 못한 상황
//                    print("Photo 구조체에 담기 실패")
//                }
//            }
//            
//        }
        
    
        
        
//        .responseDecodable(of: Photo.self) { response in //responseDecodable(을 사용할 경우는 디코딩 실패시 failure)는 Photo.self때문에 하나의 모델에 대해서만 디코딩이 가능! 하지만 실패한 경우에도 디코딩이 필요할 수 있다
//            switch response.result {
//            case .success(let v=alue):
//                dump(value)
//                
//                success(value)
//                
//            case .failure(let error):
//                print("fail", error)
//            }
//            
//        }
        
        

        
//        .responseString(completionHandler: { response in  // responseString도 스위치문 사용가능! : 틀에 너무 갇히지마 : 대신 value값이 무조건 string으로 들어옴
//            switch response.result {
//            case .success(let value):
//                dump(value)
//                
//                dump(value)
//                
//            case .failure(let error):
//                print("fail", error)
//            }
//        })
//        
        
        
    }
    
}

