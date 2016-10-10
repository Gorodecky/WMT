//
//  DownloadManager.m
//  testForWeMakeTrafick
//
//  Created by Vitaliy on 9/25/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//


#import <REDownloadTasksQueue/REDownloadTasksQueue.h>
#import <AFNetworking.h>

#import "DownloadManager.h"
#import "Utilite.h"


@interface DownloadManager ()
{
    StatusTypeFile statusFile;
    
    NSString *dataPath;
    
    NSArray* directoryContents;
}

@property (strong, nonatomic) REDownloadTasksQueue* queue;

@end

@implementation DownloadManager

- (id)init {
    
    self = [super init];
    
    if (self) {
        
         [self createDirectoryInDocumentsFolderWithName:kDirectoryWMT];
    }
    return self;
}

- (void) downloadFile:(WMFile*)file {
    
    NSString * fromURLString = file.fileResponseURL; // URL string for download file
    
    NSString* fileType = file.fileType;
    
    NSString* fileName = file.fileName;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString* createStorePath = [NSString stringWithFormat:@"/%@/%@.%@", kDirectoryWMT, fileName, fileType];
    
    NSString * storePath = [documentsDirectory stringByAppendingPathComponent:createStorePath];// Full path for storing
    
    REDownloadTasksQueue * queue = [[REDownloadTasksQueue alloc] init];
    
    [queue addURLString:fromURLString withStorePath:storePath]; // add as URL string.
    
    [queue setUserObject:file];
    
    [queue start];

    [queue setOnProgressHandler:^(REDownloadTasksQueue * _Nonnull queue, float progress) {
        
        NSLog(@"userObject = %@, progress = %f",queue.userObject,progress);
        
        if (_delegate) {
            
            [_delegate updatedProgress:queue.downloadProgress toFile:queue.userObject];
        }
    }];
    
    [queue setOnFinishedHandler:^(REDownloadTasksQueue * queue){
        
        NSLog(@"onFinished");

        if (_delegate) {
            
            [_delegate updatedStatus:queue.userObject];
            NSLog(@"userObject = %@",queue.userObject);
        }
    }];
    
    [queue setOnErrorOccurredHandler:^(REDownloadTasksQueue * queue, NSError * error, NSURL * downloadURL, NSURL * storeFilePathURL){
        NSLog(@"onErrorOccurred, error: %@, from: %@, to: %@", error, downloadURL, storeFilePathURL);
        
        if (_delegate) {
            
            [_delegate downloadedFileWithError:queue.userObject];
            
            NSLog(@"userObject = %@",queue.userObject);
        }
    }];
}

- (NSArray*) createDirectorylistingFilesArray {
    
    NSError * error;
    
    directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dataPath error:&error];
    
    //NSLog(@"Directory array = %@", directoryContents);
    NSLog(@"%@",error);
    
    return directoryContents;
}

- (void)createDirectoryInDocumentsFolderWithName:(NSString *)dirName {
    
    NSError* error = [[NSError alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    
    NSString *createDataPath = [NSString stringWithFormat:@"/%@", dirName];
    
    
    dataPath = [documentsDirectory stringByAppendingPathComponent:createDataPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath
                                  withIntermediateDirectories:NO attributes:nil error:&error];
    }
}

@end
