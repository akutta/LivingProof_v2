//
//  CategoryListViewController_iPad.m
//  LivingProof
//
//  Created by Mark Sands on 9/19/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import "CategoryListViewController_iPad.h"
#import "HorizontalVariables.h"
#import "HorizontalTableCell_iPad.h"

#define kHeadlineSectionHeight  34
#define kRegularSectionHeight   24

@implementation CategoryListViewController_iPad

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  if (!self.reusableCells)
    {       
      NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
      NSArray* sortedCategories = [self.videoDictionary.allKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
      
      NSString *categoryName;
      NSArray *currentCategory;
      
      self.reusableCells = [NSMutableArray array];
      
      for (int i = 0; i < [self.videoDictionary.allKeys count]; i++)
      {                        
        HorizontalTableCell_iPad *cell = [[HorizontalTableCell_iPad alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
        
        categoryName = [sortedCategories objectAtIndex:i];
        currentCategory = [self.videoDictionary objectForKey:categoryName];
        cell.videos = [NSArray arrayWithArray:currentCategory];
        
        [self.reusableCells addObject:cell];
        [cell release];
      }
    }
}

#pragma mark - Table View Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return section == 0 ? kHeadlineSectionHeight : kRegularSectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UIView *customSectionHeaderView;
  UILabel *titleLabel;
  UIFont *labelFont;
  
  if (section == 0)
  {
    customSectionHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kHeadlineSectionHeight)] autorelease];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, kHeadlineSectionHeight)];
    labelFont = [UIFont boldSystemFontOfSize:20];
  }
  else
  {
    customSectionHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kRegularSectionHeight)] autorelease];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, kRegularSectionHeight)];
    
    labelFont = [UIFont boldSystemFontOfSize:13];
  }  
  
  customSectionHeaderView.backgroundColor = [UIColor colorWithRed:0 green:0.40784314 blue:0.21568627 alpha:0.95];
  
  titleLabel.textAlignment = UITextAlignmentLeft;
  [titleLabel setTextColor:[UIColor whiteColor]];
  [titleLabel setBackgroundColor:[UIColor clearColor]];   
  titleLabel.font = labelFont;
  
  NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
  NSArray* sortedCategories = [self.videoDictionary.allKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
  
  NSString *categoryName = [sortedCategories objectAtIndex:section];
  
  titleLabel.text = [categoryName substringFromIndex:1];

  [customSectionHeaderView addSubview:titleLabel];
  [titleLabel release];
  
  return customSectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{        
  HorizontalTableCell *cell = [self.reusableCells objectAtIndex:indexPath.section];
  
  return cell;
}

#pragma mark - Memory Management

- (void)awakeFromNib
{
  [self.tableView setBackgroundColor:kVerticalTableBackgroundColor];
  self.tableView.rowHeight = kCellHeight_iPad + (kRowVerticalPadding_iPad * 0.5) + ((kRowVerticalPadding_iPad * 0.5) * 0.5);
}

@end
