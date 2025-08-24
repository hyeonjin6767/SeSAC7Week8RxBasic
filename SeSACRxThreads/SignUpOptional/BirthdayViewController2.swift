//
//  BirthdayViewController2.swift
//  SeSACRxThreads
//
//  Created by 박현진 on 8/21/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum JackError: Error {
    case inValid
}

class BirthdayViewController2: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    

    let disposeBag = DisposeBag()
    
//    let text = BehaviorSubject(value: "") // 빌드하자마자 벨류의""가 왜 바로 레이블에 들어가는 걸까? : 빌드되자마자 실행되는 현상(input/output 패턴만들때도 input을 넣지 않았는데 바로 실행되는 현상처럼) : 이걸 방지하기 위한 PublishSubject 사용
//    let text = PublishSubject<String>()

    
    let viewModel = BirthdayViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
        //다음주에 할
        DispatchQueue.global().async {
            //네트워크 통신 AF
            DispatchQueue.main.async {
                //테이블뷰 갱신 reloaddata
            }
        }
        
        
        // 버튼을 눌러서 네트워크 통신(벡그라운드 쓰레드: 디스패치큐메인에이싱크에서), 테이블뷰 로드
        // RxSwift GCD > Schedular
        
        
        //이런식으로 진행 예정?
//        DispatchQueue.global().async {
//            nextButton.rx.tap
//            .map { "네트워크 통신" }
//            .map { "테이블뷰 갱신" }
//        }
       

        
        

        view.backgroundColor = Color.white
        
        configureLayout()
        
