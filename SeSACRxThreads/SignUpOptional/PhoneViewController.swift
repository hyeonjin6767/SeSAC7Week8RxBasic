//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

/*
 과제안내
 필수
 1. 넘버뷰컨트롤러
 2. 심플밸리데이션뷰컨트롤러
 -> MVVM, 인풋아웃풋
 3. 홈워크는 옵션
 
 */


class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let resultLabel = UILabel()
    
    
    // dispose를 어떻게 잘 쓰는지 : deinit이 되면 disposeBag이 정리가 잘 되는데, deinit이 혹시나 안되는 경우에는 신경써줘야 하긴 하지만 수동으로 신경쓸 필요는 없음

    private let disposeBag = DisposeBag()
    
    let limitNumber = 8 // self 추가하라는 에러 유발용
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        bind()
        
//        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
//    @objc func nextButtonClicked() {
//        navigationController?.pushViewController(NicknameViewController(), animated: true)
//    }
    
    
    
    let viewModel = SecondPhoneViewModel()
    
    func bind() {
        
        
        
        // 타입 확인용
//        let a = nextButton.rx.tap
//        let b = phoneTextField.rx.text.orEmpty
        
        
        let input = SecondPhoneViewModel.Input(buttonTap: nextButton.rx.tap, textField: phoneTextField.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        output.text
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        
        
        // 버튼 클릭시 레이블에 내용이 보이게
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in //  _ : 버튼이라 void로 받아
                owner.resultLabel.text = "버튼 클릭"
            }
            .disposed(by: disposeBag)
        
        
        
        // 좀더 rx스럽게 : map추가
//        nextButton.rx.tap
//            .map { _ in //_(와일드카드)로 보이드 생략 : 함수연산자 안에 소괄호 생략가능 : 더 극단으로 대괄호도 줄여서 사용
//                "버튼 클릭"
//            }
//            .disposed(by: disposeBag)

        
        
//        nextButton.rx.tap
//            .map { "버튼 클릭" }
//            .bind(with: self, onNext: { owner, value in
//                owner.resultLabel.text = value // 받아온 내용을 그대로 보여주는 형태 : 그래서 bind to 로도 가능
//            })
//            .disposed(by: disposeBag)

        
        
//        nextButton.rx.tap
//            .map { "버튼 클릭" }
//            .debug("버튼1")
//            .debug("버튼2")
//            .debug("버튼3")
//            .bind(to: resultLabel.rx.text)
//            .disposed(by: disposeBag)

        
        
        
        // 몇글자 얼마 : "조건"을 걸어줘보자
        
        //텍스트필드가 실시간으로 달라질 때마다 레이블에 내용 출력해보자
        phoneTextField
            .rx
            .text
            .orEmpty
            .debug("orEmpty 다음") // rx는 디버깅이 어려운데.. : 중간중간 라인바이라인 프린트도 어려워 : 대신 debug
//            .withUnretained(self)
            .map { $0.count >= self.limitNumber } //불타입으로 결과가 나옴 //self.limitNumber :self를 자꾸 추가하라고 뜨는데 :메모리 누수 발생 : 해결 방법 :1. 그냥 8로 쓰거나, 2. 여기 바인드 함수 안에 넣어주면 셀프뜨라고 안뜸 3. weak self 쓰기 4. withUnretained 사용:근데 orEmpty에서 문제발생(거꾸로 올라가서 판단해서) 5. 그냥 써서 메모리 누수 발생 시켜버림
            .debug("1")
            .debug("2") // 실행순서 거꾸로 올라감 : 내가 구독을 누구를 하는지를 거꾸로 올라가면서 찾음 : 이벤트 방출(Event next(false))이 바로 된다는걸 확인이 되는데 : 넥스트이벤트가 즉시 실행이 된다는 걸 확인됨 : 커스텀 옵져버블중에서 바로 실행하는 바인드 개념으로 생각하면 됨
            .debug("3")
            .debug("map 다음")
            .bind(with: self) { owner, value in
                owner.resultLabel.text = value ? "통과" : "8자 이상 입력해주세요"
            }
            .disposed(by: disposeBag)
        
        
        // "map" : 끝단까지 들어있는 타입으로 들어옴  : .withUnretained(self)다음 맵 하면 self , value 2개 타입이가 생김
//        nextButton.rx.tap
//            .map {3}
//            .map{ "\($0)"}
//            .map { <#String#> in
//                <#code#>
//            }

//        phoneTextField
//            .rx
//            .text
//            .orEmpty // string
//            .withUnretained(self) // self , value
//            .map { owner, text in
//                text.count >= owner.limitNumber
//            }
//            .bind(with: self) { owner, value in
//                owner.resultLabel.text = value ? "통과" : "8자 이상 입력해주세요"
//            }
//            .disposed(by: disposeBag)
//        
        // 버튼 틀릭시 글자만 보여지지 않고 버튼을 가져와서 실시간
        
        //버튼 클릭시 레이블 내용
        nextButton.rx.tap
            .withLatestFrom(phoneTextField.rx.text.orEmpty) //withLatestFrom: 값을 가져오고 싶을 때 쓰는애 : 제일 마지막꺼를 가져오는 거라 orEmpty로 비었는지 체크
            .bind(with: self, onNext: { owner, value in
                print(value)
            })
            .disposed(by: disposeBag)
        
        //버튼 클릭시 레이블 내용
        nextButton.rx.tap
            .withLatestFrom(phoneTextField.rx.text.orEmpty) //가져와서
            .bind(to: resultLabel.rx.text) //다이렉트로 보여줘
            .disposed(by: disposeBag)
        
//        nextButton.rx.tap
//            .withLatestFrom(phoneTextField.rx.text.orEmpty) //가져와서
//            .map({ text in
//                text.count >= 8  ? "통과" : "8자 이상 입력해주세요" //조건처리후
//            })
//            .bind(to: resultLabel.rx.text) //보여줘
//            .disposed(by: disposeBag)
//        // 위에꺼 뷰모델로 통째 이동
        
        
        
    }

    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
        view.addSubview(resultLabel)
         
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
        
        resultLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(nextButton.snp.bottom).offset(20)
        }
        
        resultLabel.text = "test"
    }

}
