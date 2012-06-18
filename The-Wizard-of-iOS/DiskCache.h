//
//  DiskCache.h
//  The-Wizard-of-iOS
//
//  Created by Antonio Henrique C B S Araújo on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiskCache : NSObject {

}

+ (DiskCache *) sharedCache;

- (void) clearCache;
- (void) removeCachedForKey:(NSString *) key;
- (BOOL) hasCacheForKey:(NSString *) key;
- (BOOL) cachedForKeyIsExpired:(NSString *) key;
- (NSDate *) expirationDateForKey:(NSString *) key;
- (NSData *) cachedForKey:(NSString *) key;
- (void) cacheData:(NSData *) data forKey:(NSString *) key withCacheDuration:(NSTimeInterval) cacheDuration;

@end
