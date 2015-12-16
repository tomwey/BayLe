//
//  FeedbackViewController.m
//  EAT
//
//  Created by tangwei1 on 15/5/12.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import "FeedbackViewController.h"
#import "Defines.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface FeedbackViewController ()
{
//    TextInputComponent* _textInputControl;
}

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"意见反馈";
    
//    UIButton* saveButton = createTextButton(CGRectMake(0, 0, 60, 44),
//                                            @"发送",
//                                            RGB(82, 82, 82),
//                                            [UIFont systemFontOfSize:15],
//                                            self,
//                                            @selector(save));
//    
//    saveButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -5, -30);
//    
//    [self setRightBarButtonWithView:saveButton];
    
//    TextInputComponent* tic = [[[TextInputComponent alloc] init] autorelease];
//    [self.view addSubview:tic];
//    
//    tic.componentType = TextInputComponentTypeMultiple;
//    
//    tic.font = [UIFont systemFontOfSize:16];
//    
//    _textInputControl = tic;
//    
//    CGRect frame = tic.frame;
//    frame.origin.y = 64 + 15;
//    tic.frame = frame;
//    
//    tic.placeholder = @"欢迎您给我们提出宝贵的意见";
}

- (NSString *)deviceModel
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

- (void)save
{
//    if ( [NSString isStringEmpty:_textInputControl.text] ) {
//        return;
//    }
//    
//    [_textInputControl hideKeyboard];
//    
//    NSString* url = @"http://kekestudio.com/api/v1/feedbacks";
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:
//                                    [NSURL URLWithString:url]];
//    
//    request.HTTPMethod = @"POST";
//    
//    NSString* body = [NSString stringWithFormat:@"key=0a3e2114fefe44d485308e6d7b7beade&content=%@&m=%@&ov=%@",
//                      _textInputControl.text,
//                      [self deviceModel],
//                      [[UIDevice currentDevice] systemVersion]];
//    
//    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
//    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
//    {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//        if ( !connectionError ) {
//           [AWToast showText:@"提交反馈成功"];
////           [self back];
//            [self.navigationController popViewControllerAnimated:YES];
//       } else {
//           [AWToast showText:@"提交反馈失败"];
//       }
//    }];
}

@end
