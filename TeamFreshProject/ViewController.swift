//
//  ViewController.swift
//  TeamFreshProject
//
//  Created by mac on 2022/08/11.
//

// 08.11 commit => notion rgb추출하여 placeholder 적용, imageview setImage

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(#function)
        
        setUP()
        
        loginBtn.tag = 0
    }
    
    func setUP(){
        //아이디 텍스트필드 설정
        idTextField.attributedPlaceholder = NSAttributedString(string: "아이디", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        idTextField.autocorrectionType = .no
        idTextField.spellCheckingType = .no
        idTextField.autocapitalizationType = .none
        idTextField.returnKeyType = .next
//        idTextField.textContentType
        
        //비밀번호 텍스트필드 설정
        pwTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        pwTextField.autocorrectionType = .no
    }
    
    override func viewDidLayoutSubviews() {
        
        //아이디 텍스트필드
        idTextField.layer.cornerRadius = 10
        idTextField.backgroundColor = .systemGray6
        
        //패스워드 텍스트필드
        pwTextField.layer.cornerRadius = 10
        pwTextField.backgroundColor = .systemGray6
        
        //로그인 버튼 #ff6348
        loginBtn.layer.cornerRadius = 20
    }

    @IBAction func btnAction(_ sender: Any) {
        print((sender as AnyObject).tag!)
    }
    

}

