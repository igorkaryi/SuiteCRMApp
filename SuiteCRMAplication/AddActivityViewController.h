//
//  AddActivityViewController.h
//  SuiteCRMAplication
//
//  Created by Igor Karyi on 11/1/17.
//  Copyright © 2017 Igor Karyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreData;
@class AppDelegate;

@interface AddActivityViewController : UIViewController

@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic, weak) AppDelegate *delegate;

@end
