//
//  PublishViewController.m
//  BayLe
//
//  Created by tangwei1 on 15/11/19.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "PublishViewController.h"
#import "Defines.h"

@interface PublishViewController () <UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, APIManagerDelegate>

// 保存填入的数据
@property (nonatomic, retain) NSMutableDictionary* itemData;

// 记录表视图的初始状态
@property (nonatomic, assign) CGPoint originContentOffset;
@property (nonatomic, assign) UIEdgeInsets originContentInset;

// 提交数据对象
@property (nonatomic, retain) APIManager* postAPIManager;

@end

#define SECTION_PADDING 10
#define NUMBER_OF_COLS_PER_ROW 4

static NSString * const kParamKeyTitle = @"title";
static NSString * const kParamKeyIntro = @"intro";
static NSString * const kParamKeyFee = @"fee";
static NSString * const kParamKeyDeposit = @"deposit";
static NSString * const kParamKeyTagID = @"tag_id";
static NSString * const kParamKeyLocation = @"location";
static NSString * const kParamKeyPlacement = @"placement";

@implementation PublishViewController
{

    UITextField* _currentField; // 当前输入框
    UITextView*  _currentTextView; // 描述
    
    UITextField* _titleField; // 标题
    
    UILabel*     _catalogLabel;  // 分类
    UILabel*     _locationLabel; // 位置
    
    UITextField* _priceField; // 租金
    UITextField* _depositField; // 押金
    
    UILabel*     _introPlaceholderLabel; // 描述提示
    
    UITableView* _tableView;
    
    UIView*      _thumbImagesContainer; // 保存选择的图片容器
    
    UIButton*    _addPhotoButton; // 添加图片按钮
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"发布";
    
    self.itemData = [NSMutableDictionary dictionary];
    
    UIButton* rightBtn = AWCreateTextButton(CGRectMake(0, 0, 40, 33), @"提交", NAVBAR_HIGHLIGHT_TEXT_COLOR, self, @selector(commit));
    [[rightBtn titleLabel] setFont:AWSystemFontWithSize(14, NO)];
    self.navBar.rightButton = rightBtn;
    
    [self initTableView];
    
    self.originContentOffset = _tableView.contentOffset;
    self.originContentInset  = _tableView.contentInset;
    
    [self resetForm];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didPushPhotosToUse)
                                                 name:PhotoAssetDidRemoveNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PhotoAssetDidRemoveNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    CGPoint point = [_currentField.superview convertPoint:_currentField.frame.origin toView:AWAppWindow()];
    CGFloat dt = point.y - [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height - _currentField.height + 16;
    if ( dt > 0 ) {
        [UIView animateWithDuration:[[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]
                         animations:
         ^{
             _tableView.contentInset = UIEdgeInsetsMake(0, 0, dt, 0);
             
             CGPoint offset = _tableView.contentOffset;
             offset.y += dt;
             _tableView.contentOffset = offset;
         }];
    }
    
}

#pragma mark - UITableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

static int rows[] = { 2, 3, 1 };
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rows[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifier = [NSString stringWithFormat:@"cell.id.%d - %d", indexPath.section, indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //[tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        
        switch (indexPath.section) {
            case 0:
            {
                [self initSection0:indexPath forCell:cell];
            }
                break;
            case 1:
            {
                [self initSection1:indexPath forCell:cell];
            }
                break;
            case 2:
            {
                [self initSection2:indexPath forCell:cell];
            }
                break;
                
            default:
                break;
        }
    }
    
    int lastRow = rows[indexPath.section] - 1;
    if ( indexPath.row < lastRow ) {
        UIView* line = [cell.contentView viewWithTag:10011];
        if ( !line ) {
            line = AWCreateLine(CGSizeMake(_tableView.width - 15, 0.6),
                                AWColorFromRGB(224, 224, 224));
            line.tag = 10011;
            [cell.contentView addSubview:line];
            line.position = CGPointMake(15, cell.contentView.height + 5);
        }
    }
    
    return cell;
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( indexPath.section != 0 ) {
        if ( indexPath.section == 1 && indexPath.row == 2 ) {
            [self changeCategory];
        } else if ( indexPath.section == 2 ) {
            [self changeLocation];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        if ( indexPath.row == 0 ) {
            return 50;
        }
        
        if ( [[[PhotoManager sharedInstance] allPhotoAssets] count] == 0 ) {
            return 88 + 10 + 10 + 60;
        }
        
        int rows = ( [[[PhotoManager sharedInstance] allPhotoAssets] count] + 1 + NUMBER_OF_COLS_PER_ROW - 1 ) / NUMBER_OF_COLS_PER_ROW;
        
        return 88 + 10 + rows * 60 + (rows + 1) * SECTION_PADDING / 2 + 10 + 10;
    }
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 0.1;
    }
    
    return 10;
}

#pragma mark - UIScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_currentTextView resignFirstResponder];
    
    if ( _currentField.tag == 1002 || _currentField.tag == 1003 ) {
        [_currentField resignFirstResponder];
        _currentField = nil;
        
        [UIView animateWithDuration:.25 animations:^{
            _tableView.contentInset = self.originContentInset;
            _tableView.contentOffset = self.originContentOffset;
        }];
        
    }
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentField = textField;
}

