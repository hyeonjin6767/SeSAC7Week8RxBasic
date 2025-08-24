//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 박현진 on 8/21/25.
//

import Foundation
import RxSwift
import RxCocoa

class PhoneViewModel {
    
    
    // rx에서 인풋/아웃풋 패턴은 "타입"만 잘 확인하면 됨!
    
    
    struct Input {
        
        //버튼 클릭시 Input으로 받아오고
        let buttonTap: ControlEvent<Void>  // 커스텀 옵저버때 처럼 버튼 클릭 액션을 받아와보자 :nextButton.rx.tap요소가 들어오게 됨
    }
    
    struct Output {
        
        // 어떤 로직을 거쳐서 Output에서는 텍스트를 꺼내주는 형태 : 레이블에 보여줄 아웃풋이 레이블에 보여줄 텍스트가 될것. : 어떤 데이터를 전해줄지 어떻게 타입을 보내줄지가 문제.
//        let text: BehaviorSubject<String>
        let text: PublishSubject<String>
        
        let palceholder: BehaviorSubject<String>
        let next: BehaviorSubject<String>

    }
    
    private let disposeBag = DisposeBag()

    init() {
        
        // 인잇을 사용하는 경우도 있고, transform메서드를 쓰는 경우도 있다~ : 정해진 틀은 아니다 나중에~
        
    }
    
    // 많이 사용하는 패턴 : transform 메서드
    func transform(input: Input) -> Output {
        
//        let text = BehaviorSubject(value: "") // 초기값이 없으므로 빈칸이 보임 : "a" 넣으면 빌드직후 a가 보임
        let text = PublishSubject<String>() // 초기값이 필요없으므로 BehaviorSubject말고 PublishSubject를 사용
        let ph = BehaviorSubject(value: "연락처를 입력해주세요")
        let sdg = BehaviorSubject(value: "다음")
        
        input.buttonTap // nextButton.rx.tap 와 같아짐
            .bind(with: self) { owner, _ in
                text.onNext("칙촉 \(Int.random(in: 1...100))")
            }
            .disposed(by: disposeBag)

        return Output(text: text,
                      palceholder: ph,
                      next: sdg )
    }
}
