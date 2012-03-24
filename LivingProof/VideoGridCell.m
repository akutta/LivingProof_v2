//
//  VideoGridCell.m
//  LivingProof
//
//  Created by Mark Sands on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VideoGridCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation VideoGridCell

@synthesize imageView = _imageView, _title = title;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)aReuseIdentifier
{
    if ((self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier]))
    {
        _identifier = aReuseIdentifier;
        
        UIView* mainView = [[UIView alloc] initWithFrame:frame];
        [mainView.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [mainView.layer setMasksToBounds:YES];
        [mainView.layer setBorderWidth:2.0];
        [mainView.layer setCornerRadius:5.0];
        mainView.backgroundColor = [UIColor whiteColor];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageView.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [_imageView.layer setMasksToBounds:YES];
        [_imageView.layer setBorderWidth:2];
        [_imageView.layer setCornerRadius:5.0];
        
        
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.highlightedTextColor = [UIColor whiteColor];
        
        // Modified by Drew
        if (_identifier == @"VideoPlayerGridCellIdentifier") {
            _title.font = [UIFont boldSystemFontOfSize:12.0];
        } else {
            _title.font = [UIFont boldSystemFontOfSize:18.0]; // Increase font size
        }
        
        _title.adjustsFontSizeToFitWidth = YES;              // Set to be multiline
        _title.numberOfLines = 3;                           // Set to use as many lines as needed (3 max i think)
        _title.textAlignment = UITextAlignmentCenter;       // Center the text
        _title.minimumFontSize = 10.0;
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = self.backgroundColor;
        _imageView.backgroundColor = self.backgroundColor;
        _title.backgroundColor = [UIColor whiteColor];
        
        [_title.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [_title.layer setMasksToBounds:YES];
        [_title.layer setBorderWidth:2];
        [_title.layer setCornerRadius:5.0];
        
        //self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.25];
        
        [mainView addSubview:_imageView];
        [mainView addSubview:_title];
        [self.contentView addSubview:mainView];
        
        
        return self;
    }
    
    return nil;
}

- (void)dealloc
{
    [_imageView release];
    [_title release];
    [super dealloc];
}

- (UIImage *)image
{
    return _imageView.image;
}

- (void)setImageView:(UIImageView *)anImageView
{
    _imageView = anImageView;
    [self setNeedsLayout];
}

- (void)setImage:(UIImage *)anImage
{
    _imageView.image = anImage;
    [self setNeedsLayout];
}

- (NSString *)title
{
    return _title.text;
}

- (void)setTitle:(NSString *)newTitle
{
    _title.text = newTitle;
    [self setNeedsLayout];
}


// Original layoutSubviews was based on an imageSize that was large
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageHeightToWidth = imageSize.height/imageSize.width;
    
    CGRect bounds;
    if ( _identifier == @"VideoGridCellIdentifier" ) {
        bounds = CGRectInset(self.contentView.bounds, 5.0, 5.0);
    } else {
        bounds = CGRectInset(self.contentView.bounds, 10.0, 10.0);
    }
    CGRect frame;
    [_imageView sizeToFit];
    // get current frame
    frame = _imageView.frame;

    CGFloat inset = ((self.contentView.bounds.size.width - bounds.size.width) / 2.0);
    
    frame.origin.x = inset;
    frame.origin.y = inset;
    frame.size.width = bounds.size.width;
    frame.size.height = frame.size.width * imageHeightToWidth;
    
    // update frame
    _imageView.frame = frame;
    
    imageSize = _imageView.image.size;
    
    [_title sizeToFit];
    frame = _title.frame;
    
    frame.size.width = bounds.size.width;
    
//    frame.size.height = titleHeight;  // Modified by Drew:  Sets the height so it positions properly
    frame.origin.y = _imageView.frame.origin.y + _imageView.frame.size.height + inset;
    frame.origin.x = inset;
    frame.size.width = bounds.size.width;
    frame.size.height = bounds.size.height - frame.origin.y + inset;
    
    _title.frame = frame;
}

@end
