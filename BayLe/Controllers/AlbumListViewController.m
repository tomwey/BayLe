//
//  PhotoListViewController.m
//  BayLe
//
//  Created by tangwei1 on 15/12/2.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "AlbumListViewController.h"
#import "Defines.h"

@interface AlbumListViewController () <UITableViewDelegate>

@property (nonatomic, retain) AWTableViewDataSource* dataSource;
@property (nonatomic, retain) ALAssetsLibrary* assetsLibrary;

@end
@implementation AlbumListViewController
{
    UITableView*  _tableView;
    UIScrollView* _thumbsContainer;
    NSUInteger     _currentThumbPosition;
    
    UILabel*  _totalLabel;
    UIButton* _addPhotoButton;
}

- (void)dealloc
{
    self.dataSource = nil;
    self.assetsLibrary = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavBar];
    
    _currentThumbPosition = 0;
    
    self.dataSource = AWTableViewDataSourceCreate(nil, @"AlbumCell", @"album.cell");
    
    [self initTableView];
    
    [self initThumbsContainer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didAddPhoto:)
                                                 name:PhotoAssetDidAddNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRemovePhoto:)
                                                 name:PhotoAssetDidRemoveNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadAlbumData];
}

#pragma mark - Private Methods
- (void)didAddPhoto:(NSNotification *)noti
{
    ALAsset* asset = (ALAsset *)noti.object;
    
    [self addThumbView:asset];
}

- (void)addThumbView:(ALAsset *)asset
{
    ThumbView* thumbView = [[[ThumbView alloc] init] autorelease];
    thumbView.asset = asset;
    [_thumbsContainer addSubview:thumbView];
    
    thumbView.frame = CGRectMake(5 + _currentThumbPosition * ( 5 + 60 ), 2, 60, 60);
    thumbView.tag = 1000 + _currentThumbPosition;
    thumbView.asset.index = _currentThumbPosition;
    
    _currentThumbPosition++;
    
    _thumbsContainer.contentSize = CGSizeMake(_currentThumbPosition * 60 + 5 * ( _currentThumbPosition + 1 ), _thumbsContainer.height);
    
    [_thumbsContainer scrollRectToVisible:thumbView.frame animated:YES];
    
    [self updateTotalLabel];
}

- (void)didRemovePhoto:(NSNotification *)noti
{
    ALAsset* asset = (ALAsset *)noti.object;
    [[_thumbsContainer viewWithTag:1000 + asset.index] removeFromSuperview];
    
    // 更新剩下元素的位置
    for (int i=asset.index + 1; i<_currentThumbPosition; i++) {
        ThumbView* view = (ThumbView *)[_thumbsContainer viewWithTag:1000 + i];
        [UIView animateWithDuration:.3 animations:^{
            CGRect frame = view.frame;
            frame.origin.x -= 65;
            view.frame = frame;
        }];
        view.asset.index -= 1;
        view.tag = 1000 + view.asset.index;
    }
    
    _currentThumbPosition --;
    
    CGSize contentSize = _thumbsContainer.contentSize;
    contentSize.width -= 65;
    _thumbsContainer.contentSize = contentSize;
    
//    [_thumbsContainer scrollRectToVisible:[_thumbsContainer viewWithTag:1000 + _currentThumbPosition - 1].frame animated:YES];
    
    [self updateTotalLabel];
}

- (void)updateTotalLabel
{
    if ( _currentThumbPosition > 0 ) {
        _addPhotoButton.userInteractionEnabled = YES;
        _totalLabel.backgroundColor = MAIN_RED_COLOR;
        _totalLabel.textColor = [UIColor blackColor];
    } else {
        _addPhotoButton.userInteractionEnabled = NO;
        _totalLabel.backgroundColor = [UIColor grayColor];
        _totalLabel.textColor = [UIColor whiteColor];
    }
    _totalLabel.text = [NSString stringWithFormat:@"确定\n%d/%d", _currentThumbPosition, [[DataManager sharedInstance] totalThumbs]];
}

