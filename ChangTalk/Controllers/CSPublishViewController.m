//
//  CSPublishViewController.m
//  ChangTalk
//  发布
//  Created by ctkj on 14-4-11.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "CSPublishViewController.h"
#import "CSInputAccessoryView.h"
#import "CSKeyboardBuilder.h"

@interface CSPublishViewController ()
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)UITextView* textView;
@property (nonatomic, strong)CSInputAccessoryView* accessoryView;

@end

@implementation CSPublishViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"发布信息";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clickDimissView:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(clickPostNewTweet:)];
    
    //_editorButtons = [[NSMutableArray alloc] initWithCapacity:6];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    _scrollView.backgroundColor = [UIColor blueColor];
    //[self.view addSubview:_scrollView];
    
    debugLog(@"widht%f= height=%f", CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    _accessoryView = [[CSInputAccessoryView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-44, 320, 44)];
    _accessoryView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_accessoryView];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 80, 320, 100)];
    _textView.backgroundColor = [UIColor redColor];
    _textView.font = [UIFont systemFontOfSize:16.0f];
    _textView.returnKeyType = UIReturnKeySend;
    //_textView.inputAccessoryView = _accessoryView;
    
    
    [self.view addSubview:_textView];
    
    [self initComposeView];
    
    //注册键盘消息
    [self registerKeyBoardForNotifications];
}

- (void)initComposeView
{
    
    NSArray* buttonNormalNames = @[@"compose_location_background",
                                   @"compose_camera_background",
                                   @"compose_hashtag_background",
                                   @"compose_mention_background",
                                   @"compose_emoticon_background",
                                   @"compose_keyboard_background"
                                   ];
    
    NSArray* buttonHighlightedNames = @[@"compose_location_highlighted",
                                        @"compose_camera_highlighted",
                                        @"compose_hashtag_highlighted",
                                        @"compose_mention_highlighted",
                                        @"compose_emoticon_highlighted",
                                        @"compose_keyboard_highlighted"
                                        ];
    
//    NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:0];
//    for (int i=0; i<buttonNormalNames.count; i++) {
//        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
//        [array addObject:item];
//    }
//    _accessoryView.items = array;
    
    for (int i=0; i<buttonNormalNames.count; i++) {
        NSString* imageName = buttonNormalNames[i];
        NSString* imageHighName = buttonHighlightedNames[i];
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageHighName] forState:UIControlStateHighlighted];
        button.tag = 10+i;
        [button addTarget:self action:@selector(clickInputAccessoryView:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(20+(64*i), 22-10, 27, 24);
        
        [_accessoryView addSubview:button];
        //[_editorButtons addObject:button];
        
        if (i == buttonNormalNames.count-1) {
            button.frame = CGRectMake(20+(64*(i-1)), 22-10, 27, 24);
            button.alpha = 0;
            button.hidden = YES;
        }
    }
}

- (void)registerKeyBoardForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)unregisterKeyBoardForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)clickDimissView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(){
        debugLog(@"dismiss publish!");
    }];
    
}
- (void)clickPostNewTweet:(id)sender
{
    [_textView resignFirstResponder];
}

- (void)clickInputAccessoryView:(UIButton*)sender
{
    if (sender.tag == 10) { //位置
        //[self clickLocationButton];
    }else if(sender.tag == 11){ //相机
        //[self clickCameraButton];
    }else if(sender.tag == 12){ //话题
        //[self clickTopicButton];
    }else if(sender.tag == 13){ //@用户
        //[self clickUserButton];
    }else if(sender.tag == 14){ //表情
        [self clickEmoticonButton];
    }else if(sender.tag == 15){ //键盘
        [self clickKeyboardButton];
    }
}

- (void)clickEmoticonButton
{
    if (self.textView.isFirstResponder) {
      [self.textView switchToEmoticonsKeyboard:[CSKeyboardBuilder sharedEmoticonsKeyboard]];
    }else{
        [self.textView switchToEmoticonsKeyboard:[CSKeyboardBuilder sharedEmoticonsKeyboard]];
        [self.textView becomeFirstResponder];
    }
    
    UIButton* buttonEmotion = (UIButton*)[_accessoryView viewWithTag:14];
    UIButton* buttonKeyboard = (UIButton*)[_accessoryView viewWithTag:15];
    
    buttonKeyboard.hidden = NO;
    buttonEmotion.alpha = 1;
    buttonKeyboard.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        //_scrollViewFace.top = self.editorBar.bottom;
        buttonEmotion.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            buttonKeyboard.alpha = 1;
            buttonEmotion.hidden = YES;
        }];
    }];
}

- (void)clickKeyboardButton
{
    if (self.textView.emoticonsKeyboard)
        [self.textView switchToDefaultKeyboard];
    
    UIButton* buttonEmotion = (UIButton*)[_accessoryView viewWithTag:14];
    UIButton* buttonKeyboard = (UIButton*)[_accessoryView viewWithTag:15];
    
    buttonEmotion.hidden = NO;
    buttonKeyboard.alpha = 1;
    buttonEmotion.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        //_scrollViewFace.top = ScreenHeight;
        buttonKeyboard.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            buttonEmotion.alpha = 1;
            buttonKeyboard.hidden = YES;
        }];
    }];
}

#pragma mark -
- (void)keyboardWillShow:(NSNotification *)notification
{
    self.scrollView.scrollEnabled = NO;
    
    CGRect keyboardBounds;
    [notification.userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    CGRect containerFrame = self.scrollView.frame;
    containerFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(keyboardBounds);
    
    self.scrollView.frame = containerFrame;
    
    self.scrollView.scrollEnabled = YES;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // This method is called many times on different occasions.
    
    // This method is called when the user has stopped dragging
    // the keyboard and it is about to animate downwards.
    // The keyboardWillHide method determines if that is the case
    // and adjusts the interface accordingly.
    [self keyboardWillHide:notification];
    
    // This method is called when the user has switched
    // to a different keyboard. The keyboardWillSwitch method
    // determines if that is the case and adjusts the interface
    // accordingly.
    [self keyboardWillSwitch:notification];
}

- (void)keyboardWillSwitch:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    // Disregard false notification
    // This works around a bug in iOS
    CGRect inputViewBounds = self.inputView.bounds;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.scrollView.scrollEnabled = NO;
    
    CGRect keyboardBounds;
    [notification.userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    CGRect containerFrame = self.scrollView.frame;
    containerFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(keyboardBounds);
    
    self.scrollView.frame = containerFrame;
    
    self.scrollView.scrollEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self unregisterKeyBoardForNotifications];
}
@end
