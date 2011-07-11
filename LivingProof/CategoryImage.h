//
//  CategoryImage.h
//  LivingProof
//
//  Created by Andrew Kutta on 6/27/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CategoryImage : NSObject {
    NSString *_categoryName;
    UIImage *_imageData;
    UIImageView *_imageView;
}

@property (retain) UIImage* imageData;
@property (retain) NSString* categoryName;
@property (retain) UIImageView* imageView;

@end
