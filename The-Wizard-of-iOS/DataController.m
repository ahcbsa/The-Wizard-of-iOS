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

@implementation DataController

#pragma mark - loading methods

+ (void) loadWithObject:(AbstractModel *) object responseDataType:(ResponseDataType) responseDataType parameters:(NSDictionary *) parameters andHttpRequestMethod:(NSString *) httpRequestMethod {
    
    //Implement disk and memory caches
    //Request with HEAD method to get only the response headers and verify the last-modified field
        
    //Starts request
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:nil];
    NSMutableURLRequest *request = [httpClient requestWithMethod:httpRequestMethod path:object.url parameters:parameters];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation start];
    [operation waitUntilFinished];
    
    if (!operation.error) {
        
        //NSLog(@"HEADERS: %@", [operation.response allHeaderFields]);
        
        switch (responseDataType) {
                
            case JSONResponseDataType:{
                
                [JSONModelReflector reflectJSONWithObject:object andContentData:operation.responseData];
                break;
                
            }
            case XMLResponseDataType:{
                
                [XMLModelReflector reflectXMLWithObject:object andContentData:operation.responseData];
                break;
                
            }
                
        }
        
    } else {
        
        NSLog(@"ERROR: %@", [operation.error localizedDescription]);
        
    }

}

@end
