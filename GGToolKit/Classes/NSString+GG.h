//
//  NSString+GG.h
//  unzip
//
//  Created by yg on 2021/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (GG)

- (BOOL)gg_isInteger;

+ (NSString *)gg_stringWithFileSize:(NSInteger)size;

+ (NSString *)base64encode:(NSString*)str;

+ (NSString *)sha256Value:(NSString *)srcString;

- (NSString *)md5;

- (NSInteger)gg_zhTotal;

@end

NS_ASSUME_NONNULL_END
