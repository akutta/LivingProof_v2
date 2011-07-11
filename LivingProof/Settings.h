//
//  Settings.h
//  LivingProof
//
//  Created by Andrew Kutta on 6/22/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Settings : NSObject {
    NSString* settingsPath;
}

@property (retain) NSString* settingsPath;

-(void)saveCategoryImages:(NSArray *)data;
//-(void)saveCategoryImages:(NSArray*)data images:(NSArray*)images;
-(NSArray*)getCategoryImages;

@end
