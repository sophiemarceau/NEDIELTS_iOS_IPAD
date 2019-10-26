//
//  MyMD5.m
//  GoodLectures
//
//  Created by yangshangqing on 11-10-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MyMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MyMD5

+(NSString *) md5: (NSString *) inPutText
{
    if(inPutText == nil || [inPutText length] == 0)
        return nil;
    const char *value = [inPutText UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
    
}
/*
 - (NSString *)getMd5_32Bit_String:(NSString *)srcString{
 constchar *cStr = [srcString UTF8String];
 unsignedchar digest[CC_MD5_DIGEST_LENGTH];
 // CC_MD5( cStr, strlen(cStr), digest ); 这里的用法明显是错误的，但是不知道为什么依然可以在网络上得以流传。当srcString中包含空字符（\0）时
 CC_MD5( cStr, self.length, digest );
 NSMutableString *result = [NSMutableStringstringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
 for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
 [result appendFormat:@"%02x", digest[i]];
 
 return result;
 }
 */
@end
