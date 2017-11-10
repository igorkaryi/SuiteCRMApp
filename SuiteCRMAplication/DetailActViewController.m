//
//  DetailActViewController.m
//  SuiteCRMAplication
//
//  Created by Igor Karyi on 11/2/17.
//  Copyright © 2017 Igor Karyi. All rights reserved.
//

#import "DetailActViewController.h"
#import "AFNetworking/AFNetworking.h"

@interface DetailActViewController ()

@end

@implementation DetailActViewController

@synthesize subjectLabel,
            dateStartActLabel,
            dateEndActLabel,
            durationActLabel,
            statusActLabel,
            relatedToActLabel,
            placeActLabel,
            descActLabel;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    subjectLabel.text = _DetailModal[0];
    dateStartActLabel.text = _DetailModal[1];
    dateEndActLabel.text = _DetailModal[2];
    durationActLabel.text = _DetailModal[3];
    statusActLabel.text = _DetailModal[4];
    relatedToActLabel.text = _DetailModal[5];
    placeActLabel.text = _DetailModal[6];
    descActLabel.text = _DetailModal[7];

    self.navigationItem.title = _DetailModal[0];
    
    [self activiti];
}

- (IBAction)SendToServer:(UIButton *)sender {
    [self postActivity];
}

- (void) activiti {
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"ssID"];
    NSLog(@"print savedValue %@", savedValue);
    NSString *activitiData = [NSString stringWithFormat: @"{\"session\": \"%@\"}", savedValue];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary* params = @{ @"method": @"get_upcoming_activities",
                              @"input_type": @"JSON",
                              @"response_type": @"JSON",
                              @"rest_data": activitiData };
    
    [manager POST:@"http://crm.express-srl.it/service/v4_1/rest.php"
       parameters:params
         progress:nil success:^(NSURLSessionTask *task, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             
         }];
}

- (void) postActivity {
    
    NSString* nameActivity = self.subjectLabel.text;
//    NSString* dateStartActivity = self.dateStartActLabel.text;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm"];
//    NSDate *dateFromString = [dateFormatter dateFromString:dateStartActivity];
//    NSLog(@"dateFromString %@", dateFromString);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"ssID"];
    NSLog(@"method print postActivity %@", savedValue);
    
    // NSString *sessionID = [NSString stringWithFormat: @"{\"session\": \"%@\"}", savedValue];
    
    NSString *restDataString = [NSString stringWithFormat: @"{\"session\": \"%@\",\"module_name\": \"Meetings\",\"name_value_list\": {\"name\": \"%@\", \"date_start\": \"2017-11-03\"}}", savedValue, nameActivity];
    
    NSDictionary *dict = @{   @"method": @"set_entry",
                              @"input_type": @"JSON",
                              @"response_type": @"JSON",
                              @"rest_data": restDataString
                              };
    
    [manager POST:@"http://crm.express-srl.it/service/v4_1/rest.php"
       parameters:dict
         progress:nil success:^(NSURLSessionTask *task, id responseObject) {
             NSLog(@"postActivity new: %@", responseObject);
         } failure:^(NSURLSessionTask * operation, NSError* error) {
             NSLog(@"Error: %@", error);
         }];
}


@end
