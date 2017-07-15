# 3DTouchManager

## Screenshot

![Sceenshot](Screenshots/demo.gif)

## Required

- Xcode 8.0+
- iOS 8.0

## Installation
Add `pod 'CP3DTouchManager'` in your Podfile. 
## Usage

### 1.Setup 3DTouch previewing controller commit handler.
You can import the following code in your 
`- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions` 
or any where before you use 3DTouch, but the first way may be the best.
```
[CP3DTouchManager setupPreviewCommitHandler:^(UIViewController *vc) {

   //you may need to push vc here.

}];
```
  
### 2.Make your viewcontroller support 3DTouch using the following code:

 `[CP3DTouchManager makeViewController:self support3DTouchForView:self.view];`
 
### 3.Specific your view for 3DTouch.
  
```
aView.viewControllerFor3DTouch = ^UIViewController *{
    // the previewing controller for this view when 3DTouch recognized.
    return [UIViewController new];
};
```

## Issue
If you met any problem,please issue me, or if you had any better way to use 3DTouch, please issue me. thanks a lot.
