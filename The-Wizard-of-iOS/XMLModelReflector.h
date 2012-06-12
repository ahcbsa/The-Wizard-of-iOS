//
//  XMLModelReflector.h
//  oaSis2
//
//  Created by Antonio Henrique C B S Araújo on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AbstractModel.h"

@interface XMLModelReflector : NSObject

+ (void) reflectXMLWithObject:(NSObject *) object andContentData:(NSData *) contentData;

@end