- (void)initThumbsContainer
{
    _thumbsContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                      AWFullScreenHeight() - THUMB_CONTAINER_HEIGHT,
                                                                      AWFullScreenWidth() - THUMB_CONTAINER_HEIGHT,
                                                                      THUMB_CONTAINER_HEIGHT)];
    [self.navigationController.view addSubview:_thumbsContainer];
    _thumbsContainer.backgroundColor = [UIColor blackColor];
    [_thumbsContainer release];
    
    _thumbsContainer.showsHorizontalScrollIndicator = NO;
    
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(_thumbsContainer.right, _thumbsContainer.top,
                                                              AWFullScreenWidth() - CGRectGetWidth(_thumbsContainer.frame),
                                                              THUMB_CONTAINER_HEIGHT)];
    bgView.backgroundColor = [UIColor blackColor];
    [self.navigationController.view addSubview:bgView];
    [bgView release];
    
    UILabel* totalLabel = AWCreateLabel(CGRectMake(10, 13, 50, 50),
                                        @"确定\n0/9",
                                        NSTextAlignmentCenter,
                                        AWSystemFontWithSize(15, NO),
                                        [UIColor whiteColor]);
    [bgView addSubview:totalLabel];
    totalLabel.backgroundColor = [UIColor grayColor];//AWColorFromRGB(237, 237, 237);
    totalLabel.numberOfLines = 2;
    
    _totalLabel = totalLabel;
    
    UIButton* blankBtn = AWCreateImageButton(nil, self, @selector(addPhotos));
    [bgView addSubview:blankBtn];
    blankBtn.frame = totalLabel.frame;
    
    _addPhotoButton = blankBtn;
    
    [self updateTotalLabel];
}

- (void)addPhotos
{
    if ( [self.delegate respondsToSelector:@selector(didAddPhotos:)] ) {
        [self.delegate didAddPhotos:[NSArray arrayWithArray:[[DataManager sharedInstance] currentPhotoAssets]]];
    }
    
    [[DataManager sharedInstance] addAllPhotos];
    
    [self close];
}

- (void)loadAlbumData
{
    if ( !self.assetsLibrary ) {
        self.assetsLibrary = [[[ALAssetsLibrary alloc] init] autorelease];
    }
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        if ( [error code] == ALAssetsLibraryAccessGloballyDeniedError ||
            [error code] == ALAssetsLibraryAccessUserDeniedError ) {
            [AWModalAlert say:@"没有访问权限，请到设置中打开权限。" message: @""];
        }
        
        NSLog(@"error: %@", error);
    };
    
    NSMutableArray* groups = [NSMutableArray array];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup* group, BOOL *stop) {
        ALAssetsFilter* onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        
        if ( [group numberOfAssets] > 0 ) {
            [groups addObject:group];
        } else {
            self.dataSource.dataSource = groups;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        }
    };
    
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupSavedPhotos | ALAssetsGroupEvent | ALAssetsGroupFaces;
    [self.assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PhotoListViewController* plvc = [[[PhotoListViewController alloc] init] autorelease];
    plvc.assetsGroup = [self.dataSource.dataSource objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:plvc animated:YES];
}

- (void)initTableView
{
    UITableView* tableView = AWCreateTableView(self.contentView.bounds,
                                               UITableViewStylePlain,
                                               self.contentView,
                                               self.dataSource);
    tableView.height = self.contentView.height - THUMB_CONTAINER_HEIGHT;
    
    tableView.delegate = self;
    
    _tableView = tableView;
    
    [tableView removeBlankCells];
}

- (void)setupNavBar
{
    self.title = @"相册";
    
    UIButton* leftBtn = AWCreateTextButton(CGRectMake(0, 0, 40, 33), @"取消",
                                           [UIColor whiteColor],
                                           self,
                                           @selector(close));
    [[leftBtn titleLabel] setFont:AWSystemFontWithSize(14, NO)];
    self.navBar.leftButton = leftBtn;
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
