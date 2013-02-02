//
//  MainViewController.h
//  BetterAutocomplete
//
//  Created by Pieter Jongsma on 01-02-13.
//  Copyright (c) 2013 Pieter Jongsma. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GoogleAutocompleteViewController.h"


@interface MainViewController : UIViewController

@property (nonatomic, strong) IBOutlet GoogleAutocompleteViewController *googleAutocompleteViewController;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

@end
