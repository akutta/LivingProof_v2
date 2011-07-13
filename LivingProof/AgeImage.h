//
//  AgeImage.h
//  LivingProof
//
//  Created by Andrew Kutta on 7/13/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AgeImage : NSObject {
    NSString *_ageName;
    UIImage *_imageData;
    UIImageView *_imageView;
}

@property (retain) UIImage* imageData;
@property (retain) NSString* ageName;
@property (retain) UIImageView* imageView;

@end
