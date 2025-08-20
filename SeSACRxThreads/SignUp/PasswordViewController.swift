//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa //UIkit 기반

class PasswordViewController: UIViewController {
   
    //이니셜라이즈(비번 입력해주세요 같은 초기화)가 없다고 생각하고
//    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
//    let nextButton = PointButton()
    let passwordTextField = SignTextField(placeholderText: "")
    let nextButton = PointButton(title: "")
    
    private let passwordPlaceholder = Observable.just("비밀번호를 입력해주세요") //스트링 이벤트를 전달(방출)을 해주는 옵져버블
    private let nextButtonTitle = Observable.just("다음") //스트링 이벤트를 전달(방출)을 해주는 옵져버블

    
//    private let disposeBag = DisposeBag()
    private var disposeBag = DisposeBag()

    
    

    // 뷰컨같은 클래스의 메모리가 해제되는 시점에 알아서 dispose되는 것. 알아서 구독해제가 되서 우리가 사실 메모리 누수에 대해 걱정할 필요는 없다. :혹시 타이머가 다른 화면에 있는 경우같은 때는 화면전환시에도 디인잇되지 않으니까 : 디인잇을 신경써줘야함 : 앞으로 계속 디인잇은 주의 필요 : 쓸일은 거의 없지만 면접 질문 가능
    deinit {
        print("PasswordViewController deinit") //위에 모든 프로퍼티들이 싹다 정리가 잘되면 실행:  리소스 정리가 잘 되었다
    }
    
    
    
    
// 2.
// "DisposeBag 에 대해 알아보자" : 리소스 정리 하는 역할 : 정리하지 않으면 메모리 누수 발생할수 있으니까.
    func aboutDispose() {
        
        // DispatchQueue.global.async: 네트워크 통신 : 백그라운드 쓰레드 (: 킹받는 강아지들)
        // DispatchQueue.main.async : UI업데이트 혹은 시점미루기 : 메인 쓰레드 (: 닭벼슬)
        // 쓰레드들을 관리하는(알바생들을 관리하는) 애들을 맵핑해서 rx가 만들어둔게 scheduler이다 : MainScheduler.instance는 어느 쓰레드에서 동작할꺼냐 하는 뜻 : 메인쓰레드에서 동작하는 메인스케줄러에서 동작할거다 : DispatchQueue.main.async에서 동작하는 것과 비슷하다 정도로 알고 있자
        // ios에서는 GCD에서 쓰레드(알바생) 관리를 하던것을 rx에서는 스케줄러라는 개념으로 한번더 랩핑한거구나 정도.
        
        
        
        // 새로운 operator : "interval" : 타이머 : 무한대로 실행 : 반환값이 제네릭 구조로 뭘로 방출할지 정해져 있지 않아서 정의가 필요: 제네릭 타입을 Int로 설정해주자
        let test = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance) // 1초마다 한번씩 버튼 클릭하는 느낌
        let array = Observable.from([1,2,3,4,5])
        
        
        //유한한 옵져버블
        array
            .subscribe(with:self) { owner, value in
                print(" array onNext", value)
            } onError: { owner, error in
                print("array onError", error)
            } onCompleted: { owner in
                print(" array onCompleted")
            } onDisposed: { owner in
                print(" array onDisposed")
            }
            .disposed(by: disposeBag)
        
        
        // "Observable Lifecycle" : 넥스트 이벤트에 대한 방출이 끝나면, 컴플리트 이벤트가 실행되고, 디스포즈를 통해서 시퀀스를 종료시킴: 리소스 정리가 잘 되었다
        // 무한한 옵져버블 : Next가 무한 방출되고 있어서 디스포즈가 되지 않음 : 화면전환이 되면서도 계속 무한대로 실행되서 리소스 정리가 계속 안됨 : 멈추게 하는 방법이 있음:DispatchQueue
        
        
// 상수에 담아서 사용하는 형태
        //let result = test
//            .subscribe(with:self) { owner, value in
//                print("result onNext", value)
//            } onError: { owner, error in
//                print("result onError", error)
//            } onCompleted: { owner in
//                print("result onCompleted")
//            } onDisposed: { owner in
//                print("result onDisposed")
//            }
//            .dispose()
//            .disposed(by: disposeBag) // 아래 result.dispose()로 대신
        
        // 멈추게 하는 법 :DispatchQueue.main.asyncAfter : 몇초 뒤에 코드를 실행을 할지를 :지금부터 5초후
        DispatchQueue.main.asyncAfter(deadline: .now() + 5 ) { // 5초후 onDisposed 가 출력됨! : 구독을 끊어서 무한대 방출을 멈추게 해줘서 리소스정리를 해주는 역할
            // dispose()는 바로 끝내는 아이인데 5초후를 디스패치큐로 설정해줘서 : 5초후 멈추게
            //result.dispose() // result에 담아서 쓰는 이유는? : 그냥 테스트에 바로 .dispose()로 하면 : .dispose()는 즉시 정리해서 구독을 끊어주는 역할: 아무 타이머 실행없이 끝나버려서 onDisposed가 바로 출력 : 원하는 시점(5초뒤나, 버튼이 눌리고나서나)에 정리하려면 result같은 상수에 담아서 사용해야 디스패치큐 안에서 사용할 수 있으니까 굳이 담아서 쓰는것.
        }
        
