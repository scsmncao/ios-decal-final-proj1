//
//  ViewController.swift
//  Miracle
//
//  Created by Simon Cao on 12/4/16.
//  Copyright © 2016 Miracle. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookCore
import FacebookLogin
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //video background
        let path = Bundle.main.path(forResource: "naturescreen480", ofType: "mov")
        var player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(playerLayer)
        player.seek(to: kCMTimeZero)
        player.play()
        self.loopVideo(videoPlayer: player)
        
        // Screen Sizes
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        // Add a custom login button to your app
        let myLoginButton = UIButton(type: .custom)
        myLoginButton.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
        myLoginButton.frame = CGRect(x: 0, y: 0, width: 230, height: 50)
        myLoginButton.center = CGPoint(x: screenWidth/2, y: screenHeight * 0.80)
        myLoginButton.setTitle("Sign in with Facebook", for: .normal)
        
        // Handle clicks on the button
        myLoginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        
        // Add the button to the view
        view.addSubview(myLoginButton)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 200))
        label.center = CGPoint(x: screenWidth/2, y: screenHeight * 0.20)
        label.textAlignment = .center
        label.text = "Miracle"
        label.textColor = UIColor.white
        label.font = UIFont(name: label.font.fontName, size: 30.0)
        self.view.addSubview(label)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Once the button is clicked, show the login dialog
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .userFriends, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: AccessToken.current!.authenticationToken)
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    // ...
                    self.performSegue(withIdentifier: "LoginSuccess", sender: self)
                    if let error = error {
                        // ...
                        return
                    }
                }

            }
        }
        }
    
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: kCMTimeZero)
            videoPlayer.play()
        }
    }


}

