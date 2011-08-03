//
//  YouTubeInterface.m
//  LivingProof
//
//  Created by Andrew Kutta on 6/21/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "YouTubeInterface.h"

#import "Video.h"
#import "Keys.h"
#import "Settings.h"


#import "GDataYouTube.h"
#import "GDataEntryYouTubeVideo.h"

#import "GDataServiceGoogleYouTube.h"

#import "GDataEntryPhoto.h"
#import "GDataFeedPhotoAlbum.h"
#import "GDataFeedPhoto.h"

#import "GDataMedia.h"
#import "GDataMediaGroup.h"
#import "GDataMediaThumbnail.h"

#import "LivingProofAppDelegate.h"

#define YouTube_devKey @"AI39si73rPI3lBhtbSwjwML_FPEUeg7th7VQgaN3QplOaA5j9C7r-MbrP8LHwQ3ncIfMgIcevYzNpE83ynB69Uy2v-1aoq4PbQ"


@interface YouTubeInterface (Private)

- (GDataServiceGoogleYouTube *)youTubeService;
- (void) parseVideos;

- (GDataServiceTicket *)entriesFetchTicket;
- (void)setEntriesFetchTicket:(GDataServiceTicket *)ticket;

- (GDataFeedBase *)entriesFeed;
- (void)setEntriesFeed:(GDataFeedBase *)feed;

- (NSError *)entryFetchError;
- (void)setEntriesFetchError:(NSError *)error;

@end


@implementation YouTubeInterface


