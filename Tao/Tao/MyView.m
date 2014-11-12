//
//  MyView.m
//  Tao
//
//  Created by JD_Acorld on 14-9-3.
//  Copyright (c) 2014年 hxy. All rights reserved.
//

#import "MyView.h"
#import "ExceptionObject.h"
#import <objc/runtime.h>
@interface Test : ExceptionObject
//- (void)hello;
@end

@implementation Test

//- (void)hello
//{
//    NSLog(@"22 %@",@"");
//}

@end

@interface MyView ()
{
    Test *test;

}
@end

@implementation MyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();//注，像许多低级别的API，核心文本使用的Y翻转坐标系 更杯具的是，内容是也渲染的翻转向下！
    //手动翻转,注，每次使用可将下面三句话复制粘贴过去。必用
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //1,外边框。mac支持矩形和圆，ios仅支持矩形。本例中使用self.bounds作为path的reference
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, self.bounds);
    
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
    CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, self.attributedString.length), pathRef, NULL);
    CTFrameDraw(frameRef, context);
    CFRelease(frameRef);
    CFRelease(setterRef);
    CFRelease(pathRef);
    
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    IMP myIMP = imp_implementationWithBlock(^(id _self) {
        NSLog(@"block implementation!!!");
    });
    Class metaClass = object_getClass(self);
    class_addMethod(metaClass,sel,myIMP,"v@:");

    return YES;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self respondsToSelector:anInvocation.selector])
    {
        [self forwardingTargetForSelector:anInvocation.selector];
    }else
    {
        [anInvocation invokeWithTarget:test];
    }
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        test = [Test new];
        signature = [test methodSignatureForSelector:aSelector];
        
    }
    
    return signature;
}

@end

