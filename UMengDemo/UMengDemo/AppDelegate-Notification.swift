//
//  AppDelegate-Notification.swift
//  UMengDemo
//
//  Created by brian on 2018/4/2.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

//MARK: - iOS 10以上接收通知的代理方法
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
    // 前台
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // 拿到前台接收到的userinfo
        let userinfo = notification.request.content.userInfo
        // 判断通知的类型是否是UNPushNotificationTrigger(UNPushNotificationTrigger can be sent from a server using Apple Push Notification Service.)
        let result = notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) ?? false
        // 如果是UNPushNotificationTrigger类型，则需要统计，如果不是，不需要统计
        if result {
            // 调用UPush接收消息的方法，并把userinfo给这个方法
            UMessage.didReceiveRemoteNotification(userinfo)
            
            // UPush默认添加了前台提醒，如果需要关闭，通过UMessage.setAutoAlert(false)关闭前台UPush默认添加的提醒
            UMessage.setAutoAlert(false)
        }
    }
    
    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from application:didFinishLaunchingWithOptions:.
    // 后台
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 拿到处于后台时收到的userinfo
        let userinfo = response.notification.request.content.userInfo
        // 判断通知的类型是否是UNPushNotificationTrigger(UNPushNotificationTrigger can be sent from a server using Apple Push Notification Service.)
        let result = response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) ?? false
        // 如果是UNPushNotificationTrigger类型，则需要统计，如果不是，不需要统计
        if result{
            // 调用UPush接收消息的方法，并把userinfo给这个方法
            UMessage.didReceiveRemoteNotification(userinfo)
        }
    }
}


//MARK: - iOS 10以下接收通知的方法
extension AppDelegate {

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        /** 应用处于运行时（前台、后台）的消息处理
         @param userInfo 消息参数
         */
        // 统计点击数
        UMessage.didReceiveRemoteNotification(userInfo)
        
        // UPush默认添加了前台提醒，如果需要关闭，通过UMessage.setAutoAlert(false)关闭前台UPush默认添加的提醒
        UMessage.setAutoAlert(false)
    }
}
