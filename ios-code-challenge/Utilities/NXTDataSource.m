//
//  NXTDataSource.m
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/20/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

#import "NXTDataSource.h"
#import "NXTCellForObjectDelegate.h"
#import "NXTBindingDataForObjectDelegate.h"
#import "ios_code_challenge-Swift.h"

@interface NXTDataSource()

@property (nonatomic, strong) NSMutableArray *mutableObjects;
    
@end

@implementation NXTDataSource
    
- (instancetype)initWithObjects:(NSArray *)objects
{
    if(self = [super init]) {
        _mutableObjects = [NSMutableArray arrayWithArray:objects];
    }
    
    return self;
}
    
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mutableObjects count];
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<NXTCellForObjectDelegate> object = self.mutableObjects[indexPath.row];
    return [object estimatedCellHeightForObjectForTableView:tableView];
}
    
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<NXTCellForObjectDelegate> object = self.mutableObjects[indexPath.row];
    return [object estimatedCellHeightForObjectForTableView:tableView];
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<NXTCellForObjectDelegate> object = self.mutableObjects[indexPath.row];
    id<NXTBindingDataForObjectDelegate> cell = [object cellForObjectForTableView:tableView];
    
    [cell bindingDataForObject:object];
    
    return (UITableViewCell *)cell;
}
    
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(id<NXTBindingDataForObjectDelegate>)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableViewWillDisplay(indexPath);

    if([cell respondsToSelector:@selector(willDisplayCellForObject:)]) {
        id<NXTCellForObjectDelegate> object = self.mutableObjects[indexPath.row];
        
        [cell willDisplayCellForObject:object];
    }
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = self.mutableObjects[indexPath.row];
    
    if(self.tableViewDidSelectCell) {
        self.tableViewDidSelectCell(object);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
    
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    id object = self.mutableObjects[indexPath.row];
    
    if(self.tableViewDidSelectAccessoryView) {
        self.tableViewDidSelectAccessoryView(object);
    }
}
    
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.tableViewDidScroll) {
        self.tableViewDidScroll();
    }
}
    
#pragma mark - Getters & Setters
- (void)setObjects:(NSArray *)objects
{
    [self.mutableObjects setArray:objects];
}
    
- (void)appendObjects:(NSArray *)objects
{
    [self.mutableObjects addObjectsFromArray:objects];
    
    if(self.tableViewDidReceiveData) {
        self.tableViewDidReceiveData();
    }
}
    
- (void)insertObject:(id)object atIndex:(NSUInteger)index
{
    [self.mutableObjects insertObject:object atIndex:index];
}
    
- (void)removeAllObjects
{
    [self.mutableObjects removeAllObjects];
    
    if(self.tableViewDidReceiveData) {
        self.tableViewDidReceiveData();
    }
}
    
- (void)removeObject:(id)object
{
    [self.mutableObjects removeObject:object];
}
    
- (NSArray *)objects
{
    return self.mutableObjects;
}
    
#pragma mark - Properties
- (NSMutableArray *)mutableObjects
{
    if(_mutableObjects == nil) {
        _mutableObjects = [NSMutableArray array];
    }
    
    return _mutableObjects;
}

@end
