//
//  HorizontalTableCell.m
//  LivingProof
//
//  Created by Mark Sands on 9/19/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import "HorizontalTableCell.h"

@implementation HorizontalTableCell

@synthesize horizontalTableView = _horizontalTableView;
@synthesize videos = _videos;

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
  return [self.videos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"VideoCell";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

  if (cell == nil) 
  {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
  }

  cell.textLabel.text = @"The title of the cell in the table within the table :O";

  return cell;
}

#pragma mark - Memory Management

- (NSString *) reuseIdentifier 
{
  return @"HorizontalCell";
}

- (void)dealloc
{
  self.horizontalTableView = nil;
  self.videos = nil;
  
  [super dealloc];
}

@end