- (void)textFieldDidChange:(UITextField *)textFiled
{
    if ( textFiled.tag == 1001 ) {
        if ( textFiled.text.length > 50 ) {
            [AWModalAlert say:@"最多不超过50个字" message:@""];
            return;
        }
        
        [self.itemData setObject:textFiled.text forKey:kParamKeyTitle];
    } else if ( textFiled.tag == 1002 ) {
        if ( textFiled.text.length == 1 &&
            [textFiled.text isEqualToString:@"0"]) {
            textFiled.text = @"";
            [AWModalAlert say:@"不正确的数字" message:@""];
            return;
        }
        [self.itemData setObject:@([textFiled.text integerValue]) forKey:kParamKeyFee];
    } else if ( textFiled.tag == 1003 ) {
        if ( textFiled.text.length == 1 &&
            [textFiled.text isEqualToString:@"0"]) {
            textFiled.text = @"";
            [AWModalAlert say:@"不正确的数字" message:@""];
            return;
        }
        [self.itemData setObject:@([textFiled.text integerValue]) forKey:kParamKeyDeposit];
    }
    
}

- (void)textFieldTapReturn:(UITextField *)textFiled
{
    [textFiled resignFirstResponder];
}

#pragma mark - UITextView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _currentTextView = textView;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    _introPlaceholderLabel.hidden = ( textView.text.length > 0 );
    if ( textView.text.length >= 200 ) {
        [AWModalAlert say:@"最多不超过200个字" message:@""];
        return;
    }
    
    [self.itemData setObject:textView.text forKey:kParamKeyIntro];
}

#pragma mark - APIManager delegate
/** 网络请求开始 */
- (void)apiManagerDidStart:(APIManager *)manager
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

/** 网络请求完成 */
- (void)apiManagerDidFinish:(APIManager *)manager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

/** 网络请求成功回调 */
- (void)apiManagerDidSuccess:(APIManager *)manager
{
    [AWToast showText:@"发布成功"];
    
    [self resetForm];
}

/** 网络请求失败回调 */
- (void)apiManagerDidFailure:(APIManager *)manager
{
    [AWToast showText:manager.apiError.message];
}

#pragma mark - Target Action methods
- (void)commit
{
    if ( ![self validateFormData] ) {
        return;
    }
    
    if ( !self.postAPIManager ) {
        self.postAPIManager = [APIManager apiManagerWithDelegate:self];
    }
    
    [self.postAPIManager cancelRequest];
    
    [self.itemData setObject:[[[UserManager sharedInstance] currentUser] token] forKey:@"token"];
    
    APIRequest* request = APIRequestCreate(API_CREATE_ITEM, RequestMethodPost, self.itemData);
    
    int index = 0;
    NSMutableArray* fileParams = [NSMutableArray array];
    for (ALAsset* asset in [[PhotoManager sharedInstance] allPhotoAssets]) {
        
        ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
        
        UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]
                                                       scale:[assetRepresentation scale]
                                                 orientation:UIImageOrientationUp];
        
        NSString* name = [NSString stringWithFormat:@"photo%d", index];
        APIFileParam* fileParam = APIFileParamCreate(UIImageJPEGRepresentation(fullScreenImage, 1.0),
                                                     name,
                                                     @"image.jpg",
                                                     @"image/jpeg");
        [fileParams addObject:fileParam];
        
        index++;
    }
    
    request.fileParams = fileParams;
    
    [self.postAPIManager sendRequest:request];
}

