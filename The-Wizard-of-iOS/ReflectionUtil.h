//
//  ReflectionUtil.h
//  The-Wizard-of-iOS
//
//  Created by Antonio Henrique C B S Araújo on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface ReflectionUtil : NSObject

+ (NSDictionary *) dumpObjectInfo:(NSObject *) object;
NSString * property_getType(objc_property_t property);
SEL property_getSetter(objc_property_t property);
NSArray * class_getProperties(Class klass);

@end

