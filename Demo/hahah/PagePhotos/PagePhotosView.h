//
//  PagePhotosView.h
//  PagePhotosDemo
//
//  Created by junmin liu on 10-8-23.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PagePhotosControl.h"

@protocol PagePhotosDataSource

// 有多少页
//
- (int)numberOfPages;

// 每页的图片
//
- (UIButton *)buttonAtIndex:(int)index;

// 点击事件
//
- (void)clickAtIndex:(int)index;

@end
@interface PagePhotosView : UIView<UIScrollViewDelegate> {

    BOOL pageControlUsed;
}

@property (nonatomic, assign) id<PagePhotosDataSource> dataSource;
@property (nonatomic, retain) NSMutableArray *buttonViews;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) PagePhotosControl *pageControl;
@property (nonatomic , strong) NSTimer *animationTimer;
//- (IBAction)changePage:(id)sender;

- (id)initWithFrame:(CGRect)frame withDataSource:(id<PagePhotosDataSource>)_dataSource animationDuration:(NSTimeInterval)animationDuration;


@end
