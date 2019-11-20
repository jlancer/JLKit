//
//  NSString+Addition_JL.h
//  JLKit-OC
//
//  Created by wangjian on 2019/10/28.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Typeset/Typeset.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JLTrimType) {
    JLTrimTypeNone,                     // 不去除空格
    JLTrimTypeDefault,                  // 默认（去除两端的空格）
    JLTrimTypeWhiteSpace,               // 去除两端的空格
    JLTrimTypeWhiteSpaneAndNewline,     // 去除两端的空格和回车
    JLTrimTypeAllSpace                  // 去除所有的空格
};

typedef NS_ENUM(NSInteger, JLCompareResult) {
    JLCompareResultEqual,   // 相等
    JLCompareResultLarger,  // 左边比右边大
    JLCompareResultSmaller  // 左边比右边小
};

@interface NSString (Addition_JL)

#pragma mark - 校验、比较、转换

/**
 *  去除空格字符
 */
- (NSString *)jl_trim:(JLTrimType)trimType;

/**
 *  是否包含相同的字符串（大小写敏感）
 */
- (BOOL)jl_containsStringMatchCase:(NSString *)aString;

/**
 *  是否包含相同的字符串（大小写不敏感）
 */
- (BOOL)jl_containsStringIgnoreCase:(NSString *)aString;

/**
 *  是否包含Emoji
 */
- (BOOL)jl_containsEmoji;

/**
 *  字符串是否相同（空格去除可控，大小写敏感）
 */
- (BOOL)jl_isEqual:(NSString *)aString trimType:(JLTrimType)trimType;

/**
 *  字符串是否相同（空格不可去除，大小写敏感可控）
 */
- (BOOL)jl_isEqual:(NSString *)aString ignoreCase:(BOOL)ignoreCase;

/**
 *  字符串是否相同（空格去除可控，大小写敏感可控）
 */
- (BOOL)jl_isEqual:(NSString *)aString trimType:(JLTrimType)trimType ignoreCase:(BOOL)ignoreCase;

/**
 *  去除所有空格，是否为空
 */
- (BOOL)jl_isEmptyByTrimmingAllSpace;

/**
 *  截取两段字符串之间的子字符串
 */
- (NSString *)jl_substringFromSting:(NSString *)fromString toString:(NSString *)toString;

/**
 *  获取字符串Byte数（汉字2byte，英文1byte）
 */
- (NSUInteger)jl_bytesLenght;

/**
 *  首字母是否是英文字母
 */
- (BOOL)jl_isTopCharacterLetter;

/**
 *  首字母是否小写
 */
- (BOOL)jl_isTopLowerCaseAlphabetic;

/**
 *  首字母是否大写
 */
- (BOOL)jl_isTopUpperCaseAlphabetic;

/**
 *  用户比较APP版本大小
 */
+ (JLCompareResult)jl_compare:(NSString *)left than:(NSString *)right;

/**
 *  验证Text的长度（中文字符为两个英文字符长度）
 */
- (BOOL)jl_validTextLength:(NSInteger)limited;

/**
 *  中国固定电话
 */
- (BOOL)jl_validChineseLandLine;

/**
 *  中国手机号码
 */
- (BOOL)jl_validChineseMobile;

/**
 *  邮件合法性校验
 */
- (BOOL)jl_validEmail;

/**
 *  用户名合法性校验,允许输入[X,Y]位字母、数字、下划线的组合
 */
- (BOOL)jl_validUserName:(NSUInteger)shortest longest:(NSUInteger)longest enableUnderLine:(BOOL)enableUnderLine enableNumber:(BOOL)enableNumber initialAlphabetic:(BOOL)initialAlphabetic;

/**
 *  两次密码的合法性校验
 */
- (BOOL)jl_validPwd:(NSString *)pwd another:(NSString *)anotherPwd;

/**
 *  判断全汉字
 */
- (BOOL)jl_isChinese;

/**
 *  判断全数字（正整数和小数）
 */
- (BOOL)jl_isNumeric;

/**
 *  判断全字母
 */
