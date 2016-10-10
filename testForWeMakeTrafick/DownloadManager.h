//
//  DownloadManager.h
//  testForWeMakeTrafick
//
//  Created by Vitaliy on 9/25/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <REDownloadTasksQueue/REDownloadTasksQueue.h>

#import "WMFile.h"

@protocol DownloadStatusDelegate <NSObject>

- (void) updatedProgress:(float)progress toFile:(WMFile *)file;
- (void) updatedStatus:(WMFile *)fileName;
- (void) downloadedFileWithError:(WMFile *)fileName;

@end

@interface DownloadManager : NSObject

@property (weak, nonatomic) id <DownloadStatusDelegate> delegate;

- (void) downloadFile:(WMFile*)file;

@end

