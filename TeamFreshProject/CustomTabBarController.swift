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
    @IBOutlet weak var uiTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(#file) \(#function)")
        
        navigationBarSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("customtabbar viewWillAppear")
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white // 네비게이션바 become black 삭제
        appearance.shadowColor = .white // 네비게이션바 bottom 테두리 삭제
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        //
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        //
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        
        //네비게이션바 뒤로가기 삭제
        self.navigationItem.hidesBackButton = true
//
//        self.navigationController?.navigationBar.topItem?.title = "기프티콘 저장"
        
//        if #available(iOS 15.0, *) {
            let appearanceTabbar = UITabBarAppearance()
            appearanceTabbar.configureWithOpaqueBackground()
            appearanceTabbar.backgroundColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
            uiTabBar.standardAppearance = appearanceTabbar
//            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
//        }
        uiTabBar.layer.borderWidth = 0.30
        uiTabBar.layer.borderColor = UIColor.clear.cgColor
        uiTabBar.clipsToBounds = true
        
        
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