//        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
//        aboutPublishSubject()
//        aboutBehaviorSubject()
        
    }
    
    
    // Rx + input/output + mvvm
    func bind() {
        
        // 타입확인용
//        let a = birthDayPicker.rx.date
        
//        let input = BirthdayViewModel.Input(datePicker: birthDayPicker.rx.date)
        let input = BirthdayViewModel.Input()
        let output = viewModel.transform(input: input)
        
        
        
        // 컨트롤이벤트나 컨트롤프로퍼티를 뷰모델이 받는 형태가 아닌 다른 형태로 받는 것도 가능하다! : 그래서 코드가 끊임없이 발전해 나갈 수 있음!
        birthDayPicker.rx.date // 이 날짜 사실 자체를 보내주는게 아니라 날짜가 변화했을 때 구독을 하는게 맞지 않나
            .subscribe(with: self) { owner, date in
                // owner.viewModel.input.datePicker 여기에 보내고 싶은데..: 잠깐 담아둘 date를 뷰모델에서 만들어서 거기로 넥스트로 전달을 해버리자 : 이렇게되면 위에 input의 역할이 없어져서 위에 Input()로 input을 지우는게 가능
                owner.viewModel.date.onNext(date)
            }
            .disposed(by: disposeBag)

        
        
        
        // 스레드 3가지 방식으로
        output.year
            .observe(on: MainScheduler.instance)
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.month
            .asDriver(onErrorJustReturn: "OO월")
            .drive(monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.day
//            .asDriver(onErrorJustReturn: "OO일") //이것조차 비즈니스 로직이라고 생각하는 개발자는 다르게 뷰모델을 나눌수 잇다 :asDriver도 뷰모델에서 하는게 맞다?
            .drive(dayLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    /*
    func bind() {
        
        
        // 스트림 관점에서
        // Subject : 여러번 구독을 하더라도 내부적으로 공유되고 있다 : "multicast"
        // Observable : 스트림을 독립적으로 갖고 있고 : 여러번 구독을 해도 독립적인 실행 : "unicast"
        
        text
            .bind(with: self) { owner, value in
                print("next 1", value)
            }
            .disposed(by: disposeBag)
        text
            .bind(with: self) { owner, value in
                print("next 2", value)
            }
            .disposed(by: disposeBag)
        text
            .bind(with: self) { owner, value in
                print("next 3", value)
            }
            .disposed(by: disposeBag)
        
        text.onNext("랜덤 \(Int.random(in: 1...100))")
        
        
        
        
        
        // "Stream을 공유한다" 의 의미

        // 아래 중복코드를 줄여보자
        
        
        // Observable<String> : 스트림을 공유하지 않기 때문에 bind도 그 특징을 그대로 가져오게됨
        
        
        // 마치 버튼이 3번 눌리는 거 같은 : 같은 Stream 을 사용하는게 아니라 다른 Stream 3개 사용중인것 :
        // 버튼이 3번 클릭되는 현상(네트워크 통신도 3번) :  Stream이 공유되고 있지 않다 :  share
        let tap = nextButton.rx.tap
            .map { "랜덤 \(Int.random(in: 1...100))" }
            .share() // Stream이 공유되는 상황으로 만들어줌 :  버튼 한번 클릭이 재사용(네트워크 통신도 한번만)
//            .asDriver(onErrorJustReturn: "") // share가 내장되어 있음 :  drive 사용시에는 스트림 공유 신경쓰지 않아도 괜춘
        
        tap
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        tap
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)
        tap
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        
//        nextButton.rx
//            .tap
//            .map { "랜덤 \(Int.random(in: 1...100))" }
//            .bind(to: yearLabel.rx.text)
//            .disposed(by: disposeBag)
//        nextButton.rx
//            .tap
//            .map { "랜덤 \(Int.random(in: 1...100))" }
//            .bind(to: monthLabel.rx.text)
//            .disposed(by: disposeBag)
//        nextButton.rx
//            .tap
//            .map { "랜덤 \(Int.random(in: 1...100))" }
//            .bind(to: dayLabel.rx.text)
//            .disposed(by: disposeBag)
        
        
        
        
        
        
        
        
        
        
        // Bind vs subscribe vs drive
        
        text
            .asDriver(onErrorJustReturn: "unknown") // 혹시 에러가 발생할 경우 대처 : 앱터지지 않게 하기 위한 : 오류에 대한 예외 처리
            .drive(yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        // drive는 메인스레드 동작이 보장되어 있어서 observe가 필요없음
        nextButton.rx.tap
            .asDriver() //
            .drive(with: self) { owner, _ in
                owner.infoLabel.text = "입력했어요"
//                owner.text.onNext("고래밥")
                owner.text.onError(JackError.inValid) // bind는 넥스트이벤트만 받을 수 있고 에러이벤트는 못받는데..? : 앱 터짐
            }
            .disposed(by: disposeBag)
        
        
        
        
        
        
        
        
        
        
        // 네트웤크 통신이나 파일 다운로드 같은 오래 걸리는 일 같은 백그라운드 쓰레드에서 있을 경우 : 동작에 지연이 발생할 수 있으므로 방지용 방법 :observe
        
        /*
        nextButton.rx.tap
            .observe(on: MainScheduler.instance) // 구독(bind, subscribe 둘다)전에 메인스레드에서 동작되게 해줘야 문제가 발생하지 않음
            .subscribe(with: self) { owner, _ in
                owner.infoLabel.text = "입력했어요"
            }
            .disposed(by: disposeBag)
        
         
        
        nextButton.rx.tap
            .observe(on: MainScheduler.instance) // 구독(bind, subscribe 둘다)전에 메인스레드에서 동작되게 해줘야 문제가 발생하지 않음
            .bind(with: self) { owner, _ in // Binder 객체에 대해서만 메인 쓰레드 보장
                owner.infoLabel.text = "입력했어요"
            }
            .disposed(by: disposeBag)

        
        // drive는 메인스레드 동작이 보장되어 있어서 observe가 필요없음
        nextButton.rx.tap
            .asDriver() //
            .drive(with: self) { owner, _ in
                owner.infoLabel.text = "입력했어요"
            }
            .disposed(by: disposeBag)
        
         */
        
        
        
        
        
        
        /*
        
        // "만 17세 이상만 가입 가능합니다"가 안보이고 뷰디드로드에 초기값 해준 빈칸""이 보임
        // 빌드하자마자 벨류의""가 왜 바로 레이블에 들어가는 걸까?
        text
            .bind(to: infoLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 버튼이 클릭되야 이벤트가 전달되는 형태
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                print("가입 가능")
                owner.text.onNext("가입 가능")
            }
            .disposed(by: disposeBag)
        
        */
        
        

    }
     */
    
    // " PublishSubject vs BehaviorSubject " :  제일 많이 사용(초기값 유무로 골라서 사용)
    
    // PublishSubject에 대해 알아보자 :  구독이후에 이벤트만 받을 수 있다
    func aboutPublishSubject() {
        
        let text = PublishSubject<String>() // let a: Array<String> = Array<String>() // 제네릭 스트링 타입
        
        text.onNext("칙촉")
        text.onNext("칫솔") //PublishSubject 는 그전에 구독이 안되는 애라 칫솔 출력 안됨 : 초기값같은게 필요없을 때 주로 사용됨

        // 아직 구독 전
        text
            .subscribe(with: self) { owner, value in
                print("PublishSubject next", value) // next 고래밥 출력 확인
            } onError: { owner, error in
                print("PublishSubject onError", error)
            } onCompleted: { owner in
                print("PublishSubject onCompleted")
            } onDisposed: { owner in
                print("PublishSubject onDisposed")
            }
            .disposed(by: disposeBag)

        // 구독 후
        text.onNext("치약")
        text.onCompleted() // 더이상 이벤트가 필요가 없다 : 아래 음료수는 출력안됨
        text.onError(JackError.inValid) // 에러이벤트가 전달되면 구독이 해제되면서 아래 음료수는 출력안됨
        text.onNext("음료수")
        
        
    }
    
    
    // BehaviorSubject에 대해 알아보자 : 구독이전의 값도 마지막값은 받아올 수 있다(구독 전 하나는 무조건 하나 갖고 있어야 함): 고래밥같은 초기값
    func aboutBehaviorSubject() {
        
        let text = BehaviorSubject(value: "고래밥")
        
        // 아직 구독 전
        text.onNext("칙촉")
        text.onNext("칫솔") //BehaviorSubject는 값을 미리 가지고 있을 수 있어서(구독이 미리 되어) 칫솔은 출력됨 : 초기값 필요시 많이 사용
 
        text
            .subscribe(with: self) { owner, value in
                print("next", value) // next 고래밥 출력 확인
            } onError: { owner, error in
                print("onError", error)
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)

        // 구독 후
        text.onNext("치약")
        text.onCompleted() // 여기서 구독이 끊겨서 아래 음료수는 출력안됨
        text.onNext("음료수")


        
        
    }
    
//    @objc func nextButtonClicked() {
//        navigationController?.pushViewController(SearchViewController(), animated: true)
//    }

    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