- (void)changeCategory
{
    CatalogViewController* cvc = [[[CatalogViewController alloc] init] autorelease];
    cvc.delegate = self;
    [self presentViewController:cvc animated:YES completion:nil];
}

- (void)changeLocation
{
    SelectLocationViewController* slvc = [[[SelectLocationViewController alloc] init] autorelease];
    slvc.shouldSearching = NO;
    slvc.delegate = self;
    [self presentViewController:slvc animated:YES completion:nil];
}

- (void)addPhoto:(UIButton *)sender
{
    AlbumListViewController* controller = [[[AlbumListViewController alloc] init] autorelease];
    UINavigationController* nav = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
    controller.delegate = self;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Controller Delegate
- (void)didPushPhotosToUse
{
    // 移除旧数据
    for (UIView* subview in [_thumbImagesContainer subviews]) {
        if ( ![subview isKindOfClass:[UIButton class]] ) {
            [subview removeFromSuperview];
        }
    }
    
    // 添加新数据
    CGFloat width = [self thumbWidth];
    CGFloat top = SECTION_PADDING / 2;
    
    NSArray* tempPhotos = [[PhotoManager sharedInstance] allPhotoAssets];
    
    for (int i=0; i<[tempPhotos count]; i++) {
        ThumbView* thumbView = [[[ThumbView alloc] init] autorelease];
        [_thumbImagesContainer addSubview:thumbView];
        thumbView.asset = [tempPhotos objectAtIndex:i];
        
        CGFloat dtx = ( width + SECTION_PADDING / 2) * ( (int)( i % NUMBER_OF_COLS_PER_ROW ) );
        CGFloat dty = ( top + ( width + SECTION_PADDING / 2 ) * (int)(i / NUMBER_OF_COLS_PER_ROW) );
        thumbView.frame = CGRectMake(dtx, dty, width, width);
        
        if ( i == [tempPhotos count] - 1 ) {
            CGFloat btx = ( width + SECTION_PADDING / 2) * ( (int)( ( i + 1 ) % NUMBER_OF_COLS_PER_ROW ) );
            CGFloat bty = ( top + ( width + SECTION_PADDING / 2 ) * (int)( ( i + 1 ) / NUMBER_OF_COLS_PER_ROW) );
            
            _addPhotoButton.frame = CGRectMake(btx, bty + 11, thumbView.height - 11, thumbView.height - 11);
            _thumbImagesContainer.height = _addPhotoButton.bottom + SECTION_PADDING / 2;
        }
    }
    
    if ( [tempPhotos count] < UPLOAD_MAX_COUNT ) {
        _addPhotoButton.hidden = NO;
    } else {
        _addPhotoButton.hidden = YES;
    }
    
    if ( [tempPhotos count] == 0 ) {
        _addPhotoButton.frame = CGRectMake(0, 0, 60, 60);
        _thumbImagesContainer.frame = CGRectMake(_currentTextView.left,
                                                 _currentTextView.bottom + 5,
                                                 _tableView.width - _currentTextView.left * 2, 60);
        
    }
    
    [_tableView reloadData];
}

- (void)didSelectCatalog:(id)catalog
{
    _catalogLabel.text = [catalog objectForKey:@"name"];
    [self.itemData setObject:@([[catalog objectForKey:@"id"] integerValue]) forKey:kParamKeyTagID];
}

- (void)didSelectLocation:(Location *)aLocation
{
    [self configLocation:aLocation];
}

#pragma mark - Override methods
- (BOOL)shouldCheckLogin
{
    return YES;
}

#pragma mark - Private Methods
- (void)initTableView
{
    _tableView = AWCreateTableView(self.contentView.bounds,
                                   UITableViewStylePlain,
                                   self.contentView,
                                   self);
    _tableView.delegate = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.backgroundColor = [UIColor clearColor];
}

- (void)initSection0:(NSIndexPath *)indexPath forCell:(UITableViewCell *)cell
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ( indexPath.row == 0 ) {
        // 添加标题
        _titleField = [self createTextFieldWithFrame:CGRectMake(15, 7, _tableView.width - 30, 37)
                                                 tag:1001
                                         placeholder:@"标题"
                                              inView:cell.contentView];
    } else {
        // 添加描述
        UITextView* introTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 7,
                                                                                 _tableView.width - 30,
                                                                                 88)];
        [cell.contentView addSubview:introTextView];
        [introTextView release];
        
        introTextView.delegate = self;
        
        _currentTextView = introTextView;
        
        introTextView.font = AWSystemFontWithSize(14, NO);
        
        CGRect frame = introTextView.frame;
        frame.size.height = 30;
        frame.origin.y += 2;
        frame.origin.x += 2;
        UILabel* placeholder = AWCreateLabel(frame,
                                             @"描述一下您的宝贝",
                                             NSTextAlignmentLeft,
                                             introTextView.font,
                                             _tableView.separatorColor);
        [cell.contentView addSubview:placeholder];
        
        _introPlaceholderLabel = placeholder;
        
        introTextView.x -= 3;
        introTextView.width += 6;
        
        _thumbImagesContainer = [[UIView alloc] initWithFrame:CGRectMake(introTextView.left,
                                                                         introTextView.bottom + 5,
                                                                         _tableView.width - introTextView.left * 2,
                                                                         60)];
        [cell.contentView addSubview:_thumbImagesContainer];
        [_thumbImagesContainer release];
