////
////  YLPPrice.m
////  ios-code-challenge
////
////  Created by Alfredo Merino on 2/17/20.
////  Copyright © 2020 Dustin Lange. All rights reserved.
////
//
//#import "YLPPrice.h"
//
//@implementation YLPPrice : NSObject
//+ (NSDictionary<NSString *, YLPPrice *> *)values
//{
//    static NSDictionary<NSString *, YLPPrice *> *values;
//    return values = values ? values : @{
//        @"$$": [[YLPPrice alloc] initWithValue:@"$$"],
//        @"$": [[YLPPrice alloc] initWithValue:@"$"],
//    };
//}
//
//+ (YLPPrice *)empty { return YLPPrice.values[@"$$"]; }
//+ (YLPPrice *)price { return YLPPrice.values[@"$"]; }
//
//+ (instancetype _Nullable)withValue:(NSString *)value
//{
//    return YLPPrice.values[value];
//}
//
//- (instancetype)initWithValue:(NSString *)value
//{
//    if (self = [super init]) _value = value;
//    return self;
//}
//
//- (NSUInteger)hash { return _value.hash; }
//@end
