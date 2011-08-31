//
//  VideoGridCell.m
//  LivingProof
//
//  Created by Mark Sands on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VideoGridCell.h"

@implementation VideoGridCell

@synthesize imageView = _imageView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)aReuseIdentifier
{
    if ((self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier]))
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.highlightedTextColor = [UIColor whiteColor];
        
        // Modified by Drew
        _title.font = [UIFont boldSystemFontOfSize: 14.0]; // Increase font size
        _title.adjustsFontSizeToFitWidth = YES;              // Set to be multiline
        _title.numberOfLines = 3;                           // Set to use as many lines as needed (3 max i think)
        _title.textAlignment = UITextAlignmentCenter;       // Center the text
        _title.minimumFontSize = 10.0;
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = self.backgroundColor;
        _imageView.backgroundColor = self.backgroundColor;
        _title.backgroundColor = self.backgroundColor;
        
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_title];
        
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

- (void)setTitle:(NSString *)title
{
    _title.text = title;
    [self setNeedsLayout];
}


// Original layoutSubviews was based on an imageSize that was large
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize imageSize = _imageView.image.size;
    
    CGRect bounds = CGRectInset(self.contentView.bounds, 10.0, 10.0);
    CGFloat ratio = MIN(bounds.size.width / imageSize.width , ((bounds.size.height) / imageSize.height));;
    //CGFloat aspectRatio = imageSize.width / imageSize.height;
    CGFloat titleHeight = (bounds.size.height - _imageView.image.size.height * ratio);
    CGRect frame;
    
    if ((imageSize.width <= bounds.size.width) && (imageSize.height <= bounds.size.height))
    {
        ratio = 1;
    }
    [_imageView sizeToFit];
    // get current frame
    frame = _imageView.frame;
    
    // update frame variable based on image
    frame.size.width = floorf(imageSize.width * ratio);
    frame.size.height = floorf(imageSize.height * ratio);
        
    if ( frame.size.height == bounds.size.height )
        frame.size.height -= titleHeight;
    
    frame.origin.x = floorf((bounds.size.width - frame.size.width) * 0.5);
    frame.origin.y = floorf((bounds.size.height - frame.size.height) * 0.5);
    
    // update frame
    _imageView.frame = frame;
    
    imageSize = _imageView.image.size;
    
    [_title sizeToFit];
    frame = _title.frame;
    frame.size.width = MIN(frame.size.width, bounds.size.width);
    frame.size.height = titleHeight;  // Modified by Drew:  Sets the height so it positions properly
    frame.origin.y = CGRectGetMaxY(bounds) - frame.size.height * 0.7;    // multiply by .5
    frame.origin.x = floorf((bounds.size.width - frame.size.width) * 0.5);
    _title.frame = frame;
}

@end
