//
//  User.h
//  oaSis2
//
//  Created by Antonio Henrique C B S Araújo on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screen_name;
@property (nonatomic, strong) NSString *profile_image_url;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic) BOOL profile_use_background_image;

@end
