//
//  JSONPublicFeed.m
//  The-Wizard-of-iOS
//
//  Created by Antonio Henrique C B S Araújo on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONPublicFeed.h"

@implementation JSONPublicFeed

@synthesize list;

- (Class) childrenClassForPropertyWithName:(NSString *) propertyName {
    
    if ([propertyName isEqualToString:@"list"]) {
        
        return [Tweet class];
        
    }
    
    return nil;
    
}

- (id) init {
    
    self = [super initWithUrl:@"https://dl.dropboxusercontent.com/u/5044205/twitter_public_timeline.json" andCacheDuration:60];
    
    if (self) {
        
    }
    
    return self;
    
}

- (void) load {
    
    [super loadWithResponseDataType:JSONResponseDataType];
    
}

@end
