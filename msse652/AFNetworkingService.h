//
//  AFNetworkingService.h
//  msse652
//
//  Created by echolush on 7/14/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"

@interface AFNetworkingService : NSObject <Service>

/**Holds Programs*/
@property (strong, nonatomic) NSMutableArray *arrayPrograms;

@end
