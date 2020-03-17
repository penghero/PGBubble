//
//  ViewController.m
//  PGBubble
//
//  Created by pgg on 2020/3/17.
//  Copyright © 2020 pgg. All rights reserved.
//

#import "ViewController.h"
#import "PGBubble.h"

@interface ViewController ()

@property (nonatomic, strong) PGBubble *bubble;

@property (nonatomic, strong) UIButton *tap1;
@property (nonatomic, strong) UIButton *tap2;
@property (nonatomic, strong) UIButton *tap3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.grayColor;
    
    [self.view addSubview:self.tap1];
    [self.view addSubview:self.tap2];
    [self.view addSubview:self.tap3];

    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBubble)]];
}

- (void) addBubbleWithView: (UIButton *) view {
    [self dismissBubble];
    self.bubble = [[PGBubble alloc] initWithFrame:CGRectMake(0, 0, 120, 250)];
    self.bubble.triangleH = 12;
    self.bubble.triangleW = 12;
    self.bubble.borderWidth = 1;
    self.bubble.borderWidth = 0.0;
    
    if (view.tag == 1) {
        self.bubble.direction = PGDirectionType_Down;
        self.bubble.color = COLOR(167, 107, 215, 1);
        self.bubble.bubbleTpye = PGBubbleType_Custom2;
            [self.bubble.receiveBtn setTitle:@"带有按钮" forState:UIControlStateNormal];
            [self.bubble.receiveBtn setTitleColor:COLOR(81, 50, 21, 1) forState:UIControlStateNormal];
            [self.bubble.receiveBtn setBackgroundColor:COLOR(255, 188, 85, 1)];
            self.bubble.isSettingColorForReceive = YES;
            self.bubble.isClick = YES;
             self.bubble.blockEvent = ^(UIButton * _Nullable button) {
        //         [self.bubble dismiss];
        //         self.bubble = nil;
                 
            };
        [self.bubble.scheduleBtn setTitle:@"鹏哥气泡" forState:UIControlStateNormal];
        self.bubble.descLabel.text = @"欢迎使用鹏哥哥气泡,带有标题和描述还有按钮的类型";
        [self.bubble.scheduleBtn setBackgroundColor:COLOR(135, 74, 183, 1)];
        self.bubble.scheduleBtn.layer.cornerRadius = 6;
        [self.bubble.scheduleBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [self.bubble.scheduleBtn setTitleColor:COLOR(28, 4, 38, 1) forState:UIControlStateNormal];
        self.bubble.descLabel.textColor = COLOR(28, 4, 38, 1);
    } else if (view.tag == 2) {
        self.bubble.direction = PGDirectionType_Down;
        self.bubble.color = UIColor.whiteColor;
        self.bubble.bubbleTpye = PGBubbleType_Custom1;
        [self.bubble.scheduleBtn setTitle:@"鹏哥气泡" forState:UIControlStateNormal];
        self.bubble.descLabel.text = @"欢迎使用鹏哥哥气泡,带有标题和描述的类型";
        [self.bubble.scheduleBtn setBackgroundColor:COLOR(2, 74, 111, 1)];
        self.bubble.scheduleBtn.layer.cornerRadius = 6;
        [self.bubble.scheduleBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [self.bubble.scheduleBtn setTitleColor:COLOR(222, 4, 38, 1) forState:UIControlStateNormal];
        self.bubble.descLabel.textColor = UIColor.blackColor;
    } else {
        self.bubble.direction = PGDirectionType_Up;
        self.bubble.bubbleTpye = PGBubbleType_Text;
        self.bubble.descLabel.text = @"欢迎使用鹏哥哥气泡,只有描述的类型";
        self.bubble.color = UIColor.blackColor;
        self.bubble.descLabel.textColor = UIColor.whiteColor;
    }
        

    [self.bubble showWithView:view];
}

- (void)dismissBubble {
    if (self.bubble != nil) { [self.bubble dismiss]; }
}

- (UIButton *)tap1 {
    if (!_tap1) {
        _tap1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _tap1.frame = CGRectMake((SCREEN_W-200)/2., 350, 200, 50);
        _tap1.backgroundColor = UIColor.yellowColor;
        _tap1.tag = 1;
        [_tap1 setTitle:@"点我弹出气泡1" forState:UIControlStateNormal];
        [_tap1 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_tap1 addTarget:self action:@selector(addBubbleWithView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tap1;
}

- (UIButton *)tap2 {
    if (!_tap2) {
        _tap2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _tap2.frame = CGRectMake((SCREEN_W-150)/2., 150, 150, 100);
        _tap2.backgroundColor = UIColor.redColor;
        _tap2.tag = 2;
        [_tap2 setTitle:@"点我弹出气泡2" forState:UIControlStateNormal];
        [_tap2 setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_tap2 addTarget:self action:@selector(addBubbleWithView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tap2;
}

- (UIButton *)tap3 {
    if (!_tap3) {
        _tap3 = [UIButton buttonWithType:UIButtonTypeCustom];
        _tap3.frame = CGRectMake(50, 450, 150, 50);
        _tap3.backgroundColor = UIColor.greenColor;
        _tap3.tag = 3;
        [_tap3 setTitle:@"点我弹出气泡3" forState:UIControlStateNormal];
        [_tap3 setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_tap3 addTarget:self action:@selector(addBubbleWithView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tap3;
}


@end
