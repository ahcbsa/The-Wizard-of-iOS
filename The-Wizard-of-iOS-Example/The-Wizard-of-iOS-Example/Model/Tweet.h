//
//  Tweet.h
//  The-Wizard-of-iOS
//
//  Created by Antonio Henrique C B S Araújo on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AbstractModel.h"
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic) BOOL favorited;
@property (nonatomic) BOOL retweeted;
@property (nonatomic) NSInteger retweet_count;
@property (nonatomic, strong) NSNumber *id;

@end
