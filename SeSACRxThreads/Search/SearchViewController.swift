//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


// 아무리 rx로 짠다해도 테이블뷰에 등록하고 레이아웃 잡는 거는 똑같이 해줘야 함!!!


class SearchViewController: UIViewController {
   
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .lightGray
        view.rowHeight = 180
        view.separatorStyle = .none
       return view
     }()
    
//    let items = Observable.just(["First Item", "Second Item", "Third Item"]) //아래껄 위로
    
    let searchBar = UISearchBar()
    
    let disposeBag = DisposeBag()
    
    //셀 클릭시 셀의 데이터(셀의 제목)를 갖고 오고 싶다!: 어떻게 접근해하나 : 방법은 많음
    // 우선 방법 하나: 실제 데이터를 다른 배열에 두자 : 배열의 인덱스로 접근을 하기 위해서
    let data = [ "First Item", "Second Item", "Third Item"]
    lazy var items = Observable.just(data) //위에처럼하면 인스턴스가 중복되니까 레아지로 변경
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        setSearchController()
        bind()
        operatorTest()
    }
    
    func bind() {
        print(#function)
        
        
        
        // "RxExample" 폴더에 다 샘플이 있음 : 다 익스텐션 처럼 만들어둔 파일이 존재하기 때문에 우리가 간편하게 갖다 쓰는것
        // rx가 명시해준 example 복붙
        let items = Observable.just([ // 대충 저스트로 보아 배열 전체를 방출을 하고 있나보다
            "First Item",
            "Second Item",
            "Third Item"
        ]) //위로 빼도 되니까 그동안 만들었던 테이블뷰를 만드는 방법이 간결해짐

        
        // 코드가 어색
        
        
        items //observable
        .bind(to: tableView.rx.items) { (tableView, row, element) in
            
            // 아래 3줄은 알고 있던 형태로 보인다
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as! SearchTableViewCell
            cell.appNameLabel.text = "\(element) @ row \(row)"
            return cell
            
        }
        .disposed(by: disposeBag)
        
        //셀 클릭도 rx에서 미리 만들어둠 : 델리게이트 채택 안해줘도 됨
        
        //인덱스 갖고오는거 따로 : itemSelected
        
//        tableView.rx.itemSelected // 셀클릭시 방출하는 이벤트:Observable
//            .bind(with: self) { owner, indexPath in
//                print(indexPath) //넥스트
//                print(owner.data[indexPath.row])
//                //owner.navigationItem.title =
//            }
//            .disposed(by: disposeBag)
//        
//        //데이터 갖고 오는거 따로 : modelSelected
        
//        tableView.rx.modelSelected(String.self) // 셀의 데이터가 스트링 타입으로 되어 있으니까 String.self로 지정 //데이터 방출하는 Observable
//            .bind(with: self) { owner, value in
//                print(value)
//            }
//            .disposed(by: disposeBag)
        
        
        
        //셀선택시의 기능은 이 zip 하나로~ : 얼럿같은게 두번 뜨면 안되니까 한번 뜨게 하려고 합침
        //위에는 두번 클릭이 되니까
        //itemSelected, modelSelected를 합쳐보자 : zip(두개를 합치는 일을 벌이겟다)
        Observable.zip(
            tableView.rx.modelSelected(String.self),
            tableView.rx.itemSelected //묶는 순서에 따라 바인드의 매개변수 순서가 정해짐
        ).bind(with: self) { owner, value in
            print(value.0)
            print(value.1)
        }
        .disposed(by: disposeBag)
        
        
        // combineLatest : 위에 zip이랑 다른게 두번 프린트됨.. : 오퍼레이터는 2개를 비교하면서 사용하면 도움됨~ : zip vs combineLatest 차이점: 아래 operatorTest함수로 비교해보자(예시)
//        Observable.combineLatest(
//            tableView.rx.modelSelected(String.self),
//            tableView.rx.itemSelected //묶는 순서에 따라 바인드의 매개변수 순서가 정해짐
//        ).bind(with: self) { owner, value in
//            print(value.0)
//            print(value.1)
//        }
//        .disposed(by: disposeBag)
//        
 
    }
    
    func operatorTest() {
        
        // of :
        let mentor = Observable.of("Hue", "Jack", "Finn")
        let age = Observable.of(10)
        
        /*
         zip : 두 옵저버블이 모두 변화할 때 이벤트가 방출됨
         combineLatest : 두 옵저버블 중 하나만 바껴도 이벤트가 방출됨
         */
        Observable.zip(
            mentor,
            age
        )
        .bind(with: self) { owner, value in
            print(value)
        }
        .disposed(by: disposeBag)
        
    }
     
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    @objc func plusButtonClicked() {
        print("추가 버튼 클릭")
    }

    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
}
