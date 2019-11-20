//
//  NSString+Addition_JL.m
//  JLKit-OC
//
//  Created by wangjian on 2019/10/28.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "NSString+Addition_JL.h"

@implementation NSString (Addition_JL)

#pragma mark - 校验、比较、转换

/**
 *  去除空格字符
 */
- (NSString *)jl_trim:(JLTrimType)trimType {
    
    NSString *newStr = nil;
    switch (trimType) {
        case JLTrimTypeDefault:
        case JLTrimTypeWhiteSpace: {
            newStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
            break;
        case JLTrimTypeWhiteSpaneAndNewline: {
            newStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
            break;
        case JLTrimTypeAllSpace: {
            newStr = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
            break;
        case JLTrimTypeNone:
        default:
        {
            return self;
        }
            break;
    }
    return newStr;
}

/**
 *  是否包含相同的字符串（大小写敏感）
 */
- (BOOL)jl_containsStringMatchCase:(NSString *)aString {
    
    NSRange range = [self rangeOfString:aString];
    return (range.length > 0);
}

/**
 *  是否包含相同的字符串（大小写不敏感）
 */
- (BOOL)jl_containsStringIgnoreCase:(NSString *)aString {
    
    NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
    return (range.length > 0);
}

/**
 *  是否包含Emoji
 */
- (BOOL)jl_containsEmoji {
    
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar hs = [substring characterAtIndex:0];
                              if (0xd800 <= hs && hs <= 0xdbff) {
                                  if (substring.length > 1) {
                                      const unichar ls = [substring characterAtIndex:1];
                                      const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                      if (0x1d000 <= uc && uc <= 0x1f77f) {
                                          returnValue = YES;
                                      }
                                  }
                              } else if (substring.length > 1) {
                                  const unichar ls = [substring characterAtIndex:1];
                                  if (ls == 0x20e3) {
                                      returnValue = YES;
                                  }
                              } else {
                                  if (0x2100 <= hs && hs <= 0x27ff) {
                                      returnValue = YES;
                                  } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                      returnValue = YES;
                                  } else if (0x2934 <= hs && hs <= 0x2935) {
                                      returnValue = YES;
                                  } else if (0x3297 <= hs && hs <= 0x3299) {
                                      returnValue = YES;
                                  } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                      returnValue = YES;
                                  }
                              }
                          }];
    return returnValue;
}

/**
 *  字符串是否相同（空格去除可控，大小写敏感）
 */
- (BOOL)jl_isEqual:(NSString *)aString trimType:(JLTrimType)trimType {
    
    return [self jl_isEqual:aString trimType:trimType ignoreCase:NO];
}

/**
 *  字符串是否相同（空格不可去除，大小写敏感可控）
 */
- (BOOL)jl_isEqual:(NSString *)aString ignoreCase:(BOOL)ignoreCase {
    
    return [self jl_isEqual:aString trimType:JLTrimTypeNone ignoreCase:ignoreCase];
}

/**
 *  字符串是否相同（空格去除可控，大小写敏感可控）
 */
- (BOOL)jl_isEqual:(NSString *)aString trimType:(JLTrimType)trimType ignoreCase:(BOOL)ignoreCase {
    
    NSString *strSelf = [self jl_trim:trimType];
    NSString *strCompare = [aString jl_trim:trimType];
    if (ignoreCase) {
        return ([strSelf caseInsensitiveCompare:strCompare] == NSOrderedSame);
    }else{
        return [strSelf isEqualToString:strCompare];
    }
}

/**
 *  去除所有空格，是否为空
 */
- (BOOL)jl_isEmptyByTrimmingAllSpace {
    
    NSString *string = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string == nil || string.length == 0;
}

/**
 *  截取两段字符串之间的子字符串
 */
- (NSString *)jl_substringFromSting:(NSString *)fromString toString:(NSString *)toString {
    
    NSRange startRange = [self rangeOfString:fromString];
    NSRange endRange = [self rangeOfString:toString];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    return [self substringWithRange:range];
}

