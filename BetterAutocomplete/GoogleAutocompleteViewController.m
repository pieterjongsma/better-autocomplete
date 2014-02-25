//
//  GoogleAutocompleteViewController.m
//  BetterAutocomplete
//
//  Created by Pieter Jongsma on 01-02-13.
//  Copyright (c) 2013 Pieter Jongsma. All rights reserved.
//

#import "GoogleAutocompleteViewController.h"

#import "XPathQuery.h"


@interface GoogleAutocompleteViewController ()

// Initialization
- (void)setup;

// Interface
- (void)dismissSearchBar;

// Google Suggestion API
- (void)getSuggestionsForQuery:(NSString *)query;
- (NSURL *)suggestionURLForQuery:(NSString *)query;

// Google Search API
- (NSURL *)searchURLForQuery:(NSString *)query;

// Keyboard
- (void)keyboardWillChange:(NSNotification *)notification;

@end


@implementation GoogleAutocompleteViewController {
    dispatch_queue_t _requestQueue;
}

@synthesize searchBar;
@synthesize suggestionsTableView;
@synthesize resultsView;

#pragma mark - Initialization

- (id)init
{
    if ((self = [super init])) {
        [self setup];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _requestQueue = dispatch_queue_create("com.pieterjongsma.betterautocomplete.suggestions", NULL);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.resultsView.scrollView.delegate = self;
}

#pragma mark - Interface

- (void)dismissSearchBar
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - Query

- (void)setQuery:(NSString *)query
{
    [super setQuery:query];
    [self.searchBar setText:query];
}

#pragma mark - Suggestions

- (void)suggestWithQuery:(NSString *)query
{
    [super suggestWithQuery:query];
    [self getSuggestionsForQuery:query];
    self.suggestionsTableView.hidden = NO;
}

#pragma mark - Search

- (void)searchWithQuery:(NSString *)query
{
    [super searchWithQuery:query];
    self.suggestionsTableView.hidden = YES;
    
    NSURL *url = [self searchURLForQuery:query];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.resultsView loadRequest:request];
}

#pragma mark - Google Suggestion API

- (void)getSuggestionsForQuery:(NSString *)query
{
    // This could do with some mechanism to discard outdated requests, i.e. when a newer request has finished earlier
    dispatch_async(_requestQueue, ^{
        NSURL *url = [self suggestionURLForQuery:query];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSArray *results = PerformXMLXPathQuery(data, @"/toplevel/CompleteSuggestion/suggestion");
        
        NSMutableArray *suggestions = [NSMutableArray arrayWithCapacity:[results count]];
        for (NSDictionary *result in results) {
            NSArray *attributes = [result objectForKey:@"nodeAttributeArray"];
            for (NSDictionary *attribute in attributes) {
                if ([[attribute objectForKey:@"attributeName"] isEqualToString:@"data"])
                    [suggestions addObject:[attribute objectForKey:@"nodeContent"]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.suggestions = suggestions;
            [self.suggestionsTableView reloadData];
        });
    });
}

- (NSURL *)suggestionURLForQuery:(NSString *)query
{
    NSString *queryEscaped = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://suggestqueries.google.com/complete/search?output=toolbar&hl=en&q=%@", queryEscaped];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

#pragma mark - Google Search API

- (NSURL *)searchURLForQuery:(NSString *)query
{
    NSString *queryEscaped = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://www.google.com/search?hl=en&q=%@", queryEscaped];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

#pragma mark - Keyboard

- (void)keyboardWillChange:(NSNotification *)notification
{
    CGRect newFrame;
    [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&newFrame];
    
    NSNumber *animationDuration;
    [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];

    [UIView animateWithDuration:[animationDuration doubleValue] animations:^{
        self.suggestionsTableView.frame = CGRectMake(0., 64., 320., newFrame.origin.y - 64.); // 64 = status bar + navigation bar
    } completion:NULL];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self queryChanged:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self dismissSearchBar];
    [self searchWithQuery:self.searchBar.text];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.resultsView.scrollView) {
        // Extra check whether it was the user that scrolled. Loading a webpage can also trigger this method
        // The couple pixel margin seems necessary. I admit this is a bit of a hack
        if (scrollView.contentOffset.y > 3.0 || scrollView.contentOffset.x > 3.0)
            [self dismissSearchBar];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView == self.resultsView.scrollView)
        [self dismissSearchBar];
}

@end
