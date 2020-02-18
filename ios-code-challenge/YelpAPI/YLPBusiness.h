//
//  YLPBusiness.h
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "YLPPrice.h"
NS_ASSUME_NONNULL_BEGIN

@interface YLPBusiness : NSObject


- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, readonly, copy) NSString *identifier;
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *rating;
@property (nonatomic, readonly, copy) NSString *reviewCount;
@property (nonatomic, readonly, copy) NSString *distance;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly, copy) NSString *price;
@property (nonatomic, readonly, copy) NSArray<NSString*> *categories;
@property (nonatomic, readonly, copy) NSString *alias;

@end

NS_ASSUME_NONNULL_END
