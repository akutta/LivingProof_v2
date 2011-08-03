//
//  VideoSelectionViewController.h
//  LivingProof
//
//  Created by Andrew Kutta on 6/16/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"


@interface VideoSelectionViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource> {
    
    IBOutlet UIBarButtonItem* display;
    
    AQGridView *_gridView;
    NSString *_curCategory;
    NSString *_curButtonText;
    NSString *_searchText;
    
    NSMutableArray *_filteredResults;
}

@property (nonatomic, retain) IBOutlet AQGridView *gridView;
@property (nonatomic, retain) NSString* curCategory;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil category:(NSString *)catText filter:(NSString *)filterText buttonText:(NSString*)title;


-(IBAction)swapViewToCategories:(id)sender;
-(void)reloadCurrentGrid;
@end
