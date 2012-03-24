//
//  AgesViewController.h
//  LivingProof
//
//  Created by Andrew Kutta on 7/12/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "Utilities.h"

@interface AgesViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource>  {
    NSArray *_imageNames;
    NSArray *_ageNames;
    NSArray *_ages;
    
    AQGridView *_gridView;
    Utilities *_utilities;
}

@property (nonatomic, retain) IBOutlet AQGridView *gridView;

-(IBAction)goHome:(id)sender;
-(IBAction)back;
-(void)reloadCurrentGrid;
@end
