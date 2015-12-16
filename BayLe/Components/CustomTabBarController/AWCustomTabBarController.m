//
//  CustomTabBarController.m
//  BayLe
//
//  Created by tangwei1 on 15/11/19.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "AWCustomTabBarController.h"
#import <objc/runtime.h>

@interface ViewHolder : UIView

@property (nonatomic, retain) CustomTabBarItem* tabBarItem;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, retain) UIColor* selectedTintColor;

@end

@interface AWCustomTabBarController ()

@property (nonatomic, assign) NSArray* currentViewControllers;

@end

@implementation AWCustomTabBarController
{
    CustomTabBar*   _customTabBar;
    NSMutableArray* _viewHolderGroup;
    UIView*         _lineView;
}

@dynamic tabBarBackgroundImage;

@synthesize viewControllers = _viewControllers;

#pragma mark Getters and Setters
- (void)setTabBarBackgroundImage:(UIImage *)tabBarBackgroundImage
{
    _customTabBar.image = tabBarBackgroundImage;
    if ( tabBarBackgroundImage ) {
        _lineView.hidden = YES;
    } else {
        _lineView.hidden = NO;
    }
}

- (UIImage *)tabBarBackgroundImage { return _customTabBar.image; }

- (CustomTabBar *)customTabBar { return _customTabBar; }

- (void)setSelectedItemTintColor:(UIColor *)selectedItemTintColor
{
    if ( _selectedItemTintColor != selectedItemTintColor ) {
        [_selectedItemTintColor release];
        _selectedItemTintColor = [selectedItemTintColor retain];
    }
    
    for (ViewHolder* vh in _viewHolderGroup) {
        if ( vh.selected ) {
            vh.selectedTintColor = _selectedItemTintColor;
        }
    }
}

- (void)setItemTintColor:(UIColor *)itemTintColor
{
    if ( _itemTintColor != itemTintColor ) {
        [_itemTintColor release];
        _itemTintColor = [itemTintColor retain];
    }
    
    for (ViewHolder* vh in _viewHolderGroup) {
        vh.tintColor = _itemTintColor;
    }
}

#pragma mark Lifecycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customizeTabBar];
    
    self.selectedIndex = 0;
}

- (void)dealloc
{
    [_viewHolderGroup release];
    [_selectedItemTintColor release];
    [_itemTintColor release];
    
    [super dealloc];
}

#pragma mark Private Methods
- (void)customizeTabBar
{
    _customTabBar = [[CustomTabBar alloc] initWithFrame:self.tabBar.frame];
    [self.view addSubview:_customTabBar];
    [_customTabBar release];
    
    _customTabBar.userInteractionEnabled = YES;
    
    _customTabBar.backgroundColor = [UIColor whiteColor];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_customTabBar.frame), 0.618)];
    [_customTabBar addSubview:_lineView];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    [_lineView release];
    
    // 隐藏原来的工具条
    for (UIView *sv in self.view.subviews) {
        if ([sv isKindOfClass:[UITabBar class]]) {
            sv.hidden = YES;
            break;
        }
    }
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
    
    self.currentViewControllers = viewControllers;
    
    [self addTabBarItem:viewControllers];
}

- (void)addTabBarItem:(NSArray *)viewControllers
{
    NSUInteger count = viewControllers.count;
    // 最多支持5个控制器显示
    count = MIN(count, 5);
    
    if ( count != 0 ) {
        CGFloat width = CGRectGetWidth(_customTabBar.frame) / count;
        CGFloat height = CGRectGetHeight(_customTabBar.frame);
        for (int i=0; i<count; i++) {
            UIViewController* controller = viewControllers[i];
            
            // 添加item
            ViewHolder* viewHolder = [[ViewHolder alloc] initWithFrame:CGRectMake(width * i, 0, width, height)];
            [_customTabBar addSubview:viewHolder];
            [viewHolder release];
            
            CustomTabBarItem* item = controller.customTabBarItem;
            viewHolder.tabBarItem = item;
            viewHolder.index = i;
            viewHolder.delegate = self;
            viewHolder.selectedTintColor = !!self.selectedItemTintColor ? self.selectedItemTintColor : [UIColor blueColor];
            viewHolder.tintColor = !!self.itemTintColor ? self.itemTintColor : [UIColor darkGrayColor];
            
            // 第一个项目选中
            if ( i == 0 ) {
                viewHolder.selected = YES;
            }
            
            // 添加到组里面
            if ( !_viewHolderGroup ) {
                _viewHolderGroup = [[NSMutableArray alloc] initWithCapacity:count];
            }
            
            [_viewHolderGroup addObject:viewHolder];
        }
    }
}

