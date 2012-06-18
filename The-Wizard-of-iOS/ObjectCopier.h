//
//  ObjectCopier.h
//  The-Wizard-of-iOS-Example
//
//  Created by Antonio Henrique C B S Araújo on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AbstractModel;

@interface ObjectCopier : NSObject

+ (void) copyObject:(AbstractModel *) sourceObject toObject:(AbstractModel *) destinationObject;

@end
