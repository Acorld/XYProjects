//
//  ExceptionObject.m
//  Tao
//
//  Created by JD_Acorld on 14-9-6.
//  Copyright (c) 2014年 hxy. All rights reserved.
//

#import "ExceptionObject.h"
#import <objc/runtime.h>
@implementation ExceptionObject

#pragma mark -
#pragma -mark ==== 动态添加方法(class_replaceMethod/class_addMethod) ====
#pragma mark -



void printParmsException(id self, SEL _cmd, NSString *desc)
{
    NSLog(@"<Exception>: parms:---->%@ ++++++ target---->(%@) cmd---->(%@)",desc,NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}

void printException(id self, SEL _cmd)
{
    NSLog(@"<Exception>: ++++++ target---->(%@) cmd---->(%@)",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}

/*
 IMP blockImp = imp_implementationWithBlock(^(id _self) {
 NSLog(@"block implementation!!!");
 });
 */

//无人响应的实例方法
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSString *selectorString = NSStringFromSelector(sel);
    NSRange range = [selectorString rangeOfString:@":"];
    if (range.location == NSNotFound)
    {
        class_addMethod([ExceptionObject class],sel , (IMP)printException, "v@:");
    }else
    {
        class_addMethod([ExceptionObject class],sel , (IMP)printParmsException, "v@:@");
    }
    return YES;
}

//无人响应的类方法
+ (BOOL)resolveClassMethod:(SEL)sel
{
    NSString *selectorString = NSStringFromSelector(sel);
    NSRange range = [selectorString rangeOfString:@":"];
    if (range.location == NSNotFound)
    {
        class_addMethod([ExceptionObject class],sel , (IMP)printException, "v@:");
    }else
    {
        class_addMethod([ExceptionObject class],sel , (IMP)printParmsException, "v@:@");
    }
    return YES;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *sig = [super methodSignatureForSelector:aSelector];
    if (nil == sig)
    {
        //其他消息转发
    }
    return sig;
}

#pragma mark -
#pragma -mark ==== 当某个对象不能接受某个selector时，将对该selector的调用转发给另一个对象 ====
#pragma mark -

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return NSStringFromSelector(aSelector);
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self respondsToSelector:anInvocation.selector])
    {
        [anInvocation invokeWithTarget:self];
    }else
    {
        //Other someone handle it
    }
}

@end
