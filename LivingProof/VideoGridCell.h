//
//  VideoGridCell.h
//  LivingProof
//
//  Created by Andrew Kutta on 6/20/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AQGridViewCell.h"

@interface VideoGridCell : AQGridViewCell {
    
    UIImageView *_mainView;
    UIImageView *_imageView;
    UILabel *_title;
    NSString *_identifier;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImageView *mainView;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) UILabel *_title;

@end
