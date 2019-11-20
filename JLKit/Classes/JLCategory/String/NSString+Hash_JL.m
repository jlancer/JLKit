//
//  NSString+Hash_JL.m
//  JLKit-OC
//
//  Created by wangjian on 2019/10/28.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import "NSString+Hash_JL.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Hash_JL)

- (NSString *)jl_md5String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(string, length, bytes);
    return [self jl_stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)jl_sha1String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(string, length, bytes);
    return [self jl_stringFromBytes:bytes length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)jl_sha256String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(string, length, bytes);
    return [self jl_stringFromBytes:bytes length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)jl_sha512String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(string, length, bytes);
    return [self jl_stringFromBytes:bytes length:CC_SHA512_DIGEST_LENGTH];
}

#pragma mark - Helpers

- (NSString *)jl_stringFromBytes:(unsigned char *)bytes length:(int)length
{
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < length; i++)
        [mutableString appendFormat:@"%02x", bytes[i]];
    return [NSString stringWithString:mutableString];
}

@end
