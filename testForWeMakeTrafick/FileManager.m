//
//  FileManager.m
//  testForWeMakeTrafick
//
//  Created by Vitaliy on 10/4/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import "FileManager.h"
#import "Utilite.h"
#import "DownloadManager.h"
#import "WMFile.h"
#import "APIManager.h"

@interface FileManager () <DownloadStatusDelegate> {
    NSMutableArray *files; //private files array
    NSMutableArray *downloadingFiles;
    
    DownloadManager *downloadManager;
}

@property (strong, nonatomic) NSMutableArray* downloableArrayForView;

@end

@implementation FileManager

+ (id)sharedManager {
    
    static FileManager *sharedMyManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}

#pragma mark - Public

- (NSInteger)filesCount {
    
    return files.count;
}

- (NSArray*)getFiles {
    
    if (files) {
        return files;
    }
    
    return nil;
}

- (void)setupDelegate:(id)newDelegate {
    
    _delegate = newDelegate;
}

- (void)loadFilesFromUserDefaults {
    
    NSArray* arrayfromUserDefault = [Utilite retrieveArrayFromUserDefaults];
    
    if (arrayfromUserDefault) {
        
        files = [arrayfromUserDefault mutableCopy];
    }
}

- (void)saveFilesToUserDefaults {
    
    if (files) {
        
        [Utilite saveArrayToUserDefaults:files];
        
    } else {
        
        NSLog(@"Can't save - files is missing");
    }
}

- (void)loadFilesFromServer {
    
    NSArray *loadedFiles = [[APIManager sharedManager] createArrayFilesInJSON];
    
    if (loadedFiles) {
        
        //process obrained files
        [self processObtainedFiles:loadedFiles];
        
        [self saveFilesToUserDefaults];
    }
}

- (void)startDownload {
    
    [self initDownloadManager];
    
    if (downloadingFiles.count == kUploadFilesCount) {
        
                NSLog(@"Downloading stack is full");
        
    } else if (downloadingFiles.count < kUploadFilesCount) {
        
        NSArray *filesForDownload = [self findObjectsForUpload:kUploadFilesCount - (int)downloadingFiles.count];
        
        if (!downloadingFiles) {
            
            downloadingFiles = [NSMutableArray array];
        }
        
        [downloadingFiles addObjectsFromArray:filesForDownload];
        
        for (WMFile * file in filesForDownload) {
            
            [file changeFileStatus:fileDownlading];
            
            [downloadManager downloadFile:file];
        }
    }
}

#pragma mark - Private

- (void)processObtainedFiles:(NSArray*)newFiles {
    
    if (!files) {
        
        NSLog(@"Local files exist - add all list");
        
        files = [newFiles mutableCopy];
        
    } else {
        
        NSMutableArray *newFiles = [NSMutableArray array];
        
        for (WMFile* fileJSON in newFiles) {
            
            BOOL isExist = false;
            
            for (WMFile* savedFile in files) {
                
                isExist = [self comparisonFileInUserDefault:savedFile withFileJSON:fileJSON];
                
                if (isExist) {
                    break;
                }
            }
            
            if (!isExist) {
                [newFiles addObject:fileJSON];
            }
        }
        
        if (newFiles.count > 0) {
            
            NSLog(@"Available %lu files",(unsigned long)newFiles.count);
            
            [files addObjectsFromArray:newFiles];
        }
    }
}

- (BOOL) comparisonFileInUserDefault:(WMFile*) fileUserDefault withFileJSON:(WMFile*)fileJSON {
    
    if ([fileUserDefault.fileName isEqualToString:fileJSON.fileName]) {
        
        return YES;
        
    } else {
        
        return NO;
    }
}

- (void)initDownloadManager {
    
    if (!downloadManager) {
        
        downloadManager = [[DownloadManager alloc] init];
        downloadManager.delegate = self;
    }
}

-(NSArray*)findObjectsForUpload:(int)filesCont {
    
    NSMutableArray *filesForUpload = [NSMutableArray array];
    
    
    for (WMFile * file in files) {
        
        NSLog(@"file = %i",file.fileStatusType);
        
        if (file.fileStatusType == fileNotDownload) {
            
            [filesForUpload addObject:file];
            
            if (filesForUpload.count == filesCont) {
                
                return filesForUpload;
            }
        }
    }
    
    if (filesForUpload.count > 0) {
        return filesForUpload;
    }
    
    return nil;
}

- (void)markFileAsDownloaded:(WMFile *)downloadedFile {
    
    [downloadedFile changeFileStatus:fileIsDoWnload];
    
    //save updated files data
    [Utilite saveArrayToUserDefaults:files];
    
    //remove file from downloading stack
    [self removeFileFromDownloadingQueue:downloadedFile];
    
    //find new file for uploading
    [self startDownload];
    
    //update UI
    if (_delegate) {
        [_delegate updatedFileState];
    }
}

- (void)removeFileFromDownloadingQueue:(WMFile *)downloadedFile {
    int fileIndex = -1;
    for (int i = 0; i < downloadingFiles.count; i++) {
        WMFile * file = downloadingFiles[i];
        if (file == downloadedFile) {
            fileIndex = i;
        }
    }
    
    if (fileIndex > 0) {
        [downloadingFiles removeObjectAtIndex:fileIndex];
    }
}

#pragma mark - DownloadStatusDelegate

- (void) updatedProgress:(float)progress toFile:(WMFile *)file {
    NSLog(@"updatedProgress = %f, file = %@",progress,file);
    float state = file.fileProgressDownload/100.0;
    
    if ((progress - state) > 0.10) {
        [file updateProgress:progress];
        
        if (_delegate) {
            [_delegate updatedFileState];
        }
    }
}

- (void) updatedStatus:(WMFile *)downloadedFile {
    
    [self markFileAsDownloaded:downloadedFile];
    
    NSLog(@"updatedStatus = %@",downloadedFile);
    
    NSLog(@"downloadedFile = %@",downloadedFile.fileName);
}

- (void) downloadedFileWithError:(WMFile *)file {
    
    [file changeFileStatus:fileNotDownload];
}

@end
