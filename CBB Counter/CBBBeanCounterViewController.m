//
//  CBBBeanCounterViewController.m
//  CBB Counter
//
//  Created by Spruce Bondera on 9/7/13.
//  Copyright (c) 2013 Spruce Bondera. All rights reserved.
//

#import "CBBBeanCounterViewController.h"
#import "CBBNamedUIStepper.h"
#import "Common.h"

@interface CBBBeanCounterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ABAliveTextField;
@property (weak, nonatomic) IBOutlet  CBBNamedUIStepper *ABAliveCounter;
@property (weak, nonatomic) IBOutlet UITextField *ABGoneTextField;
@property (weak, nonatomic) IBOutlet CBBNamedUIStepper *ABGoneCounter;
@property (weak, nonatomic) IBOutlet UITextField *CDTextField;
@property (weak, nonatomic) IBOutlet CBBNamedUIStepper *CDCounter;
@property (strong, nonatomic) UIGestureRecognizer *textExitTap;
@property (nonatomic) UITextField *selectedField;
@property (nonatomic) NSDictionary *data;

@end

@implementation CBBBeanCounterViewController

@synthesize ABAliveCounter = _ABAliveCounter;
@synthesize ABAliveTextField = _ABAliveTextField;
@synthesize ABGoneCounter = _ABGoneCounter;
@synthesize ABGoneTextField = _ABGoneTextField;
@synthesize CDCounter = _CDCounter;
@synthesize CDTextField = _CDTextField;
@synthesize textExitTap = _textExitTap;
@synthesize selectedField = _selectedField;

-(NSDictionary *) data {
    NSDictionary *testData;
    @try {
        testData = [[NSUserDefaults standardUserDefaults] objectForKey: BeansDataKey];
    }
    @catch (NSException *exception) {
        testData = nil;
    }
    if (!testData) {
        testData = @{ABAliveKey: @(0), ABDeadKey: @(0), CDKey: @(0)};
        [[NSUserDefaults standardUserDefaults] setObject: testData forKey: BeansDataKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return testData;
}

-(void) setData:(NSDictionary *) data {
    [[NSUserDefaults standardUserDefaults] setObject: data forKey: BeansDataKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) setDataObject: (id) object forKey: (NSString *) key {
    NSMutableDictionary *mutDict = [self.data mutableCopy];
    mutDict[key] = object;
    self.data = mutDict;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.ABAliveCounter.name = ABAliveKey;
    self.ABGoneCounter.name = ABDeadKey;
    self.CDCounter.name = CDKey;
    
    self.ABAliveTextField.placeholder = ABAliveKey;
    self.ABGoneTextField.placeholder = ABDeadKey;
    self.CDTextField.placeholder = CDKey;

    [self syncFields];
}

-(void) syncFields {
  
    self.ABAliveCounter.value = [self.data[ABAliveKey] integerValue];
    self.ABGoneCounter.value = [self.data[ABDeadKey] integerValue];
    self.CDCounter.value = [self.data[CDKey] integerValue];
    
    self.ABAliveTextField.text = [self.data[ABAliveKey] description];
    self.ABGoneTextField.text = [self.data[ABDeadKey] description];
    self.CDTextField.text = [self.data[CDKey] description];
}
    
- (IBAction)stepperChanged:(CBBNamedUIStepper *)sender {
    [self setDataObject: @(sender.value) forKey: sender.name];
    [self syncFields];
}

- (IBAction)numFieldsEndedEditing: (UITextField *)sender {
    
    if ([sender.text isEqualToString: @""]) sender.text = @"0";
    [self setDataObject: @(sender.text.integerValue) forKey: sender.placeholder];
    [self syncFields];
    [self closeOpenKeyboard];
    
}

- (IBAction)changedEditing:(UITextField *)sender {
    [self setDataObject: @(sender.text.integerValue) forKey: sender.placeholder];
    
}


- (IBAction)textEditingStart:(UITextField *)sender {
    if ([sender.placeholder isEqualToString: CDKey]) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        CGRect rect = self.view.frame;
        rect.origin.y -=  80;
        rect.size.height += 80;
        self.view.frame = rect;
    }
    
    if ([sender.text isEqualToString: @"0"]) sender.text = @"";
    self.textExitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeOpenKeyboard)];
    [self.view addGestureRecognizer: self.textExitTap];
    self.selectedField = sender;
    
}

-(void) closeOpenKeyboard {
    [self.selectedField resignFirstResponder];
    [self.selectedField removeGestureRecognizer: self.textExitTap];
    self.textExitTap.enabled = NO;
    self.textExitTap = nil;
    if ([self.selectedField.placeholder isEqualToString: CDKey]) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        CGRect rect = self.view.frame;
        rect.origin.y += 80;
        rect.size.height -= 80;
        self.view.frame = rect;
    }
    self.selectedField = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setABAliveTextField:nil];
    [self setABAliveCounter:nil];
    [self setABGoneTextField:nil];
    [self setABGoneCounter:nil];
    [self setCDTextField:nil];
    [self setCDCounter:nil];
    [super viewDidUnload];
}
@end
