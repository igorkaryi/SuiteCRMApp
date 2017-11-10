//
//  AppDelegate.m
//  SuiteCRMAplication
//
//  Created by Igor Karyi on 11/1/17.
//  Copyright © 2017 Igor Karyi. All rights reserved.
//

#import "AppDelegate.h"
#import "Meeting+CoreDataClass.h"
@interface AppDelegate ()
@property (nonatomic) NSManagedObjectContext * context;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.context = self.persistentContainer.viewContext;
    //[self basicFetch];
    return YES;
}

#pragma mark - Core Data

//- (void) basicFetch {
//    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Meeting"];
//    NSArray<Meeting*>*meetings = [self.context executeFetchRequest:request error:nil];
//    [self printResultsFromArray:meetings];
//}
//
//- (void) printResultsFromArray:(NSArray<Meeting*>*)meetings {
//    for (Meeting * meeting in meetings) {
//        NSLog(@"%@ all core data", meeting.dateEnd);
//    }
//}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [self saveContext];
}

#pragma mark - Core Data stack
@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"SuiteCRMAplication"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSError *error = nil;
    if ([self.context hasChanges] && ![self.context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
