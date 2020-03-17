//
//  PGBubble.m
//  Bubble
//
//  Created by 陈鹏 on 2019/11/18.
//  Copyright © 2019 penggege.CP. All rights reserved.
//  请务 删除
//  作者github地址： https://github.com/penghero/PGBubble
#import "PGBubble.h"
#import "UIView+MGExtension.h"

/// 默认行间距
 #define UILABEL_LINE_SPACE 0

@interface PGBubble()

/// 整体View高 用于自适应箭头显示方向 暂没有做自适应 后期添加 目前只是用于更新View
@property (nonatomic, assign) CGFloat contentViewH;

/// 区分dect调用调用
@property (nonatomic, assign) BOOL isPGG;

/// 下列用于临时存前一次计算正确的数值
@property (nonatomic, assign) CGFloat beforeNum;
@property (nonatomic, copy) NSString *beforeStr;

@property (nonatomic, assign) CGFloat beforeNum2;
@property (nonatomic, copy) NSString *beforeStr2;

@property (nonatomic, strong) UIImageView *descImgPadding;

@property (nonatomic, strong) UIView *redSign;

/// 自动计算上下尖头
@property (nonatomic) CGFloat top_H;

@end


@implementation PGBubble

/// 初始化的时候 高度可以随意给 宽度给定就好
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubView];
    }
    return self;
}

///
- (void) addSubView {
    self.backgroundColor = [UIColor clearColor];

    [self addSubview:self.contentView];
    [self.contentView addSubview:self.topTitle];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.scheduleBtn];
    [self.contentView addSubview:self.receiveBtn];
    [self.contentView addSubview:self.descImgPadding];
    [self.contentView addSubview:self.descImg];
    [self.receiveBtn addSubview:self.redSign];
    [self.contentView addSubview:self.upgradeBtn];
    self.isPGG = NO;
    self.top_H = 0;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)]];
}


