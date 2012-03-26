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

#import "SVProgressHUD.h"

#define YouTube_devKey @"AI39si73rPI3lBhtbSwjwML_FPEUeg7th7VQgaN3QplOaA5j9C7r-MbrP8LHwQ3ncIfMgIcevYzNpE83ynB69Uy2v-1aoq4PbQ"


@interface YouTubeInterface (Private)

- (LivingProofAppDelegate*)delegate;
- (NSArray*)getAges;
- (NSArray*)getCategories;

- (void)setFinished:(BOOL)value;
- (BOOL)getFinished;

- (BOOL)isInternetConnected;

- (void)loadVideoFeed;
- (void)addToAges:(NSString*)newAge;
- (void) addToCategories:(NSString*)newCategory;
- (NSString*) replaceSymbols:(NSString*)input;
- (NSString*) safeGetValue:(NSArray*)input index:(NSInteger)index;
- (Keys*) parseKeys:(NSArray*)unparsed;

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

NSInteger compareLargestNumber(NSString *firstTitle, NSString *secondTitle, void *context)
{
    NSArray *firstTitleChunks = [firstTitle componentsSeparatedByString:@" "];
    NSArray *secondTitleChunks = [secondTitle componentsSeparatedByString:@" "];
    
    NSInteger firstMaxAge = 0;
    NSInteger secondMaxAge = 0;
    
    // Find the largest number in the first chunk
    for ( NSString* entry in firstTitleChunks ) {
        if ( [entry integerValue] > firstMaxAge ) { // a non number is converted to a 0
            firstMaxAge = [entry integerValue];
        }
        //NSLog(@"%@ -> %i",entry, [entry integerValue]);
    }
    
    for ( NSString* entry in secondTitleChunks ) {
        if ( [entry integerValue] > secondMaxAge ) {
            secondMaxAge = [entry integerValue];
        }
    }
    
    if ( firstMaxAge < secondMaxAge )
        return NSOrderedAscending;
    else if ( firstMaxAge > secondMaxAge )
        return NSOrderedDescending;
    
    return NSOrderedSame;
}

NSInteger compareViewCount(Video *firstVideo, Video *secondVideo, void *context)
{
    //NSLog(@"Comparing %@ with %@",[firstVideo viewCount], [secondVideo viewCount]);
    
    if ( [firstVideo viewCount] < [secondVideo viewCount] )
        return NSOrderedDescending; // Normally NSOrderedAscending but this makes it order from 0..1...MAX
    else if ( [firstVideo viewCount] > [secondVideo viewCount] )
        return NSOrderedAscending;
    else
        return NSOrderedSame;
}

