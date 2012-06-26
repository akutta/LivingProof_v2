//
//  Utilities.m
//  LivingProof
//
//  Created by Andrew Kutta on 1/14/12.
//  Copyright (c) 2012 Student. All rights reserved.
//

#import "LivingProofAppDelegate.h"
#import "Image.h"
#import "Video.h"
#import "Survivor.h"
#import "Utilities.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"



@implementation Utilities

-(LivingProofAppDelegate*)delegate {
    static LivingProofAppDelegate* del;
    if ( del == nil ) {
        del = (LivingProofAppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    
    return del;
}

-(NSArray*)getNameVideoArray:(NSArray*)SpecificAgeVideoArray specificAge:(NSString*)age {
    NSMutableArray* videoArray = [[[NSMutableArray alloc] init] autorelease];
    
    for ( Video* video in SpecificAgeVideoArray ) {
        BOOL bFound = NO;
        if ( ![video.parsedKeys.age compare:age] ) {
            bFound = YES;
        }
        
        if ( bFound == YES ) {
            [videoArray addObject:video];
        }
    }
    
    return videoArray;
}

-(NSArray*)getNameVideoArray:(NSArray*)SpecificAgeVideoArray {
    NSMutableArray* nameArray = [[[NSMutableArray alloc] init] autorelease];
    
    for ( Video* video in SpecificAgeVideoArray ) {
        BOOL bFound = NO;
        
        for ( Video *savedVideo in nameArray ) {
            if ( ![savedVideo.parsedKeys.name compare:video.parsedKeys.name] ) {
                bFound = YES;
            }
        }
        
        if ( bFound == NO ) {
            [nameArray addObject:video];
        }
    }
    
    return [nameArray copy];
}

-(NSArray*)getNameArray:(NSArray*)SpecificAgeVideoArray {  

    NSMutableArray* nameImageArray = [[[NSMutableArray alloc] init] autorelease];
    
    for ( Video* video in SpecificAgeVideoArray ) {
        BOOL bFound = NO;
        for ( Image *savedName in nameImageArray ) {
            if ( ![savedName.name compare:video.parsedKeys.name] ) {
                bFound = YES;
            }
        }
        
        if ( bFound == NO ) {
            Image *tmpImage = [[Image alloc] init];
            tmpImage.name = video.parsedKeys.name;
            tmpImage.thumbnailURL = video.thumbnailURL;
            
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            UIImage *cachedImage = [manager imageWithURL:tmpImage.thumbnailURL];
            if ( cachedImage ) {
                tmpImage.imageData = cachedImage;
            } else {
                [tmpImage.imageView setImageWithURL:tmpImage.thumbnailURL placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            }
            
            [nameImageArray addObject:tmpImage];
            [tmpImage release];
        }
        
    }
    
    return [nameImageArray copy];
}


-(NSArray*)getArrayOfSurvivorsFromYoutube:(BOOL)getCategories {
    
    NSMutableArray* survivors = [[NSMutableArray alloc] init];
    NSMutableArray* _survivorImages = [[NSMutableArray alloc] init];
    NSArray* _Names;
    NSArray* videos;
    NSInteger index = 0;
    
    [survivors autorelease];
    [_survivorImages autorelease];
    
    // YouTube isn't finished downloading yet so don't continue here
    if ( [[[self delegate] iYouTube] getFinished] == NO ) {
        NSLog(@"YouTube Not Finished");
        return [[_survivorImages copy] autorelease];
    }

    if ( getCategories == YES )
        _Names = [[[[self delegate] iYouTube] getCategories] copy];
    else {
        _Names = [[[[self delegate] iYouTube] getAges] copy];
    }
        
    
    
    videos = [[[self delegate] iYouTube] getYouTubeArray:nil];;
    
    for ( Video* curVideo in videos )
    {
        BOOL bFound = NO;
        for ( Survivor* survivor in survivors )
        {
            if ( ![survivor.name compare:curVideo.parsedKeys.name] ) {
                bFound = YES;
            }
        }
        
        if ( !bFound ) {
            Survivor *tmp = [[Survivor alloc] init];
            tmp.name = curVideo.parsedKeys.name;
            tmp.url = curVideo.thumbnailURL;
            [survivors addObject:tmp];
            [tmp release];
        }
    }
    
    for ( NSString* name in _Names ) {
        Image *tmp = [[Image alloc] init];
        if ( index >= [survivors count] ) {
            tmp.imageData = nil;
            tmp.imageView = nil;
        } else {
            Survivor *surv = [survivors objectAtIndex:index];            // Reduces the amount of work that the iPad needs to do
            // Without doing it this way, the application can lag and slightly freeze
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            UIImage *cachedImage = [manager imageWithURL:surv.url];
            if ( cachedImage )
                tmp.imageData = cachedImage;
            else
                [tmp.imageView setImageWithURL:surv.url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            
            tmp.thumbnailURL = surv.url;
        }
        tmp.name = name;
        [_survivorImages addObject:tmp];
        
        [tmp release];
        index++;
    }
    
    [_Names release];
    return [_survivorImages copy];
}

@end
