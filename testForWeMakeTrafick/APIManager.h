//
//  APIManager.h
//  testForWeMakeTrafick
//
//  Created by Vitaliy on 10/5/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

+ (id)sharedManager;

- (NSMutableArray*) createArrayFilesInJSON;

@end
