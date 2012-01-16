//
//  SurvivorNamesViewController.h
//  LivingProof
//
//  Created by Andrew Kutta on 1/15/12.
//  Copyright (c) 2012 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@interface SurvivorNamesViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource> 
{
    AQGridView *_gridView;
    NSArray* NameArray;
    NSArray* SpecificAgeVideoArray;
}
@property (nonatomic, retain) IBOutlet AQGridView *gridView;

-(IBAction)back;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil filter:(NSString*)filter;
-(void)reloadCurrentGrid;
@end
