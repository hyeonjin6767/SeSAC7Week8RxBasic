//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
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
    
    
//    let userDate = BehaviorSubject(value: Date()) // Data() : 오늘 날짜를 보여지게
    let userDate = BehaviorRelay(value: Date())
    // BehaviorRelays도 바인드처럼 넥스트이벤트만 다루는 애 서브젝트 업그레이드가 릴레이 : (서브스크라이브 업그레이드가 바인드인 것 처럼)
    // 우선은 기분에 따라 골라서 써봐
    // "drive"는 또 뭐지 : 바인드 업그레이드 버전? : 넥스트이벤트만 담당 및 메인쓰레드에서만 동작 하는 애
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        bind()
        
//        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
    }
    
    func bind() {
        
        // birthDayPicker이 옵저버블의 역할로
        
        /*
         
        birthDayPicker.rx.date
            .bind(with: self) { owner, date in
                print(date)
//                owner.userDate.onNext(date)
                owner.userDate.accept(date) //릴레이는 accept로 보내줌

            }
            .disposed(by: disposeBag)
         
        */
        
        userDate
            .bind(with: self) { owner, date in
                
                let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
                owner.yearLabel.text = "\(components.year!)"
                owner.monthLabel.text = "\(components.month!)"
                owner.dayLabel.text = "\(components.day!)"

            }
            .disposed(by: disposeBag)
        
        
        // "drive"
        // 위에 birthDayPicker의 bind와 같은 의미
        birthDayPicker.rx.date
            .asDriver() //asDriver로 타입을 바꿔줘야 drive 사용 가능 : 메인스레드에서만 동작을 보장함
            .drive(with: self) { owner, date in
                print(date)
                owner.userDate.accept(date) // relay는 accept로 보내줌
            }
            .disposed(by: disposeBag)
        
     
        
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
