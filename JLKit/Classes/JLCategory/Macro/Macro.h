//
//  Macro.h
//  JLKit-OC
//
//  Created by wangjian on 2019/10/28.
//  Copyright © 2019 wangjian. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#import "NSString+Addition_JL.h"

// Weak
#define WeakSelf(type)  __weak typeof(type) weak##type = type;
#define StrongSelf(type)  __strong typeof(type) type = weak##type;

// 自定义输入日志 Log
#ifdef DEBUG // 如果当前是开发 调试阶段可以用ZYLog输入
#define JLLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else // 发布后就不能输入了
#define JLLog(...)
#endif

// iPhone4,4S       分辨率320x480，像素分别320x480和640x960，@1x，@2x
// iPhone5,5S,SE    分辨率320x568，像素640x1136，@2x
// iPhone6\7\8\SE2  分辨率375x667，像素750x1334，@2x
// iPhone6\7\8 Plus 分辨率414x736，像素1242x2208，@3x

// iPhoneX\XS\11Pro\12mini 分辨率375x812，像素1125x2436，@3x
// iPhoneXMax\11ProMax     分辨率414x896，像素1242x2688，@3x
// iPhoneXR\11             分辨率414x896，像素828x1792，@2x
// iPhone12\12Pro          分辨率390x844，像素1170x2532，@3x
// iPhone12ProMax          分辨率428x926，像素1284x2778，@3x

#define UI_I4_WIDTH                     (320.0)
#define UI_I4_HEIGHT                    (480.0)
#define UI_I5_WIDTH                     (320.0)
#define UI_I5_HEIGHT                    (568.0)
#define UI_I6_WIDTH                     (375.0)
#define UI_I6_HEIGHT                    (667.0)
#define UI_I6P_WIDTH                    (414.0)
#define UI_I6P_HEIGHT                   (736.0)
#define UI_IPX_WIDTH                    (375.0)
#define UI_IPX_HEIGHT                   (812.0)
#define UI_IPXMAX_WIDTH                 (414.0)
#define UI_IPXMAX_HEIGHT                (896.0)
#define UI_IPXR_WIDTH                   (414.0)
#define UI_IPXR_HEIGHT                  (896.0)
#define UI_IP12_WIDTH                   (390.0)
#define UI_IP12_HEIGHT                  (844.0)
#define UI_IP12ProMax_WIDTH             (428.0)
#define UI_IP12ProMax_HEIGHT            (926.0)

// 屏幕高宽
#define UI_SCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)
#define UI_SCREEN_BOUND                 ([[UIScreen mainScreen] bounds])

// 2.xx倍是实际3倍屏的物理像素
#define UI_RESOLUTON_WIDTH              (([[UIScreen mainScreen] bounds].size.width >= 414.0) ? UI_SCREEN_WIDTH * 2.5 : UI_SCREEN_WIDTH * 2)
#define UI_RESOLUTON_HEIGHT             (([[UIScreen mainScreen] bounds].size.height >= 736.0) ? UI_SCREEN_HEIGHT * 2.5 : UI_SCREEN_HEIGHT * 2)

// 屏幕中心
#define UI_POINT_CENTER                 CGPointMake( UI_SCREEN_WIDTH / 2.0, UI_SCREEN_HEIGHT / 2.0 )
#define UI_POINT_CENTER_OFFSET(x)       CGPointMake( UI_SCREEN_WIDTH / 2.0, UI_SCREEN_HEIGHT + (x) )

/**
 *  Device Helper
 */
//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone5系列
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6 6s 7系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6p 6sp 7p系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneX，Xs（iPhoneX，iPhoneXs）
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXsMax
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)&& !isPad : NO)
//判断iPhone12\12Pro
#define IS_IPHONE_12_Pro ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1170, 2532), [[UIScreen mainScreen] currentMode].size)&& !isPad : NO)
//判断iPhone12ProMax
#define IS_IPHONE_12_Pro_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1284, 2778), [[UIScreen mainScreen] currentMode].size)&& !isPad : NO)

