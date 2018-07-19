//
//  ViewController.swift
//  FirebaseSocialLogin
//
//  Created by SEAN on 2018/7/18.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {

    let facebookLoginButtton: FBSDKLoginButton = {
        let loginButton = FBSDKLoginButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        for const in loginButton.constraints{
            if const.firstAttribute == NSLayoutAttribute.height && const.constant == 28{
                loginButton.removeConstraint(const)
            }
        }
        loginButton.readPermissions = ["email", "public_profile"]

        return loginButton
    }()
    
    let customFBLoginButton: UIButton = {
        let loginButton = UIButton(type: .system)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Facebook帳戶登入", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = UIColor(red: 66/255, green: 103/255, blue: 178/255, alpha: 1)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        return loginButton
    }()
    
    let googleLoginButtion: GIDSignInButton = {
        let loginButton = GIDSignInButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        return loginButton
    }()
    
    let customGoogleLoginButton: UIButton = {
        let loginButton = UIButton(type: .system)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Google帳戶登入", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = UIColor.red
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.addTarget(self, action: #selector(handleCustomGoogleSignIn), for: .touchUpInside)
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFacebookButton()
        setupGoogleButton()
    }
    
    private func setupGoogleButton(){
        view.addSubview(googleLoginButtion)
        googleLoginButtion.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        googleLoginButtion.bottomAnchor.constraint(equalTo: facebookLoginButtton.topAnchor, constant: -16).isActive = true
        googleLoginButtion.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        googleLoginButtion.heightAnchor.constraint(equalToConstant: 50).isActive = true
        GIDSignIn.sharedInstance().uiDelegate = self
        
        view.addSubview(customGoogleLoginButton)
        customGoogleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customGoogleLoginButton.bottomAnchor.constraint(equalTo: googleLoginButtion.topAnchor, constant: -16).isActive = true
        customGoogleLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        customGoogleLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupFacebookButton(){
        view.addSubview(facebookLoginButtton)
        facebookLoginButtton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookLoginButtton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        facebookLoginButtton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        facebookLoginButtton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        facebookLoginButtton.delegate = self
        
        view.addSubview(customFBLoginButton)
        customFBLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customFBLoginButton.topAnchor.constraint(equalTo: facebookLoginButtton.bottomAnchor, constant: 16).isActive = true
        customFBLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        customFBLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc private func handleCustomGoogleSignIn(){
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc private func handleCustomFBLogin(){
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil{
                print("Custom FB Login failed: ", error ?? "error")
            }
            self.showFacebookEmailAdress()
        }
            
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("Failed to log in with facebook: ", error)
            return
        }
        
        showFacebookEmailAdress()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did Log out of facebook")
    }
    
    private func showFacebookEmailAdress(){
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signInAndRetrieveData(with: credentials) { (result, error) in
            if error != nil {
                print("Failed to sign in Firebase by FB: ", error ?? "error")
                return
            }
            print("Successfully logged in Firebase with facebook...")
            print(result?.user.uid ?? "no uid")
        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            if err != nil {
                print("Failed to start graph request: ", err ?? "error")
                return
            }
            print(result ?? "")
        }
    }
    

}

