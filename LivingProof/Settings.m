//
//  Settings.m
//  LivingProof
//
//  Created by Andrew Kutta on 6/22/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "Settings.h"
#import "Image.h"

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


- (NSMutableArray *) getImages:(NSString *)directory files:(NSArray *)files settingsName:(NSString*)settings  {
    // Get Image Names
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for ( NSString *file in files ) {
        if ( [self check:file forSubstring:@".jpg"] == YES) {
            [images addObject:file];
        } else if ( [self check:file forSubstring:settings] == YES ) {
            settingsPath = [directory stringByAppendingPathComponent:file];
        }
    }
    return images;
}


- (NSArray *) getFilesInDirectory: (NSString *) categoryDirectory  {
    // Get the file names
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:categoryDirectory error:&error];
    if ( files == nil ) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    return files;
}

-(NSArray*)getAgeImages
{
    NSMutableArray *retValue = [[NSMutableArray alloc] init];
    
    NSString *agesDirectory = [self getDirPath:@"Age Images"];
    NSArray *files  = [self getFilesInDirectory:agesDirectory];
    NSMutableArray *images = [self getImages:agesDirectory
                                       files:files 
                                settingsName:@"ages"];
    
    // check if anything has been saved
    if ( settingsPath == nil ) {
        return nil;
    } else {
        NSLog(@"AgeSettings:\r%@",settingsPath);
        // Path to settings file
        NSString* ageData = [NSString stringWithContentsOfFile:settingsPath 
                                                           encoding:NSUTF8StringEncoding 
                                                              error:nil];
        NSArray* allLinedStrings = [ageData componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSInteger curImage = 0;
        for ( NSString* age in allLinedStrings ) {
            Image *tmp = [[Image alloc] init];
            tmp.name = [age copy];
            
            if ( curImage >= [images count] )
                tmp.imageData = nil;//[UIImage imageNamed:@"placeholder.png"];
            else
                tmp.imageData = [UIImage imageWithContentsOfFile:[agesDirectory stringByAppendingPathComponent:[images objectAtIndex:curImage]]];
            [retValue addObject:tmp];
            [tmp release];
            curImage++;
        }
    }

    return [retValue copy];
}


-(NSArray*)getCategoryImages
{
    NSMutableArray *retValue = [[NSMutableArray alloc] init];
    /*
    NSString* id = [[UIDevice currentDevice] uniqueIdentifier];
    NSLog(@"Identifier:  %@",id);*/
    
    
    NSMutableArray *images;
    NSArray *files;
    NSString *categoryDirectory = [self getDirPath:@"Category Images"];
    
    files = [self getFilesInDirectory: categoryDirectory];
    images = [self getImages:categoryDirectory 
                       files:files
                settingsName:@"categories"];

    
    // check if anything has been saved
    if ( settingsPath == nil ) {
        return nil;
    } else {
        NSLog(@"CategorySettings:\r%@",settingsPath);
        // Path to settings file
        NSString* categoryData = [NSString stringWithContentsOfFile:settingsPath 
                                                           encoding:NSUTF8StringEncoding 
                                                              error:nil];
        NSArray* allLinedStrings = [categoryData componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSInteger curImage = 0;
        for ( NSString* category in allLinedStrings ) {
          //  NSLog(@"%@",category);
            Image *tmp = [[Image alloc] init];
            tmp.name = [category copy];
            
            if ( curImage >= [images count] )
                tmp.imageData = nil;//[UIImage imageNamed:@"placeholder.png"];
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

-(void)saveAgeImages:(NSArray *)data {
    NSInteger curImage = 0;
    NSString *ageDirectory = [self getDirPath:@"Age Images"];
    NSMutableArray *ageData = [[NSMutableArray alloc] init];
    
    for ( id item in data ) {
        if ( [item isKindOfClass:[Image class]] )
        {
            NSString *path = [ageDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d.jpg",curImage]];
            Image *entry = item;
            if ( entry.imageData != nil ) {
                NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(entry.imageData, 1.0)];
                [imageData writeToFile:path atomically:YES];
                curImage++;
            }
            [ageData addObject:[NSString stringWithFormat:@"%@", entry.name]];
        } else {
            NSLog(@"Error Settings:saveAgeImages");
        }
    }
    
    NSString *toFile = [self stripParenthesis:[NSString stringWithFormat:@"%@", ageData]];
    [toFile writeToFile:[ageDirectory stringByAppendingPathComponent:@"ages"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(void)saveCategoryImages:(NSArray *)data {
    NSInteger curImage = 0;
    NSString *categoryDirectory = [self getDirPath:@"Category Images"];
    NSMutableArray *categoryData = [[NSMutableArray alloc] init];
    
    for ( id item in data ) {
        if ( [item isKindOfClass:[Image class]] ) {
            NSString* path = [categoryDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d.jpg",curImage]];
            Image *entry = item;
            if ( entry.imageData != nil ) {
                NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(entry.imageData, 1.0)];
                [imageData writeToFile:path atomically:YES];
                curImage++;
            }
            [categoryData addObject:[NSString stringWithFormat:@"%@", entry.name]];
        } else {
            NSLog(@"Error Settings:saveCategoryImages");
        }
    }
    
    NSString *toFile = [self stripParenthesis:[NSString stringWithFormat:@"%@", categoryData]];
    [toFile writeToFile:[categoryDirectory stringByAppendingPathComponent:@"categories"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
