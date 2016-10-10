//
//  FileManager.h
//  testForWeMakeTrafick
//
//  Created by Vitaliy on 10/4/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FileManagerDelegate <NSObject>

- (void)updatedFileState;

@end

@interface FileManager : NSObject


@property (weak, nonatomic) id <FileManagerDelegate> delegate;

+ (id)sharedManager;

- (void)setupDelegate:(id)newDelegate;

- (NSInteger)filesCount;

- (NSArray*)getFiles;

- (void)loadFilesFromUserDefaults;

- (void)loadFilesFromServer;

- (void)startDownload;

@end
