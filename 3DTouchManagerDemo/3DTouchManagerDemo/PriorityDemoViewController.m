//
//  PriorityDemoViewController.m
//  3DTouchManagerDemo
//
//  Created by Mrc.cc on 2017/7/3.
//  Copyright © 2017年 _yourcompany_. All rights reserved.
//

#import "PriorityDemoViewController.h"
#import "CP3DTouchManager.h"
#import "TipViewController.h"

UIViewController * TipVcWithTitle(NSString *title){
    TipViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TIP"];
    vc.title = title;
    return vc;
}

@interface PriorityDemoViewController ()
@property (weak, nonatomic) IBOutlet UIView *theView;
@property (weak, nonatomic) IBOutlet UILabel *theLabel;
@property (weak, nonatomic) IBOutlet UIButton *theButton;
@property (weak, nonatomic) IBOutlet UIImageView *theImageView;

@end

@implementation PriorityDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [CP3DTouchManager makeViewControllerSupport3DTouch:self];
    
    self.theView.viewControllerFor3DTouch = ^UIViewController *{
        return TipVcWithTitle(@"The View");
    };
    self.theImageView.viewControllerFor3DTouch = ^UIViewController *{
        return TipVcWithTitle(@"The ImageView");
    };
    self.theLabel.viewControllerFor3DTouch = ^UIViewController *{
        return TipVcWithTitle(@"The Label");
    };
    self.theButton.viewControllerFor3DTouch = ^UIViewController *{
        return TipVcWithTitle(@"The Button");
    };
    
    self.theImageView.touch3DPriority = 1;
    self.theView.touch3DPriority = 3;
    self.theButton.touch3DPriority = 2;
    self.theLabel.touch3DPriority = 4;
    
    self.theButton.layer.borderColor = [UIColor cyanColor].CGColor;
    self.theButton.layer.borderWidth = 2.0f;
    self.theLabel.layer.borderColor = [UIColor orangeColor].CGColor;
    self.theLabel.layer.borderWidth = 2.0f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
