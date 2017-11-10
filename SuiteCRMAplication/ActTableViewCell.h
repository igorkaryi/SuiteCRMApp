//
//  ActTableViewCell.h
//  SuiteCRMAplication
//
//  Created by Igor Karyi on 11/2/17.
//  Copyright © 2017 Igor Karyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reloatedToLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateEndLabel;


@end