//判断iPhoneX所有系列
#define IS_PhoneXAll (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs_Max || IS_IPHONE_12_Pro || IS_IPHONE_12_Pro_Max)
#define k_Height_NavContentBar 44.0f
#define k_Height_StatusBar (IS_PhoneXAll? 44.0 : 20.0)
#define k_Height_NavBar (IS_PhoneXAll ? 88.0 : 64.0)
#define k_Height_TabBar (IS_PhoneXAll ? 83.0 : 49.0)


#define MF_IF_IPad                      isPad
#define MF_IF_IP4                       kiPhone4
#define MF_IF_IP5                       kiPhone5
#define MF_IF_IP6                       kiPhone6
#define MF_IF_IP6P                      kiPhone6Plus
#define MF_IF_IPX                       IS_IPHONE_X
#define MF_IF_IPXMAX                    IS_IPHONE_Xs_Max
#define MF_IF_IPXR                      IS_IPHONE_Xr
#define MF_IF_IPX_SERIES                IS_PhoneXAll

#define isiPad                          isPad
#define isiPhone4                       kiPhone4
#define isiPhone5                       kiPhone5
#define isiPhone6                       kiPhone6
#define isiPhone6P                      kiPhone6Plus
#define isiPhoneX                       IS_IPHONE_X
#define isiPhoneXMAX                    IS_IPHONE_Xs_Max
#define isiPhoneXR                      IS_IPHONE_Xr
#define isiPhoneXSeries                 IS_PhoneXAll

/**
 *  Constant
 */
#define UI_STATUS_BAR_HEIGHT            (MF_IF_IPX_SERIES ? 44 : 20)
#define UI_NAVIGATION_BAR_HEIGHT        (44.0)
#define UI_TOP_HEIGHT                   (MF_IF_IPX_SERIES ? 88 : 64)
#define UI_TAB_BAR_HEIGHT               (MF_IF_IPX_SERIES ? 83 : 49)
#define UI_NAVIGATIONBAR_ICON_LEN       (20.0)
#define UI_TAB_ICON_LEN                 (30.0)

/**
 * Block Helper
 */
#if NS_BLOCKS_AVAILABLE
#define MF_BLOCK_CALL_NO_P(b)                     (b == nil ? : b())
#define MF_BLOCK_CALL(b, p)                       (b == nil ? : b(p) )
#define MF_BLOCK_CALL_2_P(b, p1, p2)              (b == nil ? : b(p1, p2))
#define MF_BLOCK_CALL_3_P(b, p1, p2 , p3)         (b == nil ? : b(p1, p2, p3))
#define MF_BLOCK_CALL_4_P(b, p1, p2 , p3, p4)     (b == nil ? : b(p1, p2, p3, p4))
#define MF_BLOCK_CALL_5_P(b, p1, p2 , p3, p4, p5) (b == nil ? : b(p1, p2, p3, p4, p5))
#endif


/**
 * String Helper
 */
#define MF_NULL_OR_EMPTY(str)           (str == nil || ((NSString *)str).length == 0)

#define MF_NULL_OR_EMPTY_TRIMSPACE(str) (str == nil || ((NSString *)str).length == 0 || [((NSString *)str) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)

#define MF_STR_UNNIL(str)               (str == nil ? @"" : str)

#define MF_STR_NIL_TO_EMPTY(str)        (str == nil ? @"" : str)

#define MF_STR_FM(str)                  (str == nil ? @"" : [NSString stringWithFormat:@"%@",str])

#define MF_STR_FL(f)                    [NSString stringWithFormat:@"%f",f]

#define MF_STR_FL_1(f)                  [NSString stringWithFormat:@"%.1f",f]

#define MF_STR_FL_2(f)                  [NSString stringWithFormat:@"%.2f",f]

#define MF_STR_FL_3(f)                  [NSString stringWithFormat:@"%.3f",f]

#define MF_STR_FL_4(f)                  [NSString stringWithFormat:@"%.4f",f]

#define MF_STR_MERGE(a,b)               [NSString stringWithFormat:@"%@%@",a, b]

/**
 * Resource Helper
 */
#define MF_LOAD_NIB(x)                     [[[NSBundle bundleForClass:NSClassFromString(x)] loadNibNamed:x owner:nil options:nil] objectAtIndex:0]

#define MF_LOAD_NIB_EXTRA(x, owner, opt)   [[[NSBundle bundleForClass:NSClassFromString(x)] loadNibNamed:x owner:owner options:opt] objectAtIndex:0]