//        _thumbImagesContainer.backgroundColor = [UIColor redColor];
        
        // 添加图片
        UIButton* addPhoto = AWCreateTextButton(CGRectMake(0, 0, 60, 60),
                                                @"添加图片",
                                                MAIN_LIGHT_GRAY_COLOR,
                                                self,
                                                @selector(addPhoto:));
        [[addPhoto titleLabel] setFont:AWSystemFontWithSize(14, NO)];
        [_thumbImagesContainer addSubview:addPhoto];
        
        addPhoto.backgroundColor = MAIN_CONTENT_BG_COLOR;
        
        _addPhotoButton = addPhoto;
    }
}

- (void)initSection1:(NSIndexPath *)indexPath forCell:(UITableViewCell *)cell
{
    if ( indexPath.row == 0 ) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 租金
        UILabel* priceLabel = AWCreateLabel(CGRectMake(15, 10, 36, 30),
                                            @"租金",
                                            NSTextAlignmentLeft,
                                            AWSystemFontWithSize(14, NO), [UIColor blackColor]);
        [cell.contentView addSubview:priceLabel];
        
        UITextField* priceField = [self createTextFieldWithFrame:CGRectMake(priceLabel.right + 10, priceLabel.top,
                                                                            _tableView.width - priceLabel.right - 20,
                                                                            priceLabel.height)
                                                             tag:1002
                                                     placeholder:@"输入租金"
                                                          inView:cell.contentView];
        priceField.keyboardType = UIKeyboardTypeNumberPad;
        
        _priceField = priceField;
        
    } else if ( indexPath.row == 1 ) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 押金
        UILabel* depositLabel = AWCreateLabel(CGRectMake(15, 10, 36, 30),
                                              @"押金",
                                              NSTextAlignmentLeft,
                                              AWSystemFontWithSize(14, NO), [UIColor blackColor]);
        [cell.contentView addSubview:depositLabel];
        
        UITextField* depositField = [self createTextFieldWithFrame:CGRectMake(depositLabel.right + 10,
                                                                              depositLabel.top,
                                                                              _tableView.width - depositLabel.right - 20,
                                                                              depositLabel.height)
                                                               tag:1003
                                                       placeholder:@"输入押金"
                                                            inView:cell.contentView];
        depositField.keyboardType = UIKeyboardTypeNumberPad;
        
        _depositField = depositField;
    } else if ( indexPath.row == 2 ) {
        // 分类
        UILabel* categoryLabel = AWCreateLabel(CGRectMake(15, 10, 36, 30),
                                               @"分类",
                                               NSTextAlignmentLeft,
                                               AWSystemFontWithSize(14, NO), [UIColor blackColor]);
        [cell.contentView addSubview:categoryLabel];
        
        UILabel* selectTip = AWCreateLabel(CGRectMake(categoryLabel.right + 10,
                                                      categoryLabel.top,
                                                      _tableView.width - categoryLabel.right - 20,
                                                      categoryLabel.height),
                                           @"请选择分类",
                                           NSTextAlignmentLeft,
                                           AWSystemFontWithSize(14, NO), [UIColor blackColor]);
        [cell.contentView addSubview:selectTip];
        
        _catalogLabel = selectTip;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

- (void)initSection2:(NSIndexPath *)indexPath forCell:(UITableViewCell *)cell
{
    UILabel* adLabel = AWCreateLabel(CGRectMake(15, 10, 36, 30),
                                     @"地址",
                                     NSTextAlignmentLeft,
                                     AWSystemFontWithSize(14, NO), [UIColor blackColor]);
    [cell.contentView addSubview:adLabel];
    
    CGRect frame = adLabel.frame;
    frame.origin.x = adLabel.right + 10;
    frame.size.width = _tableView.width - adLabel.right - 20;
    
    UILabel* locationLabel = AWCreateLabel(frame,
                                           @"绿地世纪城",
                                           NSTextAlignmentLeft,
                                           AWSystemFontWithSize(14, NO), [UIColor blackColor]);
    [cell.contentView addSubview:locationLabel];
    _locationLabel = locationLabel;
    
    Location* loc = [[LBSManager sharedInstance] currentLocation];
    [self configLocation:loc];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)hideKeyboard
{
    [_currentTextView resignFirstResponder];
    [_currentField resignFirstResponder];
}

- (UITextField *)createTextFieldWithFrame:(CGRect)frame
                                      tag:(int)tag
                              placeholder:(NSString *)placeholder
                                   inView:(UIView *)containerView
{
    UITextField* textField = [[UITextField alloc] initWithFrame:frame];
    [containerView addSubview:textField];
    [textField release];
    
    textField.returnKeyType = UIReturnKeyDone;
    
    textField.tag = tag;
    
    textField.placeholder = placeholder;
    
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [textField addTarget:self action:@selector(textFieldTapReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [textField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    return textField;
}

- (void)configLocation:(Location *)loc
{
    if ( loc ) {
        _locationLabel.text = loc.placement;
        [self.itemData setObject:[loc locationString] forKey:kParamKeyLocation];
        [self.itemData setObject:loc.placement forKey:kParamKeyPlacement];
    }
}

- (void)resetForm
{
    _titleField.text = @"";
    _currentTextView.text = @"";
    
    _introPlaceholderLabel.hidden = NO;
    
    _priceField.text = @"";
    _depositField.text = @"";
    
    _catalogLabel.text = @"请选择分类";
    
    _locationLabel.text = [[[LBSManager sharedInstance] currentLocation] placement];
    
    for (UIView* view in _thumbImagesContainer.subviews) {
        if ( ![view isKindOfClass:[UIButton class]] ) {
            [view removeFromSuperview];
        }
    }
    
    _thumbImagesContainer.frame = CGRectMake(_currentTextView.left,
                                             _currentTextView.bottom + 5,
                                             _tableView.width - _currentTextView.left * 2,
                                             60 + 15);
    _addPhotoButton.frame = CGRectMake(0, 0, 60, 60);
    
    [self.itemData removeAllObjects];
    
    [[PhotoManager sharedInstance] clearAllPhotoAssets];
    
    [_tableView reloadData];
}

- (BOOL)validateFormData
{
    if ( [[[PhotoManager sharedInstance] allPhotoAssets] count] == 0  ) {
        [AWToast showText:@"至少需要一张图片"];
        return NO;
    }
    
    if ( [[self.itemData objectForKey:kParamKeyTitle] length] == 0 ) {
        [AWToast showText:@"标题不能为空"];
        return NO;
    }
    
    if ( ![self.itemData objectForKey:kParamKeyFee] ) {
        [AWToast showText:@"租金不能为空"];
        return NO;
    }
    
    if ( ![self.itemData objectForKey:kParamKeyDeposit] ) {
        [AWToast showText:@"押金不能为空"];
        return NO;
    }
    
    if ( [[self.itemData objectForKey:kParamKeyIntro] length] == 0 ) {
        [AWToast showText:@"描述不能为空"];
        return NO;
    }
    
    if ( ![self.itemData objectForKey:kParamKeyTagID] ) {
        [AWToast showText:@"必须选择一个分类"];
        return NO;
    }
    
    if ( ![self.itemData objectForKey:kParamKeyLocation] ) {
        [AWToast showText:@"位置不能为空"];
        return NO;
    }
    
    return YES;
}

- (CGFloat)thumbWidth
{
    return ( _tableView.width - 30 - ( NUMBER_OF_COLS_PER_ROW - 1 ) * SECTION_PADDING / 2) / NUMBER_OF_COLS_PER_ROW;
}

@end
