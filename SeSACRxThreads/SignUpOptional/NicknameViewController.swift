//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NicknameViewController: UIViewController {
   
    let nicknameTextField = SignTextField(placeholderText: "")
    let nextButton = PointButton(title: "")
    
    
    private let placeHolder = Observable.just("닉네임 입력")
    private let buttonTitle = Observable.just("닉네임 추천")
    
    
    
    //private let text = Observable.just("고래밥") //얘는 옵저버블이라 고래밥이라는 글자를 전달만 하는 역할 :버튼 클릭시에 고래밥에다가 다른 값을 넣어주고 싶다== text가 전달도 하고 수습(다른 값 바꿔주기라는 처리)도 하게 하고 싶다. :  옵저버와 옵저버블의 두가지 역할 다 하고 싶다 : BehaviorSubject로 변경
    private let text = BehaviorSubject(value: "고래밥") // 2개의 역할을 다 하는 BehaviorSubject

    
    private let disposeBag = DisposeBag()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
        
//        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)

    }
    
    func bind() {
        
        placeHolder
            .bind(to: nicknameTextField.rx.placeholder)
            .disposed(by: disposeBag)
        buttonTitle
            .bind(to: nextButton.rx.title())
            .disposed(by: disposeBag)
        text
            .bind(to: nicknameTextField.rx.text) // text가 고래밥말고 다른 글자가 들어와도 넣어주면 되지 않을까 :  고래밥자리에 간식 리스트에서 랜덤으로 뽑아다가 넣은걸 바로 바인드~
            .disposed(by: disposeBag)
        
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                
                let list = ["칙촉","갈배","몽쉘"]
                let random = list.randomElement()!
//                owner.nicknameTextField.text = random
                
                
                // 버튼 클릭시 이벤트(random이라는 내용으로 바꿔달라는:옵저버 역할)를 전달(이벤트를 전달:옵저버블의 역할) -> 모든 이벤트의 전달은 onNext가 담당
                owner.text.onNext(random) // owner.text = random(안되는코드) : text에 랜덤이라는 문자열을 넣어주고싶은것같은 의미
                //Subject로 쓰는 이유와 =(대입:등호)대신에 온넥스트라고 하는지가 포인트
            }
            .disposed(by: disposeBag)
        
        
        
        
        
        
    }
    
//    @objc func nextButtonClicked() {
//        navigationController?.pushViewController(BirthdayViewController(), animated: true)
//    }

    
    func configureLayout() {
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
         
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
