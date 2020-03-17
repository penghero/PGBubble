# PGBubble
  鹏哥哥气泡 -支持各种样式-自定义效果
  GitHub地址  https://github.com/penghero/PGBubble.git
# 演示GIF
![image](https://github.com/penghero/PGBubble/blob/master/bubble.gif)
# 部分讲解
1.开源属性及方法

// 气泡类型
typedef NS_ENUM(NSInteger, PGBubbleType) {
    PGBubbleType_Default, // 默认样式
    PGBubbleType_Text,    // 只有文字的样式
    PGBubbleType_Custom1, // 顶部有背景的标题和描述
    PGBubbleType_Custom2, // 顶部有背景的标题和描述 底部按钮 
    PGBubbleType_Custom3, // 列表样式
    PGBubbleType_Custom4, // 顶部有背景的标题和描述 底部头像框
    PGBubbleType_Custom5, // 顶部有背景的标题和描述 按钮1 按钮2
    PGBubbleType_Other    // 其他样式
};

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *borderColor;
/// 设置>0 才有边框 不设置 不显示边框
@property (nonatomic, assign) CGFloat borderWidth;
/// 圆角
@property (nonatomic, assign) CGFloat cornerRadius;
/// 三角形高
@property (nonatomic, assign) CGFloat triangleH;
/// 三角形底边长
@property (nonatomic, assign) CGFloat triangleW;
/// 容器 可自定义
@property (nonatomic, strong) UIView *contentView;
/// 顶部标题文字
@property (nonatomic, strong) UILabel *topTitle;
/// 中间详细描述
@property (nonatomic, strong) UILabel *descLabel;
/// 中间进度 3/5之类 带背景图但是没有相应事件
@property (nonatomic, strong) UIButton *scheduleBtn;
/// 底部领取按钮 有点击回调
@property (nonatomic, strong) UIButton *receiveBtn;
/// 领取按钮是否可以点击 默认不可以 不设置就是不可以
@property (nonatomic, assign) BOOL isClick;

/// 升级按钮 为custom5 定制
@property (nonatomic, strong) UIButton *upgradeBtn;
/// 升级按钮状态 yes 已升级
@property (nonatomic, assign) BOOL isUpgrade;
///是否可以设置下方背景色 默认NO 如开启 必须将 isUpgrade 设置为YES 同时开启 即可生效 yes 置灰
@property (nonatomic, assign) BOOL isSettingColorForUpgrade;


/// 是否显示红点 加错了 暂无用
@property (nonatomic, assign) BOOL isShowRedSign;

///是否可以设置下方背景色 默认NO 如开启 必须将 isClick 设置为YES 同时开启 即可生效
@property (nonatomic, assign) BOOL isSettingColorForReceive;

/// 中间部分的描述框
@property (nonatomic, strong) UIImageView *descImg;
/// 三角方向，默认朝下
@property (nonatomic) PGDirectionType direction;
//优先使用triangleXY。如果triangleXY和triangleXYScale都不设置，则三角在中间
///三角的x或y。
@property (nonatomic, assign) CGFloat triangleXY;
///三角的中心x或y位置占边长的比例，如0.5代表在中间
@property (nonatomic, assign) CGFloat triangleXYScale;
/// 点击回调 按钮2
@property (nonatomic,copy) ClickBlock blockEvent;
/// 点击回调 按钮1
@property (nonatomic,copy) ClickBlock blockEventOther;
/// 气泡样式
@property (nonatomic) PGBubbleType bubbleTpye;

/// 是否取消 消失的动画效果 默认NO
@property (nonatomic, assign) BOOL isAnimation;

/// 显示
-(void)showWithView:(UIView *)view;
/// 移除
- (void)dismiss;

2.用例
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

