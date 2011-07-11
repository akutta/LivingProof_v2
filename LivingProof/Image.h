//
//  Image.h
//  LivingProof
//
//  Created by Andrew Kutta on 6/23/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Image : NSObject {
    NSString *_filepath;
    NSString *_title;
    UIImage  *_image;
}

@property (retain) NSString* filepath;
@property (retain) NSString* title;
@property (retain) UIImage* image;

@end
