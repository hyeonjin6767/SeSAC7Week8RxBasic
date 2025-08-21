//
//  PhoneViewController2.swift
//  SeSACRxThreads
//
//  Created by 박현진 on 8/21/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa



class PhoneViewController2: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    
    
    private let disposeBag = DisposeBag()

    let text = BehaviorSubject(value: "고래밥")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        bind()
        
//        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    let viewModel = PhoneViewModel()
    
    func bind() {
        
        // 인풋 아웃풋을 고민하지말고 그냥 해
        
        // 버튼 클릭시 텍스트필드에 글자 출력을 인풋아웃풋 구조로 만들기 위해 2파트로 나눠서 함
        // 1 : "버튼 클릭시" : subject에 내용을 보내주고
        // 2 : "텍스트필드에 글자 출력" : subject의 내용을 받아서 텍스트필드에 글자를 보여줄수 있는 형태
        
        
//뷰모델로 이동        // 1 : "버튼 클릭시" : subject에 내용을 보내주고
//        nextButton.rx.tap // 버튼 탭이 옵저버블로 text가 옵저버의 형태로 이벤트(value가 고래밥에서 칙촉과 랜덤숫자로 데이터가 바뀌면 바인드구문이 동작)를 받을 수 있게
//            .bind(with: self) { owner, _ in
//                owner.text.onNext("칙촉 \(Int.random(in: 1...100))")
//            }
 
//뷰모델로 이동       // 2 : "텍스트필드에 글자 출력" : subject의 내용을 받아서 텍스트필드에 글자를 보여줄수 있는 형태
//        text // text를 옵져버블로 쓰면 그 내용이 텍스트필드에 옵저버로 전달이 되는거고,
//            .bind(to: phoneTextField.rx.text)
//            .disposed(by: disposeBag)
        
        
        // 뷰모델에서 인풋/아웃풋 만들때 타입확인용
        let a = nextButton.rx.tap // 여기까지가 사실상 인풋에 해당 : a의 타입을 확인해보면 ControlEvent<Void> : 탭 자체를 인풋에 던저보자 : 뷰모델에 해당타입으로 선언해주자
        
        // 여태 커스텀뷰모델과 유사하지만 이니셜라이즈만 바깥으로 여기 나옴 : 뷰컨에서 일어나는 모든일은 다 뷰모델로 떼려넣고, 데이터에 대한 조작은 다 뷰모델에서 하기.
        let input = PhoneViewModel.Input(buttonTap: nextButton.rx.tap) // 뷰모델로 nextButton의 눌렸음을 던져주기
        let output = viewModel.transform(input: input) // output에서 메서드(transform) 실행을 시킬때 input 매개변수를 가지고 실행
        
        
        output.text // 아웃풋에 대한 내용을 받아서만 처리
            .bind(to: phoneTextField.rx.text) // transform의 반환값을 폰텍스트필드에 보여줘
            .disposed(by: disposeBag)
        
        
       
        
        

        
    }
    
    
    
//    @objc func nextButtonClicked() {
//        navigationController?.pushViewController(NicknameViewController(), animated: true)
//    }

    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