        // 그럼 무한대로 방출하는 무한한 옵저버블이 수백개라면...? 하나하나 디스패치큐로 일일히 다 정리(구독취소, 즉 리소스정리)를 해줘야.. : 이걸 해결해보자
        
        let test2 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)

//        let result2 = test2
//            .subscribe(with:self) { owner, value in
//                print("result2 onNext", value)
//            } onError: { owner, error in
//                print("result2 onError", error)
//            } onCompleted: { owner in
//                print("result2 onCompleted")
//            } onDisposed: { owner in
//                print("result2 onDisposed")
//            }
//        
        // 수동으로 하나하나 dispose메서드를 통해 이렇게 메모리 누수 관리? : 현실적으로 못해: "보통은 화면이 사라지거나, 뷰컨이 디인잇이 될때라도 모든 옵저버블이 dispose되면 되겠다" 라는 의미
        // 그래서 매번 일일히 정리하기 어려우니까~ :
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10 ) {
//            result2.dispose()
//        }
        
        
        // 해결법
        var bag = DisposeBag() //DisposeBag이라는 클래스를 만들어보자 : DisposeBag이라는 인스턴스 하나 생성
        test
            .subscribe(with:self) { owner, value in
                print("onNext", value)
            } onError: { owner, error in
                print("onError", error)
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
//            .disposed(by: bag) // 바로 위에서 만든 인스턴스를 사용
            .disposed(by: disposeBag) // subscribe의 반환값 개념
        
        test2
            .subscribe(with:self) { owner, value in
                print("test2 onNext", value)
            } onError: { owner, error in
                print("test2 onError", error)
            } onCompleted: { owner in
                print("test2 onCompleted")
            } onDisposed: { owner in
                print("test2 onDisposed")
            }
//            .disposed(by: bag)
            .disposed(by: disposeBag)

        
        // rx가 만들어둔 DisposeBag라는 클래스안에서 디인잇이 될때 자기가 스스로 실행시키고 있음 (디인잇에 self.dispose()으로 : 스스로 끝내주고 있음)
        
//       /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 5 ) {
            
//            bag = DisposeBag() // 기존 인스턴스를 변경해주면 기존 애들이 날아감 : 그래서 .disposed(by: bag)이렇게 bag을 갖고 있는 애들을 한번에 관리(멈추게) 가능!
            self.disposeBag = DisposeBag() //클래스안에 있어서 self를 써줘야
        }
 //       */
        
        
        // onDisposed되고나서는 버튼 동작이 안됨 :disposeBag에 의존하고 있던 애들은 다 동작이 안되버리는 것
        // 근데 구독이 끊기면 아래 버튼의 동작도 끊겨서 버튼이 동작이 안되버림..
        // 이런 경우 버튼이 동작이 왜 안되는지 디버깅할때는 바인드말고 subscribe로 해서 하나하나 프린트해서 알아내기
        
        
    }
    
// 1.
    func bind() {
        
        /*
         1. subscribe - next, error,complete, dispose print를 하다보니
         2. "순환참조" 라는 이슈 : 그래서 쓰기 시작한 subscribe(with:)
         3. 호출되지 않는 error,complete 이벤트는 생략 가능
         4. 그래서 subscribe를 bind로 바꿔줘도 괜찮겠다 : 주로 ui관련 애들
         */
        
        
        
//        passwordPlaceholder
//            .subscribe(with: self) { owner, value in
//                owner.passwordTextField.placeholder = value
//            } onError: { owner, error in
//                print("onError", error)
//            } onCompleted: { owner in
//                print("onCompleted ")
//            } onDisposed: { AnyObjectowner in
//                print("onDisposed ")
//            }
//            .disposed(by: disposeBag)
        
        // 줄이고
//
//        passwordPlaceholder
//            .bind(with: self) { owner, value in
//                owner.passwordTextField.placeholder = value
//            }
//            .disposed(by: disposeBag)
//
        // 또 줄여서 : rx스럽게(rx로 랩핑)
        
        passwordPlaceholder
            .bind(to: passwordTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        
        nextButtonTitle
            .bind(to: nextButton.rx.title())
            .disposed(by: disposeBag)

        
        // RxSwift 와 RxCocoa 를 같이 사용하는 이유 : 지금 ui객체들을 rx로 변경(rx로 감싸서)해서 사용하고 있는데.. :
        // swift를 rx스럽게 만든게 RxSwift라고 하면, UIkit을 맵핑해서 간편하게 사용할수 있게 바꿔준건 RxCocoa(placeholder, title 등을 사용할 수 있게 해주는) :uukit로 랩핑해서 rx스럽게 짜고 있는 것 :
        // RxCocoa는 UIkit을 기반으로 만들어졌다고 알고 있다
        
        
        // addTarget와 @objc func nextButtonClicked() 대신 rx적으로
//        nextButton.rx.tap
//            .bind(with: self) { owner, _ in
//                owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
//            }
//            .disposed(by: disposeBag)

        nextButton.rx.tap
            .subscribe(with: self){ owner, _ in
                print("subscribe(onNext)")
            } onError: { owner, error in
                print("onError", error)
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)
        
        
        
        
        
        
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        bind()
        aboutDispose()
         
//        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
//    @objc func nextButtonClicked() {
//        navigationController?.pushViewController(PhoneViewController(), animated: true)
//    }
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
