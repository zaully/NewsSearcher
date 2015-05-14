//
//  CRNewsItemTableViewCell.h
//  newssearch
//
//  Created by Vince Liang on 2015-05-13.
//  Copyright (c) 2015 crowley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFlatSwitch.h"

@interface CRNewsItemTableViewCell : UITableViewCell
@property (nonatomic, weak)IBOutlet CRFlatSwitch *flatSwitch;
@property (nonatomic, weak)IBOutlet UILabel *newsSectionLabel;
@property (nonatomic, weak)IBOutlet UILabel *newsTitleLabel;
@end
