//
//  ObjectCopier.m
//  The-Wizard-of-iOS-Example
//
//  Created by Antonio Henrique C B S Araújo on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObjectCopier.h"

#import "AbstractModel.h"
#import "ReflectionUtil.h"

@implementation ObjectCopier

+ (void) copyObject:(AbstractModel *) sourceObject toObject:(AbstractModel *) destinationObject {
    
    NSArray *sourceObjectClassProperties = class_getProperties([sourceObject class]);
    for (NSString *propertyName in sourceObjectClassProperties) {
        [destinationObject setValue:[sourceObject valueForKey:propertyName] forKey:propertyName];
    }
    
}

@end
