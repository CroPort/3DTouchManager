//
//  CP3DTouchManager.m
//  3DTouchManagerDemo
//
//  Created by Mrc.cc on 2017/7/3.
//  Copyright © 2017年 _yourcompany_. All rights reserved.
//

#import "CP3DTouchManager.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"

@interface CP3DTouchManager()<UIViewControllerPreviewingDelegate>

@end

@implementation CP3DTouchManager

+ (instancetype)shared{
    static CP3DTouchManager *util = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [CP3DTouchManager new];
    });
    return util;
}
- (instancetype)init{
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        self = [super init];
        return self;
    }
    return nil;
    
}
+ (void)setupPreviewCommitHandler:(CPPreviewCommitHandler)commitHandler{
    [CP3DTouchManager shared].commitHandler = commitHandler;
}
+ (void)makeViewController:(UIViewController *)vc support3DTouchForView:(UIView *)view{
    [[CP3DTouchManager shared] makeViewController:vc support3DTouchForView:view];
}
- (void)makeViewController:(UIViewController *)vc support3DTouchForView:(UIView *)view{
    
    if (vc.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        CP3DTouchManager *util = [CP3DTouchManager shared];
        [vc registerForPreviewingWithDelegate:util sourceView:view];
    }
}
#pragma mark 3D touch
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    
    UIView *view = [previewingContext.sourceView viewAtTouchPoint:location];
    if (view.viewControllerFor3DTouch) {
        previewingContext.sourceRect = [view convertRect:view.bounds toView:previewingContext.sourceView];
        return view.viewControllerFor3DTouch();
    }
    return nil;
}
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    
    if (self.commitHandler) {
        self.commitHandler(viewControllerToCommit);
    }
}
@end


@implementation UIView (Touch3D)
- (void)setTouch3DPriority:(CPView3DTouchPriority)touch3DPriority{
    objc_setAssociatedObject(self, @selector(touch3DPriority), [NSNumber numberWithInteger:touch3DPriority], OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (CPView3DTouchPriority)touch3DPriority{
    NSNumber *value = objc_getAssociatedObject(self, _cmd);
    if (value) {
        return value.integerValue;
    }
    return 0;
}
- (void)setViewControllerFor3DTouch:(UIViewController *(^)(void))viewControllerFor3DTouch{
    objc_setAssociatedObject(self, @selector(viewControllerFor3DTouch), viewControllerFor3DTouch, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CPViewFor3DTouchHandler)viewControllerFor3DTouch{
    return objc_getAssociatedObject(self, _cmd);
}

- (UIView *)viewAtTouchPoint:(CGPoint)point{
    
    // 不可相应的视图返回空
    if (self.hidden) {
        return nil;
    }
    // 当前点击是否在Self上
    BOOL isInSelf = CGRectContainsPoint(self.frame, point);
    
    // 在self上则进行自视图遍历
    if (isInSelf) {
        
        BOOL isScrollView = [self isKindOfClass:[UIScrollView class]];
        if (isScrollView) {
            UIScrollView *scrolView = (UIScrollView*)self;
            // scrollview 需要加上偏移量
            CGPoint offset = scrolView.contentOffset;
            UIEdgeInsets adjustAutoInsets = UIEdgeInsetsZero;
#ifdef __IPHONE_11_0
            if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0) {
                adjustAutoInsets = scrolView.adjustedContentInset;
            }
#endif
            point = CGPointMake(offset.x + point.x, offset.y + point.y + adjustAutoInsets.top);
        }
        CGPoint origin = self.frame.origin;
        UIView *touchView = nil;
        
        for (NSInteger i = self.subviews.count - 1; i >= 0; i --) {
            // 自上而下查找响应3D touch 的view
            UIView *view = [self.subviews objectAtIndex:i];
            // view的frame是相对于self的，所以需要转化一下touchPoint
            CGPoint convertPoint = CGPointMake(point.x - origin.x, point.y - origin.y);
            UIView *result = [view viewAtTouchPoint:convertPoint];
            // 存在可响应视图
            if (result && result.viewControllerFor3DTouch) {
                if (!touchView || touchView.touch3DPriority < result.touch3DPriority) {
                    touchView = result;
                }
            }
        }
        if (touchView) {
            return touchView;
        }
        // 子视图中没有可响应的则返回self
        return self.viewControllerFor3DTouch ? self : nil;
    }
    return nil;
}
@end
