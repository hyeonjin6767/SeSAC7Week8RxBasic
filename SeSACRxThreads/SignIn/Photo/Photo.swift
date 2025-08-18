//
//  Photo.swift
//  SeSACRxThreads
//
//  Created by Jack on 8/18/25.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let weight: Int?
    let height: Int?
    let urls: ImageURL
//    let errors: [String]? //위의 그릇을 싹다 옵셔널 처리로 바꾸고("싹 다 옵셔널 처리해주면" let errors가 새로 새롭개 추가된 새로운 형태에 그릇에도 담을 수가 있게 되는것) errors를 추가하고 그릇으로 받아보기 : 이러면 담기기는 하는데 불필요한 다른 모든 애들까지 다 옵셔널로 받게 되버리는 단점: 그래서 아래에 아예 "실패 전용 그릇"을 따로 만들자
}

struct ImageURL: Decodable {
    let regular: String
}






//실패시에도 성공시와 같이 똑같이 제이슨구조로 잘 보내주니까 그걸 그대로 전용 그릇에 담으면 되지
//아예 실패시 데이터 구조도 따로 만들어보자
struct PhotoError: Decodable {
    let errors: [String]
}