- (LivingProofAppDelegate*)delegate {
    static LivingProofAppDelegate* del;
    if ( del == nil ) {
        del = (LivingProofAppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    
    return del;
}

- (NSArray*)getAges {
    return [[ages copy] autorelease];
}

- (NSArray*)getCategories {
    return [[categories copy] autorelease];
}

- (void)setFinished:(BOOL)value {
    finished = [NSNumber numberWithBool:value];
}

- (BOOL)getFinished {
    return [finished boolValue];
}

- (BOOL)isInternetConnected {
    return internetConnected;
}

- (void)loadVideoFeed
{
    //[SVProgressHUD showWithStatus:@"Loading"];

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
    
    // 'next' Pages Used Reduced from 8 to 4.  Supposedly supports more but always 
    // returns an error when attempted >50.
    [query setMaxResults:50]; // IMPORTANT:  set to 50 for full testing.
    
    // Replaces api call below 
    // to increase number of queries per request
    //
    //  Increases effeciency
    ticket = [service fetchFeedWithQuery:query
                                delegate:self 
                       didFinishSelector:@selector(entryListFetchTicket:finishedWithFeed:error:)];
    
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

/*
 * entryListFetchTicket:finishedWithFeed:error
 * Last Modified: Summer2011
 * - Drew
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

        // Not able to connect to internet
        internetConnected = NO;
        return;
	}
    
    internetConnected = YES;
        
    // Create Mutable Arrays
    if ( YouTubeArray == nil )
        YouTubeArray = [[[NSMutableArray alloc] init] retain];
    
    if ( categories == nil )
        categories = [[[NSMutableArray alloc] init] retain];
 
    if ( ages == nil ) 
        ages = [[[NSMutableArray alloc] init] retain];
        
    // Explore all entries downloaded from YouTube
    NSArray *entries = [mEntriesFeed entries];
    for ( GDataEntryYouTubeVideo *entry in entries )
    {
        Video *youtubeVideo = [[Video alloc] init];
            
        // Fill out Video Data Struct
        youtubeVideo.title         = [[entry title] stringValue];
        youtubeVideo.url           = [[[entry links] objectAtIndex:0] valueForKey:@"href"]; 
        youtubeVideo.time          = [[entry mediaGroup] duration];
        youtubeVideo.category      = [[[entry mediaGroup] mediaDescription] stringValue];
        youtubeVideo.thumbnailURL  = [NSURL URLWithString:[[[[entry mediaGroup] mediaThumbnails] objectAtIndex:0] URLString]];        
        youtubeVideo.viewCount      = [[entry statistics] viewCount].intValue;
        
        
        // Dynamically update the categories that can be selected from
        [self addToCategories:youtubeVideo.category];
            
        // Store keywords pulled from Youtube
        youtubeVideo.keysArray = [[[entry mediaGroup] mediaKeywords] keywords];                 // For filter matching
        // Parse keys into own data struct
        youtubeVideo.parsedKeys = [self parseKeys:youtubeVideo.keysArray];
            
        // Dynamically update ages that can be selected from
        [self addToAges:youtubeVideo.parsedKeys.age];
            
        // Append to Mutable Array
        [YouTubeArray addObject:youtubeVideo];
            
        // Memory Management
        [youtubeVideo release];
    }
    
    [ages sortUsingFunction:compareLargestNumber context:NULL];
    [YouTubeArray sortUsingFunction:compareViewCount context:NULL];
        
    // if asked tell them we are finished
    [self setFinished:YES];
    
    // reload the current grid (UI) to update pictures
    [[self delegate] reloadCurrentGrid];

    // Done loading
    //[SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishedLoadingYoutube" object:nil];
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
    mEntriesFeed = (GDataFeedYouTubeVideo*)([feed retain]);
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

    if ( [self isInternetConnected] == NO )
        [self loadVideoFeed];
    
    // Only retrieve if we have finished downloading list from youtube
    if ( [self getFinished] == NO ) {
        return 0;
    }
    
    // if there isn't a filter send back full array
    if ( filter == nil ) {
        return [[YouTubeArray copy] autorelease];
    }
    
    // Create Mutable Array
    NSMutableArray *tmpValue = [[[NSMutableArray alloc] init] autorelease];
    
    // Only Sorting by Category and Age here
    for ( Video* video in YouTubeArray ) {
        if ( [video.category caseInsensitiveCompare:filter] == NSOrderedSame )
            [tmpValue addObject:video];
        else if ( [video.parsedKeys.age caseInsensitiveCompare:filter] == NSOrderedSame) {
            [tmpValue addObject:video];
        } else if ( [video.parsedKeys.name caseInsensitiveCompare:filter] == NSOrderedSame) {
            [tmpValue addObject:video];
        }
        
    }
    
    return [[tmpValue copy] autorelease];
}

#pragma mark - 
#pragma mark Parsing of Categories

// Check if the age exists, if not add to mutable array
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


// Check if the category exists, if not add to mutable array
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
        } else if ( ![key caseInsensitiveCompare:@"age"] ) {
            tmp.age = [self safeGetValue:unparsed index:index];
        } else if ( ![key caseInsensitiveCompare:@"survivor"] ) {
            tmp.survivorshipLength = [self safeGetValue:unparsed index:index];
        } else if ( ![key caseInsensitiveCompare:@"treatment"]) {
            tmp.treatment = [self safeGetValue:unparsed index:index];
        } else if ( ![key caseInsensitiveCompare:@"relationship"]) {
            tmp.maritalStatus = [self safeGetValue:unparsed index:index];
        } else if ( ![key caseInsensitiveCompare:@"jobstatus"]) {
            tmp.employmentStatus = [self safeGetValue:unparsed index:index];
        } else if ( ![key caseInsensitiveCompare:@"kids"]) {
            tmp.childrenStatus = [self safeGetValue:unparsed index:index];
        }
        index++;
    }
    
    return tmp;
}


@end
