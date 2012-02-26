//
//  Utilities.h
//  LivingProof
//
//  Created by Andrew Kutta on 1/14/12.
//  Copyright (c) 2012 Student. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject {
    
}

-(NSArray*)getNameVideoArray:(NSArray*)SpecificAgeVideoArray specificAge:(NSString*)age;
-(NSArray*)getNameVideoArray:(NSArray*)SpecificAgeVideoArray;
-(NSArray*)getArrayOfSurvivorsFromYoutube:(BOOL)getCategories;
-(NSArray*)getNameArray:(NSArray*)SpecificAgeVideoArray;

@end