- (BOOL)jl_isAlphabetic;

/**
 *  判断仅输入字母或数字
 */
- (BOOL)jl_isAlphabeticOrNumeric;

#pragma mark - 字符串尺寸、高度和宽度计算

/**
 *  获得字符串尺寸
 */
- (CGSize)jl_getSize:(CGSize)renderSize attributes:(NSDictionary *)attributes enableCeil:(BOOL)enableCeil;

/**
 *  计算字体渲染宽高（字体，行间距，字间距，换行模式）
 */
- (CGSize)jl_size:(UIFont *)font kern:(CGFloat)kern space:(CGFloat)space linebreakmode:(NSLineBreakMode)linebreakmode limitedlineHeight:(CGFloat)limitedlineHeight renderSize:(CGSize)renderSize;

/**
 *  计算字体渲染宽高（字体，行间距，字间距，换行模式等）
 */
- (CGSize)jl_size:(UIFont *)font kern:(CGFloat)kern space:(CGFloat)space linebreakmode:(NSLineBreakMode)linebreakmode maxLineHeight:(CGFloat)maxLineHeight minLineHeight:(CGFloat)minLineHeight textAlignment:(NSTextAlignment)textAlignment renderSize:(CGSize)renderSize;

/**
 *  计算限宽行高（字体，宽度）
 */
- (CGFloat)jl_height:(UIFont *)font withLabelWidth:(CGFloat)width enableCeil:(BOOL)enableCeil;

/**
 *  计算单行宽度（字体）
 */
- (CGFloat)jl_width:(UIFont *)font enableCeil:(BOOL)enableCeil;

/**
 *  计算单行行高（字体）
 */
- (CGFloat)jl_height:(UIFont *)font enableCeil:(BOOL)enableCeil;

/**
 *  限制显示行数
 */
- (CGFloat)jl_height:(UIFont *)font maxLineCount:(int)maxLineCount limitedlineHeight:(CGFloat)limitedlineHeight kern:(CGFloat)kern labelWidth:(CGFloat)labelWidth enableCeil:(BOOL)enableCeil;

/**
 *  限制显示行数（Deprecated）
 */
- (CGFloat)jl_heightWithFont:(UIFont*)font maxLine:(int)lineCount lineHeight:(CGFloat)lineHeight kern:(CGFloat)kern maxWidth:(CGFloat)maxWidth;

/**
 *  根据字间距计算（Deprecated）
 */
- (CGSize)jl_sizeWithKern:(CGFloat)kern font:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 *  根据行高计算（Deprecated）
 */
- (CGSize)jl_sizeWithFont:(UIFont*)font lineHeight:(CGFloat)lineHeight kern:(CGFloat)kern maxWidth:(CGFloat)maxWidth;

/**
 *  根据字体算尺寸（Deprecated）
 */
- (CGSize)jl_sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

#pragma mark - NSAttributedString

/**
 *  数字高亮，输出NSAttributedString
 */
- (NSAttributedString *)jl_numberHighlighted:(UIFont *)font color:(UIColor *)color;

/**
 *  字符串数组高亮，输出NSAttributedString
 */
- (NSAttributedString *)jl_charatersHighlighted:(NSArray *)characters font:(UIFont *)font color:(UIColor *)color;

/**
 *  数字高亮，输出TypesetKit
 */
- (TypesetKit *)jl_numberHighlightedTypeset:(UIFont *)font color:(UIColor *)color;

/**
 *  字符串数组高亮，输出TypesetKit
 */
- (TypesetKit *)jl_charatersHighlightedTypeset:(NSArray *)characters font:(UIFont *)font color:(UIColor *)color;

#pragma mark - NSURL, NSURLRequest

/**
 *  NSString转NSURL
 */
- (NSURL *)jlNSURL;

/**
 *  NSString转NSURLRequest
 */
- (NSURLRequest *)jlNSURLRequest;

#pragma mark - JSON字符串处理
/**
 *  JSON字符串转NSDictionary或NSArray
 */
- (id)jl_jsonToCocoaObject;

@end

NS_ASSUME_NONNULL_END
