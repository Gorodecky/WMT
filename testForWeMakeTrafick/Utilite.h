//
//  Utilite.h
//  testForWeMakeTrafick
//
//  Created by Vitaliy on 9/27/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    fileIsDoWnload,
    fileDownlading,
    fileNotDownload
    
} StatusTypeFile;

@interface Utilite : NSObject

+ (void) saveArrayToUserDefaults:(NSArray*)array;
+ (NSArray*) retrieveArrayFromUserDefaults;

@end

static NSString* const kArrayFilesInUserDefault = @"arayFilesInUserDefault";
static NSString* const kDirectoryWMT = @"WMT";

static int const kUploadFilesCount = 3;
