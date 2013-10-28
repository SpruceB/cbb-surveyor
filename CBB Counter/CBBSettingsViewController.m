//
//  CBBT2FirstViewController.m
//  CBB Counter
//
//  Created by Spruce Bondera on 8/31/13.
//  Copyright (c) 2013 Spruce Bondera. All rights reserved.
//

#import "CBBSettingsViewController.h"
#import "CBBDataEditingViewController.h"

@interface CBBSettingsViewController()

@property UITextField *selectedTextField;
@property UIGestureRecognizer *textExitTap;

@end


@implementation CBBSettingsViewController

@synthesize farmName = _farmName;
@synthesize textExitTap = _textExitTap;
@synthesize selectedTextField = _selectedTextField;
-(void) viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)numFieldsEndedEditing:(UITextField *)sender {
    [[NSUserDefaults standardUserDefaults] setDouble: sender.text.doubleValue forKey: sender.placeholder];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self closeOpenKeyboard];
}
- (IBAction)farmEditingReturn:(UITextField *)sender {
    [self closeOpenKeyboard];
}


- (IBAction)textEditingStart:(UITextField *)sender {
    self.textExitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeOpenKeyboard)];
    [self.view addGestureRecognizer: self.textExitTap];
    
    self.selectedTextField = sender;
}



-(void)closeOpenKeyboard {
    [self.view removeGestureRecognizer: self.textExitTap];
    [self.selectedTextField resignFirstResponder];
    self.selectedTextField = nil;
    
}

@end
