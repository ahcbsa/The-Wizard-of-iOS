//
//  DiskCache.m
//  The-Wizard-of-iOS
//
//  Created by Antonio Henrique C B S Araújo on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DiskCache.h"

@implementation DiskCache

+ (DiskCache *) sharedCache {
    static dispatch_once_t pred = 0;
    static DiskCache *diskCache = nil;
    dispatch_once(&pred, ^{
        diskCache = [[DiskCache alloc] init];
    });
    return diskCache; 
}

- (id) init {

    self = [super init];
    
    if (self) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:[self cacheDirectory]withIntermediateDirectories:YES attributes:nil error:NULL];
        
    }
    
    return self;

}

#pragma mark - Cache methods

- (NSString *) cacheDirectory {
    
    NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"Cache"];
        
}

- (NSString *) cachePathForKey:(NSString *) key {
    
    NSString *cacheDirectory = [self cacheDirectory];
    return [cacheDirectory stringByAppendingPathComponent:key];
    
}

- (NSMutableDictionary *) cacheInfoDictionary {
    
    return [NSMutableDictionary dictionaryWithContentsOfFile:[self cachePathForKey:@"Cache.plist"]];
    
}

- (void) saveCacheInfoDictionary:(NSMutableDictionary *) dictionary {
    
    [dictionary writeToFile:[self cachePathForKey:@"Cache.plist"] atomically:YES];
    
}

- (void) clearCache {
    
    @synchronized(self) {
    
        NSMutableDictionary* dictionary = [self cacheInfoDictionary];
        
        for (NSString *key in dictionary) {
            
            [self removeCachedForKey:key];
            
        }
        
        [self saveCacheInfoDictionary:dictionary];
        
    }

}

- (void) removeCachedForKey:(NSString *) key {
    
    @synchronized(self) {
    
        NSMutableDictionary* dictionary = [self cacheInfoDictionary];
        [[NSFileManager defaultManager] removeItemAtPath:[self cachePathForKey:key] error:NULL];
        [dictionary removeObjectForKey:key];
        [self saveCacheInfoDictionary:dictionary];
    
    }
    
}

- (BOOL) hasCacheForKey:(NSString *) key {
    
    NSMutableDictionary* dictionary = [self cacheInfoDictionary];
    return [dictionary objectForKey:key] != nil;
    
}

- (BOOL) cachedForKeyIsExpired:(NSString *) key {
    
    NSMutableDictionary* dictionary = [self cacheInfoDictionary];
    NSDate *expirationDate = [dictionary objectForKey:key];
    
    if (!expirationDate || [expirationDate compare:[NSDate date]] != NSOrderedDescending) {
        
        return YES;
        
    }
    
    return NO;

}

- (NSDate *) expirationDateForKey:(NSString *) key {
    
    NSMutableDictionary* dictionary = [self cacheInfoDictionary];
    return [dictionary objectForKey:key];

}

- (NSData *) cachedForKey:(NSString *) key {
        
    return [NSData dataWithContentsOfFile:[self cachePathForKey:key]];
    
}

- (void) cacheData:(NSData *) data forKey:(NSString *) key withCacheDuration:(NSTimeInterval) cacheDuration {
    
    @synchronized(self) {
    
        [data writeToFile:[self cachePathForKey:key] atomically:YES];
        NSMutableDictionary* dictionary = [self cacheInfoDictionary];
        
        if(![dictionary isKindOfClass:[NSDictionary class]]) {
            
            dictionary = [[NSMutableDictionary alloc] init];
            
        }
        
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:cacheDuration];
        [dictionary setObject:expirationDate forKey:key];
        [self saveCacheInfoDictionary:dictionary];
        
    }
    
}

@end
