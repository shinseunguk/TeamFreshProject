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
    let helper : Helper = Helper()
    private var viewControllers: Array<UIViewController> = []
    @IBOutlet weak var tempView: UIView! // 상단 탭바 들어갈 자리
    @IBOutlet weak var tableView: UITableView!
    
    let length : Int = 20
    
    var recordsTotal : Int = 0
    
    var index : Int = 0
    var searchObj : Dictionary<String, Any> = [:] //Server Request 하기 위한 Dictionary
    var creatDt : String? = nil
    
    var wrterNcnmArr : [Any] = []
    var anscntArr : [Int] = []
    var creatDtArr : [Any] = []
    var rdcntArr : [Int] = []
    var boardCnArr : [Any] = []
    var viewPagerArr = ["자유게시판", "한줄평", "영차TV"]
    var writeBtn: UIButton = {
        let writeBtn = UIButton()
        writeBtn.translatesAutoresizingMaskIntoConstraints = false
        writeBtn.setTitle("글쓰기", for: .normal)
        writeBtn.layer.cornerRadius = 5
        writeBtn.backgroundColor = UIColor.init(displayP3Red: 147/255, green: 111/255, blue: 104/255, alpha: 1)// backgroundColor #936f68
        return writeBtn
    }()
    let exceptionLabel : UILabel = {
        let exceptionLabel = UILabel()
        exceptionLabel.translatesAutoresizingMaskIntoConstraints = false
        exceptionLabel.textAlignment = .center
        exceptionLabel.font = UIFont.systemFont(ofSize: 15)
        exceptionLabel.textColor = .black
        exceptionLabel.backgroundColor = .white
        exceptionLabel.numberOfLines = 1
        exceptionLabel.text = "서버 통신실패 잠시후 다시 시도해주세요."
        return exceptionLabel
    }()
    
    var creatDEnd : String = {
        var now = NSDate()
        var formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        print("##", formatter.string(from: now as Date))
        return formatter.string(from: now as Date)
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        tempView.layer.addBorder([.bottom], color: UIColor.systemGray6, width: 2.0)
    }
    
    override func viewDidLoad() {
        print("\(#function)")
        
        searchObj["boardCn"] = "string"
        searchObj["boardSj"] = "string"
        searchObj["boardTy"] = "string"
        searchObj["creatDEnd"] = creatDEnd
        searchObj["creatDStart"] = "2022-06-28T08:48:15.289Z"
        searchObj["wrterLoginId"] = "string"
        searchObj["wrterNcnm"] = "string"
        
        requestServer()
        
        
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
    
    func requestServer() {
            let url = "https://yhapidev.teamfresh.co.kr/v1/free-boards/Dt"
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "accept")
            request.setValue("utf-8", forHTTPHeaderField: "Accept-Charset")
        
            request.timeoutInterval = 10
        
            let params = [
                "length" : length,
                "searchObj" : searchObj,
                "start" : length * index
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
//                        print("##\n",dicCreate)
                        self.recordsTotal = dicCreate["recordsTotal"] as! Int
                        
                        if dicCreate["code"]! as? Int == 0 || (dicCreate["code"]! as? Int)! >= 0 { // 서버 통신성공
                            print("##\n",dicCreate["data"]!)
                            let JSON = dicCreate["data"]! as! NSArray
                            for x in 0 ... 19 {
                                let firstResult = JSON[x]
                                //Convert to Data
                                let jsonData = try JSONSerialization.data(withJSONObject: firstResult, options: JSONSerialization.WritingOptions.prettyPrinted)
                                let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
//                                print("\(x)????1 ",json!["wrterNcnm"]! as Any) // 작성자
//                                print("\(x)????2 ",json!["anscnt"]! as Any) // 댓글수
//                                print("\(x)????3 ",json!["creatDt"]! as Any) // 생성일시
//                                print("\(x)????4 ",json!["rdcnt"]! as Any) // 조회수
//                                print("\(x)????5 ",json!["boardCn"]! as Any) // 게시글 내용
                                self.creatDt = json!["creatDt"]! as! String
                                
                                //json에서 값 가져와 배열로 담기 => tableView에 값들 뿌려주기 위한 작업
                                self.wrterNcnmArr.append(json!["wrterNcnm"]! as Any)
                                self.anscntArr.append(json!["anscnt"]! as! Int)
                                self.creatDtArr.append("\(self.creatDt!.substring(from: 2, to: 3)).\(self.creatDt!.substring(from: 5, to: 6)).\(self.creatDt!.substring(from: 8, to: 9))") // ex) 22-08-12
                                self.rdcntArr.append(json!["rdcnt"]! as! Int)
                                self.boardCnArr.append(json!["boardCn"]! as Any)
                            }
                                //서버에서 가져온 값들 set하기위한 reload
                                self.tableView.register(UINib(nibName: "BoardTableViewCell", bundle: nil), forCellReuseIdentifier: "BoardTableViewCell")
                                self.tableView.dataSource = self
                                self.tableView.delegate = self
                                self.tableView.reloadData()
                            
                        }else { // 서버 통신실패
                            print("서버 통신실패 예외처리")
                            self.tableView.removeFromSuperview()
                            self.view.addSubview(self.exceptionLabel)
                            self.exceptionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                            self.exceptionLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
                        }
                    } catch {
                        print("catch :: ", error.localizedDescription)
                    }
                case .failure(let error):
                    print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                }
            }
        index += 1
    }
    
}

extension BoardController: PageboyViewControllerDataSource, TMBarDataSource, UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return index * length
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BoardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BoardTableViewCell", for: indexPath) as! BoardTableViewCell
        cell.contentLabel.text = boardCnArr[indexPath.row] as! String
        cell.nickNameLabel.text = wrterNcnmArr[indexPath.row] as! String
        cell.dateLabel.text = creatDtArr[indexPath.row] as! String
        cell.viewCountLabel.text = "조회 \(rdcntArr[indexPath.row] as! Int)"
        cell.commentCountLabel.text = "\(anscntArr[indexPath.row] as! Int)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("willDisplay " ,indexPath.row)
        //240 .. 260
        if self.recordsTotal > indexPath.row { // 252  < 20 40 60 80 ... 220 240
            if indexPath.row == (index * length) - 1 { // 테이블뷰 맨아래까지 도달
                print("테이블뷰 맨아래까지 도달할때 서버통신")
                requestServer()
            }
        }
    }
    
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        
            //자유게시판 한줄평 영차TV
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
