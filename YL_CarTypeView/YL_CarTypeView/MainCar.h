//
//  MainCar.h
//  CarIconDate
//
//  Created by AS150701001 on 16/3/11.
//  Copyright © 2016年 lele. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainCar : NSObject
@property(nonatomic,copy) NSString* name; // 名字
@property(nonatomic,copy) NSString* icon; // 图片
@property(nonatomic,strong) NSArray* subCars; // 每一类别是子数据

-(instancetype) initWithDict:(NSDictionary*)dict;
+(NSArray*) mainCars;

@end
