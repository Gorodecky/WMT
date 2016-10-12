//
//  APIManager.m
//  testForWeMakeTrafick
//
//  Created by Vitaliy on 10/5/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import "APIManager.h"
#import <AFNetworking/AFNetworking.h>
#import "WMFile.h"

@interface APIManager ()
{
    NSArray* json;
}

@end

@implementation APIManager

+ (id)sharedManager {
    
    
    static APIManager *sharedMyManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}

- (void) createJson {
    
    NSString* title = @"82836353";
    
    NSString* type = @"txt";
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:title ofType:type];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
}

- (NSMutableArray*) createArrayFilesInJSON {
    
    [self createJson];
    
    NSMutableArray* arrayFile = [NSMutableArray array];
    
    for (NSDictionary* dic in json) {
        
        WMFile* file = [[WMFile alloc] initWithServerResponse:dic];
        
        [arrayFile addObject:file];
    }
    
    return arrayFile;
}





@end