/**
 *  获取字符串Byte数（汉字2byte，英文1byte）
 */
- (NSUInteger)jl_bytesLenght {
    
    int lenght = 0;
    for(int i=0; i< [self length]; i++) {
        int c = [self characterAtIndex:i];
        if( c > 0x4e00 && c < 0x9fff) {
            // 中文
            lenght += 2;
        }else {
            lenght += 1;
        }
    }
    return lenght;
}

/**
 *  首字母是否是英文字母
 */
- (BOOL)jl_isTopCharacterLetter {
    
    if ([self jl_isTopLowerCaseAlphabetic] || [self jl_isTopUpperCaseAlphabetic]) {
        return YES;
    }
    return NO;
}

/**
 *  首字母是否小写
 */
- (BOOL)jl_isTopLowerCaseAlphabetic {
    
    if ([self characterAtIndex:0] >= 'a' && [self characterAtIndex:0] <= 'z') {
        return YES;
    }
    return NO;
}

/**
 *  首字母是否大写
 */
- (BOOL)jl_isTopUpperCaseAlphabetic {
    
    if ([self characterAtIndex:0] >= 'A' && [self characterAtIndex:0] <= 'Z') {
        return YES;
    }
    return NO;
}

/**
 *  用户比较APP版本大小
 */
+ (JLCompareResult)jl_compare:(NSString *)left than:(NSString *)right {
    
    if (left == nil && right == nil) {
        return JLCompareResultEqual;
    }else if (left == nil) {
        return JLCompareResultSmaller;
    }else if (right == nil) {
        return JLCompareResultLarger;
    }else if ([left isEqualToString:right]) {
        return JLCompareResultEqual;
    }else {
        NSArray *arr1 = [left componentsSeparatedByString:@"."];
        NSArray *arr2 = [right componentsSeparatedByString:@"."];
        int ret1 = 0;
        int ret2 = 0;
        if ([arr1 count] == [arr2 count]) {
            // 版本格式一致
            for (int i = 0; i < [arr1 count]; i++) {
                ret1 += ([arr1[i] intValue] * pow(10, ([arr1 count] - i)));
                ret2 += ([arr2[i] intValue] * pow(10, ([arr2 count] - i)));
            }
            
            if (ret1 == ret2) {
                return JLCompareResultEqual;
            }else if (ret1 < ret2) {
                return JLCompareResultSmaller;
            }else {
                return JLCompareResultLarger;
            }
        }else if ([arr1 count] < [arr2 count]) {
            // 版本格式深度前者小于后者
            for (int i = 0; i < [arr1 count]; i++) {
                ret1 += ([arr1[i] intValue] * pow(10, ([arr1 count] - i)));
                ret2 += ([arr2[i] intValue] * pow(10, ([arr1 count] - i)));
            }
            if (ret1 <= ret2) {
                return JLCompareResultSmaller;
            }else {
                return JLCompareResultLarger;
            }
            
        }else{
            // 版本格式深度前者大于后者
            for (int i = 0; i < [arr2 count]; i++) {
                ret1 += ([arr1[i] intValue] * pow(10, ([arr2 count] - i)));
                ret2 += ([arr2[i] intValue] * pow(10, ([arr2 count] - i)));
            }
            if (ret1 >= ret2) {
                return JLCompareResultLarger;
            }else {
                return JLCompareResultSmaller;
            }
        }
    }
    return JLCompareResultEqual;
}

/**
 *  验证Text的长度（中文字符为两个英文字符长度）
 */
- (BOOL)jl_validTextLength:(NSInteger)limited {
    
    NSUInteger  character = 0;
    BOOL containChinese = NO;
    for(int i=0; i< [self length];i++) {
        int a = [self characterAtIndex:i];
        if( a >= 0x4e00 && a <= 0x9fa5) {
            //判断是否为中文
            character +=2;
            containChinese = YES;
        }else {
            character +=1;
        }
    }
    if (containChinese) {
        if (character > 0 && character <= limited) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return YES;
    }
}

/**
 *  中国固定电话
 */
