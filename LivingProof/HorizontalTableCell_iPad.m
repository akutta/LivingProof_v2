//
//  HorizontalTableCell_iPad.m
//  LivingProof
//
//  Created by Mark Sands on 9/19/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import "HorizontalTableCell_iPad.h"
#import "VideoCell_iPad.h"
#import "VideoTitleLabel.h"
#import "HorizontalVariables.h"

@implementation HorizontalTableCell_iPad


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"VideoCell";
  
  __block VideoCell_iPad *cell = (VideoCell_iPad *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) 
  {
    //cell = [[[VideoCell_iPad alloc] initWithFrame:CGRectMake(0, 0, kCellWidth_iPad, kCellHeight_iPad)] autorelease];
      cell = [[VideoCell_iPad alloc] initWithFrame:CGRectMake(0, 0, kCellWidth_iPad, kCellHeight_iPad)];
  }
  
  __block NSDictionary *currentVideo = [self.videos objectAtIndex:indexPath.row];
  
  dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  
  dispatch_async(concurrentQueue, ^{        
    UIImage *image = nil;        
    image = [UIImage imageNamed:[currentVideo objectForKey:@"ImageName"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [cell.thumbnail setImage:image]; 
    });
  }); 
  
  cell.titleLabel.text = [currentVideo objectForKey:@"Title"];
  
  return cell;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
    //self.horizontalTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCellHeight_iPad, kTableLength_iPad)] autorelease];
        self.horizontalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCellHeight_iPad, kTableLength_iPad)];
        self.horizontalTableView.showsVerticalScrollIndicator = NO;
        self.horizontalTableView.showsHorizontalScrollIndicator = NO;
        self.horizontalTableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
        [self.horizontalTableView setFrame:CGRectMake(kRowHorizontalPadding_iPad * 0.5, kRowVerticalPadding_iPad * 0.5, kTableLength_iPad - kRowHorizontalPadding_iPad, kCellHeight_iPad)];
    
        self.horizontalTableView.rowHeight = kCellWidth_iPad;
        self.horizontalTableView.backgroundColor = kHorizontalTableBackgroundColor;
    
        self.horizontalTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.horizontalTableView.separatorColor = [UIColor clearColor];
    
        self.horizontalTableView.dataSource = self;
        self.horizontalTableView.delegate = self;
        [self addSubview:self.horizontalTableView];
    }
  
  return self;
}

@end
