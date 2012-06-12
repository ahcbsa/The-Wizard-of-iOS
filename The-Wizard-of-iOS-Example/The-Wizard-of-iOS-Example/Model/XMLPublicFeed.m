//
//  XMLPublicFeed.m
//  oaSis2
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
    self = [super initWithUrl:@"https://api.twitter.com/1/statuses/public_timeline.xml?count=3&include_entities=true"];
    if (self) {
        
    }
    return self;
}

- (void) load {
    [super loadWithResponseDataType:XMLResponseDataType];
}

@end
