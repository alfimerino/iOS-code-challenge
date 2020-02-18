//
//  YLPBusiness+CellForObject.m
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

#import "YLPBusiness+CellForObject.h"
#import "ios_code_challenge-Swift.h"


NSString *const kNXTBusinessTableViewCellIdentifier = @"NXTBusinessTableViewCellIdentifier";

@implementation YLPBusiness (CellForObject)

#pragma mark - NXTCellForObjectDelegate
- (id<NXTBindingDataForObjectDelegate>)cellForObjectForTableView:(id)tableView
{
    id<NXTBindingDataForObjectDelegate> cell = [tableView dequeueReusableCellWithIdentifier:kNXTBusinessTableViewCellIdentifier];

    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NXTBusinessTableViewCell class])
                                              owner:nil
                                            options:nil] firstObject];
    }

    return cell;
}

- (CGFloat)estimatedCellHeightForObjectForTableView:(UITableView *)tableView
{
    return 120.0f;
}

@end