-(LivingProofAppDelegate*)delegate {
    static LivingProofAppDelegate* del;
    if ( del == nil ) {
        del = (LivingProofAppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    
    return del;
}

-(NSArray*)getAges {
    NSArray *ret = [[ages copy] autorelease];
    return ret;
}

-(NSArray*)getCategories {
    NSArray *ret = [[categories copy] autorelease];
    return ret;
}

- (void)setFinished:(BOOL)value {
    finished = [NSNumber numberWithBool:value];
}

- (BOOL)getFinished {
    return [finished boolValue];
}

- (void)loadVideoFeed
{
    // Ensure we initialize this
    finished = [NSNumber numberWithBool:NO];

    // get the youtube service
    GDataServiceGoogleYouTube *service = [self youTubeService];
    GDataServiceTicket *ticket;
    
    // construct the feed url
    NSURL *feedURL = [NSURL URLWithString:@"http://gdata.youtube.com/feeds/api/users/livingproofapp/uploads"];
    
    // MODIFICATION:
    //      Improves network time by increasing the number of results per page
    //      Overall improvement of network speed
    GDataQueryYouTube *query = [GDataQueryYouTube youTubeQueryWithFeedURL:feedURL];
    
    // Reduced from 8 to 4.  Supposedly supports more but always returns an error when attempted >50.
    [query setMaxResults:50]; // IMPORTANT:  set to 50 for full testing.
    
    // Replaces api call below 
    // to increase number of queries per request
    ticket = [service fetchFeedWithQuery:query
                                delegate:self 
                       didFinishSelector:@selector(entryListFetchTicket:finishedWithFeed:error:)];
    
    /*
    // make API call
    ticket = [service fetchFeedWithURL:feedURL
                              delegate:self
                     didFinishSelector:@selector(entryListFetchTicket:finishedWithFeed:error:)];
    */
    
    [self setEntriesFetchTicket:ticket];
}

#pragma mark -
#pragma mark gData

// get a YouTube service object with the current username/password
//
// A "service" object handles networking tasks.  Service objects
// contain user authentication information as well as networking
// state information (such as cookies and the "last modified" date for
// fetched data.)

- (GDataServiceGoogleYouTube *)youTubeService
{  
    static GDataServiceGoogleYouTube* service = nil;
    
    if (!service) {
        service = [[GDataServiceGoogleYouTube alloc] init];
        [service setShouldCacheResponseData:YES];
        [service setServiceShouldFollowNextLinks:YES]; // IMPORTANT:  When doing more testing set to YES
        [service setIsServiceRetryEnabled:YES];
    }
    
	[service setUserCredentialsWithUsername:@"livingproofapp" password:@"breastcancer"];
    [service setYouTubeDeveloperKey:YouTube_devKey];
	
    return service;
}

-(void)addToAges:(NSString*)newAge {

    if ( newAge == nil ) {
        newAge = @""; // There is an error in the ages
    }
    
    BOOL bFound = NO;
    for ( id objects in ages ) {
        if ( [objects isKindOfClass:[NSString class]] ) {
            NSString* curObject = objects;
            if ( ![curObject compare:newAge] ) 
                bFound = YES;
        }
    }
    if ( !bFound ) {
        [ages addObject:newAge];
    }
}

- (void) addToCategories:(NSString*)newCategory {
    
    BOOL bFound = NO;
    for ( id objects in categories ) {
        if ( [objects isKindOfClass:[NSString class]] )
        {
            NSString *curObject = objects;
            if ( ![curObject compare:newCategory] )
                bFound = YES;
        }
    }
    if ( !bFound ) {
        [categories addObject:newCategory];
    }

}

-(NSString*) replaceSymbols:(NSString*)input {
    NSMutableString *output = [[NSMutableString alloc] initWithString:input];
    
    [output replaceOccurrencesOfString:@"_" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [output length])];
    
    return output;
}

-(NSString*) safeGetValue:(NSArray*)input index:(NSInteger)index {
    
   // NSLog(@"%d  %d",index,[input count]);
    
    if ( index >= [input count] - 1 )
        return @"Unavailable";
    
    return [self replaceSymbols:[input objectAtIndex:(index+1)]];
}

- (Keys*) parseKeys:(NSArray*)unparsed {
    Keys *tmp = [[[Keys alloc] init] autorelease];
    
    NSInteger index = 0;
    for ( NSString* key in unparsed ) 
    {
        if ( ![key caseInsensitiveCompare:@"name"] ) {
            tmp.name = [self safeGetValue:unparsed index:index];
            //NSLog(@"Name:  %@",tmp.name);
        } else if ( ![key caseInsensitiveCompare:@"age"] ) {
            tmp.age = [self safeGetValue:unparsed index:index];
            //NSLog(@"Age:   %@",tmp.age);
        } else if ( ![key caseInsensitiveCompare:@"survivor"] ) {
            tmp.survivorshipLength = [self safeGetValue:unparsed index:index];
            //NSLog(@"Length of Survival:  %@",tmp.survivorshipLength);
        } else if ( ![key caseInsensitiveCompare:@"treatment"]) {
            tmp.treatment = [self safeGetValue:unparsed index:index];
            //NSLog(@"Treatment:  %@", tmp.treatment);
        } else if ( ![key caseInsensitiveCompare:@"relationship"]) {
            tmp.maritalStatus = [self safeGetValue:unparsed index:index];
            //NSLog(@"Relationship: %@", tmp.maritalStatus);
        } else if ( ![key caseInsensitiveCompare:@"jobstatus"]) {
            tmp.employmentStatus = [self safeGetValue:unparsed index:index];
            //NSLog(@"Employment at Time of Diagnosis:   %@", tmp.employmentStatus);
        } else if ( ![key caseInsensitiveCompare:@"kids"]) {
            tmp.childrenStatus = [self safeGetValue:unparsed index:index];
            //NSLog(@"Children:  %@", tmp.childrenStatus);
        }
        index++;
    }
    
    return tmp;
}

/*
 * entryListFetchTicket:finishedWithFeed:error
 * Last Modified: 20June2010
 * - Mark
 * 
 * When gData is finished downloading the youtube data, the mEntriesFeed is set
 * to the passed value, the items are then traversed in a for loop as a
 * GDataEntryYouTubevideo item, and assigned associated values to a YouTubeVideo model.
 * The object is then added to the YouTubeArray.
 *
 */
- (void)entryListFetchTicket:(GDataServiceTicket *)ticket
            finishedWithFeed:(GDataFeedBase *)feed
                       error:(NSError *)error
{
	[self setEntriesFeed:feed];
	[self setEntriesFetchError:error];
	[self setEntriesFetchTicket:nil];
 	
	if ( error != nil ) {
        NSLog(@"Error: %@",[error localizedDescription]);
	}
	else {
		if ( YouTubeArray == nil )
			YouTubeArray = [[NSMutableArray alloc] init];
        
        if ( categories == nil )
            categories = [[NSMutableArray alloc] init];
        
        if ( ages == nil ) 
            ages = [[NSMutableArray alloc] init];
        
		NSArray *entries = [mEntriesFeed entries];
		for ( GDataEntryYouTubeVideo *entry in entries )
		{
			Video *youtubeVideo = [[Video alloc] init];
            
			youtubeVideo.title         = [[entry title] stringValue];
			youtubeVideo.url           = [[[entry links] objectAtIndex:0] valueForKey:@"href"]; 
			youtubeVideo.time          = [[entry mediaGroup] duration];
			youtubeVideo.category      = [[[entry mediaGroup] mediaDescription] stringValue];
			youtubeVideo.thumbnailURL  = [NSURL URLWithString:[[[[entry mediaGroup] mediaThumbnails] objectAtIndex:0] URLString]];        
            
            [self addToCategories:youtubeVideo.category];
            
            
            youtubeVideo.keysArray = [[[entry mediaGroup] mediaKeywords] keywords];                 // For filter matching
            youtubeVideo.parsedKeys = [self parseKeys:youtubeVideo.keysArray];
                
            [self addToAges:youtubeVideo.parsedKeys.age];
            
			[YouTubeArray addObject:youtubeVideo];
			[youtubeVideo release];
		}
	}
    
    [self setFinished:YES];
    [[self delegate] reloadCurrentGrid];
}


#pragma mark -
#pragma mark Get & Set

- (void)setEntriesFetchTicket:(GDataServiceTicket *)ticket
{
    [mEntriesFetchTicket release];
    mEntriesFetchTicket = [ticket retain];
}

- (NSError *)entryFetchError
{
    return mEntriesFetchError; 
}

- (GDataFeedBase *)entriesFeed
{
    return mEntriesFeed; 
}

- (void)setEntriesFeed:(GDataFeedBase *)feed
{
    [mEntriesFeed autorelease];
    mEntriesFeed = [feed retain];
}

- (void)setEntriesFetchError:(NSError *)error
{
    [mEntriesFetchError release];
    mEntriesFetchError = [error retain];
}

- (GDataServiceTicket *)entriesFetchTicket
{
    return mEntriesFetchTicket; 
}


-(NSArray*)getYouTubeArray:(NSString*)filter {
    
    if ( [self getFinished] == NO ) {
        return 0;
    }
    
    if ( filter == nil ) {
        NSArray* retValue = [YouTubeArray copy];
        [retValue autorelease];
        return retValue;
    }
    
    NSMutableArray *tmpValue = [[NSMutableArray alloc] init];
    
    
    // Only Sorting by Category and Age here
    for ( Video* video in YouTubeArray ) {
        if ( [video.category caseInsensitiveCompare:filter] == NSOrderedSame )
            [tmpValue addObject:video];
        else if ( [video.parsedKeys.age caseInsensitiveCompare:filter] == NSOrderedSame) {
            //NSLog(@"%@ is the same as %@",filter,video.parsedKeys.age);
            [tmpValue addObject:video];
        }
        
    }
    
    NSArray* retValue = [tmpValue copy];
    [retValue autorelease];
    [tmpValue release];
    return retValue;
}

@end
