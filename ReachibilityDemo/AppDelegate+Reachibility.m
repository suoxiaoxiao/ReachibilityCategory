//
//  AppDelegate+Reachibility.m
//  ReachibilityDemo
//
//  Created by 索晓晓 on 2018/11/27.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "AppDelegate+Reachibility.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate ()

//网络状态
@property (strong, nonatomic) Reachability *reach;
@property (nonatomic) NetworkStatus networkStatus;
@property (nonatomic, assign) int autoDismissAlertCount;
@property (nonatomic) int tryDetectNetworkTimesCount;
@property (nonatomic, strong) UIAlertController* autoDismissAlert;


@end
NS_ASSUME_NONNULL_END

@implementation AppDelegate (Reachibility)


- (void)setReach:(Reachability *)reach
{
    objc_setAssociatedObject(self, @selector(reach), reach, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (Reachability *)reach
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setNetworkStatus:(NetworkStatus)networkStatus
{
    objc_setAssociatedObject(self, @selector(networkStatus), @(networkStatus), OBJC_ASSOCIATION_ASSIGN);
}
- (NetworkStatus)networkStatus
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setAutoDismissAlert:(UIAlertController *)autoDismissAlert
{
    objc_setAssociatedObject(self, @selector(autoDismissAlert), autoDismissAlert, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIAlertController *)autoDismissAlert
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setAutoDismissAlertCount:(int)autoDismissAlertCount
{
    objc_setAssociatedObject(self, @selector(autoDismissAlertCount), @(autoDismissAlertCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (int)autoDismissAlertCount
{
    return [objc_getAssociatedObject(self, _cmd) intValue];
}
- (void)setTryDetectNetworkTimesCount:(int)tryDetectNetworkTimesCount
{
    objc_setAssociatedObject(self, @selector(tryDetectNetworkTimesCount), @(tryDetectNetworkTimesCount), OBJC_ASSOCIATION_ASSIGN);
}
- (int)tryDetectNetworkTimesCount
{
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

- (void)initReachibility
{
    self.autoDismissAlertCount = 0;
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    
    self.reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [self.reach startNotifier];
}
// 连接改变
- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
    
    //通知外界
    [[NSNotificationCenter defaultCenter] postNotificationName:kNetWorkChangedNotification object:[note object]];
    
}
//处理连接改变后的情况
- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    //对连接改变做出响应的处理动作。
    self.networkStatus = [curReach currentReachabilityStatus];
    
    if ( self.networkStatus == NotReachable)
    {
        //没有连接到网络就弹出提实况
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"网络不给力呀,检查一下网络再试试吧!" preferredStyle:UIAlertControllerStyleAlert];
        
        if (self.autoDismissAlertCount<1) {
            [self.window.rootViewController presentViewController:alert animated:YES completion:^{
                
            }];
            self.autoDismissAlert = alert;
            self.autoDismissAlertCount +=1;
            [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
        }
    }
}
-(void) performDismiss:(NSTimer *)timer
{
    [self.autoDismissAlert dismissViewControllerAnimated:YES completion:^{
        
    }];
    self.autoDismissAlertCount = 0;
}
@end
