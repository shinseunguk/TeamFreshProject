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

class BoardController : TabmanViewController {
    
    private var viewControllers: Array<UIViewController> = []
    @IBOutlet weak var tempView: UIView! // 상단 탭바 들어갈 자리
    
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
}

extension BoardController: PageboyViewControllerDataSource, TMBarDataSource{
    
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
