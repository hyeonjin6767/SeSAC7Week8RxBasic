//
//  SignInViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

enum Title: String {
    case email = "이메일을 입력해주세요"
    case password = "비밀번호를 입력해주세요"
    case signInButton = "로그인"
}

class SignInViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: Title.email.rawValue)
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    let photoImageView = UIImageView()
    
    let disposeBag = DisposeBag()
    
    
    // 컬러라는 프로퍼티를 만들어서 Observable클래스에다가 just로 이벤트를 전달해주고 싶다 : "노랑색이라는 컬러를 방출"
    let color = Observable.just(UIColor.yellow)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//2.
        
        // 4자리 이상 이메일 작성시, 로그인 버튼 회색 > 검정색으로 변경
        // 텍스트필드에 에드타켓같은게 필요할 거같은데...editchanged(실시간 체크) : 이걸 어떻게 rx로 표현할끼
        // 중간에 rx로 한번 감싸서 데려오면 타입이 달라짐
        
        
        
        // 글자를 입력받는것도 에러가 발생할 일이 없을 무한한 이벤트이니까 subscribe를 사용할 필요없이 bind로 사용해보자
        //글자가 달라질때마다 실행이됨
        
//        emailTextField.rx.text // 텍스트필드에 입력되어있는 글자를 rx스럽게 갖고 오는 것 : 감싸서 데리고 오면 타입 자체가 바뀜 : "타입이 달라졌을 때 어떻게 할래?"
        //            .bind(with: self) { owner, value in // value: 전달되는 스트링이 자체가 옵션로 되어있어서
        //                print("bind  :  \(value)")
        //                guard let value = value else {return} //value가 옵셔널이라 옵셔널 해지 해주고 조건문
//                if value.count >= 4 {
//                    owner.signInButton.backgroundColor = .black
//                } else {
//                    owner.signInButton.backgroundColor = .lightGray
//                }
//            }
//            .disposed(by: disposeBag)
      
        
//3. : 2번 개선
//        emailTextField.rx.text
//            .bind(with: self) { owner, value in
//                print("bind  :  \(value)")
//                guard let value = value else {return} //value가 옵셔널이라 옵셔널 해제를 위해 해줘야
//                if value.count >= 4 {
//                    owner.signInButton.backgroundColor = .black
//                } else {
//                    owner.signInButton.backgroundColor = .lightGray
//                }
//            }
//            .disposed(by: disposeBag)

        
        
//4. : orEmpty
        
        
        
//        emailTextField.rx.text
//            .orEmpty // 여기 text가 자체가 String?으로 옵셔널 타입인데 이걸 해지 해주는 "orEmpty"가 존재함! :위에 가드렛벨류구문을 안써도 됨
//            .bind(with: self) { owner, value in
//                print("bind  :  \(value)")
//                if value.count >= 4 {
//                    owner.signInButton.backgroundColor = .black
//                } else {
//                    owner.signInButton.backgroundColor = .lightGray
//                }
//        }
//            .disposed(by: disposeBag)

   
        
//5. : map을 통해 조건 걸어주기

        
//
//        emailTextField
//            .rx
//            .text
//            .orEmpty
//            .map { text in //쭈르르 위에서 옵셔널까지 해제한 텍스트를 text(클로저의 파라미터)로 받아서
//                text.count >= 4
//              }
//            .map {  // 맵으로 "조건" 추가(만능) : 새롭게 데이터를 변환을 해주는 것
//                $0.count >= 4 // bool값으로 타입을 변경해줌 //클로저 파라미터 사용안할때는 임시로 지정해주는 달러 사인 :달러영
//            }
//            .bind(with: self) { owner, value in
//                owner.signInButton.backgroundColor = value ? .black : .lightGray
//            }
//            .disposed(by: disposeBag)
//
       
        
//6. : 5와 같은 코드
        
        emailTextField.rx.text.orEmpty
            .map { $0.count >= 4 } // 텍스트를 bool타입으로 변경을 시켜서
            .bind(to: signInButton.rx.isHidden) // 히든 시켜줄지 말지를 바로 바인드 해주는 형태
            .disposed(by: disposeBag)

        
        // 바인드 to를 쓰냐 바인드 with를 쓰냐 차이는 to를 쓰는 경우 바로 다이렉트로 데이터를 보여주거나 뭔가 "바로" 갖다 쓸 수 있는 경우인 것 같다. 기본적으로는 with를 쓰는게 맞고.
        
        
        
        
 //1.
        
        // rx로 변경해보자
//        view.backgroundColor = Color.white

        
        // to 안에 들어가야 하는 코드는 그동안 우리가 써왔던 view.backgroundColor 같은 형태의 ios적인 코드는 아니어서 못들어가고
        // view를 rx프로퍼티로 감쌀 수 있는데 : 우리가 스트링, 구조체, 클래스를 커스텀observable로 감쌌던 것처럼 UIView를 rx로 감싸서 타입을 바꿔줘서(uiview타입이 아니게) 적용을 해준다. : 받아온 내용을 어차피 그대로 어떤 뷰에 다이렉트로 보여줄꺼라면 다이렉트로 박을 수 있는 형태가 아래 바인트투 형태
        color
            .bind(to: view.rx.backgroundColor, emailTextField.rx.textColor) // "rx로 한번 감싸서"
            .disposed(by: disposeBag)
//
        
        //컬러가 오류가 발생할 사항은 아니니까 굳이 subscribe를 쓸 필요없이 bind를 쓰면 될듯하다: 오류가 발생할 케이스가 아닌거 같은 경우는 굳이 subscribe로 할 필요가 없다
        
        //컬러 이벤트가 발생을 하면 안에 내용을 실행해줄꺼다
//        color
//            .bind(with: self) { owner, color in
//            // 이 코드는 rx적인 코드는 아니고(받아온 color라는 친구가 클로저에 전달이 되고 이 클로저로 전달된 값을 그대로 보여주고만 있는 이 형태: 우리가 그동안 써온 클로저와 유사한 형태) : 이걸 간결하게 해줄 다른 방식이 또 있는데 "bind (to)" : 위아래 같은 의미
//            owner.view.backgroundColor = color
//            owner.emailTextField.tintColor = color
//        }
//        .disposed(by: disposeBag)
//        
        
        
        
        
        configureLayout()
        configure()
        
        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInButtonClicked), for: .touchUpInside)
    }
    
    @objc func signInButtonClicked() {
        PhotoManager.shared.getRandomPhoto(api: .random) { photo in
//            print("random", photo)
//            self.photoImageView.kf.setImage(with: URL(string: photo.urls.regular))
        }
    }
    
    @objc func signUpButtonClicked() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    
    func configure() {
        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
        signUpButton.setTitleColor(Color.black, for: .normal)
        photoImageView.backgroundColor = .blue
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        view.addSubview(photoImageView)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(signUpButton.snp.bottom).offset(10)
        }
    }
    

}
