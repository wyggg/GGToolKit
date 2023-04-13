//
//  NSAttributedString+GG.m
//  GGExtensionDemo
//
//  Created by yg on 2022/8/2.
//

#import "NSAttributedString+GG.h"
#import <CoreText/CoreText.h>


@implementation NSAttributedString (GG)

- (CGFloat)gg_heightWithContainWidth:(CGFloat)width{
	int total_height = 0;
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self);
	CGRect drawingRect = CGRectMake(0, 0, width, 100000);
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, drawingRect);
	CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
	CGPathRelease(path);
	CFRelease(framesetter);

	NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
	if(linesArray.count == 0){
		CFRelease(textFrame);
		return 0.0f;
	}
	CGPoint origins[[linesArray count]];
	CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
	int line_y = (int) origins[[linesArray count] -1].y;
	CGFloat ascent;
	CGFloat descent;
	CGFloat leading;
	CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
	CTLineGetTypographicBounds(line, &ascent, &descent, &leading);

	total_height = 100000 - line_y + (int) descent +1;
	CFRelease(textFrame);
	return total_height;
}

	//异步解析html字符串
+ (void)gg_attributedStringWithHtmlString:(NSString *)string block:(void(^)(NSAttributedString *attString))block{


	dispatch_async(dispatch_get_global_queue(0, 0), ^{

		NSMutableAttributedString *attString = nil;

		NSString *version = [UIDevice currentDevice].systemVersion;
		if (version.doubleValue >= 9.0) {
				// 针对 9.0 以上的iOS系统进行处理
			NSData *data = [string dataUsingEncoding:NSUnicodeStringEncoding];
			attString = [[NSMutableAttributedString alloc] initWithData:data options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
		} else {
				// 针对 9.0 以下的iOS系统进行处理
			attString = [[NSMutableAttributedString alloc] initWithString:string];
		}

		dispatch_async(dispatch_get_main_queue(), ^{
			block(attString);
		});
	});
}

	//同步解析html字符串
+ (NSAttributedString *)gg_attributedStringWithHtmlString:(NSString *)string{

	NSMutableAttributedString *attString = nil;

	NSString *version = [UIDevice currentDevice].systemVersion;
	if (version.doubleValue >= 8.0) {
			// 针对 8.0 以上的iOS系统进行处理
		NSData *data = [string dataUsingEncoding:NSUnicodeStringEncoding];
		attString = [[NSMutableAttributedString alloc] initWithData:data options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
	} else {
			// 针对 8.0 以下的iOS系统进行处理
		attString = [[NSMutableAttributedString alloc] initWithString:string];
	}
	return attString;
}



	//优化富文本格式 适合手机屏幕上展示 规则1
+ (NSMutableAttributedString *)gg_attributedStringFormPhoneString1:(NSAttributedString *)attStr{

	CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
	NSMutableAttributedString *attString = [attStr mutableCopy];

		//遍历富文本所有图片
	[attString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attString.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
		NSTextAttachment *imageData = value;
			//按原比例缩放图片
		CGSize imageSize = CGSizeMake(screenW-30, (screenW-30)*imageData.bounds.size.height/imageData.bounds.size.width);
		imageData.bounds = CGRectMake(0, imageData.bounds.origin.y, imageSize.width, imageSize.height);
	}];

		//调整行间距
	[attString enumerateAttribute:NSParagraphStyleAttributeName inRange:NSMakeRange(0, attString.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {

		NSMutableParagraphStyle *stype = [value mutableCopy];
		NSLog(@"调整前 ： \n行间距_%f\n段落间距_%f",stype.lineSpacing,stype.paragraphSpacing);
		stype.lineSpacing = 5.0f;
		if (stype.paragraphSpacing > -5.0) {
			stype.paragraphSpacing = -5.0;
		}else if(stype.paragraphSpacing<-10.0){
			stype.paragraphSpacing = 10.0;
		}
		[attString addAttribute:NSParagraphStyleAttributeName value:stype range:range];
		NSLog(@"调整后 ： \n行间距_%f\n段落间距_%f",stype.lineSpacing,stype.paragraphSpacing);

	}];

		//调整字体大小
	[attString enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, attString.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
		UIFont *fontaaa = value;
		UIFont *textFont = [UIFont fontWithName:[fontaaa fontName] size:fontaaa.pointSize+4];
		[attString addAttribute:NSFontAttributeName value:textFont range:range];
	}];

	return attString;
}


@end
