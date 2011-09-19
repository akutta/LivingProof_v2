//
//  VideoCell_iPad.m
//  LivingProof
//
//  Created by Mark Sands on 9/19/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import "VideoCell_iPad.h"
#import "VideoTitleLabel.h"
#import "HorizontalVariables.h"

@implementation VideoCell_iPad

- (id)initWithFrame:(CGRect)frame
{
  [super initWithFrame:frame];

  self.thumbnail = [[[UIImageView alloc] initWithFrame:CGRectMake(kArticleCellHorizontalInnerPadding_iPad, kArticleCellVerticalInnerPadding_iPad, kCellWidth_iPad - kArticleCellHorizontalInnerPadding_iPad * 2, kCellHeight_iPad - kArticleCellVerticalInnerPadding_iPad * 2)] autorelease];
  self.thumbnail.opaque = YES;
  
  [self.contentView addSubview:self.thumbnail];
  
  self.titleLabel = [[[VideoTitleLabel alloc] initWithFrame:CGRectMake(0, self.thumbnail.frame.size.height * 0.632, self.thumbnail.frame.size.width, self.thumbnail.frame.size.height * 0.37)] autorelease];
  self.titleLabel.opaque = YES;
  [self.titleLabel setPersistentBackgroundColor:[UIColor colorWithRed:0 green:0.4745098 blue:0.29019808 alpha:0.9]];
  self.titleLabel.textColor = [UIColor whiteColor];
  self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
  self.titleLabel.numberOfLines = 3;
  [self.thumbnail addSubview:self.titleLabel];

  self.backgroundColor = [UIColor colorWithRed:0 green:0.40784314 blue:0.21568627 alpha:1.0];
  self.selectedBackgroundView = [[[UIView alloc] initWithFrame:self.thumbnail.frame] autorelease];
  self.selectedBackgroundView.backgroundColor = kHorizontalTableSelectedBackgroundColor;
  
  self.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
  
  return self;
}

@end
