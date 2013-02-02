//
//  GoogleAutocompleteViewController.h
//  BetterAutocomplete
//
//  Created by Pieter Jongsma on 01-02-13.
//  Copyright (c) 2013 Pieter Jongsma. All rights reserved.
//

#import "BetterAutocompleteViewController.h"


@interface GoogleAutocompleteViewController : BetterAutocompleteViewController <UISearchBarDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *suggestionsTableView;
@property (nonatomic, weak) IBOutlet UIWebView *resultsView;

@end
