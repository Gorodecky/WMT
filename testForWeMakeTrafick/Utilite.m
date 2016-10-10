//
//  Utilite.m
//  testForWeMakeTrafick
//
//  Created by Vitaliy on 9/27/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import "Utilite.h"

@implementation Utilite

+ (void) saveArrayToUserDefaults:(NSArray*)array{
    
    NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:array];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:dataSave forKey:kArrayFilesInUserDefault];
    [userDefaults synchronize];
}

+ (NSArray*) retrieveArrayFromUserDefaults{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kArrayFilesInUserDefault];
    
    NSArray *savedArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return savedArray;
}

@end
