//
//  ViewController.swift
//  Dardesh
//
//  Created by Zienab on 18/05/2023.
//

import UIKit
import ProgressHUD
class LoginViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var conformPassword: UILabel!
    @IBOutlet weak var haveAnAccountLbl: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var conformPassTesxtField: UITextField!
    
    //Button outlets
    
    @IBOutlet weak var forgotPasswordOutlet: UIButton!
    @IBOutlet weak var resendEmailOutlet: UIButton!
    @IBOutlet weak var loginBtnOutlet: UIButton!
    @IBOutlet weak var registerBtnOutlet: UIButton!
    
    private var isLogin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareTextFields()
    }
    
    @IBAction func forgotPassPressed(_ sender: Any) {
        if isDataInputedFor(mode: "forgotPassword"){
            forgotPassword()
        }else{
            ProgressHUD.showError("All fields are required!")
        }
    }
    
    @IBAction func resendEmailPressed(_ sender: Any) {
        resendVerificationEmail()
    }
    
    @IBAction func registerBtnPreesed(_ sender: Any) {
        if isDataInputedFor(mode: isLogin ? "Login" : "Register"){
            //TODO:- Login Or register
            isLogin ? loginUser() : registerUser()
            
            
        }else{
            ProgressHUD.showError("All fields are required!")
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        updateUIMode(mode: isLogin)
    }
    
    private func updateUIMode(mode: Bool){
        if !mode { // login
            titleLbl.text = "Login"
            conformPassword.isHidden = true
            conformPassTesxtField.isHidden = true
            registerBtnOutlet.setTitle("Login", for: .normal)
            loginBtnOutlet.setTitle("Register", for: .normal)
            haveAnAccountLbl.text = "New hete?"
            resendEmailOutlet.isHidden = true
            forgotPasswordOutlet.isHidden = false
            
        }else{
            titleLbl.text = "Register"
            conformPassword.isHidden = false
            conformPassTesxtField.isHidden = false
            registerBtnOutlet.setTitle("Register", for: .normal)
            loginBtnOutlet.setTitle("Login", for: .normal)
            haveAnAccountLbl.text = "Have an account?"
            resendEmailOutlet.isHidden = false
            forgotPasswordOutlet.isHidden = true

        }
         
        isLogin.toggle()
    }
    
    // Helpers
    private func isDataInputedFor(mode: String) -> Bool {
        switch mode {
        case "Login":
            return emailTextField.text != "" && passwordTextField.text != ""
            
        case "Register":
            return emailTextField.text != "" && passwordTextField.text != "" && conformPassTesxtField.text != ""
            
        case "forgotPassword":
            return emailTextField.text != ""
        default:
            return false
        }
    }
    
    
   // registerUser
    
  private func registerUser(){
            if passwordTextField.text! == conformPassTesxtField.text! {
                FUserListener.shared.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { error in
                    if error == nil {
                        ProgressHUD.showSuccess("verification email sent,please check your email and confirm the registeration")
                    }else{
                        ProgressHUD.showError(error?.localizedDescription)
                    }

                }
            }
        
    }
  // login user
    private func loginUser(){
        FUserListener.shared.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailFerivied)in
            
            if error == nil {
                
                if isEmailFerivied {
                    self.gotoApp()
                    print("your login is success!")
                }else{
                   print("please check your email to verify your registration ")
                }
                
            }else{
                ProgressHUD.showError(error?.localizedDescription)
            }
                
        }
    }
    
    // resendVerificationEmail
    func resendVerificationEmail(){
        FUserListener.shared.resendVerficationEmailwith(email: emailTextField.text!) { error in
            if error == nil {
                ProgressHUD.showSuccess("Verification email sent successfully!")
            }else{
                ProgressHUD.showError(error?.localizedDescription)
            }
        }
    }
    
    // forgot password
    func forgotPassword(){
        FUserListener.shared.resetPasswordFor(email: emailTextField.text!) { error in
            if error == nil {
                ProgressHUD.showSuccess("Reset password email has been sent")
             }else{
                ProgressHUD.showError(error?.localizedDescription)
            }
        }
    }
    
    func gotoApp(){
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true)
        
    }
    
    
}

extension LoginViewController :UITextFieldDelegate{
    
    func prepareTextFields(){
        emailLbl.text = ""
        passwordLbl.text = ""
        conformPassword.text = ""
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        conformPassTesxtField.delegate = self
        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        emailLbl.text = emailTextField.hasText ? "Email" : ""
        passwordLbl.text = passwordTextField.hasText ? "Password" : ""
        conformPassword.text = conformPassTesxtField.hasText ? "Conform password" : ""
        
    }
    
}
