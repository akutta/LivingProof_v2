//
//  Keys.h
//  LivingProof
//
//  Created by Andrew Kutta on 6/27/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Keys : NSObject {
    NSString* _name;
    NSString* _age;
    NSString* _treatment;
    NSString* _insurance;
    NSString* _survivorshipLength;
    NSString* _maritalStatus;
    NSString* _employmentStatus;
    NSString* _childrenStatus;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* age;
@property (nonatomic, retain) NSString* treatment;
@property (nonatomic, retain) NSString* insurance;
@property (nonatomic, retain) NSString* survivorshipLength;
@property (nonatomic, retain) NSString* maritalStatus;
@property (nonatomic, retain) NSString* employmentStatus;
@property (nonatomic, retain) NSString* childrenStatus;

@end
