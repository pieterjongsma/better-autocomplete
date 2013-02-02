//
//  BetterAutocompleteViewController.h
//  BetterAutocomplete
//
//  Created by Pieter Jongsma on 01-02-13.
//  Copyright (c) 2013 Pieter Jongsma. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BetterAutocompleteViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *suggestions;

// Query
- (void)setQuery:(NSString *)query;
- (void)queryChanged:(NSString *)newQuery;

// Suggestions
- (void)suggestWithQuery:(NSString *)query;

// Search
- (void)searchWithQuery:(NSString *)query;

@end
