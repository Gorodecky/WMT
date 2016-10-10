//
//  WMFile.h
//  testForWeMakeTrafick
//
//  Created by Vitaliy on 9/22/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utilite.h"

@interface WMFile : NSObject

@property (strong, nonatomic) NSString* fileName;
@property (strong, nonatomic) NSString* fileResponseURL;
@property (strong, nonatomic) NSString* fileType;
@property (assign, nonatomic) float fileProgressDownload;
@property (assign, nonatomic) StatusTypeFile fileStatusType;

@property (strong, nonatomic) NSString* fileDescription;
@property (strong, nonatomic) NSString* fileID;
@property (strong, nonatomic) NSString* fileLocalURL;
@property (strong, nonatomic) NSDate* fileDateCreation;
@property (strong, nonatomic) NSData* fileData;

@property (strong, nonatomic) NSMutableArray* filesArray;

@property (assign, nonatomic) BOOL* fileIsDownload;

- (id)initWithServerResponse:(NSDictionary*) responseObject;
- (NSString*)progressString;
- (void)changeFileStatus:(StatusTypeFile)newStatus;
- (void)updateProgress:(float)newValue;

@end

