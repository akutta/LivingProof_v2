//
//  SurvivorNamesViewController.m
//  LivingProof
//
//  Created by Andrew Kutta on 1/15/12.
//  Copyright (c) 2012 Student. All rights reserved.
//

#import "SurvivorNamesViewController.h"
#import "VideoPlayerViewController.h"
#import "VideoGridCell.h"
#import "Video.h"
#import "Image.h"
#import "LivingProofAppDelegate.h"
#import "AgesViewController.h"

#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"


@interface SurvivorNamesViewController (Private)
- (LivingProofAppDelegate*)delegate;
@end

@implementation SurvivorNamesViewController

@synthesize gridView = _gridView;


-(IBAction)back {
    AgesViewController *nextView = [[AgesViewController alloc] initWithNibName:@"AgesViewController" 
                                                                                    bundle:nil];
    
    [[self delegate] switchView:self.view 
                         toView:nextView.view 
     //                withAnimation:UIViewAnimationTransitionFlipFromLeft 
                  withAnimation:[[self delegate] getAnimation:NO] 
                  newController:nextView];
}

-(NSArray*)getNameArray:(NSArray*)inputArray {    
    if (inputArray == nil) {
        return nil;
    }
    
    NSMutableArray* nameImageArray = [[[NSMutableArray alloc] init] autorelease];
    
    for ( Video* video in inputArray ) {
        BOOL bFound = NO;
        for ( Image *savedName in nameImageArray ) {
            if ( ![savedName.name compare:video.parsedKeys.name] ) {
                bFound = YES;
            }
        }
        
        if ( bFound == NO ) {
            NSLog(@"Adding %@",video.parsedKeys.name);
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil filter:(NSString*)filter
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSArray* SpecificAgeArray = [[[self delegate] iYouTube] getYouTubeArray:filter];
        NameArray = [self getNameArray:SpecificAgeArray];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    self.gridView.backgroundColor = [UIColor clearColor];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Enable GridView
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.gridView.autoresizesSubviews = YES;
	self.gridView.delegate = self;
	self.gridView.dataSource = self;
    
    [self reloadCurrentGrid];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


#pragma mark -
#pragma mark Grid View Data Source

- (NSUInteger)numberOfItemsInGridView:(AQGridView *)aGridView
{
    return [NameArray count];
}

- (AQGridViewCell *)gridView:(AQGridView *)aGridView cellForItemAtIndex:(NSUInteger)index
{
    static NSString *VideoGridCellIdentifier = @"VideoGridCellIdentifier";
    VideoGridCell *cell = (VideoGridCell *)[aGridView dequeueReusableCellWithIdentifier:VideoGridCellIdentifier];
    
    if ( cell == nil )
    {
        cell = [[[VideoGridCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 120.0, 160.0) reuseIdentifier:VideoGridCellIdentifier] autorelease];
        cell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
    }
    
    if ( index >= [NameArray count] ) {
        // New Category was added or we havn't stored this category yet
        [cell.imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    } else {
        Image *tmp = [NameArray objectAtIndex:index];
        
        if ( tmp.imageData == nil ) {
            if ( tmp.imageView == nil ) {
                [cell.imageView setImage:[UIImage imageNamed:@"placeholder.png"]]; 
            } else
                cell.imageView = tmp.imageView;
        } else {
            [cell.imageView setImage:tmp.imageData];
        }
        cell.title = tmp.name;
    }
    
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView:(AQGridView *)aGridView
{
    return CGSizeMake(120.0, 160.0);
}


- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{  
    Image* selectedVideo = [NameArray objectAtIndex:index];
    
}

-(LivingProofAppDelegate*)delegate {
    static LivingProofAppDelegate* del;
    if ( del == nil ) {
        del = (LivingProofAppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    
    return del;
}

-(void)reloadCurrentGrid
{
    [_gridView reloadData];
}


@end
