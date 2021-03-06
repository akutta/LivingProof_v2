//
//  CategoryImage.h
//  LivingProof
//
//  Created by Andrew Kutta on 6/27/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Video.h"

@interface Image : NSObject {
    NSString *_name;
    UIImage *_imageData;
    UIImageView *_imageView;
    NSURL *_thumbnailURL;
    Video *_video;
}

@property (retain) UIImage* imageData;
@property (retain) NSString* name;
@property (retain) UIImageView* imageView;
@property (retain) NSURL* thumbnailURL;
@property (retain) Video* video;         // Only used in SurvivorNamesViewController.h

@end
