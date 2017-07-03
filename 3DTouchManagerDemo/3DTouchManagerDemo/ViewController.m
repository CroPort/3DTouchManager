//
//  ViewController.m
//  3DTouchManagerDemo
//
//  Created by Mrc.cc on 2017/7/3.
//  Copyright © 2017年 _yourcompany_. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (nonatomic, strong) NSDictionary *demoDic;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.demoDic = @{
                     @"List Demo" : @"LIST",
                     @"Priority Demo" : @"PRIORITY"
                     };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.demoDic.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.textLabel.text = self.demoDic.allKeys[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *segueId = self.demoDic.allValues[indexPath.row];
    [self performSegueWithIdentifier:segueId sender:nil];
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

