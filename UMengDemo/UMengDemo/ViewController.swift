//
//  ViewController.swift
//  UMengDemo
//
//  Created by brian on 2018/4/2.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBAction func share(_ sender: UIButton) {
        
        UMSocialUIManager.showShareMenuViewInWindow { (socialPlatformType, userinfo) in
            // self待解决强引用的问题
            self.shareTextToPlatform(platform: socialPlatformType)
        }
    }
    
    /// 分享到某个平台，使用自己实现的分享面板，分享按钮调用以下方法即可
    ///
    /// - Parameter platform: 将要分享的平台
    func shareTextToPlatform(platform: UMSocialPlatformType) {
        
        // 创建分享实例
        let messageObject = UMSocialMessageObject.init()
        messageObject.text = "分享的文本"
        // 传给UShare
        UMSocialManager.default().share(to: UMSocialPlatformType.wechatSession, messageObject: messageObject, currentViewController: nil) { (result, error) in
            if error != nil {
                print("success")
            } else {
                print("failed")
            }
        }
    }
}


extension ViewController {
    func getUserInfo() {
        
        let platformType = UMSocialPlatformType.init(rawValue: UMSocialPlatformType.wechatSession.rawValue|UMSocialPlatformType.QQ.rawValue|UMSocialPlatformType.sina.rawValue|UMSocialPlatformType.qzone.rawValue)!
        
        UMSocialManager.default().getUserInfo(with: platformType, currentViewController: self) { (granted, error) in
            if error != nil {
                print("failed")
            } else {
                if (granted != nil) {
                    print("授权成功")
                    
                    // 用户信息
                    let userinfo = granted as! UMSocialUserInfoResponse
                    
                    print(userinfo.uid)
                    print(userinfo.accessToken)
                    print(userinfo.name)
                    print(userinfo.iconurl)
                    
                } else {
                    print("failed")
                }
            }
        }
    }
}
