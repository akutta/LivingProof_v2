//
//  Settings.m
//  LivingProof
//
//  Created by Andrew Kutta on 6/22/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "Settings.h"
#import "Image.h"
#import "CategoryImage.h"

@implementation Settings

@synthesize settingsPath;

- (BOOL)check:(NSString*)file forSubstring:(NSString*)subString {
    
    NSRange textRange;
    textRange =[[file lowercaseString] rangeOfString:subString];
    
    if(textRange.location != NSNotFound)
    {
        // Found an image
        return YES;
    }
    return NO;
}

- (NSString*)getDirPath:(NSString*)dir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:dir];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];   
    
    return documentsDirectory;
}

-(NSArray*)getCategoryImages
{
    NSMutableArray *retValue = [[NSMutableArray alloc] init];
    /*
    NSString* id = [[UIDevice currentDevice] uniqueIdentifier];
    NSLog(@"Identifier:  %@",id);*/
    
    
    NSString *categoryDirectory = [self getDirPath:@"Category Images"];
    
    // Get the file names
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:categoryDirectory error:&error];
    if ( files == nil ) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    
    // Get Image Names
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for ( NSString *file in files ) {
        if ( [self check:file forSubstring:@".jpg"] == YES) {
            [images addObject:file];
        } else if ( [self check:file forSubstring:@"categories"] == YES ) {
            settingsPath = [categoryDirectory stringByAppendingPathComponent:file];
        }
    }
    
    // check if anything has been saved
    if ( settingsPath == nil ) {
        return nil;
    } else {
        // Path to settings file
        NSString* categoryData = [NSString stringWithContentsOfFile:settingsPath 
                                                           encoding:NSUTF8StringEncoding 
                                                              error:nil];
        NSArray* allLinedStrings = [categoryData componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSInteger curImage = 0;
        for ( NSString* category in allLinedStrings ) {
          //  NSLog(@"%@",category);
            CategoryImage *tmp = [[CategoryImage alloc] init];
            tmp.categoryName = [category copy];
            
            if ( curImage >= [images count] )
                tmp.imageData = [UIImage imageNamed:@"placeholder.png"];
            else
                tmp.imageData = [UIImage imageWithContentsOfFile:[categoryDirectory stringByAppendingPathComponent:[images objectAtIndex:curImage]]];
            [retValue addObject:tmp];
            [tmp release];
            curImage++;
        }
    }
    
    return [retValue copy];
}

// Removing the side-effects of converting an NSArray -> NSString
-(NSString*)stripParenthesis:(NSString*)input {
    NSMutableString *output = [[NSMutableString alloc] initWithString:input];
    

    
    [output replaceOccurrencesOfString:@"\n)" 
                            withString:@"" 
                               options:NSCaseInsensitiveSearch 
                                 range:NSMakeRange(0, [output length])];
    [output replaceOccurrencesOfString:@"," 
                            withString:@"" 
                               options:NSCaseInsensitiveSearch 
                                 range:NSMakeRange(0, [output length])];
    [output replaceOccurrencesOfString:@"(\n" 
                            withString:@"" 
                               options:NSCaseInsensitiveSearch 
                                 range:NSMakeRange(0, [output length])];
    [output replaceOccurrencesOfString:@"(" 
                            withString:@"" 
                               options:NSCaseInsensitiveSearch 
                                 range:NSMakeRange(0, [output length])];
    [output replaceOccurrencesOfString:@"  " 
                            withString:@"" 
                               options:NSCaseInsensitiveSearch 
                                 range:NSMakeRange(0, [output length])];
    [output replaceOccurrencesOfString:@"\"" 
                            withString:@"" 
                               options:NSCaseInsensitiveSearch 
                                 range:NSMakeRange(0, [output length])];
    return [output copy];
}

-(void)saveCategoryImages:(NSArray *)data {
    NSInteger curImage = 0;
    NSString *categoryDirectory = [self getDirPath:@"Category Images"];
    NSMutableArray *categoryData = [[NSMutableArray alloc] init];
    
    for ( id item in data ) {
        if ( [item isKindOfClass:[CategoryImage class]] ) {
            NSString* path = [categoryDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d.jpg",curImage]];
            CategoryImage *entry = item;
            if ( entry.imageData != nil ) {
                NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(entry.imageData, 1.0)];
                [imageData writeToFile:path atomically:YES];
                curImage++;
            }
            [categoryData addObject:[NSString stringWithFormat:@"%@", entry.categoryName]];
        } else {
            NSLog(@"Error Settings:saveCategoryImages");
        }
    }
    
   // NSLog(@"categories: %@",categoryData);
    NSString *toFile = [self stripParenthesis:[NSString stringWithFormat:@"%@", categoryData]];
    [toFile writeToFile:[categoryDirectory stringByAppendingPathComponent:@"categories"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
