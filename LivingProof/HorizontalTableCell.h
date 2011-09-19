//
//  HorizontalTableCell.h
//  LivingProof
//
//  Created by Mark Sands on 9/19/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizontalTableCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>
{
  UITableView *_horizontalTableView;
  NSArray *_videos; 
}

@property (nonatomic, retain) UITableView *horizontalTableView;
@property (nonatomic, retain) NSArray *videos;

@end
