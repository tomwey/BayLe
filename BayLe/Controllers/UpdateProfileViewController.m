//
//  UpdateProfileViewController.m
//  BayLe
//
//  Created by tangwei1 on 15/12/11.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "UpdateProfileViewController.h"
#import "Defines.h"

@interface UpdateProfileViewController ()
<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImageView* _avatarView;
    UITextField* _nicknameField;
}

@property (nonatomic, retain) User* user;

@end

@implementation UpdateProfileViewController

- (void)dealloc
{
    self.user = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"个人资料";
    
    self.user = [[[[UserManager sharedInstance] currentUser] copy] autorelease];
    if ( !self.user ) {
        self.user = [[[User alloc] init] autorelease];
        self.user.token = @"85d7444b0da976341c3a";
    }
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
    [self.contentView addSubview:tableView];
    [tableView release];
    tableView.height = 120;
    tableView.top = 10;
    
    tableView.scrollEnabled = NO;
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    tableView.rowHeight = 60;
    
    tableView.backgroundColor = [UIColor clearColor];
    
    [tableView removeBlankCells];
    
    [tableView removeCompatibility];
    
    if ( !self.firstLogin ) {
        self.navBar.leftButton = AWCreateTextButton(CGRectMake(0, 0, 40, 40),
                                                    @"返回",
                                                    NAVBAR_HIGHLIGHT_TEXT_COLOR,
                                                    self,
                                                    @selector(back));
        self.navBar.rightButton = AWCreateTextButton(CGRectMake(0, 0, 40, 40),
                                                     @"保存",
                                                     NAVBAR_HIGHLIGHT_TEXT_COLOR,
                                                     self,
                                                     @selector(save));
    } else {
        // 完成登录
        UIButton* doneBtn = AWCreateTextButton(CGRectMake(15, tableView.bottom + 10,
                                                          self.contentView.width - 30,
                                                          50),
                                               @"完成登录",
                                               [UIColor whiteColor],
                                               self,
                                               @selector(save));
        [self.contentView addSubview:doneBtn];
        doneBtn.backgroundColor = MAIN_RED_COLOR;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell.id"];
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell.id"] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel* label = AWCreateLabel(CGRectMake(15, 0, 40, tableView.rowHeight),
                                       nil, NSTextAlignmentLeft,
                                       nil,
                                       [UIColor blackColor]);
        [cell.contentView addSubview:label];
        if ( indexPath.row == 0 ) {
            label.text = @"头像";
            
            UIImageView* avatarView = AWCreateImageView(nil);
            avatarView.backgroundColor = MAIN_LIGHT_GRAY_COLOR;
            [cell.contentView addSubview:avatarView];
            avatarView.frame = CGRectMake(tableView.width - 15 - 50 - 15, tableView.rowHeight / 2 - 50 / 2, 50, 50);
            avatarView.layer.cornerRadius = avatarView.height / 2;
            avatarView.clipsToBounds = YES;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            _avatarView = avatarView;
            
        } else {
            label.text = @"昵称";
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            UITextField* nicknameField = [[UITextField alloc] initWithFrame:CGRectMake(label.right, tableView.rowHeight / 2 - 20,
                                                                                       168,
                                                                                       40)];
            [cell.contentView addSubview:nicknameField];
            [nicknameField release];
            nicknameField.placeholder = @"输入昵称，20字以内";
            
            _nicknameField = nicknameField;
            
            nicknameField.returnKeyType = UIReturnKeyDone;

            [nicknameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [nicknameField addTarget:self action:@selector(shouldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
        }
    }
    
    _nicknameField.text = self.user.nickname;
    
    [_avatarView setImageWithURL:[NSURL URLWithString:self.user.avatar]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( indexPath.row == 0 ) {
        [_nicknameField resignFirstResponder];
        
        // 设置图片
        UIActionSheet* actionSheet = [[[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"从相册选择", @"拍照", nil] autorelease];
        [actionSheet showInView:self.view];
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if ( [textField.text length] > 20 ) {
        [AWModalAlert say:@"最多不超过20个字" message:@""];
        return;
    }
    
    self.user.nickname = textField.text;
}

- (void)shouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 ) {
        // 从相册选择
        [self showImagePickerControllerForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    } else if ( buttonIndex == 1 ) {
        // 拍照
        [self showImagePickerControllerForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
}

- (void)showImagePickerControllerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if ( [UIImagePickerController isSourceTypeAvailable:sourceType] ) {
        UIImagePickerController* controller = [[[UIImagePickerController alloc] init] autorelease];
        controller.sourceType = sourceType;
        controller.allowsEditing = YES;
        controller.delegate   = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage* anImage = [info objectForKey:UIImagePickerControllerEditedImage];
    _avatarView.image = anImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)save
{
    if ( self.firstLogin && _avatarView.image == nil ) {
        [AWToast showText:@"必须设置头像"];
        return;
    }
    
    if ( [[self.user.nickname trim] length] == 0 ) {
        [AWToast showText:@"昵称不能为空"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    [[UserManager sharedInstance] updateUser:self.user avatar:_avatarView.image completion:^(id result, NSError *error) {
        [MBProgressHUD hideHUDForView:self.contentView animated:YES];
        if ( error ) {
            [AWToast showText:error.domain];
        } else {
            [self back];
        }
    }];
}

- (void)back
{
    if ( self.firstLogin ) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
