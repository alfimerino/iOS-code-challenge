//
//  YLPSearchQuery.h
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface YLPSearchQuery : NSObject

- (instancetype)initWithLocation:(NSString *)location;
- (NSDictionary *)parameters;

@property (nonatomic, copy, nullable) NSString *term;

@property (nonatomic, copy, null_resettable) NSArray<NSString *> *categoryFilter;

@property (nonatomic, assign) double radiusFilter;

@property (nonatomic, assign) int limit;

@property (nonatomic, assign) NSString *sortBy; // Added to take in parameter to sort search results by.

@property (nonatomic, assign) int offset; // Added to take in value to offset by.

@end

NS_ASSUME_NONNULL_END
