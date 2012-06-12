//
//  XMLPublicFeed.h
//  The-Wizard-of-iOS
//
//  Created by Antonio Henrique C B S Araújo on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AbstractModel.h"

#import "Tweet.h"

@interface XMLPublicFeed : AbstractModel <AbstractModelPropertyChildrenClassDelegate> {
    
}

@property (nonatomic, strong) NSArray *statuses;

- (void) load;

@end
