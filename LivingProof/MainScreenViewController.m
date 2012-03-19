//
//  MainScreenViewController.m
//  LivingProof
//
//  Created by Andrew Kutta on 7/11/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "MainScreenViewController.h"
#import "CategoriesViewController.h"
#import "AgesViewController.h"
#import "LivingProofAppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@interface MainScreenViewController (Private)
-(LivingProofAppDelegate*)delegate;
-(IBAction)sortByCategories;
-(IBAction)sortByAge;
- (void)displayPortrait;
- (void)displayLandscape;
@end

@implementation MainScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sortAge.hidden = YES;
        sortCategory.hidden = YES;

        loadingLabel.hidden = NO;
        activityView.hidden = NO;
        [activityView startAnimating];

        [[NSNotificationCenter defaultCenter] addObserver:self 
                                               selector:@selector(finishedLoadingYoutube:) 
                                                   name:@"FinishedLoadingYoutube" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [landscapeBackgroundImage release];
    [portraitBackgroundImage release];
    [lightPink release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)finishedLoadingYoutube:(id)sender
{
  sortAge.hidden = NO;
  sortCategory.hidden = NO;
  
  [activityView stopAnimating];
  activityView.hidden = YES;
  loadingLabel.hidden = YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{    
    if ( toInterfaceOrientation == UIInterfaceOrientationPortrait || 
        toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [self displayPortrait];
    }
    else if ( toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || 
             toInterfaceOrientation == UIInterfaceOrientationLandscapeRight )
    {

        [self displayLandscape];
    }
}

#pragma mark - View lifecycle

- (UIImage*)initFromColor:(UIColor*)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setButtonLook:(UIButton*)button {
    
    /*
    button.backgroundColor = lightPink;
    [button.layer setBorderColor:[button.currentTitleColor CGColor]];
     */
    button.backgroundColor = button.currentTitleColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.layer setBorderColor:[lightPink CGColor]];
    
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderWidth:2];
    [button.layer setCornerRadius:12.0];
    
    [button setTitleColor:button.backgroundColor forState:UIControlStateHighlighted];
    [button setBackgroundImage:[self initFromColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
}

- (void)viewDidLoad
{
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib

    if ( UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ) {
        [self displayPortrait];
    } else
        [self displayLandscape];

    landscapeBackgroundImage = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"WelcomeScreenRotated.png"]]; 
    portraitBackgroundImage = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"WelcomeScreen.png"]];
    lightPink = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"WelcomeScreen.png"]];
    strongPink = sortCategory.currentTitleColor;
    
    
    self.view.backgroundColor = portraitBackgroundImage;
    [self setButtonLook:sortAge];
    [self setButtonLook:sortCategory];

  /* ensure buttons appear if the feed has already been fetched */   
    if ([[[self delegate] iYouTube] getFinished])    
        [self finishedLoadingYoutube:nil];
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
    [self delegate].curOrientation = interfaceOrientation;
    return YES;
}

//
// Private Implementations 
//


//
// Wrapper to get pointer to delegate
//
-(LivingProofAppDelegate*)delegate {
    static LivingProofAppDelegate* del;
    if ( del == nil ) {
        del = (LivingProofAppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    
    return del;
}

//
// Event Handler
//
-(IBAction)sortByCategories
{
    CategoriesViewController *nextView = [[CategoriesViewController alloc] initWithNibName:@"CategoriesViewController" bundle:nil];
  [[self delegate] switchView:self.view toView:nextView.view withAnimation:[[self delegate] getAnimation:NO] newController:nextView]; 
//  [[self delegate] switchView:self.view 
//                       toView:nextView.view 
//                withAnimation:UIViewAnimationTransitionFlipFromRight 
//                newController:nextView];

}

//
// Event Handler
//
-(IBAction)sortByAge
{
    AgesViewController *nextView = [[AgesViewController alloc] initWithNibName:@"AgesViewController" bundle:nil];
    [[self delegate] switchView:self.view toView:nextView.view withAnimation:[[self delegate] getAnimation:NO] newController:nextView]; 
//  [[self delegate] switchView:self.view 
//                       toView:nextView.view 
//                withAnimation:UIViewAnimationTransitionFlipFromRight
//                newController:nextView];
}

//
// Portrait Orientations of the Buttons and Background
//
- (void)displayPortrait {
    CGRect sortAgeFrame = sortAge.frame;
    sortAgeFrame.origin = CGPointMake(170.0f, 807.0f);
    sortAgeFrame.size = CGSizeMake(210,93);
    sortAge.frame = sortAgeFrame;
    
    
    CGRect sortCategoryFrame = sortCategory.frame;
    sortCategoryFrame.origin = CGPointMake(390.0f, 807.0f);
    sortCategoryFrame.size = CGSizeMake(210,93);
    sortCategory.frame = sortCategoryFrame;

    CGRect labelFrame = (CGRect){ CGPointMake(364, 878) ,loadingLabel.frame.size };
    loadingLabel.frame = labelFrame;

    CGRect loadFrame = (CGRect){ CGPointMake(384, 849), activityView.frame.size };
    activityView.frame = loadFrame;

    self.view.backgroundColor = portraitBackgroundImage;
}

//
// Landscape Orientations of the Buttons and Background
//
- (void)displayLandscape {
    CGRect sortAgeFrame = sortAge.frame;
    sortAgeFrame.origin = CGPointMake(150.0f, 573.0f);
    sortAgeFrame.size = CGSizeMake(360,90);
    sortAge.frame = sortAgeFrame;
    
    CGRect sortCategoryFrame = sortCategory.frame;
    sortCategoryFrame.origin = CGPointMake(516.0f, 573.0f);
    sortCategoryFrame.size = CGSizeMake(360,90);
    sortCategory.frame = sortCategoryFrame;

    CGRect labelFrame = (CGRect){ CGPointMake(480, 630) ,loadingLabel.frame.size };
    loadingLabel.frame = labelFrame;

    CGRect loadFrame = (CGRect){ CGPointMake(500, 600), activityView.frame.size };
    activityView.frame = loadFrame;

    self.view.backgroundColor = landscapeBackgroundImage;
}


@end
