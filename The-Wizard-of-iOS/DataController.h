//
//  JLDataManager.h
//  oaSis2
//
//  Created by Antonio Henrique C B S Araújo on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AbstractModel.h"

@interface DataController : NSObject {

}

+ (void) loadWithObject:(AbstractModel *) object responseDataType:(ResponseDataType) responseDataType parameters:(NSDictionary *) parameters andHttpRequestMethod:(NSString *) httpRequestMethod;

@end
