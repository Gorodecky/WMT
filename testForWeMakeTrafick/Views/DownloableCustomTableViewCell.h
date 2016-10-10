//
//  DownloableCustomTableViewCell.h
//  testForWeMakeTrafick
//
//  Created by Vitaliy on 10/3/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMFile.h"

static NSString* const kDownloableCustomTableViewCellIdentifier = @"downloableCustomTableViewCellIdentifier";

@interface DownloableCustomTableViewCell : UITableViewCell

- (void)processFile:(WMFile*)processFile;

@end
