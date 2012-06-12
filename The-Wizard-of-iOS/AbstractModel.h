//
//  JLModel.h
//  oaSis2
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
    
}

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSString *url;

// init methods
- (id) initWithUrl:(NSString *) url;

// load content methods
- (void) loadWithResponseDataType:(ResponseDataType) responseDataType;
- (void) loadWithParameters:(NSDictionary *) parameters andResponseDataType:(ResponseDataType) responseDataType;
- (void) loadWithParameters:(NSDictionary *)parameters httpRequestMethod:(NSString *) httpRequestMethod andResponseDataType:(ResponseDataType) responseDataType;

@end
