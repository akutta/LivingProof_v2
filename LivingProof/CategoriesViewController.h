//
//  CategoriesViewController.h
//  LivingProof
//
//  Created by Andrew Kutta on 6/16/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@interface CategoriesViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource>  {
    NSArray *_imageNames;
    NSArray *_categoryNames;
    NSArray *_categories;
    
    AQGridView *_gridView;
}

@property (nonatomic, retain) IBOutlet AQGridView *gridView;

-(IBAction)back;
-(void)reloadCurrentGrid;
@end
