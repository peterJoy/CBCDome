//
//  CPMainViewController.m
//  CBCDome
//
//  Created by chenpeng on 15/11/26.
//  Copyright © 2015年 chenpeng. All rights reserved.
//

#import "CPMainViewController.h"
#import "CPCircleView.h"
@interface CPMainViewController ()<circleTapGestrueDelegate>

@end

@implementation CPMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CPCircleView *circleView = [CPCircleView createCircleViewWithItems:@[]];
    circleView.delegate = self;
    [self.view addSubview:circleView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didSelectCircleItemsAtIndex:(NSInteger)index
{
    NSString *message = [NSString stringWithFormat:@"你点击了第%ld个图片",(long)index];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"系统提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
