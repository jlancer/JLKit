

//
//  JLToastView.m
//  JLKit
//
//  Created by wangjian on 2019/11/5.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "JLToastView.h"
#import "Typeset.h"
#import "UIView+Addition_JL.h"
#import "NSString+Addition_JL.h"
#import "NSAttributedString+Addition_JL.h"
#import "NSString+Image_JL.h"
#import "JLStorage.h"

static CGFloat kLeftMargin = 20.0;
static CGFloat kRightMargin = 20.0;

@interface JLToastView()

@property (nonatomic, weak) IBOutlet UILabel            *lb_message;              // message text
@property (nonatomic, weak) IBOutlet UIImageView        *iv_messageImage;         // message icon
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *const_w_icon;            // icon的宽度
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *const_h_icon;            // icon的高度
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *const_h_message;         // message的高度

@end

@implementation JLToastView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self layoutIfNeeded];
    [self jl_cornerRadius:8.0];
    self.iv_messageImage.contentMode = UIViewContentModeScaleAspectFill;
    self.lb_message.font = [UIFont systemFontOfSize:14.0];
}

+ (JLToastView *)jl_createHUD:(JLToastImageType)type message:(NSString *)message attributedMessage:(NSAttributedString *)attributedMessage image:(UIImage *)image backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius {
    
    JLToastView *alertView = [[[JLStorage podBundle:[self class]] loadNibNamed:@"JLToastView" owner:nil options:nil] lastObject];
    if (backgroundColor != nil) {
        alertView.backgroundColor = backgroundColor;
    }
    // 设置icon image相关
    UIImage *toastImage = nil;
    switch (type) {
        case JLToastImageTypeOK:
        {
            toastImage = @"JLToastView.ic_ok".jl_image;
            break;
        }
        case JLToastImageTypeWarning:
        {
            toastImage = @"JLToastView.ic_warning".jl_image;
            break;
        }
        case JLToastImageTypeError:
        {
            toastImage = @"JLToastView.ic_error".jl_image;
            break;
        }
        case JLToastImageTypeCustom:
        {
            toastImage = image;
            break;
        }
        case JLToastImageTypeNone:
        default:
            toastImage = nil;
            break;
    }
    CGSize imgSize = toastImage ? toastImage.size : CGSizeMake(0, 0);
    if (toastImage) {
        alertView.iv_messageImage.hidden = NO;
        alertView.iv_messageImage.image = toastImage;
        // 设置image icon的宽高约束
        alertView.const_w_icon.constant = imgSize.width;
        alertView.const_h_icon.constant = imgSize.height;
    }else{
        alertView.iv_messageImage.hidden = YES;
    }
    CGSize txtSize = CGSizeZero;
    if ([attributedMessage length] > 0) {
        alertView.lb_message.attributedText = attributedMessage;
        /* DEPRECATED
        UIFont *font = (UIFont *)[attributedMessage attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
        NSNumber *kern = [attributedMessage attribute:NSKernAttributeName atIndex:0 effectiveRange:nil];
        NSParagraphStyle *style = [attributedMessage attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil];
        CGFloat lineSpace = style.lineSpacing;
        NSLineBreakMode lineBreakMode = style.lineBreakMode;
        CGFloat maxH = style.maximumLineHeight;
        CGFloat minH = style.minimumLineHeight;
        NSTextAlignment textAlignment = style.alignment;
        */
        txtSize = [attributedMessage jl_getSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - kLeftMargin - kRightMargin - 16.0 - 4.0, MAXFLOAT) enableCeil:YES];
        
    }else{
        // 默认的字体和颜色
        alertView.lb_message.attributedText = message.typeset.kern(1).string;
        txtSize = [message jl_size:[UIFont systemFontOfSize:14.0] kern:1.0 space:0 linebreakmode:NSLineBreakByWordWrapping limitedlineHeight:0 renderSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - kLeftMargin - kRightMargin - 16.0 - 4.0, MAXFLOAT)];
    }
    // 设置AlertPointView的frame宽和高
    CGFloat w = 0.0 ,h = 0.0;
    // 字的宽度+16.0两边留间隙, [4.0]由于数字产生的旷量
    w = txtSize.width > imgSize.width ? (txtSize.width + 16.0 + 4.0) : (imgSize.width + 16.0 + 4.0) ;
    alertView.const_h_message.constant = txtSize.height + 4.0;  // 文字的高度 + 况量
    h += 31.0 + imgSize.height + txtSize.height + 4.0;          // 31.0是除去图片和文字的固定高度 + 图片的高度 + 文字的高度 + 况量
    alertView.frame = CGRectMake(0, 0, w, h);
    return alertView;
}

- (void)jl_dismiss{
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.22 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.22 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            weakSelf.alpha = 0.0;
        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
        }];
    }];
}

@end