///
- (void) configData {
    
    self.isAnimation    = self.isAnimation ? self.isAnimation : NO;
    self.color          = self.color ? self.color : kBubbleViewColor;
    self.cornerRadius   = self.cornerRadius > 0 ? self.cornerRadius : kBubbleViewCornerRadius;
    self.triangleH      = self.triangleH > 0 ? self.triangleH : kBubbleViewTriangleH;
    self.triangleW      = self.triangleW > 0 ? self.triangleW : kBubbleViewTriangleW;
    self.borderColor    = self.borderColor ? self.borderColor : kBorderColor;
    self.isClick        = self.isClick ? self.isClick : NO;
    self.isUpgrade      = self.isUpgrade ? self.isUpgrade : NO;
    self.isShowRedSign  = NO ;
    
    self.isSettingColorForReceive = self.isSettingColorForReceive ? self.isSettingColorForReceive : NO;
    self.isSettingColorForUpgrade = self.isSettingColorForUpgrade ? self.isSettingColorForUpgrade : NO;
    self.bubbleTpye     = self.bubbleTpye ? self.bubbleTpye : PGBubbleType_Default;
    if (self.triangleXY < 1) {
        if (self.triangleXYScale == 0) {
            self.triangleXYScale = 0.5;
        }
        self.triangleXY = self.triangleXYScale * self.frame.size.width;
    }
    
    if (self.isClick) {
        
        if (self.isSettingColorForReceive) {
            [self.receiveBtn setUserInteractionEnabled:YES];
        } else {
            [self.receiveBtn setUserInteractionEnabled:YES];
            self.receiveBtn.backgroundColor = COLOR(255, 188, 85, 1);
            [self.receiveBtn setTitleColor:COLOR(81, 50, 21, 1) forState:UIControlStateNormal];
        }

    } else {
        [self.receiveBtn setUserInteractionEnabled:NO];
        self.receiveBtn.backgroundColor = COLOR(160, 160, 160, 1);
        [self.receiveBtn setTitleColor:COLOR(69, 69, 69, 1) forState:UIControlStateNormal];
    }
    
    
    if (self.isUpgrade) {
        /// 已升级
        self.upgradeBtn.userInteractionEnabled = NO;
        self.upgradeBtn.titleLabel.font = CUSTOM_FONT(Point414(12));
        self.upgradeBtn.backgroundColor = UIColor.clearColor;
        [self.upgradeBtn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        [self.upgradeBtn setTitle:@"已升级" forState:UIControlStateNormal];

    } else {
        [self.upgradeBtn setTitle:@"升级" forState:UIControlStateNormal];
        [self.upgradeBtn setUserInteractionEnabled:YES];

        if (self.isSettingColorForUpgrade) {
            self.upgradeBtn.backgroundColor = COLOR(160, 160, 160, 1);
            [self.upgradeBtn setTitleColor:COLOR(81, 50, 21, 1) forState:UIControlStateNormal];
        } else {
            self.upgradeBtn.backgroundColor = COLOR(255, 188, 85, 1);
            [self.upgradeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        }
    }
    
    
    if (self.isShowRedSign) {
        self.redSign.hidden = NO;
    } else {
        self.redSign.hidden = YES;
    }
    
    /// 根据类型进行相应布局
    if (self.bubbleTpye == PGBubbleType_Default) {
        self.topTitle.hidden    = NO;
        self.descLabel.hidden   = NO;
        self.scheduleBtn.hidden = NO;
        self.receiveBtn.hidden  = NO;
        
        CGFloat topW            = self.contentView.width - kMargin*2;
        NSString *topTitle      = [self.topTitle.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        CGFloat topH            = [self getSpaceLabelHeight2:topTitle withFont:CUSTOM_FONT(Point414(10)) withWidth:topW];
        self.topTitle.frame     = CGRectMake(kMargin, kMargin*3, topW, topH);

        if (topH > kMargin*2.5) {
            self.topTitle.textAlignment = NSTextAlignmentLeft;
        } else {
            self.topTitle.textAlignment = NSTextAlignmentCenter;
        }
        
        CGFloat scheH           = kMargin*5 + self.topTitle.height;
        self.scheduleBtn.frame  = CGRectMake(kMargin/2, scheH, self.contentView.width-kMargin, Point414(18));
        
        CGFloat descTopH        = kMargin*6 + self.topTitle.height + self.scheduleBtn.height;
        CGFloat descW           = self.contentView.width - kMargin*2;
        NSString *descLabel     = [self.descLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        CGFloat descH           = [self getSpaceLabelHeight:descLabel withFont:CUSTOM_FONT(Point414(10)) withWidth:descW];
        
        self.descLabel.frame    = CGRectMake(kMargin, descTopH, descW,  descH); //(ceilf(descH)+1)
        if (descH > kMargin*3) {
            self.descLabel.textAlignment = NSTextAlignmentLeft;
        } else {
            self.descLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        CGFloat recTopH         = descTopH + descH + kMargin;
        CGFloat recW            = self.contentView.width - kMargin*2;
        self.receiveBtn.frame   = CGRectMake(kMargin, recTopH, recW, kMargin*6);
       
        self.redSign.frame      = CGRectMake( recW - 15, Point414(3) , Point414(6), Point414(6));
        
        /// 计算完所有view之后 此时对contentView的高进行赋值
        self.contentViewH = recTopH + self.receiveBtn.height +kMargin*4;
        
    } else if (self.bubbleTpye == PGBubbleType_Text){
        self.descLabel.hidden = NO;
        CGFloat descTopH        = kMargin *3 ;
        CGFloat descW           = self.contentView.width - kMargin*2;
        NSString *descLabel     = [self.descLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        CGFloat descH           = [self getSpaceLabelHeight:descLabel withFont:CUSTOM_FONT(Point414(10)) withWidth:descW];
        self.descLabel.frame    = CGRectMake(kMargin, descTopH, descW,descH);//(ceilf(descH)+1)
        if (descH > kMargin*3) {
            self.descLabel.textAlignment = NSTextAlignmentLeft;
        } else {
            self.descLabel.textAlignment = NSTextAlignmentCenter;
        }
        self.contentViewH = descTopH + self.descLabel.height +kMargin*6;
        
    } else if (self.bubbleTpye == PGBubbleType_Custom1){
        self.scheduleBtn.hidden = NO;
        self.descLabel.hidden   = NO;
        CGFloat scheW           = self.contentView.width - kMargin;
        self.scheduleBtn.frame = CGRectMake(kMargin/2, kMargin/2, scheW, Point414(18));
        
        CGFloat descTopH        = kMargin*2 + self.scheduleBtn.height ;
        CGFloat descW           = self.contentView.width - kMargin*2;
        NSString *descLabel     = [self.descLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        CGFloat descH           = [self getSpaceLabelHeight:descLabel withFont:CUSTOM_FONT(Point414(10)) withWidth:descW];
        
        self.descLabel.frame    = CGRectMake(kMargin, descTopH, descW,descH); //(ceilf(descH)+1)
        if (descH > kMargin*3) {
            self.descLabel.textAlignment = NSTextAlignmentLeft;
        } else {
            self.descLabel.textAlignment = NSTextAlignmentCenter;
        }

        self.contentViewH = self.scheduleBtn.height + self.descLabel.height +kMargin*7;
        
    } else if (self.bubbleTpye == PGBubbleType_Custom2){
        self.scheduleBtn.hidden = NO;
        self.descLabel.hidden   = NO;
        self.receiveBtn.hidden  = NO;
        CGFloat scheW           = self.contentView.width - kMargin;
        self.scheduleBtn.frame = CGRectMake(kMargin/2, kMargin/2, scheW, Point414(18));
        
        CGFloat descTopH        = kMargin*2 + self.scheduleBtn.height ;
        CGFloat descW           = self.contentView.width - kMargin*2;
        NSString *descLabel     = [self.descLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        CGFloat descH           = [self getSpaceLabelHeight:descLabel withFont:CUSTOM_FONT(Point414(10)) withWidth:descW];
        self.descLabel.frame    = CGRectMake(kMargin, descTopH, descW,descH);//(ceilf(descH)+1)
        if (descH > kMargin*3) {
            self.descLabel.textAlignment = NSTextAlignmentLeft;
        } else {
            self.descLabel.textAlignment = NSTextAlignmentCenter;
        }

        CGFloat recTopH         = descTopH + descH + kMargin*2;
        CGFloat recW            = self.contentView.width - kMargin*2;
        self.receiveBtn.frame   = CGRectMake(kMargin, recTopH, recW, kMargin*6);
        
        self.contentViewH = self.scheduleBtn.height + self.descLabel.height +self.receiveBtn.height + kMargin*8;

    } else if (self.bubbleTpye == PGBubbleType_Custom3) {
        
    } else if (self.bubbleTpye == PGBubbleType_Custom4) {
        self.scheduleBtn.hidden = NO;
        self.descLabel.hidden   = NO;
        self.descImg.hidden     = NO;
        self.descImgPadding.hidden = NO;
        CGFloat scheW           = self.contentView.width - kMargin;
        self.scheduleBtn.frame = CGRectMake(kMargin/2, kMargin/2, scheW, Point414(18));
        
        CGFloat descTopH        = kMargin*3 + self.scheduleBtn.height ;
        CGFloat descW           = self.contentView.width - kMargin*2;
        NSString *descLabel     = [self.descLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        CGFloat descH           = [self getSpaceLabelHeight:descLabel withFont:CUSTOM_FONT(Point414(10)) withWidth:descW];
        self.descLabel.frame    = CGRectMake(kMargin, descTopH, descW,descH);//(ceilf(descH)+1)
        if (descH > kMargin*3) {
            self.descLabel.textAlignment = NSTextAlignmentLeft;
        } else {
            self.descLabel.textAlignment = NSTextAlignmentCenter;
        }

        CGFloat descImgH        = self.scheduleBtn.height + self.descLabel.height +kMargin*5;
        
        self.descImgPadding.frame = CGRectMake((self.contentView.width-Point414(50))/2, descImgH, Point414(50), Point414(50));
        CGFloat descImgW        = Point414(50)/4.0*3;
        self.descImg.center     = self.descImgPadding.center;
        self.descImg.size       = CGSizeMake(descImgW, descImgW);
        self.contentViewH       = self.scheduleBtn.height + self.descLabel.height + self.descImgPadding.height + kMargin*12;

    } else if (self.bubbleTpye == PGBubbleType_Custom5) {
        self.scheduleBtn.hidden = NO;
        self.descLabel.hidden   = NO;
        self.upgradeBtn.hidden  = NO;
        self.receiveBtn.hidden  = NO;
        CGFloat scheW           = self.contentView.width - kMargin;
        self.scheduleBtn.frame = CGRectMake(kMargin/2, kMargin/2, scheW, Point414(18));
        
        CGFloat descTopH        = kMargin*2 + self.scheduleBtn.height ;
        CGFloat descW           = self.contentView.width - kMargin*2;
        NSString *descLabel     = [self.descLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        CGFloat descH           = [self getSpaceLabelHeight:descLabel withFont:CUSTOM_FONT(Point414(10)) withWidth:descW];
        self.descLabel.frame    = CGRectMake(kMargin, descTopH, descW,descH);//(ceilf(descH)+1)
        if (descH > kMargin*3) {
            self.descLabel.textAlignment = NSTextAlignmentLeft;
        } else {
            self.descLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        if (self.isUpgrade) {
            CGFloat upgradeTopH         = descTopH + descH + kMargin;
            CGFloat upgradeW            = self.contentView.width - kMargin*2;
            self.upgradeBtn.frame   = CGRectMake(kMargin, upgradeTopH, upgradeW, kMargin*6);
            
            CGFloat recTopH         = descTopH + descH + upgradeTopH - kMargin*3;
            CGFloat recW            = self.contentView.width - kMargin*2;
            self.receiveBtn.frame   = CGRectMake(kMargin, recTopH, recW, kMargin*6);
            
            self.contentViewH = self.scheduleBtn.height + self.descLabel.height + self.upgradeBtn.height + self.receiveBtn.height + kMargin*8;

        } else {
            CGFloat upgradeTopH         = descTopH + descH + kMargin*2;
            CGFloat upgradeW            = self.contentView.width - kMargin*2;
            self.upgradeBtn.frame   = CGRectMake(kMargin, upgradeTopH, upgradeW, kMargin*6);
            
            CGFloat recTopH         = descTopH + descH + upgradeTopH ;
            CGFloat recW            = self.contentView.width - kMargin*2;
            self.receiveBtn.frame   = CGRectMake(kMargin, recTopH, recW, kMargin*6);
            
            self.contentViewH = self.scheduleBtn.height + self.descLabel.height + self.upgradeBtn.height + self.receiveBtn.height + kMargin*10;

        }
        
    } else if (self.bubbleTpye == PGBubbleType_Other ){
        self.contentView.hidden = NO;
        self.contentViewH       = self.contentView.height + Point414(3) + self.triangleH;
    }

    /// 自动判断上下边距 改变方向
    if (self.top_H < (self.contentViewH+10)) {
        self.direction = PGDirectionType_Up;
    }

    if ((SCREEN_H-self.top_H) < (self.contentViewH+10)) {
        self.direction = PGDirectionType_Down;
    }
    
    [self show];
}

///
- (void)drawRect:(CGRect)rect {
    
    self.isPGG = NO;
        //默认数据配置
    [self configData];
        
    CGMutablePathRef path = CGPathCreateMutable();
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    rect.origin.x = rect.origin.x + self.borderWidth;
    rect.origin.y = rect.origin.y + self.borderWidth;
    rect.size.width = rect.size.width - 2*self.borderWidth;
    
    rect.size.height = self.contentViewH;
    rect.size.height = rect.size.height - 2*self.borderWidth;
    
    switch (self.direction) {
        case PGDirectionType_Down:
        {
        CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + self.cornerRadius);
        CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - self.triangleH - self.cornerRadius);
        CGPathAddArc(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y + rect.size.height - self.triangleH - self.cornerRadius,
                     self.cornerRadius, M_PI, M_PI / 2, 1);
        CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY - self.triangleW/2,
                             rect.origin.y + rect.size.height - self.triangleH);
        CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY,
                             rect.origin.y + rect.size.height);
        CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY + self.triangleW/2,
                             rect.origin.y + rect.size.height - self.triangleH);
        CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius,
                             rect.origin.y + rect.size.height - self.triangleH);
        CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius,
                     rect.origin.y + rect.size.height - self.triangleH - self.cornerRadius, self.cornerRadius, M_PI / 2, 0.0f, 1);
        CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + self.cornerRadius);
        CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius, rect.origin.y + self.cornerRadius,
                     self.cornerRadius, 0.0f, -M_PI / 2, 1);
        CGPathAddLineToPoint(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y);
        CGPathAddArc(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y + self.cornerRadius, self.cornerRadius,
                     -M_PI / 2, M_PI, 1);
        }
            break;
        case PGDirectionType_Up:
        {
        CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + self.cornerRadius + self.triangleH);
        CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - self.cornerRadius);
        CGPathAddArc(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y + rect.size.height - self.cornerRadius,
                     self.cornerRadius, M_PI, M_PI / 2, 1);
        CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius,
                             rect.origin.y + rect.size.height);
        CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius,
                     rect.origin.y + rect.size.height - self.cornerRadius, self.cornerRadius, M_PI / 2, 0.0f, 1);
        CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + self.triangleH + self.cornerRadius);
        CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius, rect.origin.y + self.triangleH + self.cornerRadius,
                     self.cornerRadius, 0.0f, -M_PI / 2, 1);
        CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY + self.triangleW/2,
                             rect.origin.y + self.triangleH);
        CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY,
                             rect.origin.y);
        CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY - self.triangleW/2,
                             rect.origin.y + self.triangleH);
        CGPathAddLineToPoint(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y + self.triangleH);
        CGPathAddArc(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y + self.triangleH + self.cornerRadius, self.cornerRadius,
                     -M_PI / 2, M_PI, 1);
        
        }
            break;
        default:
            break;
    }
    CGPathCloseSubpath(path);
    //填充气泡
    [self.color setFill];
    CGContextAddPath(context, path);
    CGContextSaveGState(context);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    // 边缘线
    if (self.borderColor && self.borderWidth > 0) {
        [self.borderColor setStroke];
        CGContextSetLineWidth(context, self.borderWidth);
        CGContextSetLineCap(context, kCGLineCapSquare);
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
    }
    CGPathRelease(path);
    CGColorSpaceRelease(space);
}

