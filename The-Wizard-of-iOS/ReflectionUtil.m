//
//  ReflectionUtil.h
//  The-Wizard-of-iOS
//
//  Created by Antonio Henrique C B S Araújo on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReflectionUtil.h"

@implementation ReflectionUtil

#pragma mark - Reflection and Introspection helpers

+ (NSDictionary *) dumpObjectInfo:(NSObject *) object {
    Class klass = [object class];
    u_int count;
    
    Ivar* ivars = class_copyIvarList(klass, &count);
    NSMutableArray* ivarArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        const char* ivarName = ivar_getName(ivars[i]);
        [ivarArray addObject:[NSString stringWithUTF8String:ivarName]];
    }
    free(ivars);
    
    objc_property_t* properties = class_copyPropertyList(klass, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++) {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithUTF8String:propertyName]];
    }
    free(properties);
    
    Method* methods = class_copyMethodList(klass, &count);
    NSMutableArray* methodArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        SEL selector = method_getName(methods[i]);
        const char* methodName = sel_getName(selector);
        [methodArray addObject:[NSString  stringWithUTF8String:methodName]];
    }
    free(methods);
    
    NSDictionary* classDump = [NSDictionary dictionaryWithObjectsAndKeys:
                               ivarArray, @"ivars",
                               propertyArray, @"properties",
                               methodArray, @"methods",
                               nil];
    
    return classDump;
}

NSString * property_getType(objc_property_t property) {
    
    const char *attributesCStr = property_getAttributes(property);
    NSString *attributes = [NSString stringWithUTF8String:attributesCStr];
    NSArray *components = [attributes componentsSeparatedByString:@","];
    
    if ([components count] > 0) {
        
        NSString *component = [components objectAtIndex:0];
        
        if ([component characterAtIndex:0] == 'T' && [component characterAtIndex:1] != '@') {
            return [component substringWithRange:NSMakeRange(1, [component length]-1)];
        } else if ([component characterAtIndex:0] == 'T' && [component characterAtIndex:1] == '@' && [component length] == 2) {
            return @"id";
        } else if ([component characterAtIndex:0] == 'T' && [component characterAtIndex:1] == '@') {
            return [component substringWithRange:NSMakeRange(3, [component length]-4)];
        }
        
    }
    
    return @"";
}

NSArray * class_getProperties(Class klass) {
    u_int count;
    objc_property_t* properties = class_copyPropertyList(klass, &count);
    NSMutableArray* propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++) {
        const char* propertyName = property_getName(properties[i]);
        [propertiesArray addObject:[NSString  stringWithUTF8String:propertyName]];
    }
    free(properties);
    return propertiesArray;
}

@end
