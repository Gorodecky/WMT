//
//  DownloadableViewController.m
//  testForWeMakeTrafick
//
//  Created by Vitaliy on 10/3/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

#import "DownloadableViewController.h"
#import "DownloableCustomTableViewCell.h"
#import "FileManager.h"
#import "DownloadManager.h"


@interface DownloadableViewController () <UITableViewDelegate, UITableViewDataSource, FileManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DownloadableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //chech available list in user defaults
    [[FileManager sharedManager] loadFilesFromUserDefaults];
    [[FileManager sharedManager] setDelegate:self];
    
    NSLog(@"Saved filesCount = %li",(long)[[FileManager sharedManager] filesCount]);
}

#pragma mark - Actions

- (IBAction)refreshButton:(id)sender {
    [[FileManager sharedManager] loadFilesFromServer];
    [_tableView reloadData];
}

- (IBAction)startDownload:(id)sender {
    [[FileManager sharedManager] startDownload];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[FileManager sharedManager] filesCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DownloableCustomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kDownloableCustomTableViewCellIdentifier];
    
    WMFile *file = [[[FileManager sharedManager] getFiles] objectAtIndex:indexPath.row];
    
    [cell processFile:file];
    
    return cell;
}

#pragma mark - FileManagerDelegate

- (void)updatedFileState {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}

#pragma mark - Private

@end
