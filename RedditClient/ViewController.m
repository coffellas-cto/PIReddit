//
//  ViewController.m
//  RedditClient
//
//  Created by Alex G on 21.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import "ViewController.h"
#import "PIRedditNetworking.h"
#import "PIRedditListing.h"
#import "PIRedditLink.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)authorize {
    
}

- (void)startUsage {
    [[PIRedditNetworking sharedInstance] searchFor:@"confused travolta" limit:1 completion:^(NSError *error, PIRedditListing *listing) {
        NSString *message;
        if (error) {
            message = error.localizedDescription;
        } else {
            PIRedditLink *link = GDDynamicCast(listing.children.firstObject, PIRedditLink);
            message = link.title;
        }
        
        [[[UIAlertView alloc] initWithTitle:@"Result" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startUsage) name:@"reddit_authorized" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
