//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    
    
    
    //Rxswift에서 만든 Observable의 just로 일을 벌리겠다 : 수습은 뷰디드로드에서
    let buttonTitle = Observable.just("중복확인") //얘는 "중복확인"이라는 글자만 전달하면 끝이어서 : 그래서 "유한"한 이벤트
    
    
    
    let disposeBag = DisposeBag() //디스포즈라는게 RxSwift에 있구나 이게 뭘까????????????????????????????
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
        basicObservableTest()
        
        
        
        
        
        //touchUpInside 대신에
        //        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        
//1.
        

        //buttonTitle는 just라는 형태로 이벤트를 벌이는 애 :Observable
        // "중복확인"이라는 스트링을 just라는 방식으로 전달을 했기 때문에  onNext에 스트링 타입으로 정의 되어 있다 : 모든 것들이 클로저로 구성되어 있음 : 클로저 기반이라 메모리 누수나기 쉽상: 나중에 메모리 누수를 잘 해결해줘야 함

//        buttonTitle  //Observable이자 이벤트를 전달하는 친구 //아래순서로 이벤트를 처리하겠다
//            .subscribe { value in // subscribe는 next 이벤트 :즉, 잘된 케이스
//            print("onNext - \(value)") //프린트를 해달라는 수습
//                self.validationButton.setTitle(value, for: .normal) //이벤트로 버튼의 제목을 표기하겠다
//            } onError: { error in //subscribe아래가 Observer //Observable와 Observer는 서로 필요 관계: Observer가 없으면 일을 벌리더라도 아무일도 못함: 유툽의 구독을 하면 업로드 알림 받는것 처럼: 구독 이전의 업로드 알림은 받지 못함 : 유툽 구독 비유
//                print("onError - \(error)")
//            } onCompleted: {
//                print("onCompleted") //완성이되고
//            } onDisposed: {
//                print("onDisposed") //끝났나
//            }
//            .disposed(by: disposeBag) //얘를 안쓰면 컴파일 경고(subscribe 자체가 반환값이 있는 애라서)가 떠서 우선 추가: 나중에 설명 예정 //onCompleted가 되서 일을 끝냈다면 메모리에 남아 있을 필요 없으니까 리소스 정리하는 역할!

        
        
