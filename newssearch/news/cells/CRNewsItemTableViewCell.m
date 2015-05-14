//
//  CRNewsItemTableViewCell.m
//  newssearch
//
//  Created by Vince Liang on 2015-05-13.
//  Copyright (c) 2015 crowley. All rights reserved.
//

#import "CRNewsItemTableViewCell.h"

@implementation CRNewsItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    /*
     we can expand the whole cell area for re-order control
     0. prepare the block
     1. check system version, different version have different view architectures
     2. expand the reorder control view
     3. remove the reorder icon
     4. excute the block, if we found the key view, break out.
     */
    
    // 0.
    BOOL (^customReorderControl)(UIView *, UITableViewCell *) = ^(UIView *view, UITableViewCell *cell) {
        BOOL found = false;
        // 2.
        if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewCellReorderControl"]) {
            CGRect newFrame = cell.bounds;
            newFrame.origin.x = 0.7 * newFrame.size.width;
            newFrame.size.width = 0.3 * newFrame.size.width;
            view.frame = newFrame;
            found = true;
            // 3.
            for(UIView * subview in view.subviews){
                if ([subview isKindOfClass: [UIImageView class]]) {
                    [subview removeFromSuperview];
                    break;
                }
            }
        }
        return found;
    };
    
    // 1.
    CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
    __weak CRNewsItemTableViewCell *weakSelf = self;
    BOOL found = false;
    for (UIView *sub in self.subviews) {
        if (version >= 7 && version < 8) {
            for (UIView *subview in sub.subviews) {
                // 4.
                found = customReorderControl(subview, weakSelf);
                if (found) {
                    break;
                }
            }
        } else {
            // 4.
            found = customReorderControl(sub, weakSelf);
            if (found) {
                break;
            }
        }
        if (found) {
            break;
        }
    }
}

@end
