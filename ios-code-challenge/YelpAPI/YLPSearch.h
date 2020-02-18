//
//  YLPSearch.h
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

@import Foundation;

@class YLPBusiness;

NS_ASSUME_NONNULL_BEGIN

@interface YLPSearch : NSObject

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, readonly) NSArray<YLPBusiness *> *businesses;
@property (nonatomic, readonly) NSUInteger total;


@end

NS_ASSUME_NONNULL_END
