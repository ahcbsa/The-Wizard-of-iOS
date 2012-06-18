//
//  AbstractModel.m
//  The-Wizard-of-iOS
//
//  Created by Antonio Henrique C B S Araújo on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AbstractModel.h"
#import "DataController.h"

@interface AbstractModel(PrivateMethods)
- (void) load;
- (void) loadWithParameters:(NSDictionary *) parameters;
- (void) loadWithParameters:(NSDictionary *) parameters andHttpRequestMethod:(NSString *) httpRequestMethod;
@end

@implementation AbstractModel

@synthesize id = _id;
@synthesize error = _error;
@synthesize url = _url;
@synthesize cacheDuration = _cacheDuration;

#pragma mark - init methods


- (id) initWithUrl:(NSString *)url {
    
    self = [super init];
    
    if (self) {
        
        self.url = url;
        self.cacheDuration = -1;
        
    }
    
    return self;
    
}

- (id) initWithUrl:(NSString *)url andCacheDuration:(NSTimeInterval) cacheDuration {
    
    self = [super init];
    
    if (self) {
        
        self.url = url;
        self.cacheDuration = cacheDuration;
        
    }
    
    return self;

}

#pragma mark - load content methods

- (BOOL) loadWithResponseDataType:(ResponseDataType) responseDataType {
    return [self loadWithParameters:nil andResponseDataType:responseDataType];
}

- (BOOL) loadWithParameters:(NSDictionary *) parameters andResponseDataType:(ResponseDataType) responseDataType {
    return [self loadWithParameters:parameters httpRequestMethod:@"GET" andResponseDataType:responseDataType];
}

- (BOOL) loadWithParameters:(NSDictionary *)parameters httpRequestMethod:(NSString *) httpRequestMethod andResponseDataType:(ResponseDataType) responseDataType {
    return [DataController loadWithObject:self responseDataType:responseDataType parameters:parameters andHttpRequestMethod:httpRequestMethod];
}

@end
