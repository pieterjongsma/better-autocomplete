//
//  MainViewController.m
//  BetterAutocomplete
//
//  Created by Pieter Jongsma on 01-02-13.
//  Copyright (c) 2013 Pieter Jongsma. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController ()

@end


@implementation MainViewController

@synthesize googleAutocompleteViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.searchBar becomeFirstResponder];
}

@end
