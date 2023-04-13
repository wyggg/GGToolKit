//
//  NSString+GG.m
//  unzip
//
//  Created by yg on 2021/11/24.
//

#import "NSString+GG.h"
#include <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
@implementation NSString (GG)

- (BOOL)gg_isInteger{
	if (self.length == 0) {
		return NO;
	}
	NSString *regex = @"[0-9]*";
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
	if ([pred evaluateWithObject:self]) {
		return YES;
	}
	return NO;
}

+ (NSString *)gg_stringWithFileSize:(NSInteger)size {
	double dataLength = size * 1.0;
	NSArray *typeArray = @[@"bytes", @"KB", @"MB", @"GB", @"TB", @"PB", @"EB", @"ZB", @"YB"];
	NSInteger index = 0;
	while (dataLength > 1024) {
		dataLength /= 1024.0;
		index++;
	}
	return [NSString stringWithFormat:@"%.2f%@", dataLength, typeArray[index]];
}

+ (NSString*)base64encode:(NSString*)str{
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

+ (NSString *)sha256Value:(NSString *)srcString {
    
    const char *string = [srcString UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(string, (CC_LONG)strlen(string), result);

    NSMutableString *hashed = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
      [hashed appendFormat:@"%02x", result[i]];
    }
    return hashed;
}

- (NSString *)md5 {
	const char *cstr = [self UTF8String];
	unsigned char result[16];
	CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
	NSMutableString *md5 = [NSMutableString stringWithCapacity:32];
	for (int i = 0; i < 16; i++) {
		[md5 appendFormat:@"%02x", result[i]];
	}
	return md5;
}

- (NSInteger)gg_zhTotal{
	NSUInteger  character = 0;
	for(int i=0; i< [self length];i++){
		int a = [self characterAtIndex:i];
		if( a >= 0x4e00 && a <= 0x9fa5){ //判断是否为中文
			character +=2;
		}else{
			character +=1;
		}
	}

	return character;

}

@end
