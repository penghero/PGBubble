//
//  PGBubble.h
//  Bubble
//
//  Created by 陈鹏 on 2019/11/18.
//  Copyright © 2019 penggege.CP. All rights reserved.
//  请务 删除
//  作者github地址： https://github.com/penghero/PGBubble

#import <UIKit/UIKit.h>


#define SCREEN_W                 [UIScreen mainScreen].bounds.size.width
#define SCREEN_H                 [UIScreen mainScreen].bounds.size.height
#define kMainWindow              [UIApplication sharedApplication].keyWindow
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define CUSTOM_FONT(float) [UIFont systemFontOfSize:float]

/// 边距
#define kMargin                   5
//默认背景色
#define kBubbleViewColor          COLOR(253, 240, 209, 1)
//默认边框颜色
#define kBorderColor              COLOR(132, 104, 67, 1)
//默认圆角
#define kBubbleViewCornerRadius   7
//默认三角形高
#define kBubbleViewTriangleH      10
//默认三角形底边长
#define kBubbleViewTriangleW      10
// 箭头方向
typedef NS_ENUM(NSInteger, PGDirectionType) {
    PGDirectionType_Down, // 默认向下
    PGDirectionType_Up // 向上
};

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

typedef void (^ClickBlock) (UIButton * _Nullable button);

NS_ASSUME_NONNULL_BEGIN

@interface PGBubble : UIView

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

@end

NS_ASSUME_NONNULL_END
