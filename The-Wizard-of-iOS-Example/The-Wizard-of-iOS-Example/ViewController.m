//
//  ViewController.m
//  The-Wizard-of-iOS-Example
//
//  Created by Antonio Henrique C B S Araújo on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#import "JSONPublicFeed.h"
#import "XMLPublicFeed.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - IBAction methods

- (IBAction)loadContentButtonTapped:(id)sender {
    [self loadContent];
}

#pragma mark - Abstract model loading method

- (void) loadContent {
    //JSON public twitter feed loading
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JSONPublicFeed *jsonPublicFeed = [[JSONPublicFeed alloc] init];
        [jsonPublicFeed load];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"JSON MODEL OUTPUT");
            NSLog(@"TOTAL COUNT: %d", [jsonPublicFeed.list count]);
            NSLog(@"-----------------------------------------------");
            
//            for (Tweet *tweet in jsonPublicFeed.list) {
//                
//                NSLog(@"USER ID: %@", tweet.user.id);
//                NSLog(@"USER NAME: %@", tweet.user.name);
//                NSLog(@"USER SCREEN NAME: %@", tweet.user.screen_name);
//                NSLog(@"USER PROFILE USE BACKGROUND IMAGE: %@", tweet.user.profile_image_url ? @"YES" : @"NO");
//                NSLog(@"ID: %@", tweet.id);
//                NSLog(@"TEXT: %@", tweet.text);
//                NSLog(@"FAVORITED: %@", tweet.favorited ? @"YES" : @"NO");
//                NSLog(@"RETWEETED: %@", tweet.retweeted ? @"YES" : @"NO");
//                NSLog(@"RETWEET COUNT: %d", tweet.retweet_count);
//                NSLog(@"CREATED AT: %@", tweet.created_at);
//                NSLog(@"-----------------------------------------------");
//                
//            }
            
        });
        
    });
    
    //XML public twitter feed loading
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        XMLPublicFeed *xmlPublicFeed = [[XMLPublicFeed alloc] init];
        [xmlPublicFeed load];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"XML MODEL OUTPUT");
            NSLog(@"TOTAL COUNT: %d", [xmlPublicFeed.statuses count]);
            NSLog(@"-----------------------------------------------");
            
//            for (Tweet *tweet in xmlPublicFeed.statuses) {
//                
//                NSLog(@"USER ID: %@", tweet.user.id);
//                NSLog(@"USER NAME: %@", tweet.user.name);
//                NSLog(@"USER SCREEN NAME: %@", tweet.user.screen_name);
//                NSLog(@"USER PROFILE USE BACKGROUND IMAGE: %@", tweet.user.profile_image_url ? @"YES" : @"NO");
//                NSLog(@"ID: %@", tweet.id);
//                NSLog(@"TEXT: %@", tweet.text);
//                NSLog(@"FAVORITED: %@", tweet.favorited ? @"YES" : @"NO");
//                NSLog(@"RETWEETED: %@", tweet.retweeted ? @"YES" : @"NO");
//                NSLog(@"RETWEET COUNT: %d", tweet.retweet_count);
//                NSLog(@"CREATED AT: %@", tweet.created_at);
//                NSLog(@"-----------------------------------------------");
//                
//            }
            
        });
        
    });
}

@end
