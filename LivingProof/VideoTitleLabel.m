//
//  VideoTitleLabel.m
//  LivingProof
//
//  Created by Mark Sands on 9/19/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import "VideoTitleLabel.h"
#import "HorizontalVariables.h"

@implementation VideoTitleLabel

- (void)setPersistentBackgroundColor:(UIColor*)color 
{
  super.backgroundColor = color;
}

- (void)setBackgroundColor:(UIColor *)color 
{
  // do nothing - background color never changes
}

- (void)drawTextInRect:(CGRect)rect
{    
  CGFloat newWidth = rect.size.width - kArticleTitleLabelPadding;
  CGFloat newHeight = rect.size.height; 
  
  CGRect newRect = CGRectMake(kArticleTitleLabelPadding * 0.5, 0, newWidth, newHeight);
  
  [super drawTextInRect:newRect];
}

@end
