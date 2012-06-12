//
//  JSONModelReflector.m
//  The-Wizard-of-iOS
//
//  Created by Antonio Henrique C B S Araújo on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONModelReflector.h"
#import "ReflectionUtil.h"

#define kJSONRootArrayName @"list"

@implementation JSONModelReflector

#pragma mark - JSON methods

+ (void) reflectJSONWithObject:(NSObject *) object andContentData:(NSData *)contentData {
            
    @autoreleasepool {
        
        NSError *error = nil;
        id jsonResponse = [NSJSONSerialization JSONObjectWithData:contentData options:kNilOptions error:&error];
        
        if (!error) {
            
            if ([jsonResponse isKindOfClass:[NSDictionary class]]) {
                
                [self reflectJSONObject:jsonResponse withObject:object];
                
            } else if ([jsonResponse isKindOfClass:[NSArray class]]) {
                
                [self reflectJSONArray:jsonResponse withObject:object];
                
            }
            
        }
        
    }
        
}

+ (void) reflectJSONObject:(NSDictionary *) JSONObject withObject:(NSObject *) object {
    
    Class objectClass = [object class];
    
    for (NSString *name in JSONObject) {
        
        objc_property_t property = class_getProperty(objectClass, [name UTF8String]);
        
        if (property != NULL) {

            NSString *propertyType = property_getType(property);
            Class propertyClass = NSClassFromString(propertyType);
            
            if (propertyClass == [NSArray class] || [propertyClass isSubclassOfClass:[NSArray class]]) {
                
                [self processArrayProperty:property withObject:object andJSONArray:[JSONObject objectForKey:name]];
                
            } else {
                
                [self processSingleProperty:property withObject:object JSONObject:[JSONObject objectForKey:name] andNodeName:name];
                
            }
            
        }
        
    }
    
}

+ (void) reflectJSONArray:(NSArray *) JSONArray withObject:(NSObject *) object {
    
    Class objectClass = [object class];
    objc_property_t property = class_getProperty(objectClass, [kJSONRootArrayName UTF8String]);
    
    if (property != NULL) {
        
        [self processArrayProperty:property withObject:object andJSONArray:JSONArray];
        
    }
    
}

+ (void) processSingleProperty:(objc_property_t) property withObject:(NSObject *) object JSONObject:(id) JSONObject andNodeName:(NSString *) nodeName {
                
    NSString *propertyType = property_getType(property);
    Class propertyClass = NSClassFromString(propertyType);
    
    BOOL isString = ((propertyClass == [NSString class]) || [propertyClass isSubclassOfClass:[NSString class]]);
    NSString *booleanTypeEncodeString = [NSString stringWithUTF8String:@encode(BOOL)];
    BOOL isBoolean = [propertyType isEqualToString:booleanTypeEncodeString];
    NSString *integerTypeEncodeString = [NSString stringWithUTF8String:@encode(NSInteger)];
    BOOL isInteger = [propertyType isEqualToString:integerTypeEncodeString];
    NSString *floatTypeEncodeString = [NSString stringWithUTF8String:@encode(CGFloat)];
    BOOL isFloat = [propertyType isEqualToString:floatTypeEncodeString];
    BOOL isNumber = ((propertyClass == [NSNumber class]) || [propertyClass isSubclassOfClass:[NSNumber class]]);
    
    if (isString || isBoolean || isInteger || isFloat || isNumber) {

        [object setValue:JSONObject forKey:nodeName];
        
    } else {
        
        NSObject *childrenObject = [[propertyClass alloc] init];
        [self reflectJSONObject:JSONObject withObject:childrenObject];
        [object setValue:childrenObject forKey:nodeName];
        
    }
    
}

+ (void) processArrayProperty:(objc_property_t) property withObject:(NSObject *) object andJSONArray:(NSArray *) JSONArray {
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    for (id children in JSONArray) {
        
        Class jsonChildrenClass = [children class];
        BOOL isString = ((jsonChildrenClass == [NSString class]) || [jsonChildrenClass isSubclassOfClass:[NSString class]]);
        BOOL isNumber = ((jsonChildrenClass == [NSNumber class]) || [jsonChildrenClass isSubclassOfClass:[NSNumber class]]); //Can be boolean, integer, double or number, the NSJSONSerialization returns all these types as NSNumbers!
        
        if (isString || isNumber) {
        
            [list addObject:children];
            
        } else {
                        
            if ([object conformsToProtocol:@protocol(AbstractModelPropertyChildrenClassDelegate)]) {
                
                const char* propertyName = property_getName(property);
                NSString* propertyNameString = [NSString stringWithUTF8String:propertyName];
                Class classFromDelegate = [object performSelector:@selector(childrenClassForPropertyWithName:) withObject:propertyNameString];
                
                NSObject *object = [[classFromDelegate alloc] init];
                [self reflectJSONObject:children withObject:object];
                [list addObject:object];
                
            }
            
        }
        
    }
    
    const char* propertyName = property_getName(property);
    NSString *propertyNameString = [NSString stringWithUTF8String:propertyName];
    [object setValue:list forKey:propertyNameString];

}

@end
