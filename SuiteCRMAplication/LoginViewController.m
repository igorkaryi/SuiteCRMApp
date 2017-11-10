//
//  ViewController.m
//  SuiteCRMAplication
//
//  Created by Igor Karyi on 11/1/17.
//  Copyright © 2017 Igor Karyi. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking/AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+MD5.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *loginField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signIn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    self.navigationItem.hidesBackButton = YES;
}

- (IBAction)signInBut:(id)sender {
    
    [self postLoginForm];
    
    //NSLog(@"user - %@, password - %@", self.loginField.text, self.passwordField.text);
    
    if ([self.loginField isFirstResponder]) {
        [self.loginField resignFirstResponder];
    } else if ([self.passwordField isFirstResponder]) {
        [self.passwordField resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.loginField]) {
        [self.passwordField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - API

- (void) postLoginForm {
    NSString* login = self.loginField.text;
    NSString* passwordHash = [self.passwordField.text MD5];
    
    NSString *restData = [NSString stringWithFormat: @"{\"user_auth\":{\"user_name\": \"%@\", \"password\": \"%@\"}}", login, passwordHash];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary* params = @{ @"method": @"login",
                              @"input_type": @"JSON",
                              @"response_type": @"JSON",
                              @"rest_data": restData };
    
    [manager POST:@"http://crm.express-srl.it/service/v4_1/rest.php"
       parameters:params
         progress:nil success:^(NSURLSessionTask *task, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             
             NSDictionary *jsonDict = (NSDictionary *) responseObject;
             NSString *res = jsonDict [@"description"];
             if (res == nil) {
                 NSLog(@"Load webview %@", res);
                 [self performSegueWithIdentifier: @"webViewSegue" sender: nil];
             } else {
                 NSLog(@"Stay on Main Page %@", res);
                 [self showMessage:@"Wrong login or password! Try again later."
                         withTitle:@"Error"];
             }
             
             //***************************
             NSDictionary *jsonDict2 = (NSDictionary *) responseObject;
             NSString *ssID = jsonDict2 [@"id"];
             NSLog(@"print response %@", ssID);
             NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
             [userDefaults setObject:ssID forKey:@"ssID"];
             NSLog(@"print userDefaults %@", [userDefaults objectForKey:@"ssID"]);
             //***************************
             
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             
         }];
    
}

//MethodshowMessage

- (void)showMessage:(NSString*)message withTitle:(NSString *)title
{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
    }];
    [alert addAction:okAction];
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}


@end
