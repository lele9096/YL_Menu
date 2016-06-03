//
//  MainCar.m
//  CarIconDate
//
//  Created by AS150701001 on 16/3/11.
//  Copyright © 2016年 lele. All rights reserved.
//

#import "MainCar.h"
@implementation MainCar

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self=[super init];
    if (self) {
        self.name=dict[@"name"];
        self.icon=dict[@"icon"];
        self.subCars=dict[@"subCars"];
    }
    return self;
}

+(NSArray*) mainCars
{
    NSString* path=[[NSBundle mainBundle] pathForResource:@"Cars.plist" ofType:nil];
    NSArray* arr=[NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray* arrM=[NSMutableArray array];
    
    for (NSDictionary* dict in arr) {
        MainCar* model=[[MainCar alloc] initWithDict:dict];
        [arrM addObject:model];
    }
    return arrM;
}

@end
