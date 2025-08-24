//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 박현진 on 8/22/25.
//

import Foundation
import RxSwift
import RxCocoa // import UIkit내포

/*
 
 import RxCocoa 는 import UIkit을 내포하고 있음
 
 import RxCocoa도 주석처리 해보면..
 
 */

class BirthdayViewModel {
    
    struct Input {
        
//        let datePicker: ControlProperty<Date>
        // ControlProperty얘도 uikit관련이라 지금 보이드가 아니라 터치 자체를 넘기는 건 너무 무겁지 않나: 아래처럼 바꾸면:  뷰컨에서 input에는 오류가 발생
//        let datePicker: BehaviorSubject<Date>
    }
    
    
    
    
    // 잠깐 담아둘 데이트를 하나 구성해보자 :  뷰컨에서 뷰모델로 접근하게 해줄수 있도록
    let date: BehaviorSubject<Date> = BehaviorSubject(value: .now)
    
    
    
    
    
    struct Output {
        
//        let year: BehaviorSubject<String>
        let year: BehaviorRelay<String> // 오류가 발생하지 않는 릴레이로 변경
        let month: BehaviorSubject<String>
//        let day: BehaviorSubject<String>
        let day: Driver<String> // == SharedSequence<DriverSharingStrategy, String>
        
    }
    
    let disposeBag = DisposeBag()
    
    init() {
        
    }
    
    func transform(input: Input) -> Output {
        
//        let year = BehaviorSubject(value: "2025")
        let year = BehaviorRelay(value: "2025")
        let month = BehaviorSubject(value: "8")
        let day = BehaviorSubject(value: "22")
        
        
        
//        input.datePicker // input이 달라질때가 아니라 변화의 신호로 온 date로 변경
        date // 여기의 date가 달라질때마다 어떻게 기능을 할 수 잇는지 형태로도 가능!
            .bind(with: self) { owner, date in
                
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                
//                year.onNext("\(component.year!)")
                year.accept("\(component.year!)")
                month.onNext("\(component.month!)")
                day.onNext("\(component.day!)")
                
            }
            .disposed(by: disposeBag)
        
        // 이것조차 뷰모델이 할일 아닌가하는 개발자도 존재
        let result = day
            .asDriver(onErrorJustReturn: "OO일")

        return Output(year: year,
                      month: month,
                      day: result)
    }
}
