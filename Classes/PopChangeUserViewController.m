//
//  PopChangeUserViewController.m
//  UserManagerSystem2
//
//  Created by yellow Dai on 13-1-3.
//  Copyright (c) 2013年 SCUT. All rights reserved.
//

#import "PopChangeUserViewController.h"

@interface PopChangeUserViewController ()

@end

@implementation PopChangeUserViewController
@synthesize picker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        userManagerController = [MCUserManagerController allocWithZone:NULL];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setPicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated
{
    [picker reloadAllComponents];
}

#pragma mark -
#pragma mark picker data source methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [userManagerController.userModel.allUser count];
}

#pragma mark -
#pragma mark picker delegate merhods
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    MCUser *user = [userManagerController.userModel.allUser objectAtIndex:row];
    return user.name;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([userManagerController.userModel.allUser count] != 0) {
        MCUser *user = [userManagerController.userModel.allUser objectAtIndex:row];
        NSString *name = [[NSString alloc] initWithString:user.name];
        [userManagerController changeCurrentUser:name];
        [name release];
    }
}


- (void)dealloc {
    [picker release];
    [super dealloc];
}
@end
