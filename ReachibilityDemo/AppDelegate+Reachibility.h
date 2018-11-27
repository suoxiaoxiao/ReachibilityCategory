//
//  AppDelegate+Reachibility.h
//  ReachibilityDemo
//
//  Created by 索晓晓 on 2018/11/27.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"

//网络发生变化通知
#define kNetWorkChangedNotification @"kNetWorkChangedNotification"


NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Reachibility)

//初始化网络检测
- (void)initReachibility;

@end

NS_ASSUME_NONNULL_END
