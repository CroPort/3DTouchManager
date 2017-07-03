//
//  ViewController.m
//  3DTouchManagerDemo
//
//  Created by Mrc.cc on 2017/7/3.
//  Copyright © 2017年 _yourcompany_. All rights reserved.
//

#import "ViewController.h"
#import "DemoCell.h"
#import "CP3DTouchManager.h"
#import "ImagePreviewViewController.h"
#import "TextPreviewViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [CP3DTouchManager makeViewController:self support3DTouchForView:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DemoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    
    cell.demoLabel.viewControllerFor3DTouch = ^UIViewController *{
        TextPreviewViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Text"];
        vc.title = @(indexPath.row).stringValue;
        return vc;
    };
    cell.demoLabel.text = self.title;
    
    cell.demoImageView.viewControllerFor3DTouch = ^UIViewController *{
        ImagePreviewViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Image"];
        return vc;
    };
    return cell;
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

