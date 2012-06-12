//
//  JSONModelReflector.h
//  The-Wizard-of-iOS
//
//  Created by Antonio Henrique C B S Araújo on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AbstractModel.h"

@interface JSONModelReflector : NSObject

+ (void) reflectJSONWithObject:(NSObject *) object andContentData:(NSData *) contentData;

@end