//2.
       // < Observable 2가지 > Infinite Observable Sequences vs Finite Observable Sequences
        
        // : 사용자가 100번하면 100번 되야 하는 이벤트들 ex) 버튼클릭, 가로세로 전환, 텍스트필드 입력 같이 이벤트가 끝나면 안되는 애들: 보통 UI관련 이벤트들
        // 끝이 없는 이벤트 전달 : Infinite Observable Sequences : 끝이 나면 안되는 친구들: 화면전환이나 글자입력이나 : UI와 관련된 이벤트들이 주로 끝나면 안되는 이벤트들.
        // "이벤트를 전달한다" == "이벤트를 방출한다"
        
        // Finite Observable Sequences : 끝이 있는 이벤트도 존재함 : ex. "패킷"(영상 다운로드시 작은 단위로 쪼개서 조금씩 시간단위로 전송해주는 방식): 점진적 다운로드 :이미지도 작게쪼개서 받는: 근데 받는 중에 네트워크 문제 발생시 : 성공, 실패의 다양한 이벤트가 발생할수 있는 상황에 대해 rx는 3가지로 나눔 : next(성공), completed(완벽히 끝: 더이상 next이벤트로 올게 없을 때), error(실패)의 3가지 이벤트가 rx에 명시되어있음 : "이벤트 처리방식 3가지"
        
        
        
        //쩜의 흐름에 따라 데이터 변화 //버튼 클릭시
        //버튼은 무한한 이벤트, ui들은 에러(버튼의 클릭이벤트가 안되는일은 존재X)X, Error와 Complete는 ui에서는 일어날 수 없으니 이 두 부분은 생략가능!
        //그래서 무한한 이벤트인 ui이벤트들은 Error와 Complete가 일어날 일이 없으니 Next만 발생하게됨 : 그래서 주로 bind가 쓰임(어차피 생략하니까 텍스트 주관하는 바인드를 쓰는것임)
        /*
        nextButton.rx.tap // 여기까지가 Observable : 이벤트를 전달만 : touchUpInside에 대한 이벤트
            .subscribe { _ in // "subscribe"가 Observable와 Observer를 "연결"해주는 역할 : subscribe가 없으면 일만 벌리고 일을 수습은 못함
                print("button onNext") // 이것만 프린트되고 아래는 안됨 : 근데 백버튼으로 돌아가면 "button onDisposed"프린트 // Next는 계속 발생 가능(그래서 버튼누를때마다 계속 프린트된거임)
//            } onError: { error in // Error
//                print("button onError")
//            } onCompleted: { //Completed
//                print("button onCompleted") //버튼이 갖고 있는 메모리 공간이 잘 정리된 전화면으로 화면 전환시 프린트됨
            } onDisposed: { // "구독 취소(dispose)" : Observable와 Observer가 연결이 끊겨서 아무것도 못하게됨 : 구독 취소가 확인되면 리소스를 정리.
                print("button onDisposed") //아래(disposed) 리소스 정리가 "끝나면" 이곳을 프린트(잘 끊겼을때:onDisposed) : 프린트안되면 메모리 누수 발생한것임 : 그래서 이건 이벤트는 아님(리소스 정리 시점을 눈으로 확인하기 위한 용도)
            }
            .disposed(by: disposeBag) //리소스 정리 구간이자 구독 취소하는 구간!
        */


//4.
        //버튼에 error와 complete는 일어날이 없으니까 두가지는 생략한 형태 : 그래서 나온 애가 아래 bind:subscribe와 같은애인데 넥스트이벤트만 가능한 아이
//        nextButton.rx.tap // tap이라는 곳 안에 다 touchUpInside가 명시되어져 있음!
//            .subscribe { _ in
//                print("button onNext")
//            } onDisposed: { //얘는 메모리누수가 안된것만 확인하는 애라 사실 이벤트도 아니라서 지워도 되는애니까 사실상 다 생략하면 subscribe만 남으니까 바인드로 대체
//                print("button onDisposed")
//            }
//            .disposed(by: disposeBag)
        
        
        
        
        
//5.             //[weak self] 추가
        
            
        // "bind" :subscribe같이 연결해주는 애인데 : 차이점은 : 바인드는 "넥스트 이벤트만" 처리 가능한 애(애초에 넥스트 이벤트밖에 처리를 못하는 구조) :subscribe는 이벤트3개 다 처리 할 수 있지만 발생하지 않으니까 "생략"을 한 경우 : 할수 있는데 "안하는것" : 바인드는 애초에 "못하는애" : 애초에 버튼에서는 에러와 컴플리트 이벤트가 일어날일이 없으니까 협업시 혼선을 위해 버튼같은 경우는 아예 바인드로 사용해버림 : 그래서 위에 subscribe로 하지 않고 아래 바인드로 주로 사용.
        //이벤트를 애초에 안받게 할지 못받게 할지 인것
//        nextButton.rx.tap
//            .bind { [weak self] _ in
//                guard let self = self else { return }
//                print("button bind onNext")
//                let vc = PasswordViewController()
//                self.navigationController?.pushViewController(vc, animated: true) //여기서 self 발생했으니 weak 쓰자!
//            }
//            .disposed(by: disposeBag)
        
        
        
//6.        // withUnretained(self)
        
        // "withUnretained": [weak self] 추가가 반복되니까 대신 작성해서 메모리 누수를 해결 해주는애 : RxSwift Community 오픈소스에서 만들어서 하도 많이 쓰이던걸 애플이 아예 만들어버림 : [weak self]와 가드문 생략해줌
        
