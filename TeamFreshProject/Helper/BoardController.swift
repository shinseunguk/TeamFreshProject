//
//  BoardController.swift
//  TeamFreshProject
//
//  Created by ukBook on 2022/08/14.
//

import Foundation
import UIKit

class BoardController : UIViewController {
    override func viewDidLoad() {
        print("\(#function)")
        
        navigationBarSetUp()
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
