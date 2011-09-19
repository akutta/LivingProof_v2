//
//  VideoCell.h
//  LivingProof
//
//  Created by Mark Sands on 9/19/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoTitleLabel;

@interface VideoCell : UITableViewCell
{
  UIImageView *_thumbnail;
  VideoTitleLabel *_titleLabel;
}

@property (nonatomic, retain) UIImageView *thumbnail;
@property (nonatomic, retain) VideoTitleLabel *titleLabel;

@end
