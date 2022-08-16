//
//  CustomTabBarController.swift
//  TeamFreshProject
//
//  Created by ukBook on 2022/08/15.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let appearance = UINavigationBarAppearance()
    let appearanceTabbar = UITabBarAppearance()
    @IBOutlet weak var uiTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        selectedIndex = 3 //로그인 완료후 네비게이터가 게시판으로 가게끔 구현
        
        navigationBarSetUp() // 네비게이션바 setup
        setupStyle() // 탭바 setup
        
        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .white // 네비게이션바 become black 삭제
//        appearance.shadowColor = .white // 네비게이션바 bottom 테두리 삭제
        
//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.navigationBar.tintColor = .systemBlue
//        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        
        // navigationBar Shadow
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.3
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize.zero
        self.navigationController?.navigationBar.layer.shadowRadius = 8
        
        // 네비게이션바 뒤로가기 삭제
        self.navigationItem.hidesBackButton = true
    }
    
    func navigationBarSetUp() {
        // 네비게이션 뒤로가기 삭제
        self.navigationItem.title = "게시판"
        self.navigationItem.hidesBackButton = true
        
        // 네비게이션바 오른쪽에 버튼 set
        let rightBarButton = UIBarButtonItem.init(image: UIImage(systemName: "person"),  style: .plain, target: self, action: nil)
        rightBarButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        // 네비게이션바 왼쪽에 버튼 set
        let leftBarButton = UIBarButtonItem.init(image: UIImage(systemName: "bell"),  style: .plain, target: self, action: nil)
        leftBarButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
}

extension CustomTabBarController{
    // Tabbar Index에 맞춰 navigationBar title 변경
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            self.navigationItem.title = "홈"
        case 1:
            self.navigationItem.title = "일구하기"
        case 2:
            self.navigationItem.title = "정산"
        case 3:
            self.navigationItem.title = "게시판"
        case 4:
            self.navigationItem.title = "운송리뷰"
        default :
            print("default")
        }
    }
    
    // UITabBar add Shadow
    func setupStyle() {
        UITabBar.clearShadow() // 기본 그림자 스타일을 초기화해야 커스텀 스타일을 적용할 수 있다.(UITabBar extension)
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12) // Sketch 스타일의 그림자를 생성하는 유틸리티 함수
    }
}
