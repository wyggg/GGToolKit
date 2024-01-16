//
//  NSObject+GG.m
//  unzip
//
//  Created by yg on 2021/11/16.
//

#import "NSObject+GG.h"
#import <objc/runtime.h>

@implementation NSObject (GG)

#pragma mark - Object

+ (void)gg_originalSelector:(SEL)originalSelector
			swizzledSelector:(SEL)swizzledSelector{
	
	Method originalMethod = class_getInstanceMethod([self class], originalSelector);
	Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
	
	BOOL didAddMethod = class_addMethod([self class],
										originalSelector,
										method_getImplementation(swizzledMethod),
										method_getTypeEncoding(swizzledMethod));
	
	if (didAddMethod){
		class_replaceMethod([self class],
							swizzledSelector,
							method_getImplementation(originalMethod),
							method_getTypeEncoding(originalMethod));
	}else{
		method_exchangeImplementations(originalMethod, swizzledMethod);
	}
}

#pragma mark - Object

///数据转换成JsonString
- (NSString *)jsonString{
	NSString *jsonStr = @"";
	if ([self isKindOfClass:[NSString class]]) {
		return (NSString *)self;
		
	}else if ([self isKindOfClass:[NSData class]]){
		jsonStr = [[NSString alloc] initWithData:(NSData *)self encoding:NSUTF8StringEncoding];
		
	}else{
		jsonStr = [[NSString alloc] initWithData:[self jsonData] encoding:NSUTF8StringEncoding];
	}
	return jsonStr;
}

