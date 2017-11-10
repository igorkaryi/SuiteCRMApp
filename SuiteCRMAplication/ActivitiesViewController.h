//
//  ActivitiesViewController.h
//  SuiteCRMAplication
//
//  Created by Igor Karyi on 11/1/17.
//  Copyright © 2017 Igor Karyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Meeting+CoreDataClass.h"
#import "Meeting+CoreDataProperties.h"
#import "AddActivityViewController.h"

@import CoreData;
@class AppDelegate;

@interface ActivitiesViewController : UITableViewController

@property (strong, nonatomic) NSFetchedResultsController<Meeting *> *fetchedResultsController;



@end