- (void)viewHolder:(ViewHolder *)viewHolder didSelectItem:(CustomTabBarItem *)item
{
    BOOL allowShow = YES;
    
    if ( [self.customTabBarDelegate respondsToSelector:@selector(customTabBar:didSelectAtIndex:)] ) {
        [self.customTabBarDelegate customTabBar:self.customTabBar didSelectAtIndex:viewHolder.index];
    }
    
    if ( [self.customTabBarDelegate respondsToSelector:@selector(shouldShowViewControllerForIndex:)] ) {
        allowShow = [self.customTabBarDelegate shouldShowViewControllerForIndex:viewHolder.index];
    }
    
    if ( !allowShow ) {
        return;
    }
    
    for (ViewHolder* holder in _viewHolderGroup) {
        holder.selected = NO;
    }
    
    viewHolder.selected = YES;
    
    self.selectedIndex = viewHolder.index;
}

@end

@implementation CustomTabBarItem

- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    if ( self = [super init] ) {
        self.title = title;
        self.image = image;
        self.selectedImage = selectedImage;
    }
    
    return self;
}

- (void)dealloc
{
    self.title = nil;
    self.image = nil;
    self.selectedImage = nil;
    [super dealloc];
}

@end

@implementation UIViewController (CustomTabBarItem)

static char kCustomTabBarItemKey;

- (void)setCustomTabBarItem:(CustomTabBarItem *)customTabBarItem
{
    objc_setAssociatedObject(self, &kCustomTabBarItemKey, customTabBarItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CustomTabBarItem *)customTabBarItem
{
    return objc_getAssociatedObject(self, &kCustomTabBarItemKey);
}

@end

@implementation ViewHolder
{
    UIImageView* _contentView;
    UILabel*     _titleLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        _contentView = [[[UIImageView alloc] init] autorelease];
        [self addSubview:_contentView];
        
        [self addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)] autorelease]];
    }
    return self;
}

- (void)setTabBarItem:(CustomTabBarItem *)tabBarItem
{
    if ( _tabBarItem == tabBarItem ) {
        return;
    }
    
    [_tabBarItem release];
    _tabBarItem = [tabBarItem retain];
    
    _contentView.image = [_tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_contentView sizeToFit];
    
    if ( _tabBarItem.title.length != 0 ) {
        if ( !_titleLabel ) {
            _titleLabel = [[[UILabel alloc] init] autorelease];
            [self addSubview:_titleLabel];
            _titleLabel.backgroundColor = [UIColor clearColor];
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.textColor = [UIColor grayColor];
        }
        _titleLabel.text = tabBarItem.title;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ( !_titleLabel ) {
        _contentView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    } else {
        _contentView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 3);
        _titleLabel.frame = CGRectMake(0, CGRectGetMaxY(_contentView.frame), CGRectGetWidth(self.frame), 20);
    }
}

- (void)tap
{
    if ( [self.delegate respondsToSelector:@selector(viewHolder:didSelectItem:)] ) {
        [self.delegate viewHolder:self didSelectItem:_tabBarItem];
    }
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    UIImage* image = _tabBarItem.image;
    if ( _selected && _tabBarItem.selectedImage ) {
        image = _tabBarItem.selectedImage;
    }
    
    _contentView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIColor *color = _selected ? self.selectedTintColor : self.tintColor;
    _contentView.tintColor = _titleLabel.textColor = color;
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    
    _titleLabel.textColor = tintColor;
    _contentView.image = [_tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _contentView.tintColor = tintColor;
}

- (void)setSelectedTintColor:(UIColor *)selectedTintColor
{
    [_selectedTintColor release];
    
    _selectedTintColor = [selectedTintColor retain];
    
    UIImage* image = _tabBarItem.image;
    if ( _selected && _tabBarItem.selectedImage ) {
        image = _tabBarItem.selectedImage;
    }
    
    _titleLabel.textColor = _selectedTintColor;
    _contentView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _contentView.tintColor = _selectedTintColor;
}

- (void)dealloc
{
    [_tabBarItem release];
    [_selectedTintColor release];
    
    [super dealloc];
}

@end

@implementation UIViewController (CustomTabBar)

@dynamic customTabBar;

- (CustomTabBar *)customTabBar
{
    AWCustomTabBarController* tabBarController = (AWCustomTabBarController *)self.tabBarController;
    return tabBarController.customTabBar;
}

@end
