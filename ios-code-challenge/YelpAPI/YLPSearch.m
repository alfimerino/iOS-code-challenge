//
//  YLPSearch.m
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

#import "YLPSearch.h"
#import "YLPBusiness.h"

@implementation YLPSearch

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init]) {
        _total = [attributes[@"total"] unsignedIntegerValue];
        _businesses = [self.class businessesFromJSONArray:attributes[@"businesses"]];
        
    }
    
    return self;
}

+ (NSArray *)businessesFromJSONArray:(NSArray *)businessesJSON
{
    NSMutableArray<YLPBusiness *> *mutableBusinessesJSON = [[NSMutableArray alloc] init];
    
    for (NSDictionary *business in businessesJSON) {
        [mutableBusinessesJSON addObject:[[YLPBusiness alloc] initWithAttributes:business]];
    }
    
    return mutableBusinessesJSON;
}

@end
