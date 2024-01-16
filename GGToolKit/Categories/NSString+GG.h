//
//  NSString+GG.h
//  unzip
//
//  Created by yg on 2021/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (GG)

+ (NSString *)gg_stringWithFileByte:(NSInteger)fileByte ;

- (NSString *)gg_base64;
- (NSString *)gg_md5;
- (NSInteger )gg_zhTotal;

@end

NS_ASSUME_NONNULL_END
