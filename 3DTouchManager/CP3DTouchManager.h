//
//  CP3DTouchManager.h
//  3DTouchManagerDemo
//
//  Created by Mrc.cc on 2017/7/3.
//  Copyright © 2017年 Paul Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// A 3DTouch recognize manager. Also work with mutiple recognized views at the same touch point base on priority.
/*
     The simplest way to use to use :
     copy the following code into your AppDelegate.m method
     `- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions `
 
     [CP3DTouchManager setupPreviewCommitHandler:^(UIViewController *vc) {
         UINavigationController *nav = (UINavigationController*)self.window.rootViewController;
         if ([nav isKindOfClass:[UINavigationController class]]) {
             [nav pushViewController:vc animated:YES];
         }
     }];
 
     [CP3DTouchManager makeViewControllerSupport3DTouch:self.window.rootViewController];
 */

typedef void(^CPPreviewCommitHandler)(UIViewController *vc);
typedef UIViewController *(^CPViewFor3DTouchHandler)(void);

@interface CP3DTouchManager : NSObject

@property (nonatomic, copy) CPPreviewCommitHandler commitHandler;

- (void)makeViewController:(UIViewController*)vc support3DTouchForView:(UIView*)view;
- (void)makeViewControllerSupport3DTouch:(UIViewController*)vc;

+ (void)makeViewController:(UIViewController*)vc support3DTouchForView:(UIView*)view;
+ (void)makeViewControllerSupport3DTouch:(UIViewController*)vc;
+ (void)setupPreviewCommitHandler:(CPPreviewCommitHandler)commitHandler;

@end

typedef NSInteger CPView3DTouchPriority;

@interface UIView (Touch3D)

/// A handler that will return the priviewing view controller when 3DTouch recognized.
@property (nonatomic, copy) CPViewFor3DTouchHandler viewControllerFor3DTouch;
/// The priority that define who will response to the recognized 3DTouch event at a touch point.
@property (nonatomic, assign) CPView3DTouchPriority touch3DPriority;

/// To find the view who can response to the 3DTouch event.
/// The point supposed to be in the same coordinate system with `self`.
- (UIView*)viewAtTouchPoint:(CGPoint)point;

@end
