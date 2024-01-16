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

+ (NSString *)gg_stringWithFileByte:(NSInteger)fileByte {
	double dataLength = fileByte * 1.0;
	NSArray *typeArray = @[@"bytes", @"KB", @"MB", @"GB", @"TB", @"PB", @"EB", @"ZB", @"YB"];
	NSInteger index = 0;
	while (dataLength > 1024) {
		dataLength /= 1024.0;
		index++;
	}
	return [NSString stringWithFormat:@"%.2f%@", dataLength, typeArray[index]];
}

- (NSString*)gg_base64{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
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