- (BOOL)jl_validChineseLandLine {
    
    NSString *regex = @"^((\\+86)|(\\(\\+86\\)))?\\W?((((010|021|022|023|024|025|026|027|028|029|852)|(\\(010\\)|\\(021\\)|\\(022\\)|\\(023\\)|\\(024\\)|\\(025\\)|\\(026\\)|\\(027\\)|\\(028\\)|\\(029\\)|\\(852\\)))\\W\\d{8}|((0[3-9][1-9]{2})|(\\(0[3-9][1-9]{2}\\)))\\W\\d{7,8}))(\\W\\d{1,4})?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (([phoneTest evaluateWithObject:self] == YES)) {
        return YES;
    }else{
        return NO;
    }
}

/**
 *  中国手机号码
 */
- (BOOL)jl_validChineseMobile {
    
    NSString *regex = @"^((\\+86)|(\\(\\+86\\)))?(((13[0-9]{1})|(15[0-9]{1})|(17[0-9]{1})|(18[0,5-9]{1}))+\\d{8})$";
    NSPredicate *mobileText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [mobileText evaluateWithObject:self];
}

/**
 *  邮件合法性校验
 */
- (BOOL)jl_validEmail {
    
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([emailTest evaluateWithObject:self] == YES) {
        return YES;
    }else {
        return NO;
    }
}

/**
 *  用户名合法性校验,允许输入[X,Y]位字母、数字、下划线的组合
 */
- (BOOL)jl_validUserName:(NSUInteger)shortest longest:(NSUInteger)longest enableUnderLine:(BOOL)enableUnderLine enableNumber:(BOOL)enableNumber initialAlphabetic:(BOOL)initialAlphabetic {
    
    NSMutableString *regex = [[NSMutableString alloc] init];
    if (initialAlphabetic) {
        [regex appendString:@"^(?!((^[0-9]+$)|(^[_]+$)))"];
    }
    if (enableNumber && enableUnderLine) {
        [regex appendFormat:@"([a-zA-Z0-9_]{%d,%d})$", (int)shortest, (int)longest];
    }else if (enableNumber) {
        [regex appendFormat:@"([a-zA-Z0-9]{%d,%d})$", (int)shortest, (int)longest];
    }else if (enableUnderLine) {
        [regex appendFormat:@"([a-zA-Z_]{%d,%d})$", (int)shortest, (int)longest];
    }else{
        [regex appendFormat:@"([a-zA-Z]{%d,%d})$", (int)shortest, (int)longest];
    }
    NSPredicate *usernameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [usernameTest evaluateWithObject:self];
}

/**
 *  两次密码的合法性校验
 */
- (BOOL)jl_validPwd:(NSString *)pwd another:(NSString *)anotherPwd {
    
    if (pwd == nil || pwd.length == 0 || anotherPwd == nil || anotherPwd.length == 0) {
        return NO;
    }
    return [pwd isEqualToString:anotherPwd];
}

/**
 *  判断全汉字
 */
- (BOOL)jl_isChinese {
    
    if (self.length == 0) return NO;
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}

/**
 *  判断全数字（正整数和小数）
 */
