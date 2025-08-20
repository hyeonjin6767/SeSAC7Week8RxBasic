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
//    var data = [ "First Item", "Second Item", "Third Item"]
    
    //위에처럼하면 인스턴스가 중복되니까 레이지로 변경
    
//    lazy var items = Observable.just(
//        ["First Item", "Second Item", "Third Item"]
//    ) // 저스트 안에 배열에 데이터가 업데이트가 되야 셀도 새로 생성이 될것.
    
    // 위의 옵저버블을 처리기능(append)까지 가능하도록 BehaviorSubject로 바꾸기 : 옵저버블 역할도 해서 subscribe, bind 다 사용가능
//    lazy var items = BehaviorSubject(value: ["First Item", "Second Item", "Third Item"]) // BehaviorSubject : 전달+수습 2개 다 하는애
    
    let items = BehaviorSubject(value: ["First","ds","adev","b","AF"])

    
    
    var den = "den"
    lazy var jack = den
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        den = "adgas" // 알아서 jack까지 반영되진 않잖아.. : items도 첨에 초기화에 들어온 data가 끝. : 그러니 data에 변화가 생긴다고 items도 변화가 생기는건 아니야
        
        view.backgroundColor = .white
        configure()
        setSearchController()
        bind()
        operatorTest()
    }
    
    func bind() {
        print(#function)
        
        
        
        
        searchBar.rx.text.orEmpty //우리가 알던 orEmpty와 같아
            .debounce(.seconds(1), scheduler: MainScheduler.instance) //검색할 내용이 확정이나고 1초지났을 때 검색했으면 좋겠어! : 검색어가 입력하는 중에 하자마자 실시간 검색하지 않고 : 입력중에 한글특성상 자음만 입력했는데 검색되면 안되므로
            .distinctUntilChanged() // 같은 검색어는 검색되지 않도록 하는 오퍼레이터
            .subscribe(with: self) { owner, value in
                print("searchBar text", value)
                
                let all = try! owner.items.value()
                let filter = all.filter{ $0.contains(value) } // 포함으로 하면 불필요한 검색까지 발생할 수 있다 : debounce
                print(filter)
                
            }
            .disposed(by: disposeBag)
        
        
        
        
        searchBar.rx.searchButtonClicked //델리게이트 필요X
            .subscribe(with: self) { owner, _ in // 서치바를 클릭하면 실행
                print("클릭")
                
                /* 서치바의 글자로 셀 생성 순서
                 1. 서치바의 글자 가져오기
                 2. items에 글자 추가(append)
                 */
                guard let text = owner.searchBar.text else { return }
                //owner.items.onNext([text]) // items가 처음에는 스트링값을 주는 이벤트를 전달해주는 옵저버블이었다가 : 서치바를 클릭하는거 자체가 옵저버블 개념: 그럼 items는 엔터를 칠때는 이벤트를 받아서 처리하는 옵저버의 역할이 됨 : 셀에 보내주는거(전달) 셀의 배열에 추가(처리)해 주는거 두가지 역할 다하게 되는 BehaviorSubject로 업그레이드
                
                // owner.items의 value라는 메서드 : 정의에 throws로 오류를 던지고 있는 형태로 되어 있어서 : 기존 데이터 조회할 수 있는 기능 : try! 구문을 써줘야함
                var result = try! owner.items.value() // value는 스트링 배열로 옴
                result.append(text) // 트라이로 가져오면 데이터를 추가해 줄 수 있다 :
                owner.items.onNext(result)
                
                
            }
            .disposed(by: disposeBag)

        
        
        
        
        // "RxExample" 폴더에 다 샘플이 있음 : 다 익스텐션 처럼 만들어둔 파일이 존재하기 때문에 우리가 간편하게 갖다 쓰는것
        // rx가 명시해준 example 복붙
//        let items = Observable.just([ // 대충 저스트로 보아 배열 전체를 방출을 하고 있나보다
//            "First Item",
//            "Second Item",
//            "Third Item"
//        ]) //위로 빼도 되니까 그동안 만들었던 테이블뷰를 만드는 방법이 간결해짐

        
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
        
        tableView.rx.modelSelected(String.self) // 셀의 데이터가 스트링 타입으로 되어 있으니까 String.self로 지정 //데이터 방출하는 Observable
            .bind(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        
        
        //셀선택시의 기능은 이 zip 하나로~ : 얼럿같은게 두번 뜨면 안되니까 한번 뜨게 하려고 합침
        //위에는 두번 클릭이 되니까
        //itemSelected, modelSelected를 합쳐보자 : zip(두개를 합치는 일을 벌이겟다)
        Observable.zip(
            tableView.rx.modelSelected(String.self),
            tableView.rx.itemSelected //묶는 순서에 따라 바인드의 매개변수 순서가 정해짐
        )
        .bind(with: self) { owner, value in
            print(value.0)
            print(value.1)
//            owner.data.append("고래밥\(Int.random(in: 1...100))")
//            owner.tableView.reloadData() // 셀에 변화가 있진않음 : 셀 생성?
//            print(owner.data)
            
            // items가 옵저버블이지 배열은 아니라서 append될 수 없어
            // 옵져버블의 "특성"(일을 벌리는거 밖에 못함: "전달만") 때문에 append가 애초에 말이 안되는 행동 : 추가(append)하는 처리(수습)는 못함
            // items.append("sdgasdg") // 불가한 코드인 이유 위에 2가지
            
            // 그럼 어떻게해야하나
            // items가 이벤트를 전달도 하고 처리(append: 옵저버의 역할)도 했으면 좋겠다:일도 벌리고 일을 수습도 하고 싶다는 의미 : 옵저버블+옵저버 -> 두역할을 합친 BehaviorSubject
            //우선 items append기능을 주면 되는데 : 모든 것은 이벤트 전달을 통해서 함 : 이벤트를 보내줄수있는 3가지 next, error, complete 중에 onNext로 이벤트를 전달
            // rx에서 데이터를 받거나 처리하는 행위는 전부 다 onNext이다
            owner.items.onNext(["sgda"]) // 셀을 클릭할 때 이벤트 전달을 하고 싶다: items에 내용을 보내달라 : 데이터 교체
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
