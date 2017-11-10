//
//  WebViewController.m
//  SuiteCRMAplication
//
//  Created by Igor Karyi on 11/1/17.
//  Copyright © 2017 Igor Karyi. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = nil;
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://crm.express-srl.it/index.php?action=Login&module=Users"]]];
    
    self.navigationItem.hidesBackButton = YES;
}

- (IBAction)clearButton:(id)sender {
    [self showMessageAlert];
}

- (void) clearCache {
    // Delete any cached URLrequests!
    NSURLCache *sharedCache = [NSURLCache sharedURLCache];
    [sharedCache removeAllCachedResponses];
    
    // Also delete all stored cookies!
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    id cookie;
    for (cookie in cookies) {
        [cookieStorage deleteCookie:cookie];
    }
    
    NSDictionary *credentialsDict = [[NSURLCredentialStorage sharedCredentialStorage] allCredentials];
    if ([credentialsDict count] > 0) {
        // the credentialsDict has NSURLProtectionSpace objs as keys and dicts of userName => NSURLCredential
        NSEnumerator *protectionSpaceEnumerator = [credentialsDict keyEnumerator];
        id urlProtectionSpace;
        // iterate over all NSURLProtectionSpaces
        while (urlProtectionSpace = [protectionSpaceEnumerator nextObject]) {
            NSEnumerator *userNameEnumerator = [[credentialsDict objectForKey:urlProtectionSpace] keyEnumerator];
            id userName;
            // iterate over all usernames for this protectionspace, which are the keys for the actual NSURLCredentials
            while (userName = [userNameEnumerator nextObject]) {
                NSURLCredential *cred = [[credentialsDict objectForKey:urlProtectionSpace] objectForKey:userName];
                //NSLog(@"credentials to be removed: %@", cred);
                [[NSURLCredentialStorage sharedCredentialStorage] removeCredential:cred forProtectionSpace:urlProtectionSpace];
            }
        }
    }
}

//[self performSegueWithIdentifier: @"ActivityListSegue" sender: nil];
- (IBAction)activityBut:(id)sender {
    [self performSegueWithIdentifier: @"ActivitiesListSegue" sender: nil];
}

- (void)showMessageAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Do you really want to log out?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
        [self clearCache];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