//        nextButton.rx.tap
//            .withUnretained(self)
//            .bind { _ in
//                print("button bind onNext")
//                let vc = PasswordViewController()
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//            .disposed(by: disposeBag)
        
        
        
 //7.최종1    //.withUnretained(self)이것마저도 줄여보자
        
        
        nextButton.rx.tap // 요즘은 메모리누수 대처를 이 형태로 "제일 많이 쓰임"
            .bind(with: self) { owner, _ in // owner : [weak self]와 가드문의 옵셔널로 담고 싶은 요소(가드문에 let self로 담는 것을 대체)
                
                print("button bind onNext")
                let vc = PasswordViewController()
                owner.navigationController?.pushViewController(vc, animated: true) //맨앞에 self. 대신 owner.
                
            }
            .disposed(by: disposeBag)
        
        
        
        
        
  //8.최종2
        
        // "앞으로 메모리누수 방지를 위해 불러올때 뒤에 with가 있는 걸 가져다 쓰는 "습관"을 길러라" : RC카운트를 늘리지 않는 요소 많이 사용함
        
        buttonTitle
            .subscribe(with: self) { owner, value in
            print("onNext - \(value)")
            owner.validationButton.setTitle(value, for: .normal)
        }
        .disposed(by: disposeBag)

        
        

        
        
        
//            .랴ㅣ { "안녕하세요" }
//            .bind(to: emailTextField.rx.text)
//            .disposed(by: disposeBag)
    }
    
    
//3.
    
    func basicObservableTest() { //기본적으로 사용하는 Observable에 대해 테스트 해보자:
        
        let list = ["고래밥","칙촉","카스타드","갈배"]
        //이 배열에 이벤트를 발생 시켜보자
        
        // just : "전체" 통으로 불러주세요 : 유한한 Observable : 이런애들을 "operator"(쩜 찍어서 나오는 모든 애들: 200가지나 됨)라고 함
        Observable.just(list)
            .subscribe { value in
            print("just - \(value)") // just - ["고래밥", "칙촉", "카스타드", "갈배"] 가 프린트: 그냥 배열이니까 유한한 이벤트 :Finite Observable
        } onError: { error in
            print("just - \(error)")
        } onCompleted: {
            print("just onCompleted" )
        } onDisposed: {
            print("just onDisposed") //onCompleted되면 할 일 다 했구나 해서 : 리소스 정리가 되서 onDisposed 출력
        }
        .disposed(by: disposeBag)
        
        // from : 유한한 Observable
        Observable.from(list)
            .subscribe { value in
            print("just - \(value)") // next이벤트가 4번 프린트됨 :반복문느낌
        } onError: { error in
            print("just - \(error)")
        } onCompleted: {
            print("just onCompleted" ) //마지막 element인 갈배가 나오면 끝이 났구나해서 출력됨
        } onDisposed: {
            print("just onDisposed")
        }
        .disposed(by: disposeBag)
        
        // take : 몇명 지정(갯수 제한 가능)해서 불러주세요 // repeatElement : 무한한 Observable
        Observable.repeatElement(list)
            .take(10) //repeatElement는 무한히 반복해라: 터짐:take없이는 빌드하지마: 무한대로 방출 : Infinite Observable : 10개만 하라고 지정 가능
            .subscribe { value in
            print("just - \(value)") //반복문처럼 프린트
        } onError: { error in
            print("just - \(error)")
        } onCompleted: {
            print("just onCompleted" )
        } onDisposed: {
            print("just onDisposed")
        }
        .disposed(by: disposeBag)
        
        
        
    }
    
    @objc func nextButtonClicked() {
        print(#function)
//        navigationController?.pushViewController(PasswordViewController(), animated: true)
        
        //touchUpInside 대신에

        
    }

    //커스텀뷰 대신 컨피규어
    func configure() {
        
        //아랫줄을 Rxswift로 변경해보자
//        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
