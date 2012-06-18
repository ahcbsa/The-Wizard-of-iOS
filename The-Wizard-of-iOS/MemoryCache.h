//
//  MemoryCache.h
//  The-Wizard-of-iOS
//
//  Created by Antonio Henrique C B S Araújo on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AbstractModel;

@interface MemoryCache : NSObject {
    
    NSMutableDictionary *_memoryCache;
    NSMutableDictionary *_memoryCacheExpirationDates;
    NSMutableArray *_memoryCacheKeys;

}

+ (MemoryCache *) sharedCache;

- (void) clearCache;
- (void) removeCachedForKey:(NSString *) key;
- (AbstractModel *) cachedForKey:(NSString *) key;
- (void) cacheObject:(AbstractModel *) object forKey:(NSString *) key;

@end