///
-(void)showWithView:(UIView *)view {
    CGRect absoluteRect = [view convertRect:view.bounds toView:kMainWindow];
    CGPoint relyPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
    
    self.isPGG = YES;
    self.top_H = relyPoint.y;
    
    //默认数据配置
    [self configData];
    //contentView与self的边距
    CGFloat padding = self.cornerRadius - self.cornerRadius/M_SQRT2 + self.borderWidth;
    switch (self.direction) {
        case PGDirectionType_Down:
        {
            self.frame = CGRectMake(relyPoint.x - self.triangleXY, relyPoint.y - self.contentViewH - view.height , self.frame.size.width, self.contentViewH);//self.frame.size.height -> self.contentViewH
            self.contentView.frame = CGRectMake(padding, padding, self.frame.size.width - 2 * padding, self.contentViewH - 2 * padding - self.triangleH);
        
        }
            break;
        case PGDirectionType_Up:
        {
            self.frame = CGRectMake(relyPoint.x - self.triangleXY, relyPoint.y, self.frame.size.width, self.contentViewH);
            self.contentView.frame = CGRectMake(padding, padding + self.triangleH, self.frame.size.width - 2 * padding, self.contentViewH - 2 * padding - self.triangleH);
        }
            break;
        default:
            break;
    }
    
}


