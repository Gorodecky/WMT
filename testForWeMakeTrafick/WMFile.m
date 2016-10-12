//
//  WMFile.m
//  testForWeMakeTrafick
//
//  Created by Vitaliy on 9/22/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import "WMFile.h"
#import "DownloadManager.h"

@interface WMFile () <NSCoding>

@end

@implementation WMFile

- (id)initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    
    if (self) {
        
        self.fileName  = responseObject[@"name"];
        self.fileResponseURL = responseObject[@"url"];
        self.fileType = responseObject[@"type"];
        self.fileStatusType = fileNotDownload;
    }
    
    return self;
}

- (NSString*)progressString {
    
    if (_fileStatusType == fileIsDoWnload) {
        
        return @"Done";
    }
    
    if (_fileProgressDownload > 0) {
        
        return [NSString stringWithFormat:@"%lu %%",lroundf(_fileProgressDownload)];
    }
    
    return @"0 %";
}

- (void)changeFileStatus:(StatusTypeFile)newStatus {
    
    self.fileStatusType = newStatus;
}

- (void)updateProgress:(float)newValue {
    
    _fileProgressDownload = newValue * 100;
}

#pragma mark - Private

- (id) initWithCoder:(NSCoder*) decoder {
    
    if (self = [super init]) {
        
        self.fileName = [decoder decodeObjectForKey:@"fileName"];
        self.fileResponseURL = [decoder decodeObjectForKey:@"fileResponseURL"];
        self.fileType = [decoder decodeObjectForKey:@"fileType"];
        
        self.fileStatusType = [decoder decodeIntForKey:@"fileStatusType"];
        
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder*) encoder {
    
    [encoder encodeObject:self.fileName forKey:@"fileName"];
    [encoder encodeObject:self.fileResponseURL forKey:@"fileResponseURL"];
    [encoder encodeObject:self.fileType forKey:@"fileType"];
    [encoder encodeInt:self.fileStatusType forKey:@"fileStatusType"];
}

@end
