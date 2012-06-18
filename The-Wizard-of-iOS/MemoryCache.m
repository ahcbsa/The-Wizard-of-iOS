//
//  MemoryCache.m
//  The-Wizard-of-iOS
//
//  Created by Antonio Henrique C B S Araújo on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MemoryCache.h"
#import "AbstractModel.h"

@implementation MemoryCache

+ (MemoryCache *) sharedCache {
    static dispatch_once_t pred = 0;
    static MemoryCache *memoryCache = nil;
    dispatch_once(&pred, ^{
        memoryCache = [[MemoryCache alloc] init];
    });
    return memoryCache; 
}

- (id) init {
    
    self = [super init];
    
    if (self) {
        
        _memoryCache = [[NSMutableDictionary alloc] init];
        _memoryCacheExpirationDates = [[NSMutableDictionary alloc] init];
        _memoryCacheKeys = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCache) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCache) name:UIApplicationWillTerminateNotification object:nil];
        
    }
    
    return self;
    
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    
}

#pragma mark - Cache methods

- (void) clearCache {
    
    @synchronized(self) {
    
        [_memoryCache removeAllObjects];
        [_memoryCacheExpirationDates removeAllObjects];
        [_memoryCacheKeys removeAllObjects];
    
    }
    
}

- (void) removeCachedForKey:(NSString *) key {
    
    @synchronized(self) {
        
        NSUInteger index = [_memoryCacheKeys indexOfObject:key];
        
        if (index != NSNotFound) {
            
            [_memoryCache removeObjectForKey:key];
            [_memoryCacheExpirationDates removeObjectForKey:key];
            [_memoryCacheKeys removeObjectAtIndex:index];
            
        }
        
    }
    
}

- (AbstractModel *) cachedForKey:(NSString *) key {

    NSDate *expirationDate = [_memoryCacheExpirationDates objectForKey:key];
    
    if (!expirationDate || [expirationDate compare:[NSDate date]] != NSOrderedDescending) {
        
        [self removeCachedForKey:key];
        return nil;
        
    }
    
    return [_memoryCache objectForKey:key];
    
}

- (void) cacheObject:(AbstractModel *) object forKey:(NSString *) key {
    
    @synchronized(self) {

        [self removeCachedForKey:key];
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:object.cacheDuration];
        [_memoryCache setObject:object forKey:key];
        [_memoryCacheExpirationDates setObject:expirationDate forKey:key];
        [_memoryCacheKeys insertObject:key atIndex:0];
        
    }
    
}

@end
