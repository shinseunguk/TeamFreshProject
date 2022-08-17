//
//  BoardController.swift
//  TeamFreshProject
//
//  Created by ukBook on 2022/08/14.
//

import Foundation
import UIKit
import Tabman
import Pageboy
import Alamofire

class BoardController : TabmanViewController {
    
    private var viewControllers: Array<UIViewController> = []
    @IBOutlet weak var tempView: UIView! // 상단 탭바 들어갈 자리
    @IBOutlet weak var tableView: UITableView!
    
    var viewPagerArr = ["자유게시판", "한줄평", "영차TV"]
    var writeBtn: UIButton = {
        let writeBtn = UIButton()
        writeBtn.translatesAutoresizingMaskIntoConstraints = false
        writeBtn.setTitle("글쓰기", for: .normal)
        writeBtn.layer.cornerRadius = 5
        writeBtn.backgroundColor = UIColor.init(displayP3Red: 147/255, green: 111/255, blue: 104/255, alpha: 1)// backgroundColor #936f68
        return writeBtn
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        tempView.layer.addBorder([.bottom], color: UIColor.systemGray6, width: 2.0)
    }
    
    override func viewDidLoad() {
        print("\(#function)")
        
        tableView.register(UINib(nibName: "BoardTableViewCell", bundle: nil), forCellReuseIdentifier: "BoardTableViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        setTabMan() // Tabman 설정
        navigationBarSetUp() // 네비게이션바 설정
        writeBtnSetUp() // [글쓰기] 버튼 UI
        
        
    }
    
    func setTabMan() {
        let VC1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC1Controller") as! VC1Controller
        let VC2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC2Controller") as! VC2Controller
        let VC3 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC3Controller") as! VC3Controller

        viewControllers.append(VC1)
        viewControllers.append(VC2)
        viewControllers.append(VC3)

        self.dataSource = self

        // Create bar
        let bar = TMBar.ButtonBar()
//        let bar = TMBar.TabBar()
        bar.backgroundView.style = .blur(style: .regular)
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 25.0, bottom: 0.0, right: 0.0)
        bar.buttons.customize { (button) in
            button.tintColor = UIColor.systemGray2 // 선택 안되어 있을 때
            button.selectedTintColor = .black // 선택 되어 있을 때
            button.font = UIFont.systemFont(ofSize: 16)
        }
        // 인디케이터 조정
        bar.indicator.weight = .medium
        bar.indicator.tintColor = .black
        bar.indicator.overscrollBehavior = .bounce
//        bar.layout.alignment = .
//        bar.layout.contentMode = .fit
        bar.layout.interButtonSpacing = 20 // 버튼 사이 간격

        bar.layout.transitionStyle = .snap // Customize

        // Add to view
        addBar(bar, dataSource: self, at: .custom(view: tempView, layout: nil)) // .custom을 통해 원하는 뷰에 삽입함. BarLocatio https://github.com/uias/Tabman/blob/main/Sources/Tabman/TabmanViewController.swift#L27-L32
    }
    
    func navigationBarSetUp() {
        // 네비게이션 뒤로가기 삭제
        self.navigationItem.title = "게시판"
        self.navigationItem.hidesBackButton = true
        
        
        let rightBarButton = UIBarButtonItem.init(image: UIImage(systemName: "person"),  style: .plain, target: self, action: nil)
        rightBarButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let leftBarButton = UIBarButtonItem.init(image: UIImage(systemName: "bell"),  style: .plain, target: self, action: nil)
        leftBarButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func writeBtnSetUp(){
        tempView.addSubview(writeBtn)
        tempView.bringSubviewToFront(writeBtn)
        writeBtn.rightAnchor.constraint(equalTo: tempView.rightAnchor, constant: -20).isActive = true
        writeBtn.bottomAnchor.constraint(equalTo: tempView.bottomAnchor, constant: -8).isActive = true
        writeBtn.widthAnchor.constraint(equalToConstant: 75).isActive = true
    }
    
    func requestServer(identity : String, password : String) {
            let url = "https://yhapidev.teamfresh.co.kr/v1/free-boards/Dt"
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "accept")
            request.setValue("utf-8", forHTTPHeaderField: "Accept-Charset")
        
            request.timeoutInterval = 10
            
            // POST 로 보낼 정보 appdev / Timf1234
            let params = [
                "userLoginId" : identity,
                "userLoginPassword" : password
            ] as Dictionary

            // httpBody 에 parameters 추가
            do {
                try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
            } catch {
                print("http Body Error")
            }
            
            AF.request(request).responseJSON { (response) in
                switch response.result {
                case .success:
                    print("POST 성공")
                    do {
                        // [응답 전체 data 를 json to dictionary 로 변환 실시]
                        let dicCreate = try JSONSerialization.jsonObject(with: Data(response.data!), options: []) as! [String:Any]
                        // [jsonArray In jsonObject 형식 데이터를 파싱 실시 : 유니코드 형식 문자열이 자동으로 변환됨]
                        print("msg =>", dicCreate["msg"]!)
                        print("code =>", dicCreate["code"]!)
                        print("success =>", dicCreate["success"]!)
                        
                        if dicCreate["code"]! as? Int != 0 { // 로그인 실패 server 에서 받아온 String값 alert으로 뿌려줌
                            self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: dicCreate["msg"]! as! String, completeTitle: "확인", nil)
                        }else { // 로그인 성공 => 화면이동
//                            guard let pushVC = self.storyboard?.instantiateViewController(identifier: "BoardController") as? BoardController else{
//                                return
//                            }
//                            self.navigationController?.pushViewController(pushVC, animated: true)
                            
                            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarController")
                            self.navigationController?.pushViewController(pushVC!, animated: true)
                        }
                        
                    } catch {
                        print("catch :: ", error.localizedDescription)
                    }
                case .failure(let error):
                    print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                }
            }
    }
}

extension BoardController: PageboyViewControllerDataSource, TMBarDataSource, UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewPagerArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 내가 정의한 Cell 만들기
        let cell: BoardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BoardTableViewCell", for: indexPath) as! BoardTableViewCell
        // Cell Label의 내용 지정
        
        if indexPath.row == 0 {
            cell.contentLabel.text = "이번달 명세서 언제부터 볼 수"
        }else {
            cell.contentLabel.text = "이번달 명세서 언제부터 볼 수 있나요 이번달 명세서 언제부터 볼 수 있나요"
        }
        
        
        // 생성한 Cell 리턴
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109
    }
    
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        
            // MARK: - Tab 안 글씨들
            switch index {
            case 0:
                return TMBarItem(title: viewPagerArr[0])
            case 1:
                return TMBarItem(title: viewPagerArr[1])
            case 2:
                return TMBarItem(title: viewPagerArr[2])
            default:
                let title = "Page \(index)"
                return TMBarItem(title: title)
            }
        }
        
        func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
            return viewPagerArr.count
        }
        
        func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
            return viewControllers[index]
        }
        
        func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
            return nil
        }
    
}