/**
 *  UIStoryboard
 */
#define MF_LOAD_STORYBOARD(s, i)           [[UIStoryboard storyboardWithName:s bundle:nil] instantiateViewControllerWithIdentifier:i]

/**
 * 判断iOS系统版本
 */
#define MF_VERSION_OVER_OR_EQUAL(a)     ([NSString jl_compare:[[UIDevice currentDevice] systemVersion] than:@#a] == JLCompareResultLarger  ||\
                                        [NSString jl_compare:[[UIDevice currentDevice] systemVersion] than:@#a] == JLCompareResultEqual)

#define MF_VERSION_OVER(a)              ([NSString jl_compare:[[UIDevice currentDevice] systemVersion] than:@#a] == JLCompareResultLarger)


#define MF_VERSION_BELOW_OR_EQUAL(a)    ([NSString jl_compare:[[UIDevice currentDevice] systemVersion] than:@#a] == JLCompareResultSmaller ||\
                                        [NSString jl_compare:[[UIDevice currentDevice] systemVersion] than:@#a] == JLCompareResultEqual)

#define MF_VERSION_BELOW(a)             ([NSString jl_compare:[[UIDevice currentDevice] systemVersion] than:@#a] == JLCompareResultSmaller)

/**
 * Logger Helper
 */
#define MF_LOG_FUNC_ENTER               NSLog(@"CALL BEGIN:%s---%s\n",__func__,__FILE__);

#define MF_LOG_FUNC_LEAVE               NSLog(@"CALL END  :%s---%s\n",__func__,__FILE__);

#define MF_LOG_FUNC_START               do{}while(0);

#define MF_LOG_FUNC_END                 do{}while(0);

#if DEBUG
#   define MFLog(...)          NSLog(@"### Macro Logging: %@", [NSString stringWithFormat:__VA_ARGS__]);
#else
#   define MFLog(...)
#endif

/**
 * Runtime Helper
 */
#define MF_STRING_CLASS(a)              [NSString stringWithUTF8String:object_getClassName(a)]

/**
 *  weskSelf
 */
#define MF_WEAK_SELF                    __weak typeof(self) weakSelf = self;
#define MF_WEAK_OBJECT(o)               __weak typeof(o) weak##o = o;

/**
 *  Money Format Helper
 */
#define MF_ROUND_STR(a)                 roundf([a floatValue])

#define MF_ROUND_FLOAT(a)               roundf((float)a)

#define MF_RMB_FEN_STR(a)               [NSString stringWithFormat:@"¥%.0f", (float)roundf( [a floatValue] / 100.0 ) ]

#define MF_RMB_YUAN_STR(a)              [NSString stringWithFormat:@"¥%.0f", MF_ROUND_STR(a)]

#define MF_RMB_FEN_FLOAT(a)             [NSString stringWithFormat:@"¥%.0f", (float) roundf( ((float)a) / 100.0 ) ]

#define MF_RMB_YUAN_FLOAT(a)            [NSString stringWithFormat:@"¥%.0f", MF_ROUND_FLOAT(a)]

// 输入货币单位a($), 值(100)
#define MF_CUR_FEN_FLOAT(a, b)          [NSString stringWithFormat:@"%@%.0f", a, (float) roundf( ((float)b) / 100.0 ) ]

/**
 *  设置StatusBar背景颜色
 */
#define MF_SET_STATUS_BAR_STYLE(a)      [UIApplication sharedApplication].statusBarStyle = a;

/**
 *  URL Helper
 */
#define MF_URL(a)                       [NSURL URLWithString:a]
#define MF_IF_URL(url)                  ([url containsString:@"http://"] || [url containsString:@"https://"])
#define MF_IS_WEBURL(str)               ([str containsString:@"http://"] || [str containsString:@"https://"])

/**
 *  isKindOfClass / isMemberOfClass
 */
#define MF_IS_Kind(object, class)       [object isKindOfClass:class]
#define MF_IS_Member(object, class)     [object isMemberOfClass:class]
#define MF_IsKind(object,class)         [object isKindOfClass:class]
#define MF_IsMember(object,class)       [object isMemberOfClass:class]

/**
 *  info.plist
 */
#define MF_APP_NAME                     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define MF_APP_VERSION                  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define MF_BUNDLE_VERSION               [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

/**
 *  Window
 */
#define MF_KEY_WINDOW                   [[UIApplication sharedApplication].delegate window]
// TabViewController上的第一个UINavigationController的根控制器是否初始化完成（ViewDidLoaded）
#define MF_IF_ROOT_INITIALIZED          (((UIViewController *)((UINavigationController *)([MF_KEY_WINDOW.rootViewController.childViewControllers objectAtIndex:0])).viewControllers[0]).isViewLoaded)

/**
 *  Math
 */
#define MF_BELOW_EQUAL_MAX(n, max)      (((int)n >= (int)max) ? (int)max-1 : (int)n)
#define MF_BELOW_EQUAL_MAX_TXT(n, max)  [NSString stringWithFormat:@"%d", MF_BELOW_EQUAL_MAX(n,max)]

/**
 *  Wrapper / UnWrapper
 */
#define MF_WRAP_BOOLT(b)                [NSNumber numberWithBool:b]
#define MF_WRAP_CHAR(c)                 [NSNumber numberWithChar:c]
#define MF_WRAP_INT(n)                  [NSNumber numberWithInt:n]
#define MF_WRAP_FLOAT(f)                [NSNumber numberWithFloat:f]
#define MF_WRAP_DOUBLE(d)               [NSNumber numberWithDouble:d]
#define MF_WRAP_SHORT(s)                [NSNumber numberWithShort:s]
#define MF_WRAP_LONG(l)                 [NSNumber numberWithLong:l]
#define MF_WRAP_LONGLONG(ll)            [NSNumber numberWithLongLong:ll]

#define MF_UNWRAP_BOOLT(b)              [b boolValue]
#define MF_UNWRAP_CHAR(c)               [c charValue]
#define MF_UNWRAP_INT(n)                [n intValue]
#define MF_UNWRAP_FLOAT(f)              [f floatValue]
#define MF_UNWRAP_DOUBLE(d)             [d doubleValue]
#define MF_UNWRAP_SHORT(s)              [s shortValue]
#define MF_UNWRAP_LONG(l)               [l longValue]
#define MF_UNWRAP_LONGLONG(ll)          [ll longLongValue]

#define MF_WRAP_ARRAY(object)           (object == nil ? nil : @[object])

/**
 *  int switch string each other
 */
#define MF_STR(a)                       [NSString stringWithFormat:@"%ld",(long)(a)]
#define MF_INT(x)                       [x intValue]
#define MF_FLOAT(x)                     [x floatValue]

/**
 * judge status
 */
#define MF_TRUE(a)  (([a isKindOfClass:[NSNumber class]] || [a isKindOfClass:[NSString class]]) ? [a boolValue]  : a != nil)

#define MF_FALSE(a) (([a isKindOfClass:[NSNumber class]] || [a isKindOfClass:[NSString class]]) ? ![a boolValue] : a == nil)

#define MF_ZERO(a)  (([a isKindOfClass:[NSNumber class]] || [a isKindOfClass:[NSString class]]) ? ![a boolValue] : a == nil)

/**
 *  performance test
 */
#define MF_PF_INIT(f) \
long long pf_t = [[NSDate date] timeIntervalSince1970] * 1000; \
long long pf_d, pf_l = pf_t; \
NSString *pf_s = [NSString stringWithFormat:@"+++ PERFORMANCE [%@] +++ Start\n", f]; \
NSLog(@"%@", pf_s);

#define MF_PF_LOG(f) \
pf_d = [[NSDate date] timeIntervalSince1970] * 1000; \
pf_s = [NSString stringWithFormat:@"+++ PERFORMANCE [%@] +++ 耗时%lld(毫秒)  累计%lld(毫秒)\n", f, pf_d - pf_l, pf_d - pf_t]; \
NSLog(@"%@", pf_s); \
pf_l = pf_d;

/**
 *  Extra Window Level
 */
#define UIWindowLevelAbsoluteHighest        (NSIntegerMax)
#define UIWindowLevelAbsolute2ndHighest     (NSIntegerMax - 1)

#endif /* Macro_h */
