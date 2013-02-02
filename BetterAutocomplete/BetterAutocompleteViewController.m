//
//  BetterAutocompleteViewController.m
//  BetterAutocomplete
//
//  Created by Pieter Jongsma on 01-02-13.
//  Copyright (c) 2013 Pieter Jongsma. All rights reserved.
//

#import "BetterAutocompleteViewController.h"


@interface BetterAutocompleteViewController ()

@end


@implementation BetterAutocompleteViewController

@synthesize suggestions;

#pragma mark - Query

- (void)setQuery:(NSString *)query
{
   // This method is for superclasses to overwrite
}

- (void)queryChanged:(NSString *)newQuery
{
    NSLog(@"Query changed: %@", newQuery);
    [self suggestWithQuery:newQuery];
}

#pragma mark - Suggestions

- (void)suggestWithQuery:(NSString *)query
{
    NSLog(@"Suggest with query: %@", query);
}

#pragma mark - Search

- (void)searchWithQuery:(NSString *)query
{
    NSLog(@"Search with query: %@", query);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.suggestions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get a cell
    NSString *identifier = @"suggestionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    // Set content to cell
    cell.textLabel.text = [self.suggestions objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Immediately deselect the cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Perform the search
    NSString *selectedSuggestion = [self.suggestions objectAtIndex:indexPath.row];
    [self setQuery:[NSString stringWithFormat:@"%@ ", selectedSuggestion]]; // Insert a space after the suggestion
    [self searchWithQuery:selectedSuggestion];
}

@end
