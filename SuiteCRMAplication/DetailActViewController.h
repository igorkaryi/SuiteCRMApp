//
//  DetailActViewController.h
//  SuiteCRMAplication
//
//  Created by Igor Karyi on 11/2/17.
//  Copyright © 2017 Igor Karyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailActViewController : UIViewController

@property (strong, nonatomic) NSArray *DetailModal;


@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateStartActLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateEndActLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationActLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusActLabel;
@property (weak, nonatomic) IBOutlet UILabel *relatedToActLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeActLabel;
@property (weak, nonatomic) IBOutlet UILabel *descActLabel;

@end
