//
//  YLPBusiness.m
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

#import "YLPBusiness.h"

@implementation YLPBusiness

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if(self = [super init]) {
        _identifier = attributes[@"id"];
        _name = attributes[@"name"];
        _rating = [NSString stringWithFormat:@"%@", attributes[@"rating"]];
        _reviewCount = [NSString stringWithFormat:@"%@", attributes[@"review_count"]];
        NSURL *imageURL = [NSURL URLWithString:attributes[@"image_url"]];
        NSData *imagedata = [NSData dataWithContentsOfURL:imageURL];
        _image = [UIImage imageWithData:imagedata];

        NSArray *categories = [attributes valueForKey:@"categories"];
        NSMutableArray *stringCategories = [NSMutableArray new];
        for (NSDictionary *category in categories) {
            [stringCategories addObject:[category valueForKey:@"title"]];
        }

        _categories = stringCategories;

        double distance = ((NSString*)attributes[@"distance"]).doubleValue;
        _distance = [NSString stringWithFormat:@"%.0f", distance];

        _price = attributes[@"price"];

        _alias = attributes[@"alias"];
    }
    
    return self;
}

@end
