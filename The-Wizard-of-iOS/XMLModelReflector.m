//
//  XMLModelReflector.m
//  The-Wizard-of-iOS
//
//  Created by Antonio Henrique C B S Araújo on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLModelReflector.h"
#import "ReflectionUtil.h"
#import "TBXML.h"

@implementation XMLModelReflector

+ (void) reflectXMLWithObject:(NSObject *) object andContentData:(NSData *)contentData {
    
    @autoreleasepool {
        
        NSError *error = nil;
        TBXML * tbxml = [TBXML newTBXMLWithXMLData:contentData error:&error];
        
        if (!error) {
            
            Class objectClass = [object class];
                        
            NSString *rootNodeName = [TBXML elementName:tbxml.rootXMLElement];
            
            objc_property_t property = class_getProperty(objectClass, [rootNodeName UTF8String]);
            
            if (property != NULL) {
                
                NSString *propertyType = property_getType(property);
                Class propertyClass = NSClassFromString(propertyType);
                
                if (propertyClass == [NSArray class] || [propertyClass isSubclassOfClass:[NSArray class]]) {
                    
                    [self processArrayProperty:property withObject:object andXMLObject:tbxml.rootXMLElement];
                    
                } else {
                    
                    [self reflectXMLObject:tbxml.rootXMLElement withObject:object];
                    
                }
                
            }
            
        }
                
    }

}

+ (void) reflectXMLObject:(TBXMLElement *) xmlNode withObject:(NSObject *) object {
    
    Class objectClass = [object class];
    
    TBXMLAttribute *attribute = xmlNode->firstAttribute;
    
    while (attribute != NULL) {
        
        NSString *attributeName = [TBXML attributeName:attribute];
        
        objc_property_t attributeProperty = class_getProperty(objectClass, [attributeName UTF8String]);
        
        if (attributeProperty != NULL) {
            
            NSString *propertyType = property_getType(attributeProperty);
            NSString *attributeValue = [TBXML valueOfAttributeNamed:attributeName forElement:xmlNode];
            
            NSString *booleanTypeEncodeString = [NSString stringWithUTF8String:@encode(BOOL)];
            BOOL isBoolean = [propertyType isEqualToString:booleanTypeEncodeString];
            NSString *integerTypeEncodeString = [NSString stringWithUTF8String:@encode(NSInteger)];
            BOOL isInteger = [propertyType isEqualToString:integerTypeEncodeString];
            NSString *floatTypeEncodeString = [NSString stringWithUTF8String:@encode(CGFloat)];
            BOOL isFloat = [propertyType isEqualToString:floatTypeEncodeString];
            
            if (isBoolean) {
                
                [object setValue:[NSNumber numberWithBool:[attributeValue boolValue]] forKey:attributeName];
                
            } else if (isInteger) {
                
                [object setValue:[NSNumber numberWithInteger:[attributeValue integerValue]] forKey:attributeName];
                
            } else if (isFloat) {
                
                [object setValue:[NSNumber numberWithFloat:[attributeValue floatValue]] forKey:attributeName];
                
            } else {
                
                [object setValue:attributeValue forKey:attributeName];
                
            }
            
        }
        
        attribute = attribute->next;
        
    }
    
    TBXMLElement *subnode = xmlNode->firstChild;
    
    while (subnode != NULL) {
        
        NSString *subnodeName = [TBXML elementName:subnode];        
        objc_property_t property = class_getProperty(objectClass, [subnodeName UTF8String]);
                
        if (property != NULL) {
            
            NSString *propertyType = property_getType(property);
            Class propertyClass = NSClassFromString(propertyType);
            
            if (propertyClass == [NSArray class] || [propertyClass isSubclassOfClass:[NSArray class]]) {
                
                [self processArrayProperty:property withObject:object andXMLObject:subnode];
                
            } else {
                
                [self processSingleProperty:property withObject:object andXMLObject:subnode];
                
            }
            
            [self reflectXMLObject:subnode withObject:object];
            
        }
        
        subnode = subnode->nextSibling;
        
    }
    
}

+ (void) reflectXMLArray:(TBXMLElement *) xmlNode withObject:(NSObject *) object {

    NSString *nodeName = [TBXML elementName:xmlNode];
//    NSLog(@"NODE NAME: %@ VALUE: %@", nodeName, [TBXML textForElement:xmlNode]);
    Class objectClass = [object class];
    objc_property_t property = class_getProperty(objectClass, [nodeName UTF8String]);
    
    if (property != NULL) {
        
        [self processArrayProperty:property withObject:object andXMLObject:xmlNode];
        
    }
    
}

