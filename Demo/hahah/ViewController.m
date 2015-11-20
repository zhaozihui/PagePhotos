//
//  ViewController.m
//  hahah
//
//  Created by 赵子辉 on 15/11/19.
//  Copyright © 2015年 zhaozihui. All rights reserved.
//

#import "ViewController.h"
#import "PagePhotosView.h"
@interface ViewController ()<PagePhotosDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    PagePhotosView *pagePhotosView = [[PagePhotosView alloc] initWithFrame: CGRectMake(0, 0, 320, 260) withDataSource: self animationDuration:3];
    [self.view addSubview:pagePhotosView];

}
// 有多少页
//
- (int)numberOfPages
{
    return 5;
}

// 每页的图片
//
- (UIButton *)buttonAtIndex:(int)index
{
    NSString *imageName = [NSString stringWithFormat:@"1933_%d.jpg", index + 1];
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return btn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)clickAtIndex:(int)index {
    NSLog(@"index:%d",index);
}
@end