- (void)show
{
    [kMainWindow addSubview:self];
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.95 options:UIViewAnimationOptionCurveLinear animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)dismiss
{
    if (self.isAnimation) {
        [self removeFromSuperview];
    } else {
        [UIView animateWithDuration: 0.25 animations:^{
            self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void) receiveAction: (UIButton *) btn {
    if (self.blockEvent != nil) {
        self.blockEvent(btn);
    }
}

- (void) upgradeBtnAction: (UIButton *) btn {
    if (self.blockEventOther != nil) {
        self.blockEventOther(btn);
    }
}


#pragma mark - 懒加载 基础配置

- (UIView *) contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.frame = self.frame;
    }
    return _contentView;
}

- (UILabel *) topTitle {
    if (!_topTitle) {
        _topTitle = [[UILabel alloc] init];
        _topTitle.textColor = COLOR(142, 117, 84, 1);
        _topTitle.font = CUSTOM_FONT(Point414(10));
        _topTitle.numberOfLines = 0;
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.hidden = YES;
    }
    return _topTitle;
}

- (UILabel *) descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = COLOR(142, 117, 84, 1);
        _descLabel.font = CUSTOM_FONT(Point414(10));
        _descLabel.hidden = YES;
        _descLabel.numberOfLines = 0;
        _descLabel.textAlignment = NSTextAlignmentCenter;

    }
    return _descLabel;
}

