//
//  NSObject+GG.h
//  unzip
//
//  Created by yg on 2021/11/16.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (GG)

#pragma mark - RunTime

///方法交换
+ (void)gg_originalSelector:(SEL)originalSelector
		   swizzledSelector:(SEL)swizzledSelector;

#pragma mark - 数组排序
//根据数组内对象某个key的值 将数组内数据进行分类 @[@[obj],@[obj]]
- (NSArray *)gg_classificationWithKey:(NSString *)key;
//忽略序列 判断数组中数据是否完全相同 (只能判断字符串)
- (BOOL)isSameArray:(NSArray <NSString *>*)array;
///performSelector方法传递多参数
- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects;

#pragma mark - 判断类
//对象是否存在（不为空）
+ (BOOL)isObjectThereAre:(NSObject *)obj;
//获得包含所有基础类的数组
+ (NSArray *)foundationClasses;
//判断本类是否为基础类 NSString、NSNumber等...
+ (BOOL)isClassFormFoundationClasses;
- (BOOL)isClassFormFoundationClasses;

	///判断对象是否为nil 如果为nil，就返回obj2
id NOTNIL1(id obji,id obj2);
	///判断对手是否为nil 如果为nil，就返回Class new一个实例
id NOTNIL2(id obj1,Class class1);

#pragma mark - 数值转换

//快捷转换数值对象到字符串
#define kStringNumber(obj) ([NSObject numberStringWithObject:obj roundingMode:NSRoundDown scale:0 multiplier:1 abnormalStr:@"0" unitString:@""])

//对象转换为数值字符串
+ (NSString *)numberStringWithObject:(id)object 
                        roundingMode:(NSRoundingMode)mode
                               scale:(short)scale
                          multiplier:(float)multiplier
                         abnormalStr:(NSString *)abnormalStr
                          unitString:(NSString *)unitString;

//数值对象转换为整数数值字符串(舍弃小数部分)
+ (NSString *)intStringWithObj:(id)obj 
                   abnormalStr:(NSString *)abnormalStr
                    unitString:(NSString *)unitString;
//数值对象转换为百分比字符串
+ (NSString *)rateStringWithObj:(id)obj 
                          scale:(short)scale
                     multiplier:(float)multiplier;

#pragma mark - 数据解析

//过滤空值
- (id)removeAllNull;
//过滤字典在中所有的空值
- (NSDictionary *)removeAllNullInDic;
//过滤数组中所有的空值
- (NSArray <id>*)removeAllNullInArray;

//获得所有属性名称
- (NSArray <NSString *>*)allProperties;
+ (NSArray <NSString *>*)allProperties;

	///获得所有属性名称和值
- (NSDictionary *)allPropertiesAndValue;

#pragma mark - 数据转换
	//注意：xml字符串暂时不能转换成json字符串 json字符串能直接转换为xml字符串
	//json解析
- (id)jsonObject;
- (NSData *)jsonData;
- (NSString *)jsonString;

///类型转换 XML
- (NSString *)xmlString;
- (NSString *)formatString;

///对象转模型
+ (id)parsingObj:(id)obj;
+ (instancetype)modelWithObjectDictionary:(NSDictionary *)objectDictionary;
+ (NSArray *)modelWithObjectArray:(NSArray *)objectArray;

///模型转对象
- (id)objValues;
- (NSDictionary *)dicValues;
- (NSArray *)aryValues;

///表明某个属性对应的class  return @{@"user":[Model class]};
+ (NSDictionary *)propertieClassInDictionary;
///替换关键属性名   return @{@"ID":@"id"};
+ (NSDictionary *)replacedKeyFromPropertyName;

#pragma mark - 归档
+ (instancetype)modelDataInFileName:(NSString *)fileName;
- (BOOL)saveValuesInFileName:(NSString *)fileName;
+ (void)removeObjInFileName:(NSString *)fileName;


#pragma mark - 宏定义
/*
 以下宏写在model的.m文件中
 */

//打印全部 输出为json字符串
#define LOGALL_JSON \
- (NSString *)description{\
return [[self objValues] jsonString];\
}

//打印全部 输出为字典
#define LOGALL_DIC \
- (NSString *)description{\
return [[self objValues] formatString];\
}


@end

NS_ASSUME_NONNULL_END
