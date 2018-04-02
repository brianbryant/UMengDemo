//
//  AppDelegate.swift
//  UMengDemo
//
//  Created by brian on 2018/4/2.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

/*
 UMSocialSDK文件夹
 > analytics:统计库
 > push:推送通知库
 > share:分享库
    > share_ios_version > SocialLibraries:需要分享到的平台的库
 > common: UMeng所有业务库必须依赖的基础功能库，为每个业务模块提供初始化功能，数据传输等功能，把老版的每个业务的初始化APPKey的函数统一到UMCommon.framework库中，用户只需要调用UMCommon的初始化接口即可初始化对应APPKey。
 > thirdparties:UTDID库
 */

/*
 UMeng基础库集成:
 1. 通过AddFileToProject导入UMCommon库文件到项目中
 2. 添加需要用到的系统库：
    点击项目 -> Target -> Build Phases -> Link Binary With Libraries
    导入以下库文件：
        > CoreTelephony.framework    获取运营商标识
        > libz.tbd  数据压缩
        > libsqlite3.tbd  数据缓存
 3. 引入UICommon库的头文件：#import <UMCommon/UMCommon.h>
 4. 初始化AppKey函数，在didFinishLaunchingWithOptions方法中通过：UMConfigure.initWithAppkey("5519104afd98c5338e0002f4", channel: "Apple Store")
 
 
 Tips：通过代码UMConfigure.setLogEnabled(true)打开Log输出一些集成过程中的提示信息，方便调试。
 */

/*
 UMeng统计SDK集成：
 1. 通过AddFileToProject导入UMAnalytics库文件到项目中
 2. 引入UMAnalytics的头文件：#import <UMAnalytics/MobClick.h>
 3. 设置统计场景，在didFinishLaunchingWithOptions方法中通过：MobClick.setScenarioType(eScenarioType.E_UM_NORMAL)
 4. 运行程序，会在控制器看到输出信息：友盟版本号，App版本号，友盟统计版本号等等
 5. 退出程序到后台（真机就是home键，模拟器就是command + shift + h），会在控制器看到统计成功的输出信息
 
 Tips: 如果需要统计游戏场景、Dplus场景，则需要分别引入场景对应的头文件，并在MobClick.setScenarioType方法中，通过“或”设置。
 */

/*
 UMeng推送SDK集成
 1. 通过AddFileToProject导入UMPush库文件到项目中
 2. 添加需要用到的系统库：
    点击项目 -> Target -> Build Phases -> Link Binary With Libraries
    导入以下库文件：
        > UserNotifications
 3. 引入友盟推送的头文件：#import <UMPush/UMessage.h>
 4. 引入系统通知库UserNotifications的头文件：import UserNotifications
 5. 设置UNUserNotificationCenter代理为AppDelegate，AppDelegate遵守代理协议UNUserNotificationCenterDelegate，实现代理方法
    > 代理方法主要是在iOS10以上的系统中接收通知，处理通知
 6. 注册通知，申请授权通知
 7. 打开Capabilities中的Push Notifications开关、Background Modes中的Remote Notifications开关
 */

/*
 UMeng分享SDK集成
 1. 通过AddFileToProject导入UShare库文件到项目中
 2. 进入Build Setting -> Other Linker FLags -> 添加-ObjC
 3. 配置第三方平台的一些参数：
        > 配置SSO白名单:此项配置App向第三方平台跳转/分享必须的参数
        > 由于新浪微博SDK还未更新ATS的支持，故目前需要对其进行配置以支持新浪微博的Http请求，在新浪微博的配置信息字典里加入NSAllowsArbitaryLoads = true
 4. 添加第三方平台URL Scheme。在target -> info -> url type中配置
        > Idenfifier: weixin。URL Schemes：WX开头的字符串
        > Identifier: QQ。URL Schemes："tencent"字符串和QQ互联获取的AppID拼接组成
        > Identifier：QQ。URL Schemes："QQ"字符串和QQ互联获取的AppID转成的十六位字符串拼接而成
        > Identifier：weibo。URL Schemes："wb"字符串和微博开放平台获取的AppKey字符串拼接而成
 5. 通过UMShare接口设置从第三方平台获取的appkey和appsecret参数
 6. 设置系统回调，将第三方平台返回的授权或分享的结果传入到UShare中处理（AppDelegate-Share）
 7. 通过UShare的接口向第三方平台获取授权登录信息或进行内容的分享（ViewController.h中）
 8. 分享信息到第三方平台
 */

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /*
         打开Log输出设置，输出集成过程中提示信息
         */
        UMConfigure.setLogEnabled(true)
        
        /*
         集成基础库的最后一步：在基础库中设置AppKey
         */
        UMConfigure.initWithAppkey("5519104afd98c5338e0002f4", channel: "Apple Store")
        
        /*
         设置友盟统计的场景
         */
        MobClick.setScenarioType(eScenarioType.init(rawValue: eScenarioType.E_UM_NORMAL.rawValue | eScenarioType.E_UM_GAME.rawValue | eScenarioType.E_UM_DPLUS.rawValue)!)
        
        /*
         注册通知
         */
        /*
         设置推送通知的代理为AppDelegate
         */
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        
        let entity = UMessageRegisterEntity.init()
        entity.types = Int(UMessageAuthorizationOptions.alert.rawValue | UMessageAuthorizationOptions.badge.rawValue | UMessageAuthorizationOptions.sound.rawValue)
        UMessage.registerForRemoteNotifications(launchOptions: launchOptions, entity: entity) { (granted, error) in
            if error == nil {
                print("申请注册通知网络请求成功！！！")
                
                if granted {
                    print("通知已授权")
                } else {
                    print("通知未授权")
                }
                
            } else {
                print("申请注册通知网络请求失败！！！")
            }
        }
        
        // 通过UMShare接口设置从第三方平台获取的appkey和appsecret参数
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: "wx5f64c38c242f5927", appSecret: "988bd80578137e0748b119a8bfcec39d", redirectURL: nil)
        // 新浪微博需要添加在新浪微博平台注册的redirectURL
        UMSocialManager.default().setPlaform(UMSocialPlatformType.sina, appKey: "1262263233", appSecret: "e90a187fbcd5cba613bc14dd9bb4d9a6", redirectURL: "http://sns.whalecloud.com/sina2/callback")
        // QQ redirectURl可以默认不添加
        UMSocialManager.default().setPlaform(UMSocialPlatformType.QQ, appKey: "101209870", appSecret: "77a0b7fc1cb5bedef4b6d41bb6fe4fb7", redirectURL: "http://www.utovr.com")
        
        
        return true
    }
}

