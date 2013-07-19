//
//  XMLPublicFeed.m
//  The-Wizard-of-iOS
//
//  Created by Antonio Henrique C B S Araújo on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLPublicFeed.h"

@implementation XMLPublicFeed

@synthesize statuses;

- (Class) childrenClassForPropertyWithName:(NSString *) propertyName {
    
    if ([propertyName isEqualToString:@"statuses"]) {
        
        return [Tweet class];
        
    }
    
    return nil;
    
}

- (id) init {
    
    self = [super initWithUrl:@"https://dl.dropboxusercontent.com/u/5044205/twitter_public_timeline.xml"];
    
    if (self) {
        
    }
    
    return self;
    
}

- (void) load {
    
    [super loadWithResponseDataType:XMLResponseDataType];
    
}

@end
