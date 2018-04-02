//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

/// UMCommon是友盟统计、推送通知、分享的基础库
#import <UMCommon/UMCommon.h>

/// UMeng统计SDK
#import <UMAnalytics/MobClick.h>
/*
 友盟统计实现了三种场景下的数据统计：
 1. 普通：适应大多数App
 2. 游戏：游戏类App统计数据
 3. Dplus
 */
/// 友盟统计游戏场景头文件
#import <UMAnalytics/MobClickGameAnalytics.h>
// Dplus场景头文件
#import <UMAnalytics/DplusMobClick.h>

/// 引入友盟通知头文件
#import <UMPush/UMessage.h>

// 引入友盟分享的头文件
// 全局都要导入:Appdelegate和所有使用分享的VC
#import <UMShare/UMShare.h>
// 哪个VC需要分享的信息，在哪个VC导入
#import <UShareUI/UShareUI.h>
