//
//  DownloableCustomTableViewCell.m
//  testForWeMakeTrafick
//
//  Created by Vitaliy on 10/3/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import "DownloableCustomTableViewCell.h"

@interface DownloableCustomTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *fileNameLable;
@property (weak, nonatomic) IBOutlet UILabel *progresDownloadLable;

@end

@implementation DownloableCustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Public

- (void)processFile:(WMFile*)processFile {
    _fileNameLable.text = processFile.fileName;
    _progresDownloadLable.text = [processFile progressString];
}

#pragma mark - Private

-(void)prepareForReuse {
    [super prepareForReuse];
    
    _fileNameLable.text = nil;
    _progresDownloadLable.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
