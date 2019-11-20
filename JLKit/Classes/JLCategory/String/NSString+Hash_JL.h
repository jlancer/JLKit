//
//  NSString+Hash_JL.h
//  JLKit-OC
//
//  Created by wangjian on 2019/10/28.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Hash_JL)

@property (readonly) NSString *jl_md5String;

@property (readonly) NSString *jl_sha1String;

@property (readonly) NSString *jl_sha256String;

@property (readonly) NSString *jl_sha512String;

@end

NS_ASSUME_NONNULL_END
