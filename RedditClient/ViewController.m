//
//  ViewController.m
//  RedditClient
//
//  Created by Alex G on 21.10.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)authorize {
    // Read the manual
    // https://github.com/reddit/reddit/wiki/OAuth2
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.reddit.com/api/v1/authorize?"
                                                "client_id=nhFJDb_f9RYThw"
                                                "&response_type=code"
                                                "&state=RANDOM_STRING"
                                                "&redirect_uri=testredditclient://apiredirect"
                                                "&duration=permanent"
                                                "&scope=identity,account,read,subscribe,submit"]];
}

- (void)startUsage {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    XLog(@"%@", token);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://oauth.reddit.com/search?q=objective-c&limit=1&raw_json=1"]];
    [request setValue:[NSString stringWithFormat:@"%@ %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenType"], token] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"RedditClientTestiOS" forHTTPHeaderField:@"User-Agent"];
    XLog(@"%@", request.allHTTPHeaderFields);
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        XLog(@"%@", responseObject);
    }] resume];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    if (token) {
        [self startUsage];
    } else {
        [self authorize];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startUsage) name:@"OAuthTokenDidReceive" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
