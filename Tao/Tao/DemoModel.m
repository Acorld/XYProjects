//
//  DemoModel.m
//  Tao
//
//  Created by JD_Acorld on 14-9-10.
//  Copyright (c) 2014年 hxy. All rights reserved.
//

#import "DemoModel.h"
#import <objc/runtime.h>

//#define TypeOne

@interface DemoModel ()
@property (nonatomic,strong) NSMutableDictionary *data;
@end

@implementation DemoModel
@dynamic userID,userName,sex;

+ (id)model
{
    DemoModel *model = [[self alloc] init];
    return model;
}

+ (id)modelWithDic:(NSDictionary *)dic
{
    DemoModel *model = [[self alloc] init];
#ifdef TypeOne
    [model setDictionary:dic];
#else
    model.data = [dic mutableCopy];
#endif
    return model;
}

- (void)setDictionary:(NSDictionary *)dic
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        id propertyValue = dic[propertyName];
        if (propertyValue)
        {
            [self setValue:propertyValue forKey:propertyName];
        }
    }
    free(properties);
}

#pragma mark -
#pragma -mark ==== Add method ====
#pragma mark -

id autoDictionaryGetter(id self, SEL _cmd)
{
    // Get the backing store from the object
    DemoModel *typedSelf = (DemoModel *)self;
    NSMutableDictionary *backingStore = typedSelf.data;
    
    // The key is simply the selector name
    NSString *key = NSStringFromSelector(_cmd);
    
    // Return the value
    return [backingStore objectForKey:key];
}

void autoDictionarySetter(id self, SEL _cmd, id value)
{
    // Get the backing store from the object
    DemoModel *typedSelf = (DemoModel *)self;
    NSMutableDictionary *backingStore = typedSelf.data;
    
    /** The selector will be for example, "setOpaqueObject:".
     *  We need to remove the "set", ":" and lowercase the first
     *  letter of the remainder.
     */
    NSString *selectorString = NSStringFromSelector(_cmd);
    NSMutableString *key = [selectorString mutableCopy];
    
    // Remove the ':' at the end
    [key deleteCharactersInRange:NSMakeRange(key.length - 1, 1)];
    
    // Remove the 'set' prefix
    [key deleteCharactersInRange:NSMakeRange(0, 3)];
    
    // Lowercase the first character
    NSString *lowercaseFirstChar =
    [[key substringToIndex:1] lowercaseString];
    [key replaceCharactersInRange:NSMakeRange(0, 1)
                       withString:lowercaseFirstChar];
    
    if (value)
    {
        [backingStore setObject:value forKey:key];
    } else
    {
        [backingStore removeObjectForKey:key];
    }
}

+ (BOOL)resolveInstanceMethod:(SEL)selector
{
    NSString *selectorString = NSStringFromSelector(selector);
    if ([selectorString hasPrefix:@"set"])
    {
        class_addMethod(self,selector,(IMP)autoDictionarySetter,"v@:@");
    } else
    {
        class_addMethod(self, selector,(IMP)autoDictionaryGetter,"@@:");
    }
    return YES;
}

#pragma mark -
#pragma -mark ==== Description ====
#pragma mark -

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: --->userName:%@ userID:%@ sex:%@ ",NSStringFromClass([self class]),self.userName,self.userID,[self.sex intValue] > 0 ? @"男" : @"女"];
}

@end
