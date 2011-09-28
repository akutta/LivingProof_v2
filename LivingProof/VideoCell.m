//
//  VideoCell.m
//  LivingProof
//
//  Created by Mark Sands on 9/19/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import "VideoCell.h"

@implementation VideoCell

@synthesize thumbnail = _thumbnail;
@synthesize titleLabel = _titleLabel;

#pragma mark - View Lifecycle

- (NSString *)reuseIdentifier 
{
  return @"ArticleCell";
}

#pragma mark - Memory Management

- (void)dealloc
{
  self.thumbnail = nil;
  self.titleLabel = nil;
  
  [super dealloc];
}

@end