- (UIButton *) scheduleBtn {
    if (!_scheduleBtn) {
        _scheduleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scheduleBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [_scheduleBtn setTitleColor:COLOR(81, 50, 21, 1) forState:UIControlStateNormal];
        _scheduleBtn.titleLabel.font = CUSTOM_FONT(Point414(12));
        [_scheduleBtn setUserInteractionEnabled:NO];
        _scheduleBtn.hidden = YES;
    }
    return _scheduleBtn;
}


- (UIButton *) receiveBtn {
    if (!_receiveBtn) {
        _receiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _receiveBtn.backgroundColor = COLOR(160, 160, 160, 1);
        _receiveBtn.titleLabel.font = CUSTOM_FONT(Point414(12));
        [_receiveBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _receiveBtn.layer.cornerRadius = Point414(7);
        _receiveBtn.layer.masksToBounds = YES;
        _receiveBtn.hidden = YES;
        [_receiveBtn addTarget:self action:@selector(receiveAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _receiveBtn;
}

- (UIButton *) upgradeBtn {
    if (!_upgradeBtn) {
        _upgradeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _upgradeBtn.backgroundColor = COLOR(255, 188, 85, 1);
        _upgradeBtn.titleLabel.font = CUSTOM_FONT(Point414(12));
        [_upgradeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _upgradeBtn.layer.cornerRadius = Point414(7);
        _upgradeBtn.layer.masksToBounds = YES;
        _upgradeBtn.hidden = YES;
        [_upgradeBtn addTarget:self action:@selector(upgradeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upgradeBtn;
}



- (UIImageView *) descImgPadding {
    if (!_descImgPadding) {
        _descImgPadding = [[UIImageView alloc] init];
        _descImgPadding.backgroundColor = COLOR(139, 114, 81, 1);
        _descImgPadding.hidden = YES;
        _descImgPadding.layer.cornerRadius = kBubbleViewCornerRadius;
        _descImgPadding.layer.masksToBounds = YES;
    }
    return _descImgPadding;
}


- (UIImageView *) descImg {
    if (!_descImg) {
        _descImg = [[UIImageView alloc] init];
        _descImg.backgroundColor = COLOR(139, 114, 81, 1);
        _descImg.hidden = YES;
//        _descImg.layer.cornerRadius = kBubbleViewCornerRadius;
//        _descImg.layer.masksToBounds = YES;
    }
    return _descImg;
}

- (UIView *)redSign {
    if (!_redSign) {
        _redSign = [[UIView alloc] init];
        _redSign.backgroundColor = [UIColor redColor];
        _redSign.layer.cornerRadius = Point414(3);
        _redSign.layer.masksToBounds = YES;
        _redSign.hidden = YES;
    }
    return _redSign;
}

#pragma mark - 私有方法 计算宽度
//计算高度(带有行间距)
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    
    if (!self.isPGG && ([self.beforeStr isEqualToString:str])) {
        return self.beforeNum;
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
};
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, SCREEN_H) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, SCREEN_H) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];

    //判断内容是否只有一行 : (目前高度 - 字体高度) <= 行间距
    if ((rect.size.height - font.lineHeight) <= paraStyle.lineSpacing){
    //如果只有一行，进行判断内容中是否全部为汉字
    if ([self containChinese:str]) {
    //修正后高度为： 目前高度 - 一个行间距
          rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paraStyle.lineSpacing);
        }
    }
    
    self.beforeNum = rect.size.height;
    self.beforeStr = str;
    
    return rect.size.height;
}

-(CGFloat)getSpaceLabelHeight2:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    
    if (!self.isPGG && ([self.beforeStr2 isEqualToString:str])) {
        return self.beforeNum2;
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
};
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, SCREEN_H) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, SCREEN_H) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];

    //判断内容是否只有一行 : (目前高度 - 字体高度) <= 行间距
    if ((rect.size.height - font.lineHeight) <= paraStyle.lineSpacing){
    //如果只有一行，进行判断内容中是否全部为汉字
    if ([self containChinese:str]) {
    //修正后高度为： 目前高度 - 一个行间距
          rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paraStyle.lineSpacing);
        }
    }
    
    self.beforeNum2 = rect.size.height;
    self.beforeStr2 = str;
    
    return rect.size.height;
}

//判断内容中是否全部为汉字
- (BOOL)containChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){ int a = [str characterAtIndex:i];
      if( a > 0x4e00 && a < 0x9fff){
          return YES;
      }
    }
    return NO;
}

static inline CGFloat Point414(CGFloat value) {
    return (value * SCREEN_W / 414.f);
}

@end
