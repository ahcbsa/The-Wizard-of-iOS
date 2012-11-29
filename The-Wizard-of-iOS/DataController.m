//
//  DataController.m
//  The-Wizard-of-iOS
//
//  Created by Antonio Henrique C B S Araújo on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataController.h"

//External
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

//Model Reflectors
#import "JSONModelReflector.h"
#import "XMLModelReflector.h"

//Cache
#import "MemoryCache.h"
#import "DiskCache.h"

//Util
#import "ObjectCopier.h"
#import "ReflectionUtil.h"

@implementation DataController

+ (NSString *) cacheKeyForObject:(AbstractModel *) object withParameters:(NSDictionary *) parameters {
    
    NSMutableString *cacheKey = [NSMutableString stringWithString:object.url];
    
    for (NSString *key in parameters) {
        
        [cacheKey appendFormat:@"%@-%@", key, [parameters objectForKey:key]];
        
    }
    
    return cacheKey;
    
}

#pragma mark - loading methods

+ (BOOL) loadWithObject:(AbstractModel *) object responseDataType:(ResponseDataType) responseDataType parameters:(NSDictionary *) parameters andHttpRequestMethod:(NSString *) httpRequestMethod {
    
    [DataController resetObjectFieldsWithObject:object];
    
    NSString *cacheKey = [self cacheKeyForObject:object withParameters:parameters];
    
    //Memory cache
    MemoryCache *memoryCache = [MemoryCache sharedCache];
    AbstractModel *memoryCached = [memoryCache cachedForKey:cacheKey];
    
    if (memoryCached) {
        [ObjectCopier copyObject:memoryCached toObject:object];
        return YES;
    }
    
    //Disk cache
    DiskCache *diskCache = [DiskCache sharedCache];
    NSData *data = nil;
    
    if ([diskCache hasCacheForKey:cacheKey]) {
        
        if ([diskCache cachedForKeyIsExpired:cacheKey]) {
            
            //Request with HEAD method to get only the response headers and verify the last-modified field
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:nil];
            NSMutableURLRequest *request = [httpClient requestWithMethod:@"HEAD" path:object.url parameters:parameters];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            [operation start];
            [operation waitUntilFinished];
            
            if (!operation.error) {
                
                NSString *lastModifiedString = [[operation.response allHeaderFields] objectForKey:@"Last-Modified"]; 
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];  
                [dateFormatter setDateFormat:@"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'"];  
                [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];  
                [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]]; 
                NSDate *lastModifiedServer = [dateFormatter dateFromString:lastModifiedString];
                NSDate *localFileExpirationDate = [diskCache expirationDateForKey:cacheKey];
                
                if ([lastModifiedServer compare:localFileExpirationDate] != NSOrderedDescending) {
                    
                    data = [diskCache cachedForKey:cacheKey];
                    
                }
                
            }
            
        } else {
            
            data = [diskCache cachedForKey:cacheKey];
            
        }
        
    }
            
    if (!data) {
        
        //Starts request
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:nil];
        NSMutableURLRequest *request = [httpClient requestWithMethod:httpRequestMethod path:object.url parameters:parameters];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation start];
        [operation waitUntilFinished];
        
        if (!operation.error) {
            
            data = operation.responseData;
            
        }
        
    }

    if (data) {
        
        switch (responseDataType) {
                
            case JSONResponseDataType:{
                
                [JSONModelReflector reflectJSONWithObject:object andContentData:data];
                break;
                
            }
                
            case XMLResponseDataType:{
                
                [XMLModelReflector reflectXMLWithObject:object andContentData:data];
                break;
                
            }
                
        }
        
        if (object.cacheDuration > 0) {
            
            [memoryCache cacheObject:[object copy] forKey:cacheKey];
            [diskCache cacheData:data forKey:cacheKey withCacheDuration:object.cacheDuration];
            
        }
        
        return YES;
        
    }

    return NO;

}

#pragma mark - reseting methods

+ (void) resetObjectFieldsWithObject:(AbstractModel *) object {
    
    Class objectClass = [object class];
    NSArray *objectProperties = class_getProperties(objectClass);
    
    for (NSString *propertyName in objectProperties) {
        
        objc_property_t property = class_getProperty(objectClass, [propertyName UTF8String]);
        NSString *propertyType = property_getType(property);
        
        if (property != NULL) {
            
            NSString *booleanTypeEncodeString = [NSString stringWithUTF8String:@encode(BOOL)];
            BOOL isBoolean = [propertyType isEqualToString:booleanTypeEncodeString];
            NSString *integerTypeEncodeString = [NSString stringWithUTF8String:@encode(NSInteger)];
            BOOL isInteger = [propertyType isEqualToString:integerTypeEncodeString];
            NSString *floatTypeEncodeString = [NSString stringWithUTF8String:@encode(CGFloat)];
            BOOL isFloat = [propertyType isEqualToString:floatTypeEncodeString];
            
            if (isBoolean) {
                
                [object setValue:[NSNumber numberWithBool:NO] forKey:propertyName];
                
            } else if (isInteger) {
                
                [object setValue:[NSNumber numberWithInteger:0] forKey:propertyName];
                
            } else if (isFloat) {
                
                [object setValue:[NSNumber numberWithFloat:0.0] forKey:propertyName];
                
            } else {
                
                [object setValue:nil forKey:propertyName];
                
            }
            
        }
        
    }
    
}

@end