///数据转换成JsonData
- (NSData *)jsonData{
	NSData *data = nil;
	if ([self isKindOfClass:[NSString class]]) {//str
		data = [((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding];
		
	}else if ([self isKindOfClass:[NSData class]]) {//data
		data = (NSData *)self;
		
	}else{ //obj
		data = [NSJSONSerialization dataWithJSONObject:[self jsonObject] options:kNilOptions error:nil];
	}
	return data;
}

///数据转换成OC对象
- (id)jsonObject{
	id obj = nil;
	if ([self isKindOfClass:[NSString class]]) {
		obj = [NSJSONSerialization JSONObjectWithData:[((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
		
	}else if ([self isKindOfClass:[NSData class]]){
		obj = [NSJSONSerialization JSONObjectWithData:(NSData *)self options:kNilOptions error:nil];
		
	}else{
		obj = self;
	}
	return obj;
}

///数据格式转换为XML字符串
- (NSString *)xmlString{
	
	NSDictionary *dic = [self jsonObject];
	if (![dic isKindOfClass:[NSDictionary class]]) {
		NSLog(@"xml转换对象必须为字典");
		return nil;
	}
	
	NSString *xmlStr = @"<xml>";
	for (NSString *key in dic.allKeys) {
		
		NSString *value = [dic objectForKey:key];
		xmlStr = [xmlStr stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>", key, value, key]];
	}
	
	xmlStr = [xmlStr stringByAppendingString:@"</xml>"];
	return xmlStr;
	
}

- (NSString *)formatString{
	if (![NSObject isObjectThereAre:self]) {
		return @"";
	}
	return [NSString stringWithFormat:@"%@",self];
}

///数据分类
- (NSArray *)gg_classificationWithKey:(NSString *)key{
	
	if (![self.jsonObject isKindOfClass:[NSArray class]]) {
		NSLog(@"数据格式不是数组 不能进行分类");
		return nil;
	}
	NSMutableArray *objArray = [NSMutableArray array];
	NSArray *array = (NSArray *)self;
	NSMutableArray *mArray = [NSMutableArray arrayWithArray:array];
	for (int i=0; i<array.count; i++) {
		id obj = array[i];
		NSString *str = [NSString stringWithFormat:@"%@",[obj valueForKey:key]];
		NSMutableArray *tempArray = @[].mutableCopy;
		
		for (int j=0; j<mArray.count; j++) {
			id toObj = mArray[j];
			NSString *toStr = [NSString stringWithFormat:@"%@",[toObj valueForKey:key]];
			if ([str isEqualToString:toStr]) {
				[tempArray addObject:toObj];
				[mArray removeObjectAtIndex:j];
				j--;
			}
		}
		if (tempArray.count!=0) {
			[objArray addObject:tempArray];
		}
	}
	
	return objArray;
}
	//判断数据是否相同
- (BOOL)isSameArray:(NSArray <NSString *>*)array{
	if (![self isKindOfClass:[NSArray class]]) {
		return false;
	}
	NSArray *array1 = (NSArray *)self;
	NSArray *array2 = array;
	bool bol = false;
	
		//创建俩新的数组
	NSMutableArray *oldArr = [NSMutableArray arrayWithArray:array1];
	NSMutableArray *newArr = [NSMutableArray arrayWithArray:array2];
	
		//对数组1排序。
	[oldArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
		return obj1 > obj2;
	}];
	
		////上个排序好像不起作用，应采用下面这个
	[oldArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2){return [obj1 localizedStandardCompare: obj2];}];
	
		//对数组2排序。
	[newArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
		return obj1 > obj2;
	}];
		////上个排序好像不起作用，应采用下面这个
	[newArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2){return [obj1 localizedStandardCompare: obj2];}];
	
	
	if (newArr.count == oldArr.count) {
		
		bol = true;
		for (int16_t i = 0; i < oldArr.count; i++) {
			
			id c1 = [oldArr objectAtIndex:i];
			id newc = [newArr objectAtIndex:i];
			
			if (![newc isEqualToString:c1]) {
				bol = false;
				break;
			}
		}
	}
	
	if (bol) {
		NSLog(@"两个数组的内容相同！");
	}
	else {
		NSLog(@"两个数组的内容不相同！");
	}
	
	return bol;
	
}



- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects
{
		// 方法签名(方法的描述)
	NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
	if (signature == nil) {
		
			//可以抛出异常也可以不操作。
	}
	
		// NSInvocation : 利用一个NSInvocation对象包装一次方法调用（方法调用者、方法名、方法参数、方法返回值）
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
	invocation.target = self;
	invocation.selector = selector;
	
		// 设置参数
	NSInteger paramsCount = signature.numberOfArguments - 2; // 除self、_cmd以外的参数个数
	paramsCount = MIN(paramsCount, objects.count);
	for (NSInteger i = 0; i < paramsCount; i++) {
		id object = objects[i];
		if ([object isKindOfClass:[NSNull class]]) continue;
		[invocation setArgument:&object atIndex:i + 2];
	}
	
		// 调用方法
	[invocation invoke];
	
		// 获取返回值
	id returnValue = nil;
	if (signature.methodReturnLength) { // 有返回值类型，才去获得返回值
		[invocation getReturnValue:&returnValue];
	}
	
	return returnValue;
}

#pragma mark - 判断

	//对象是否不为空
+ (BOOL)isObjectThereAre:(NSObject *)obj{
	if ([obj.class isKindOfClass:[NSNull class]]) {
		return NO;
	}
	if ([[NSString stringWithFormat:@"%@",obj] isEqualToString:@"<null>"]) {
		return NO;
	}
	if ([NSString stringWithFormat:@"%@",obj].length==0) {
		return NO;
	}
	if (obj==nil) {
		return NO;
	}
	return YES;
}

	//获得包含所有基础类的数组
+ (NSArray *)foundationClasses
{
	static NSArray *foundationClasses;
	if (foundationClasses == nil) {
		foundationClasses = @[[NSURL class],[NSDate class],[NSValue class],
							  [NSData class],[NSError class],[NSArray class],
							  [NSDictionary class],[NSString class],
							  [NSAttributedString class],[NSNull class]];
	}
	return foundationClasses;
}

	///判断本类是否为基础类 NSString、NSNumber等...
+ (BOOL)isClassFormFoundationClasses{
	for (Class cls in [self foundationClasses]) {
		if ([cls isSubclassOfClass:self]||[self isSubclassOfClass:cls]) {
			return YES;
		}
	}
	return NO;
}

- (BOOL)isClassFormFoundationClasses{
	return [self.class isClassFormFoundationClasses];
}

id NOTNIL1(id obj1,id obj2){
	if (obj1 == nil) {
		return obj2;
	}else if ([obj1 isKindOfClass:[NSNull class]]){
		return obj2;
	}else{
		return obj1;
	}
}

id NOTNIL2(id obj1,Class class1){
	if (obj1 == nil) {
		return [class1 new];
	}else{
		return obj1;
	}
}

#pragma mark - 数值转换
//对象转换为数值字符串
+ (NSString *)numberStringWithObject:(id)object roundingMode:(NSRoundingMode)mode scale:(short)scale multiplier:(float)multiplier abnormalStr:(NSString *)abnormalStr unitString:(NSString *)unitString{
	if ([object respondsToSelector:@selector(floatValue)]) {
		float number1 = [((NSString *)object) floatValue];
		NSString *numberStr1 = [NSString stringWithFormat:@"%f",number1];
		NSDecimalNumber * numDecima1 = [NSDecimalNumber decimalNumberWithString:numberStr1];
		NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
		NSDecimalNumber * numDecima2 = [numDecima1 decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",multiplier]] withBehavior:roundUp];
		NSString *numberStr2 = [NSString stringWithFormat:@"%@%@",numDecima2,unitString==nil?@"":unitString];
		return numberStr2;
	}else{
		return abnormalStr;
	}
}

//数值对象转换为整数数值字符串(舍弃小数部分)
+ (NSString *)intStringWithObj:(id)obj abnormalStr:(NSString *)abnormalStr unitString:(NSString *)unitString{
	return [self.class numberStringWithObject:obj roundingMode:NSRoundDown scale:0 multiplier:1 abnormalStr:abnormalStr unitString:unitString];
}

//数值对象转换为百分比字符串
+ (NSString *)rateStringWithObj:(id)obj scale:(short)scale multiplier:(float)multiplier{
	return [self.class numberStringWithObject:obj roundingMode:NSRoundDown scale:scale multiplier:multiplier abnormalStr:@"0%" unitString:@"%"];
}


//过滤空值
- (id)removeAllNull{
	if ([self isKindOfClass:[NSDictionary class]]) {
		return [self removeAllNullInDic];
	}else if ([self isKindOfClass:[NSArray class]]){
		return [self removeAllNullInArray];
	}else if ([self isKindOfClass:[NSNull class]]){
		return nil;
	}else{
		return self;
	}
}

	///过滤字典在中所有的空值
- (NSDictionary *)removeAllNullInDic{
	
	if (![NSObject isObjectThereAre:self]) {
		return @{};
	}
	if (![self isKindOfClass:[NSDictionary class]]) {
		return (NSDictionary *)self;
	}
	NSDictionary *dic = (NSDictionary *)self;
	NSMutableDictionary *mDic = [self mutableCopy];
	NSMutableArray *keyArray = [NSMutableArray array];
	for (NSString *key in dic.allKeys) {
		id obj = mDic[key];
		if ([obj isKindOfClass:[NSNull class]]) {
			[keyArray addObject:key];
		}else if ([obj isKindOfClass:[NSDictionary class]]){
			mDic[key] = [obj removeAllNullInDic];
		}else if ([obj isKindOfClass:[NSArray class]]){
			mDic[key] = [obj removeAllNullInArray];
		}
	}
	
		///清空为空的Key
	[mDic removeObjectsForKeys:keyArray];
	
	return mDic;
}

	///过滤数组中所有的空值
- (NSArray *)removeAllNullInArray{
	if (![NSObject isObjectThereAre:self]) {
		return @[];
	}
	if (![self isKindOfClass:[NSArray class]]) {
		return (NSArray *)self;
	}
	NSArray *array = (NSArray *)self;
	NSMutableArray *mArray = self.mutableCopy;
	NSMutableArray *indexArray = @[].mutableCopy;
	for (int i=0; i<array.count; i++) {
		id obj = array[i];
		if ([obj isKindOfClass:[NSNull class]]) {
			[indexArray addObject:@(i)];
		}else if ([obj isKindOfClass:[NSDictionary class]]){
			mArray[i] = [obj removeAllNullInDic];
		}else if ([obj isKindOfClass:[NSArray class]]){
			mArray[i] = [obj removeAllNullInArray];
		}
	}
	for (NSNumber *index in indexArray) {
		[mArray removeObjectAtIndex:[index integerValue]];
	}
	return mArray;
}


#pragma mark - 数据解析工具类
	///获得所有Key
- (NSArray <NSString *>*)allProperties{
	return [self.class allProperties];
}
	///获得所有Key
+ (NSArray <NSString *>*)allProperties{
	u_int count;
	objc_property_t *properties = class_copyPropertyList([self class], &count);
	NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
	for (int i = 0; i<count; i++){
		const char* propertyName = property_getName(properties[i]);
		[propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
	}
	free(properties);
	
	return propertiesArray;
}

	///获得所有Key和Value
- (NSDictionary *)allPropertiesAndValue{
	NSMutableDictionary *props = [NSMutableDictionary dictionary];
	unsigned int outCount, i;
	objc_property_t *properties = class_copyPropertyList([self class], &outCount);
	for (i = 0; i<outCount; i++){
		objc_property_t property = properties[i];
		const char* char_f =property_getName(property);
		NSString *propertyName = [NSString stringWithUTF8String:char_f];
		id propertyValue = [self valueForKey:(NSString *)propertyName];
		if (propertyValue) [props setObject:propertyValue forKey:propertyName];
	}
	free(properties);
	return props;
}

	///通用json转模型方法
+ (id)parsingObj:(id)obj{
	if (obj==nil) {
		return nil;
	}
	if ([obj isKindOfClass:[NSDictionary class]]) {
		return [self modelWithObjectDictionary:obj];
		
	}else if ([obj isKindOfClass:[NSArray class]]){
		return [self modelWithObjectArray:obj];
		
	}else if ([obj isKindOfClass:[NSData class]]){
		return [self parsingObj:[obj jsonObject]];
		
	}else if ([obj isKindOfClass:[NSString class]]){
		return [self parsingObj:[obj jsonObject]];
		
	}else if ([obj isKindOfClass:[NSNull class]]){
		return nil;
	}else{
		return nil;
	}
}

	///对象转Model
+ (instancetype)modelWithObjectDictionary:(NSDictionary *)objectDictionary{
		///如果检查到对象不是dic 则返回并提示
	if (![objectDictionary isKindOfClass:[NSDictionary class]]) {
		NSLog(@"⚠️ objectDictionary不是一个字典");
		return objectDictionary;
	}
	id model = [[self alloc] init];
		///获得自己的属性
	NSArray *properties = [model allProperties];
	for (NSString *key in properties) {
		
			//取出参数名 (如果能查到 就用dicK取数据 否则就用属性名取)
		NSString *dicK = [self replacedKeyFromPropertyName][key];
		if (!dicK) {
			dicK = key;
		}
			//取出Class
		NSDictionary *propertieClassDic = [self propertieClassInDictionary];
		Class objClass = propertieClassDic[key];
		if (!objClass) {
			objClass = propertieClassDic[dicK];
		}
		
			//从字典取出的对象
		id propertieObject = objectDictionary[dicK];
		if (propertieObject!=nil) {
			
				//如果不是基础类 如UIColor ，UIView 等 则不做解析操作
			if (![propertieObject isClassFormFoundationClasses]) {
					//如果已经指定类型 则赋值
				if (objClass==nil){
					NSLog(@"⚠️ 不能解析 %@",[propertieObject class]);
				}else{
					[model setValue:propertieObject forKey:key];
				}
				continue;
			}
			
				//如果是空 不做处理则参数为nil
			else if ([propertieObject isKindOfClass:[NSNull class]]){
					//                [model setValue:nil forKey:key];
				continue;
			}
			
				//对象是字典
			if ([propertieObject isKindOfClass:[NSDictionary class]]) {
				if (objClass) {
					id modelObj = [objClass modelWithObjectDictionary:propertieObject];
					[model setValue:modelObj forKey:key];
				}
			}
				//对象是数组
			else if ([propertieObject isKindOfClass:[NSArray class]]){
				if (objClass==nil) {
					NSArray *modelAry = [self modelWithObjectArray:propertieObject];
					[model setValue:modelAry forKey:key];
				}else{
					NSArray *modelAry = [objClass modelWithObjectArray:propertieObject];
					[model setValue:modelAry forKey:key];
				}
				
			}
			
				//对象是NSSet
			else if ([propertieObject isKindOfClass:[NSSet class]]){
				
				NSMutableArray *mAry = @[].mutableCopy;
				for (id setObj in (NSSet *)propertieObject) {
					[mAry addObject:setObj];
				}
				if (objClass) {
					NSArray *modelAry = [self modelWithObjectArray:mAry];
					[model setValue:modelAry forKey:key];
				}
			}
			
				//对象是基本数据类型
			else if ([propertieObject isKindOfClass:[NSNumber class]]){
				NSString *numStr = [NSString stringWithFormat:@"%@",objectDictionary[dicK]];
				[model setValue:numStr forKey:key];
			}
			
				//其他类型 String等 直接赋值
			else{
				[model setValue:objectDictionary[dicK] forKey:key];
			}
		}
	}
	return model;
}

	///对象Array 转 modelArray
+ (NSArray *)modelWithObjectArray:(NSArray *)objectArray{
		///如果检查到对象不是dic 则返回并提示
	if (![objectArray isKindOfClass:[NSArray class]]) {
		NSLog(@"⚠️ objectDictionary不是一个数组");
		return objectArray;
	}
	
	NSMutableArray *modelArray = [[NSMutableArray alloc] init];
	for (id object in objectArray) {
		
			//如果不是基础类 如UIColor ，UIView 等 则不做解析操作
		if (![object isClassFormFoundationClasses]) {
			NSLog(@"⚠️ 不能解析 %@",[object class]);
			continue;
		}
		
		if ([object isKindOfClass:[NSDictionary class]]) {
			[modelArray addObject:[self modelWithObjectDictionary:object]];
		}else if ([object isKindOfClass:[NSNull class]]){
			continue;
		}else if ([object isKindOfClass:[NSArray class]]){
			[modelArray addObject:[self modelWithObjectArray:object]];
		}else{
			NSString *numStr = [NSString stringWithFormat:@"%@",object];
			[modelArray addObject:numStr];
		}
	}
	return [modelArray copy];
}

	///通用模型转字典方法
- (id)objValues{
	if ([self isKindOfClass:[NSArray class]]) {
		return [self aryValues];
	}else{
		return [self dicValues];
	}
}

	///模型转字典
- (NSDictionary *)dicValues{
	if ([self isKindOfClass:[NSDictionary class]]) {
		return (NSDictionary *)self;
	}
	NSDictionary *keyValues = [self allPropertiesAndValue];
	NSMutableDictionary *modelViluesDic = [NSMutableDictionary dictionary];
	for (NSString *key in keyValues.allKeys) {
		
		id obj = keyValues[key];
		
		NSString *propertieName = [self.class replacedKeyFromPropertyName][key];
		if (propertieName==nil) {
			propertieName = key;
		}
		
		Class objClass = [self.class propertieClassInDictionary][key];
		if (!objClass) {
			objClass = [self.class propertieClassInDictionary][propertieName];
		}
		
		if ([obj isClassFormFoundationClasses]) {
				//对象是数组
			if ([obj isKindOfClass:[NSArray class]]) {
				[modelViluesDic setValue:[obj aryValues] forKey:propertieName];
			}
				//对象是字典
			else if ([obj isKindOfClass:[NSDictionary class]]){
				NSDictionary *modelDic = [obj dicValues];
				[modelViluesDic setValue:modelDic forKey:key];
			}
				//对象是基本数据类型
			else if ([obj isKindOfClass:[NSNumber class]]){
				NSString *numStr = [NSString stringWithFormat:@"%@",obj];
				[modelViluesDic setValue:numStr forKey:propertieName];
			}
				//对象是NSSet
			else if ([obj isKindOfClass:[NSSet class]]){
				NSMutableArray *mAry = @[].mutableCopy;
				for (id setObj in (NSSet *)obj) {
					[mAry addObject:setObj];
				}
				[modelViluesDic setValue:[mAry aryValues] forKey:propertieName];
			}
				//字符串
			else if ([obj isKindOfClass:[NSString class]]){
				[modelViluesDic setValue:obj forKey:propertieName];
			}
			else if (obj==nil){
				[modelViluesDic setValue:[NSNull null] forKey:propertieName];
			}
				//其他的当做字符串处理
			else{
				[modelViluesDic setValue:[NSString stringWithFormat:@"%@",obj] forKey:propertieName];
			}
		}else{
			if (objClass) {
				[modelViluesDic setValue:[obj dicValues] forKey:propertieName];
			}else{
				[modelViluesDic setValue:[NSNull null] forKey:propertieName];
			}
			
		}
	}
	return modelViluesDic.copy;
}
	///模型数组转字典数组
- (NSArray *)aryValues{
		///如果检查到对象不是数组 则返回并提示
	if (![self isKindOfClass:[NSArray class]]) {
		NSLog(@"⚠️ objectDictionary不是一个数组");
		return nil;
	}
	
	NSMutableArray *modelViluesArray = [NSMutableArray array];
	for (id obj in (NSArray *)self) {
		
		if ([obj isClassFormFoundationClasses]) {
			if ([obj isKindOfClass:[NSArray class]]){
				NSArray *array = [obj aryValues];
				[modelViluesArray addObject:array];
			}
				//对象是字典
			else if ([obj isKindOfClass:[NSDictionary class]]){
				NSDictionary *dic = [obj dicValues];
				[modelViluesArray addObject:dic];
			}
				//字符串
			else if ([obj isKindOfClass:[NSString class]]){
				[modelViluesArray addObject:obj];
			}
				//否则当做字符串处理
			else{
				[modelViluesArray addObject:[NSString stringWithFormat:@"%@",obj]];
			}
		}else{
			[modelViluesArray addObject:[obj dicValues]];
		}
		
	}
	
	return modelViluesArray.copy;
}

	///model中重写本方法，在本方法中return一个参数字典 表明某个属性对应的class
+ propertieClassInDictionary{return @{};}
	///model中重写本方法，替换关键属性名 如 id替换为ID
+ replacedKeyFromPropertyName{return @{};}

+ (instancetype)modelDataInFileName:(NSString *)fileName{
	
	id obj = [[NSUserDefaults standardUserDefaults] objectForKey:fileName];
	return [self parsingObj:obj];
}

- (BOOL)saveValuesInFileName:(NSString *)fileName{
	id obj = [self objValues];
	[[NSUserDefaults standardUserDefaults] setObject:obj forKey:fileName];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeObjInFileName:(NSString *)fileName{
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:fileName];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


@end
