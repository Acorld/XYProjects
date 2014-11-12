//
//  DemoModel.h
//  Tao
//
//  Created by JD_Acorld on 14-9-10.
//  Copyright (c) 2014年 hxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemoModel : NSObject

@property (nonatomic, copy  ) NSString *userName;
@property (nonatomic, strong) NSNumber *sex;
@property (nonatomic, copy  ) NSString *userID;


/**
 *  根据字典，初始化属性值
 *
 *  @param dic
 *
 *  @return
 */
+ (id)modelWithDic:(NSDictionary *)dic;

/**
 *  初始化，不赋值
 *
 *  @return
 */
+ (id)model;

@end
