//
//  ViewController.m
//  Tao
//
//  Created by JD_Acorld on 14-7-30.
//  Copyright (c) 2014年 hxy. All rights reserved.
//

#import "ViewController.h"
#import "MyView.h"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
@interface NSTimer (EOCBlocksSupport)
+ (id)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                     block:(void(^)())block
                                   repeats:(BOOL)repeats;
@end

@implementation NSTimer (EOCBlocksSupport)
+ (id)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                     block:(void(^)())block
                                   repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(eoc_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}
+ (void)eoc_blockInvoke:(NSTimer*)timer {
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}
@end



@interface MyTimer : NSTimer

@end

@implementation MyTimer

- (void)dealloc
{
    NSLog(@"22 %@",@"");
}

@end

@interface ViewController ()<UIAlertViewDelegate>
{
    MyTimer *timer_;
}
@end

#import "DemoModel.h"
#import "RTLabel.h"

NSString *const myName = @"hello!!!";
static const void *AC_AlertKey = @"alertView";
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    objc_msgSend(self,@selector(testAssociateObject));
    DemoModel *model = [DemoModel modelWithDic:@{@"userName": @"11111",@"sex": @(1),@"userID": @"22"}];
    NSLog(@"model %@",model);
    
    model.userName = @"ceshi";
    model.userID = @"00000";
    model.sex = @(0);
    NSLog(@"model %@",model.description);
    
    NSMutableArray *array = [NSMutableArray new];
    NSNumber *number = [[NSNumber alloc] initWithInt:1];
    [array addObject:number];
//    timer_ = [MyTimer eoc_scheduledTimerWithTimeInterval:2 block:^{
//        NSLog(@"11111 %@",@"");
//    } repeats:YES];
//    [self testAssociateObject];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSMutableAttributedString *mabstring = [[NSMutableAttributedString alloc]initWithString:@"This is a test of characterAttribute. 中文字符"];
    CTFontRef ref = CTFontCreateWithName(CFSTR("Georgia"), 20, NULL);
    [mabstring addAttribute:(id)kCTFontAttributeName value:(__bridge id)ref range:NSMakeRange(mabstring.length - 4, 4)];
    
    
    RTLabel *label = [[RTLabel alloc] initWithFrame:(CGRect){10,100,300,10}];
    label.text = @"<p>Some <b>HTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTML</b>  <img src='1.png' width=30 height=30/> </p>";
    CGSize optimumSize = [label optimumSize];
    label.frame = (CGRect){label.frame.origin,label.bounds.size.width,optimumSize.height};
    [self.view addSubview:label];
    [label setCenter:self.view.center];
    
//    MyView *view = [[MyView alloc] initWithFrame:(CGRect){0,0,200,100}];
//    [view setAttributedString:mabstring];
//    [self.view addSubview:view];
//    [view setCenter:self.view.center];
//    
//    
//    NSNumber *table = (UITableView *)view;
//    [MyView test];
}

- (void)testAssociateObject
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test" message:@"hello" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    void (^ClickBlock)(BOOL isClickYes) = ^(BOOL isClickYes){
        NSLog(@"YES:%@",isClickYes ? @"YES" : @"NO");
    };
    objc_setAssociatedObject(alert, AC_AlertKey, ClickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [alert show];
}

#pragma mark -
#pragma -mark ==== UIAlertViewDelegate ====
#pragma mark -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^ClickBlock)(BOOL) = objc_getAssociatedObject(alertView, AC_AlertKey);
    ClickBlock(buttonIndex==1 ? YES : NO);
    objc_removeAssociatedObjects(alertView);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
