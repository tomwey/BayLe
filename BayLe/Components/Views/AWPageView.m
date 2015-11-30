//
//  AWPageView.m
//  BayLe
//
//  Created by tangwei1 on 15/11/23.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "AWPageView.h"

@interface AWPageView () <UIScrollViewDelegate>

@property (nonatomic, retain) NSMutableArray* visiblePages_;

@property (nonatomic, retain) UIScrollView* pageScrollView;

@property (nonatomic, retain) NSMutableDictionary* reusableDicts;

@property (nonatomic, assign) NSInteger currentIndex;

@end
@implementation AWPageView

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ( self = [super initWithCoder:aDecoder] ) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.pageScrollView = [[[UIScrollView alloc] initWithFrame:self.bounds] autorelease];
    self.pageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.pageScrollView];
    
    self.pageScrollView.pagingEnabled = YES;
    self.pageScrollView.backgroundColor = [UIColor clearColor];
    
    self.pageScrollView.showsHorizontalScrollIndicator =
    self.pageScrollView.showsVerticalScrollIndicator   = NO;
    
    self.pageScrollView.delegate = self;
    
    self.visiblePages_  = [NSMutableArray array];
    self.reusableDicts  = [NSMutableDictionary dictionary];
    
    self.currentIndex = 0;
    
}

- (void)dealloc
{
    self.reusableDicts = nil;
    self.visiblePages_  = nil;
    
    self.pageScrollView = nil;
    
    [super dealloc];
}

- (void)setDataSource:(id<AWPageViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    [self showContents2];
}

- (void)setDelegate:(id<AWPageViewDelegate>)delegate
{
    _delegate = delegate;
    
//    [self reloadData];
}

/**
 * 显示某个位置的视图
 */
- (void)showPageForIndex:(NSInteger)index animated:(BOOL)animated
{
    AWPageViewCell* cell = [self showPageAtIndex:index];
    [self.pageScrollView scrollRectToVisible:cell.frame animated:animated];
}

/**
 * 刷新数据
 */
- (void)reloadData
{
    for (UIView* view in self.visiblePages_) {
        [view removeFromSuperview];
    }
    
    [self.visiblePages_ removeAllObjects];
    [self.reusableDicts removeAllObjects];
    
    [self showContents2];
}

- (void)showContents2
{
    NSUInteger count = [self.dataSource numberOfPages:self];
    
    if ( count <= 0 ) {
        return;
    }
    
    self.pageScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.pageScrollView.frame) * count,
                                                 CGRectGetHeight(self.pageScrollView.frame));
    
    [self displayPageForIndex:self.currentIndex];
}

/**
 * 获取重用的页面
 */
- (AWPageViewCell *)dequeueReusablePageForIndex:(NSInteger)index
{
    AWPageViewCell* cell = [self.reusableDicts objectForKey:[NSString stringWithFormat:@"%d", (index % 3)]];
    if ( cell ) {
        return [[cell retain] autorelease];
    }
    
    return nil;
}

/**
 * 返回某个位置的可见视图
 */
- (AWPageViewCell *)viewAtIndex:(NSInteger)index
{
    for (AWPageViewCell* cell in self.visiblePages_) {
        if ( cell.index == index ) {
            return cell;
        }
    }
    return nil;
}

/**
 * 返回可见的页面
 */
- (NSArray *)visiblePages
{
    return [NSArray arrayWithArray:self.visiblePages_];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( [self.delegate respondsToSelector:@selector(pageView:didScrollDelta:)] ) {
        [self.delegate pageView:self didScrollDelta:scrollView.contentOffset.x / scrollView.contentSize.width];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    if ( [self.delegate respondsToSelector:@selector(pageView:didScrollDelta:)] ) {
//        [self.delegate pageView:self didScrollDelta:scrollView.contentOffset.x / scrollView.contentSize.width];
//    }
    
    NSInteger index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    
    self.currentIndex = index;
    
    [self displayPageForIndex:index];
}

- (void)displayPageForIndex:(NSInteger)index
{
    [self showContents];
    
    AWPageViewCell* cell = [self viewAtIndex:index];
    
    if ( [self.delegate respondsToSelector:@selector(pageView:didShowPage:atIndex:)] ) {
        [self.delegate pageView:self didShowPage:cell atIndex:index];
    }
}

- (void)showContents
{
    CGRect visibleBounds = self.pageScrollView.bounds;
    
    NSInteger firstVisibleIndex = floor( fabs( CGRectGetMinX(visibleBounds) / CGRectGetWidth(self.pageScrollView.frame) ) );
    NSInteger lastVisibleIndex  = floor( fabs( CGRectGetMaxX(visibleBounds) / CGRectGetWidth(self.pageScrollView.frame) ) );

    firstVisibleIndex = MAX(firstVisibleIndex, 0);
    lastVisibleIndex  = MIN(lastVisibleIndex, [self.dataSource numberOfPages:self] - 1);
    
    [self.visiblePages_ removeAllObjects];
    
    // 显示页面
    for (int index = firstVisibleIndex; index <= lastVisibleIndex; index ++) {
        [self showPageAtIndex:index];
    }
}

- (AWPageViewCell *)showPageAtIndex:(NSInteger)index
{
    AWPageViewCell* cell = [self.dataSource pageView:self cellAtIndex:index];
    
    NSAssert(!!cell, @"AWPageViewCell对象不能为空");
    
    AWPageViewCell* reusablePage = [self dequeueReusablePageForIndex:index];
    if ( !reusablePage ) {
        [self.reusableDicts setObject:cell forKey:[NSString stringWithFormat:@"%d", (index % 3)]];
    }
    
    cell.index = index;
    
    if ( !cell.superview ) {
        [self.pageScrollView addSubview:cell];
    }
    
    [self.visiblePages_ addObject:cell];
    
    CGRect frame = self.pageScrollView.frame;
    frame.origin = CGPointMake(index * CGRectGetWidth(self.pageScrollView.frame), 0);
    cell.frame = frame;
    
    return cell;
}

@end

@implementation AWPageViewCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ( self = [super initWithCoder:aDecoder] ) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.index = -1;
}

@end
