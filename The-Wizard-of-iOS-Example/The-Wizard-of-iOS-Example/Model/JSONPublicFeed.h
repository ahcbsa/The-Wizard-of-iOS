//
//  TwitterFollowers.h
//  oaSis2
//
//  Created by Antonio Henrique C B S Araújo on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AbstractModel.h"
#import "Tweet.h"

@interface JSONPublicFeed : AbstractModel <AbstractModelPropertyChildrenClassDelegate> {
    
}

@property (nonatomic, strong) NSArray *list;

- (void) load;

@end
