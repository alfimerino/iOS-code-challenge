//
//  NXTDataSource.h
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/20/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface NXTDataSource : NSObject <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

- (instancetype)initWithObjects:(NSArray *)objects;
    
- (void)setObjects:(NSArray *)objects;
- (void)appendObjects:(NSArray *)objects;
- (void)insertObject:(id)object atIndex:(NSUInteger)index;
- (void)removeAllObjects;
- (void)removeObject:(id)object;
    
@property (nonatomic, readonly) NSArray *objects;
@property (nonatomic, copy) void(^tableViewDidReceiveData)(void);
@property (nonatomic, copy) void(^tableViewDidSelectCell)(id object);
@property (nonatomic, copy) void(^tableViewDidSelectAccessoryView)(id object);
@property (nonatomic, copy) void(^tableViewDidScroll)(void);
@property (nonatomic, copy) void(^tableViewWillDisplay)(id indexPath);
    
@end
