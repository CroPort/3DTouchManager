//
//  CP3DTouchManager.m
//  3DTouchManagerDemo
//
//  Created by Mrc.cc on 2017/7/3.
//  Copyright © 2017年 Paul Chen. All rights reserved.
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
+ (void)makeViewControllerSupport3DTouch:(UIViewController *)vc{
    [self makeViewController:vc support3DTouchForView:vc.view];
}
- (void)makeViewController:(UIViewController *)vc support3DTouchForView:(UIView *)view{
    
    if (vc.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        CP3DTouchManager *util = [CP3DTouchManager shared];
        [vc registerForPreviewingWithDelegate:util sourceView:view];
    }
}
- (void)makeViewControllerSupport3DTouch:(UIViewController *)vc{
    [self makeViewController:vc support3DTouchForView:vc.view];
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
    
    // Do nothing when hidden == YES.
    if (self.hidden) {
        return nil;
    }
    
    // Check whether the point was contained.
    BOOL isInSelf = CGRectContainsPoint(self.bounds, point);
    
    // Go through all subviews to find the appropriate view.
    if (isInSelf) {
        
        BOOL isScrollView = [self isKindOfClass:[UIScrollView class]];
        if (isScrollView) {
            UIScrollView *scrolView = (UIScrollView*)self;
            // Scrollview should plus contentOffSet.
            CGPoint offset = scrolView.contentOffset;
            UIEdgeInsets adjustContentInsets = UIEdgeInsetsZero;
#ifdef __IPHONE_11_0
            // iOS 11 only.
            if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0) {
                adjustContentInsets = scrolView.adjustedContentInset;
            }
#endif
            point = CGPointMake(offset.x + point.x + adjustContentInsets.left, offset.y + point.y + adjustContentInsets.top);
        }
        
        UIView *touchView = nil;
        
        for (NSInteger i = self.subviews.count - 1; i >= 0; i --) {
            // Find the view from front to back.
            UIView *view = [self.subviews objectAtIndex:i];
            // subview frame origin
            CGPoint origin = view.frame.origin;
            // subview bounds origin
            CGPoint sorigin = view.bounds.origin;
            
            // Convert the point to the subview's coordinate system.
            CGPoint convertPoint = CGPointMake(point.x - origin.x + sorigin.x, point.y - origin.y + sorigin.y);
            
            UIView *result = [view viewAtTouchPoint:convertPoint];
            // Find the view.
            if (result && result.viewControllerFor3DTouch) {
                if (!touchView || touchView.touch3DPriority < result.touch3DPriority) {
                    touchView = result;
                }
            }
        }
        if (touchView) {
            return touchView;
        }
        // If no view found, return self if self can response, otherwise return nil.
        return self.viewControllerFor3DTouch ? self : nil;
    }
    return nil;
}
@end
