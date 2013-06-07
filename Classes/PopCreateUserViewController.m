//
//  PopCreateUserViewController.m
//  UserManagerSystem2
//
//  Created by yellow Dai on 13-1-3.
//  Copyright (c) 2013年 SCUT. All rights reserved.
//

#import "PopCreateUserViewController.h"
#import "MCUserManagerController.h"

@interface PopCreateUserViewController ()

@end

@implementation PopCreateUserViewController
@synthesize inputName;
@synthesize createBtn;

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
    [self setInputName:nil];
    [self setCreateBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)dealloc {
    [inputName release];
    [createBtn release];
    [super dealloc];
}

- (void)createBtnPress:(id)sender
{    
    [userManagerController createNewUser:inputName.text];
}
@end
