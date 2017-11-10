//
//  ActivitiesViewController.m
//  SuiteCRMAplication
//
//  Created by Igor Karyi on 11/1/17.
//  Copyright © 2017 Igor Karyi. All rights reserved.
//

#import "ActivitiesViewController.h"
#import "Meeting+CoreDataClass.h"
#import "Meeting+CoreDataProperties.h"
@import CoreData;
#import "AppDelegate.h"
#import "ActTableViewCell.h"
#import "DetailActViewController.h"

@interface ActivitiesViewController () <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSArray <Meeting *>* meetings;
@property (nonatomic) NSManagedObjectContext * context;
@property (nonatomic, weak) AppDelegate * delegate;

@end

@implementation ActivitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchAllPersons];
    self.delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.context = self.delegate.persistentContainer.viewContext;
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.tableView reloadData];
    [self fetchAllPersons];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self fetchAllPersons];
}


- (void) fetchAllPersons {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Meeting"];
    self.meetings = [self.context executeFetchRequest:request error:nil];
}


#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdintifier = @"Cell";
    ActTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdintifier];
    
    //data
    Meeting *person = self.meetings[indexPath.row];
    cell.subjectLabel.text = person.subject;
    cell.placeLabel.text = person.place;
    cell.reloatedToLabel.text = person.relatedTo;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/mm/yyyy"];
    NSString *stringDateDE = [dateFormatter stringFromDate:person.dateEnd];
    NSLog(@"Date in us %@", person.dateEnd);
    cell.dateEndLabel.text = stringDateDE;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"ShowDetails" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString: @"addSegue"]) {
        ActivitiesViewController* mVC = (ActivitiesViewController*)segue.destinationViewController;
        mVC.context = self.context;
        mVC.delegate = self.delegate;
    } else if ([segue.identifier isEqualToString: @"ShowDetails"]) {
        
        DetailActViewController *detailViewController = segue.destinationViewController;
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        Meeting *person = self.meetings[myIndexPath.row];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm"];
        NSString *stringDateDE = [dateFormatter stringFromDate:person.dateEnd];
        NSLog(@"Date in us %@", person.dateEnd);
        
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"MM/dd/yyyy hh:mm"];
        NSString *stringDateDS = [dateFormatter stringFromDate:person.dateStart];
        NSLog(@"Date in us %@", person.dateStart);
        
        detailViewController.DetailModal = @[person.subject, stringDateDS, stringDateDE, person.duration, person.status, person.relatedTo, person.place, person.desc];
    
    /*
     person.dateStart, person.dateEnd, person.duration, person.status, person.relatedTo, person.place, person.desc
     */

    }
}

- (void)configureCell:(UITableViewCell *)cell withEvent:(Meeting *)person {
    cell.textLabel.text = person.subject.description;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController<Meeting *> *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest<Meeting *> *fetchRequest = Meeting.fetchRequest;
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"subject" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController<Meeting *> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:@"SuiteCRMAplication"];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withEvent:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withEvent:anObject];
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
