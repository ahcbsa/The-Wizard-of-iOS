//
//  AbstractModel.h
//  The-Wizard-of-iOS
//
//  Created by Antonio Henrique C B S Araújo on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataConstants.h"
#import <objc/runtime.h>

@protocol AbstractModelPropertyChildrenClassDelegate <NSObject>
@optional
- (Class) childrenClassForPropertyWithName:(NSString *) propertyName;
- (NSString *) childrenTypeForPropertyWithName:(NSString *) propertyName;
@end

@interface AbstractModel : NSObject {
    
    NSString *_id;
    NSString *_error;
    
    NSString *_url;
    NSTimeInterval _cacheDuration;
    BOOL _shouldReload;
    
}

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSString *url;
@property (nonatomic) NSTimeInterval cacheDuration;
@property (nonatomic) BOOL shouldReload;

// init methods
- (id) initWithUrl:(NSString *) url;
- (id) initWithUrl:(NSString *)url andCacheDuration:(NSTimeInterval) cacheDuration;

// load content methods
- (BOOL) loadWithResponseDataType:(ResponseDataType) responseDataType;
- (BOOL) loadWithParameters:(NSDictionary *) parameters andResponseDataType:(ResponseDataType) responseDataType;
- (BOOL) loadWithParameters:(NSDictionary *)parameters httpRequestMethod:(NSString *) httpRequestMethod andResponseDataType:(ResponseDataType) responseDataType;

// reset content methods
- (void) resetObject;

@end
