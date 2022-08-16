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
        
        //로그인 완료후 네비게이터가 게시판으로 가게끔 구현
        selectedIndex = 3
        
        navigationBarSetUp() // 네비게이션바 setUP
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
    }
    
    override func viewDidLayoutSubviews() {
        print(#function)
        
        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .white // 네비게이션바 become black 삭제
//        appearance.shadowColor = .white // 네비게이션바 bottom 테두리 삭제
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        //
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        //
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        
        //navigationBar Shadow
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.2
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize.zero
        self.navigationController?.navigationBar.layer.shadowRadius = 5
        
        //네비게이션바 뒤로가기 삭제
        self.navigationItem.hidesBackButton = true
        
        appearanceTabbar.configureWithOpaqueBackground()
        appearanceTabbar.backgroundColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        uiTabBar.standardAppearance = appearanceTabbar
        
        uiTabBar.layer.borderWidth = 0.30
        uiTabBar.layer.borderColor = UIColor.clear.cgColor
        uiTabBar.clipsToBounds = true
//        uiTabBar.backgroundColor = .blue // 작동함
        
        // 네비게이터 tintColor #936f68
//        uiTabBar.tintColor = UIColor.init(displayP3Red: 147/255, green: 111/255, blue: 104/255, alpha: 1)
        
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
}
