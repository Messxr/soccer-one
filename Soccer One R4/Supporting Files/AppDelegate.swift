//
//  AppDelegate.swift
//  Soccer One
//
//  Created by Daniil Marusenko on 04.12.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // - UI
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
                
        window.rootViewController = casualRootVC()
        return true
    }
    
    func casualRootVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Teams")
        return vc
    }

}

