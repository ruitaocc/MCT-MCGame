//
//  PopChangeUserViewController.h
//  UserManagerSystem2
//
//  Created by yellow Dai on 13-1-3.
//  Copyright (c) 2013年 SCUT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCUserManagerController.h"

@interface PopChangeUserViewController : UIViewController
    <UIPickerViewDelegate, UIPickerViewDataSource>
{
    MCUserManagerController *userManagerController;
}
@property (retain, nonatomic) IBOutlet UIPickerView *picker;

@end