+ (void) processSingleProperty:(objc_property_t) property withObject:(NSObject *) object andXMLObject:(TBXMLElement *) xmlNode {
    
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
    
    NSString *nodeName = [TBXML elementName:xmlNode];        
    NSString *nodeValue = [TBXML textForElement:xmlNode];
    
    if (isString || isNumber) {
        
        [object setValue:nodeValue forKey:nodeName];
        
    } else if (isBoolean) {
        
        [object setValue:[NSNumber numberWithBool:[nodeValue boolValue]] forKey:nodeName];
        
    } else if (isInteger) {
        
        [object setValue:[NSNumber numberWithInteger:[nodeValue integerValue]] forKey:nodeName];
        
    } else if (isFloat) {
        
        [object setValue:[NSNumber numberWithFloat:[nodeValue floatValue]] forKey:nodeName];
        
    } else {
        
        NSObject *childrenObject = [[propertyClass alloc] init];
        [self reflectXMLObject:xmlNode withObject:childrenObject];
        [object setValue:childrenObject forKey:nodeName];
        
    }
    
}

+ (void) processArrayProperty:(objc_property_t) property withObject:(NSObject *) object andXMLObject:(TBXMLElement *) xmlNode {
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    TBXMLElement *subnode = xmlNode->firstChild;
    
    while (subnode != NULL) {
                    
        if ([object respondsToSelector:@selector(childrenClassForPropertyWithName:)]) {
            
            const char* propertyName = property_getName(property);
            NSString* propertyNameString = [NSString stringWithUTF8String:propertyName];
            
            Class classFromDelegate = [object performSelector:@selector(childrenClassForPropertyWithName:) withObject:propertyNameString];
            
            if (classFromDelegate) {
             
                BOOL isArray = ((classFromDelegate == [NSArray class]) || [classFromDelegate isSubclassOfClass:[NSArray class]]);
                BOOL isString = ((classFromDelegate == [NSString class]) || [classFromDelegate isSubclassOfClass:[NSString class]]);
                BOOL isNumber = ((classFromDelegate == [NSNumber class]) || [classFromDelegate isSubclassOfClass:[NSNumber class]]); //Can be boolean, integer, double or number, the NSJSONSerialization returns all these types as NSNumbers!
                
                if (isArray) {
                    
                    NSObject *object = [[classFromDelegate alloc] init];
                    [self reflectXMLArray:subnode withObject:object];
                    [list addObject:object];
                    
                } else if (isNumber) {
                    
                    if ([object respondsToSelector:@selector(childrenTypeForPropertyWithName:)]) {
                        
                        NSString *propertyType = [object performSelector:@selector(childrenTypeForPropertyWithName:) withObject:propertyNameString];
                        
                        NSString *booleanTypeEncodeString = [NSString stringWithUTF8String:@encode(BOOL)];
                        BOOL isBoolean = [propertyType isEqualToString:booleanTypeEncodeString];
                        NSString *integerTypeEncodeString = [NSString stringWithUTF8String:@encode(NSInteger)];
                        BOOL isInteger = [propertyType isEqualToString:integerTypeEncodeString];
                        NSString *floatTypeEncodeString = [NSString stringWithUTF8String:@encode(CGFloat)];
                        BOOL isFloat = [propertyType isEqualToString:floatTypeEncodeString];
                        
                        NSString *value = [TBXML textForElement:subnode];
                        
                        if (isBoolean) {
                            
                            [list addObject:[NSNumber numberWithBool:[value boolValue]]];
                            
                        } else if (isInteger) {
                            
                            [list addObject:[NSNumber numberWithInt:[value intValue]]];
                            
                        } else if (isFloat) {
                            
                            [list addObject:[NSNumber numberWithFloat:[value floatValue]]];
                            
                        } else {
                            
                            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                            [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
                            [list addObject:[numberFormatter numberFromString:value]];
                            
                        }
                        
                    }
                    
                } else if (isString) {
                    
                    NSString *value = [TBXML textForElement:subnode];
                    [list addObject:value];
                    
                } else {
                    
                    NSObject *object = [[classFromDelegate alloc] init];
                    [self reflectXMLObject:subnode withObject:object];
                    [list addObject:object];
                    
                }
                
            }
            
        }
                    
        subnode = subnode->nextSibling;
        
    }
    
    const char* propertyName = property_getName(property);
    NSString *propertyNameString = [NSString stringWithUTF8String:propertyName];
    [object setValue:list forKey:propertyNameString];
    
}

@end