- (BOOL)jl_isNumeric {
    
    NSString *regex = @"^([1-9]\\d*|0)(\\.\\d{1,2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}

/**
 *  判断全字母
 */
- (BOOL)jl_isAlphabetic {
    
    if (self.length == 0) return NO;
    NSString *regex =@"[a-zA-Z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}

/**
 *  判断仅输入字母或数字
 */
- (BOOL)jl_isAlphabeticOrNumeric {
    
    if (self.length == 0) return NO;
    NSString *regex =@"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}

#pragma mark - 字符串尺寸、高度和宽度计算

/**
 *  获得字符串尺寸
 */
- (CGSize)jl_getSize:(CGSize)renderSize attributes:(NSDictionary *)attributes enableCeil:(BOOL)enableCeil {
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine;
    CGSize size = [self boundingRectWithSize:renderSize options:options attributes:attributes context:nil].size;
    if (enableCeil) {
        return CGSizeMake(ceilf(size.width), ceilf(size.height));
    }
    return size;
}

/**
 *  计算字体渲染宽高（字体，行间距，字间距，换行模式）
 */
- (CGSize)jl_size:(UIFont *)font kern:(CGFloat)kern space:(CGFloat)space linebreakmode:(NSLineBreakMode)linebreakmode limitedlineHeight:(CGFloat)limitedlineHeight renderSize:(CGSize)renderSize {
    
    return [self jl_size:font kern:kern space:space linebreakmode:linebreakmode maxLineHeight:limitedlineHeight minLineHeight:limitedlineHeight textAlignment:NSTextAlignmentLeft renderSize:renderSize];
}

/**
 *  计算字体渲染宽高（字体，行间距，字间距，换行模式等）
 */
- (CGSize)jl_size:(UIFont *)font kern:(CGFloat)kern space:(CGFloat)space linebreakmode:(NSLineBreakMode)linebreakmode maxLineHeight:(CGFloat)maxLineHeight minLineHeight:(CGFloat)minLineHeight textAlignment:(NSTextAlignment)textAlignment renderSize:(CGSize)renderSize {
    
    if (self.length == 0) {
        return CGSizeZero;
    } else if (font == nil || ![font isKindOfClass:[UIFont class]]) {
        return CGSizeZero;
    } else{
        // 字体
        NSMutableDictionary *attribute = [[NSMutableDictionary alloc] init];
        [attribute setObject:font forKey:NSFontAttributeName];
        // 行间距和换行模式
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        if (space > 0) {
            style.lineSpacing = space;
        }
        if (linebreakmode > 0) {
            style.lineBreakMode = linebreakmode;
        }
        if (minLineHeight > 0) {
            style.minimumLineHeight = minLineHeight;
        }
        if (maxLineHeight > 0) {
            style.maximumLineHeight = maxLineHeight;
        }
        style.alignment = textAlignment;
        [attribute setObject:style forKey:NSParagraphStyleAttributeName];
        // 字间距
        if (kern > 0) {
            [attribute setObject:@(kern) forKey:NSKernAttributeName];
        }
        // 尺寸
        CGSize size = [self boundingRectWithSize:renderSize
                                         options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil].size;
        return size;
    }
    return CGSizeZero;
}

/**
 *  计算限宽行高（字体，宽度）
 */
- (CGFloat)jl_height:(UIFont *)font withLabelWidth:(CGFloat)width enableCeil:(BOOL)enableCeil {
    
    CGFloat height = [self jl_size:font kern:0 space:0 linebreakmode:NSLineBreakByWordWrapping limitedlineHeight:0 renderSize:CGSizeMake(width, MAXFLOAT)].height;
    if (enableCeil) {
        return ceil(height);
    }
    return height;
}

/**
 *  计算单行宽度（字体）
 */
- (CGFloat)jl_width:(UIFont *)font enableCeil:(BOOL)enableCeil {
    
    CGFloat singleWidth = [self jl_size:font kern:0 space:0 linebreakmode:NSLineBreakByWordWrapping limitedlineHeight:0 renderSize:CGSizeMake(MAXFLOAT, 0)].width;
    if (enableCeil) {
        return ceil(singleWidth);
    }
    return singleWidth;
}

/**
 *  计算单行行高（字体）
 */
- (CGFloat)jl_height:(UIFont *)font enableCeil:(BOOL)enableCeil {
    
    CGFloat singleHeight = [self jl_size:font kern:0 space:0 linebreakmode:NSLineBreakByWordWrapping limitedlineHeight:0 renderSize:CGSizeMake(MAXFLOAT, 0)].height;
    if (enableCeil) {
        return ceil(singleHeight);
    }
    return  singleHeight;
}

/**
 *  限制显示行数
 */
- (CGFloat)jl_height:(UIFont *)font maxLineCount:(int)maxLineCount limitedlineHeight:(CGFloat)limitedlineHeight kern:(CGFloat)kern labelWidth:(CGFloat)labelWidth enableCeil:(BOOL)enableCeil {
    
    CGSize size = [self jl_size:font kern:kern space:0 linebreakmode:NSLineBreakByWordWrapping limitedlineHeight:limitedlineHeight renderSize:CGSizeMake(labelWidth, MAXFLOAT)];
    CGFloat maxHeight = maxLineCount * limitedlineHeight;
    if (enableCeil) {
        return size.height > maxHeight ? ceil(maxHeight) : ceil(size.height);
    }
    return size.height > maxHeight ? maxHeight : size.height;
}

/**
 *  限制显示行数（Deprecated）
 */
- (CGFloat)jl_heightWithFont:(UIFont*)font maxLine:(int)lineCount lineHeight:(CGFloat)lineHeight kern:(CGFloat)kern maxWidth:(CGFloat)maxWidth {
    
    CGSize size = [self jl_sizeWithFont:font lineHeight:lineHeight kern:kern maxWidth:maxWidth];
    CGFloat maxHeight = lineCount*lineHeight;
    return size.height > maxHeight ? maxHeight : size.height;
}

/**
 *  根据字间距计算（Deprecated）
 */
- (CGSize)jl_sizeWithKern:(CGFloat)kern font:(UIFont *)font maxSize:(CGSize)maxSize {
    
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, [NSNumber numberWithFloat:kern], NSKernAttributeName, nil];
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:nil].size;
}

/**
 *  根据行高计算（Deprecated）
 */
- (CGSize)jl_sizeWithFont:(UIFont*)font lineHeight:(CGFloat)lineHeight kern:(CGFloat)kern maxWidth:(CGFloat)maxWidth {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = lineHeight;
    style.maximumLineHeight = lineHeight;
    style.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, style, NSParagraphStyleAttributeName, @(kern), NSKernAttributeName, nil];
    CGSize txtSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrDict context:nil].size;
    return txtSize;
}

