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
        let text: BehaviorSubject<String>
    }
    
    private let disposeBag = DisposeBag()

    init() {
        
    }
    
    // 많이 사용하는 패턴 : transform 메서드
    func transform(input: Input) -> Output {
        
        let text = BehaviorSubject(value: "")
        
        input.buttonTap // nextButton.rx.tap 와 같아짐
            .bind(with: self) { owner, _ in
                text.onNext("칙촉 \(Int.random(in: 1...100))")
            }
            .disposed(by: disposeBag)

        return Output(text: text)
    }
}
