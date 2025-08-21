//
//  SecondPhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 박현진 on 8/21/25.
//

import Foundation
import RxSwift
import RxCocoa

class SecondPhoneViewModel {
    
    
    struct Input {
        let buttonTap: ControlEvent<Void>
        let textField: ControlProperty<String>
    }
    
    struct Output {
        let text: BehaviorSubject<String>
    }
    
    private let disposeBag = DisposeBag()

    init() {
   
    }
    
    func transform(input: Input) -> Output {
        
        let labelText = BehaviorSubject(value: "")
        
        input.buttonTap
            .withLatestFrom(input.textField)
            .map({ text in
                text.count >= 8  ? "통과" : "8자 이상 입력해주세요"
            })
            .bind(with: self, onNext: { owner, value in
                labelText.onNext(value)
            })
            .disposed(by: disposeBag)
        
        return Output(text: labelText)
        
    }
}
