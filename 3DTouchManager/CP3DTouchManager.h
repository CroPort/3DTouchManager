//
//  CP3DTouchManager.h
//  3DTouchManagerDemo
//
//  Created by Mrc.cc on 2017/7/3.
//  Copyright © 2017年 _yourcompany_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 如果少量的3DTouch处理则使用类方法就行，如果有大量的3DTouch支持并且PreviewController可能很复杂的时候推荐实例化一个Util来处理；

typedef void(^CPPreviewCommitHandler)(UIViewController *vc);
typedef UIViewController *(^CPViewFor3DTouchHandler)(void);

@interface CP3DTouchManager : NSObject

@property (nonatomic, copy) CPPreviewCommitHandler commitHandler;

- (void)makeViewController:(UIViewController*)vc support3DTouchForView:(UIView*)view;

+ (void)makeViewController:(UIViewController*)vc support3DTouchForView:(UIView*)view;
+ (void)setupPreviewCommitHandler:(CPPreviewCommitHandler)commitHandler;

@end

typedef NSInteger CPView3DTouchPriority;

@interface UIView (Touch3D)
/// 返回当前视图响应3DTouch的vc.
@property (nonatomic, copy) CPViewFor3DTouchHandler viewControllerFor3DTouch;
/// 3DTouch 优先级 default is 0. 当按压点存在多个可响应3DTouch事件的时候，根据优先级选择。
@property (nonatomic, assign) CPView3DTouchPriority touch3DPriority;

//  找出当前按压点的响应视图
- (UIView*)viewAtTouchPoint:(CGPoint)point;

@end
