//
//  AppDelegate.swift
//  GZWeibo666
//
//  Created by Apple on 15/11/22.
//  Copyright © 2015年 itcast. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupAppearance()
        
        print("加载账户信息:\(CZUserAccount.loadUserAccount())")

        // 创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // 设置window的背景
        window?.backgroundColor = UIColor.whiteColor()
        
        // 创建tabbarVC
        let tabbarVC = CZMainViewController()
        
        // 设置根控制器
//        window?.rootViewController = tabbarVC
        
        window?.rootViewController = defaultController()
        
        // 设置keywindow和显示
        // ? 表示?前面的变量/常量有值就执行?后面的代码. ?前面没有值,不执行后面的代码
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: - 判断进入哪个控制器
    private func defaultController() -> UIViewController {
        // 用户是否登录, 没有加载到账号表示没有登录
        if !CZUserAccount.userLogin {
            // 显示访客视图
            return CZMainViewController()
        }
        
        // 用户已经登录
        // 是否是新版本,新版本返回新特性界面,否则返回欢迎界面
        return isNewFeature() ? CZNewFeatureViewController() : CZWelcomeViewController()
    }
    
    // MARK: - 其他界面切换控制器,需要通过 AppDelegate 来切换
    // 目标控制器有2个: 欢迎界面和MainViewController
    /**
    其他界面切换控制器
    
    - parameter isMain: true表示切换到MainViewController, false表示切换到欢迎界面
    */
    private func switchViewController(isMain: Bool) {
        window?.rootViewController = isMain ? CZMainViewController() : CZWelcomeViewController()
    }
    
    // MARK: - 类方法,切换控制器,方便别人调用
    /**
    类方法,切换控制器,方便别人调用
    
    - parameter isMain: true表示切换到MainViewController, false表示切换到欢迎界面
    */
    class func switchRootViewController(isMain: Bool) {
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.switchViewController(isMain)
    }
    
    // MARK: - 判断是否是新版本
    /**
    判断是否是新版本
    
    - returns: 是否是新版本
    */
    private func isNewFeature() -> Bool {
        // 获取当前版本
        let currentVersion = Double(NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String)!
        
        // 获取上一次的版本(从偏好设置)
        let sandboxVersionKey = "sandboxVersionKey"
        
        // 上一次的版本号
        let sandboxVersion = NSUserDefaults.standardUserDefaults().doubleForKey(sandboxVersionKey)
        
        // 保存当前版本
        NSUserDefaults.standardUserDefaults().setDouble(currentVersion, forKey: sandboxVersionKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        print("currentVersion: \(currentVersion)")
        print("sandboxVersion: \(sandboxVersion)")
        
        // 比较当前版本和上一次的版本
        return currentVersion != sandboxVersion
    }
    
    /// 设置导航栏皮肤
    func setupAppearance() {
        let bar = UINavigationBar.appearance()
        bar.tintColor = UIColor.orangeColor()
    }


}

