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
    @IBOutlet weak var findIdBtn: UIButton!
    @IBOutlet weak var findPwBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    let helper : Helper = Helper()
    
    struct userlist: Codable {
        var code : Int
        var data : String
        var msg : String
        var success : Int
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(#function)
        
        setUP()
        
        loginBtn.tag = 0
        findIdBtn.tag = 1
        findPwBtn.tag = 2
        signUpBtn.tag = 3
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        imageView.addGestureRecognizer(tapGR)
        imageView.isUserInteractionEnabled = true
    }
    
    func setUP(){
        //아이디 텍스트필드 설정
        idTextField.attributedPlaceholder = NSAttributedString(string: "아이디", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        idTextField.spellCheckingType = .no // 자동 맞춤법 사용x
        idTextField.autocapitalizationType = .none // 자동 첫알파벳 대문자로 변경 사용x
        idTextField.returnKeyType = .next // 키보드 return 키 타입을 next로 변경 (시뮬레이션 혹은 블루투스 키보드에서는 확인 불가)
        idTextField.textContentType = .emailAddress // 키보드 ContentType(이메일을 입력 받아야 하기 때문에 이메일로 처리)
//        idTextField.textContentType
        idTextField.addLeftPadding()
        
        //비밀번호 텍스트필드 설정
        pwTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        pwTextField.addLeftPadding()
        idTextField.spellCheckingType = .no // 자동 맞춤법 사용x
        idTextField.autocapitalizationType = .none // 자동 첫알파벳 대문자로 변경 사용x
        idTextField.returnKeyType = .done // 키보드 return 키 타입을 done로 변경 (시뮬레이션 혹은 블루투스 키보드에서는 확인 불가, done터치시 btnAction함수 실행)
        pwTextField.textContentType = .password // 키보드 ContentType(비밀번호를 입력 받아야 하기 때문에 password로 처리)
    }
    
    override func viewDidLayoutSubviews() {
        
        //아이디 텍스트필드
        idTextField.layer.cornerRadius = 10
        idTextField.backgroundColor = .systemGray6
        
        //패스워드 텍스트필드
        pwTextField.layer.cornerRadius = 10
        pwTextField.backgroundColor = .systemGray6
        
        //로그인 버튼 #ff6348
        loginBtn.layer.cornerRadius = 30
    }

    @IBAction func btnAction(_ sender: AnyObject) {
        switch (sender as AnyObject).tag! {
            case 0: // 로그인 버튼 클릭시
                //로그인 로직
                loginAction(idTextField: idTextField, pwTextField: pwTextField)
            break
            case 1...3: // 이외 버튼 클릭시
            helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: (sender as! UIButton).titleLabel!.text!, completeTitle: "확인", nil)
            break
            default:
                print("default")
        }
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "카카오 로그인", completeTitle: "확인", nil)
        }
    }
    
    func loginAction(idTextField : UITextField, pwTextField : UITextField){
        if let text = idTextField.text, text.isEmpty{
            helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "아이디를 입력해주세요", completeTitle: "확인", nil) //set focus필요
        }else if let text1 = pwTextField.text, text1.isEmpty {
            helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "비밀번호를 입력해주세요", completeTitle: "확인", nil) //set focus필요
        }else { // id/pw칸이 빈칸이 아닐때
            tryLogin(identity: idTextField.text!, password: pwTextField.text!)
        }
    }
    
    func tryLogin(identity : String, password : String) {
            let url = "https://yhapidev.teamfresh.co.kr/v1/signIn"
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
                            print("gogo")
                            
                            guard let pushVC = self.storyboard?.instantiateViewController(identifier: "BoardController") as? BoardController else{
                                return
                            }
                            self.navigationController?.pushViewController(pushVC, animated: true)
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

