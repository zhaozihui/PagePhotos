//
//  PagePhotosView.m
//  PagePhotosDemo
//
//  Created by junmin liu on 10-8-23.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "PagePhotosView.h"
#import "NSTimer+Addition.h"

@interface PagePhotosView (PrivateMethods)

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end

@implementation PagePhotosView
@synthesize dataSource;
@synthesize buttonViews;
@synthesize scrollView;
@synthesize pageControl;
@synthesize animationTimer;
- (id)initWithFrame:(CGRect)frame withDataSource:(id<PagePhotosDataSource>)_dataSource animationDuration:(NSTimeInterval)animationDuration {
    if ((self = [super initWithFrame:frame])) {
		self.dataSource = _dataSource;

		int kNumberOfPages = [dataSource numberOfPages];
		
		// in the meantime, load the array with placeholders which will be replaced on demand
		NSMutableArray *views = [[NSMutableArray alloc] init];
		for (unsigned i = 0; i < kNumberOfPages; i++) {
			[views addObject:[NSNull null]];
		}
		self.buttonViews = views;
		
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		scrollView.pagingEnabled = YES;
		scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.scrollsToTop = NO;
		scrollView.delegate = self;
		[self addSubview:scrollView];
        
        CGFloat dotGapWidth = 8.0;
        NSString *normalImageName = [@"pagephotos.bundle" stringByAppendingPathComponent:@"page_state_normal.png"];
        NSString *highlightImageName = [@"pagephotos.bundle" stringByAppendingPathComponent:@"page_state_highlight.png"];
        UIImage *normalDotImage = [UIImage imageNamed:normalImageName];
        UIImage *highlightDotImage = [UIImage imageNamed:highlightImageName];
        CGFloat pageControlWidth = kNumberOfPages * normalDotImage.size.width + (kNumberOfPages - 1) * dotGapWidth;
        CGRect pageControlFrame = CGRectMake(frame.size.width - pageControlWidth , CGRectGetHeight(self.scrollView.frame)*0.9, pageControlWidth, normalDotImage.size.height);
        
        pageControl = [[PagePhotosControl alloc] initWithFrame:pageControlFrame
                                               normalImage:normalDotImage
                                          highlightedImage:highlightDotImage
                                                dotsNumber:kNumberOfPages sideLength:dotGapWidth dotsGap:dotGapWidth];
        [self addSubview:pageControl];
		

		[self loadScrollViewWithPage:0];
		[self loadScrollViewWithPage:1];
        animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationDuration
                                                               target:self
                                                             selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];

		
    }
    return self;
}
- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    if(newOffset.x ==  CGRectGetWidth(self.scrollView.frame) * ([buttonViews count]))
    {
        newOffset = CGPointMake(0, self.scrollView.contentOffset.y);
    }
    
    [self.scrollView setContentOffset:newOffset animated:YES];
    
}

- (void)loadScrollViewWithPage:(int)page {
	int kNumberOfPages = [dataSource numberOfPages];
	
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
	
    // replace the placeholder if necessary
//    UIImageView *view = [imageViews objectAtIndex:page];
//    if ((NSNull *)view == [NSNull null]) {
//		UIImage *image = [dataSource imageAtIndex:page];
//        view = [[UIImageView alloc] initWithImage:image];
//        [imageViews replaceObjectAtIndex:page withObject:view];
//
//    }
    
    UIButton *view = [buttonViews objectAtIndex:page];
    if ((NSNull *)view == [NSNull null]) {
        view = [dataSource buttonAtIndex:page];
        view.tag = page;
        [view addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttonViews replaceObjectAtIndex:page withObject:view];
        
    }
	
    // add the controller's view to the scroll view
    if (nil == view.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        view.frame = frame;
        [scrollView addSubview:view];
    }
}
- (void)imageClick:(UIButton *)btn
{
    [dataSource clickAtIndex:btn.tag];
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
    [animationTimer pauseTimer];
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
    [animationTimer resumeTimerAfterTimeInterval:3];
}


@end
