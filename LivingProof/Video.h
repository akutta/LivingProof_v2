//
//  Video.h
//  LivingProof
//
//  Created by Mark Sands on 3/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"

@interface Video : NSObject
{
  NSURL *_url;
  NSURL *_thumbnailURL;

  NSNumber *_time;

  NSString *_title;
  NSString *_category;

  NSArray *_parsedKeysArray;
  NSArray *_keysArray;
  Keys *_parsedKeys;
}

@property (retain) NSURL *url;
@property (retain) NSURL *thumbnailURL;

@property (copy) NSNumber *time;

@property (copy) NSString *title;
@property (copy) NSString *category;

@property (copy) NSArray* keysArray;
@property (retain) Keys* parsedKeys;

@end