/**
 *  根据字体算尺寸（Deprecated）
 */
- (CGSize)jl_sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:nil].size;
}

#pragma mark - NSAttributedString

/**
 *  数字高亮，输出NSAttributedString
 */
- (NSAttributedString *)jl_numberHighlighted:(UIFont *)font color:(UIColor *)color {
    
    return [self jl_charatersHighlighted:@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"] font:font color:color];
}

/**
 *  字符串数组高亮，输出NSAttributedString
 */
- (NSAttributedString *)jl_charatersHighlighted:(NSArray *)characters font:(UIFont *)font color:(UIColor *)color {
    
    TypesetKit *typeset = self.typeset;
    for (NSString *character in characters) {
        typeset = typeset.matchAll(character).font(font.fontName, font.pointSize).color(color);
    }
    return typeset.string;
}

/**
 *  数字高亮，输出TypesetKit
 */
- (TypesetKit *)jl_numberHighlightedTypeset:(UIFont *)font color:(UIColor *)color {
    
    return [self jl_charatersHighlightedTypeset:@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"] font:font color:color];
}

/**
 *  字符串数组高亮，输出TypesetKit
 */
- (TypesetKit *)jl_charatersHighlightedTypeset:(NSArray *)characters font:(UIFont *)font color:(UIColor *)color {
    
    TypesetKit *typeset = self.typeset;
    for (NSString *character in characters) {
        typeset = typeset.matchAll(character).font(font.fontName, font.pointSize).color(color);
    }
    return typeset;
}

#pragma mark - NSURL, NSURLRequest

/**
 *  NSString转NSURL
 */
- (NSURL *)jlNSURL {
    
    return [NSURL URLWithString:self];
}

/**
 *  NSString转NSURLRequest
 */
- (NSURLRequest *)jlNSURLRequest {
    
    return [NSURLRequest requestWithURL:[self jlNSURL]];
}

#pragma mark - JSON字符串处理
/**
 *  JSON字符串转NSDictionary或NSArray
 */
- (id)jl_jsonToCocoaObject {
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    return jsonObject;
}

@end
