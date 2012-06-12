//
//  JLModel.m
//  oaSis2
//
//  Created by Antonio Henrique C B S Araújo on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AbstractModel.h"
#import "DataController.h"

@interface AbstractModel(PrivateMethods)
- (void) load;
- (void) loadWithParameters:(NSDictionary *) parameters;
- (void) loadWithParameters:(NSDictionary *)parameters andHttpRequestMethod:(NSString *) httpRequestMethod;
@end

@implementation AbstractModel

@synthesize id = _id;
@synthesize error = _error;
@synthesize url = _url;

#pragma mark - init methods


- (id) initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

#pragma mark - load content methods

- (void) loadWithResponseDataType:(ResponseDataType) responseDataType {
    [self loadWithParameters:nil andResponseDataType:responseDataType];
}

- (void) loadWithParameters:(NSDictionary *) parameters andResponseDataType:(ResponseDataType) responseDataType {
    [self loadWithParameters:parameters httpRequestMethod:@"GET" andResponseDataType:responseDataType];
}

- (void) loadWithParameters:(NSDictionary *)parameters httpRequestMethod:(NSString *) httpRequestMethod andResponseDataType:(ResponseDataType) responseDataType {
    [DataController loadWithObject:self responseDataType:responseDataType parameters:parameters andHttpRequestMethod:httpRequestMethod];
}

@end
