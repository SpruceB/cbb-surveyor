//
//  CBBT2SecondViewController.m
//  CBB Counter
//
//  Created by Spruce Bondera on 8/31/13.
//  Copyright (c) 2013 Spruce Bondera. All rights reserved.
//

#import "CBBDataEditingViewController.h"
#import "CBBDataTableViewController.h"
#import "CBBNamedUIStepper.h"
#import "Common.h"

@interface CBBDataEditingViewController()



@property (weak, nonatomic) IBOutlet UITextField *greenTextField;
@property (weak, nonatomic) IBOutlet CBBNamedUIStepper *greenCounter;
@property (weak, nonatomic) IBOutlet UITextField *CBBTextField;
@property (weak, nonatomic) IBOutlet CBBNamedUIStepper *CBBCounter;
@property (weak, nonatomic) IBOutlet UITextField *fungusTextField;
@property (weak, nonatomic) IBOutlet CBBNamedUIStepper *fungusCounter;
@property (strong, nonatomic) UIGestureRecognizer *textExitTap;
@property (nonatomic) UITextField *selectedField;
@property (nonatomic) NSMutableDictionary *data;

@end

@implementation CBBDataEditingViewController
@synthesize CBBTextField = _CBBTextField;
@synthesize  greenTextField = _greenTextField;
@synthesize fungusTextField = _fungusTextField;
@synthesize editingNumber = _editingNumber;
@synthesize CBBCounter = _CBBCounter;
@synthesize greenCounter = _greenCounter;
@synthesize fungusCounter = _fungusCounter;
@synthesize textExitTap = _textExitTap;
@synthesize selectedField = _selectedField;

-(NSMutableDictionary *) data {
    
    NSMutableDictionary *testDict;
    @try {
        testDict = [[NSUserDefaults standardUserDefaults] objectForKey: TreesDataKey][self.editingNumber];
    }
    @catch (NSException *exception) {
        testDict = nil;
    }

    
    if (!testDict){
        [[NSUserDefaults standardUserDefaults] objectForKey: TreesDataKey][self.editingNumber] = [NSMutableDictionary dictionaryWithObjectsAndKeys: @(0), GreenKey, @(0), CBBKey, @(0), FungusKey, nil];
        [[NSUserDefaults standardUserDefaults] synchronize];
        testDict = [[NSUserDefaults standardUserDefaults] objectForKey: TreesDataKey][self.editingNumber];
    }
    return testDict;
}

-(void) setData:(NSDictionary *)data {
    [[NSUserDefaults standardUserDefaults] objectForKey: TreesDataKey][self.editingNumber] = data;
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) setDataObject: (id) obj forKey: (id) key {
    NSMutableDictionary *tmp = self.data;
    tmp[key] = obj;
    self.data = tmp;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.greenCounter.name = GreenKey;
    self.CBBCounter.name = CBBKey;
    self.fungusCounter.name = FungusKey;

    self.navigationItem.hidesBackButton = YES;
    self.title = [NSString stringWithFormat: @"Tree %d", self.editingNumber+1];
    
    self.greenTextField.text = [self.data[GreenKey] description];
    
    
    self.fungusTextField.text = [self.data[FungusKey] description];
    
    
    self.CBBTextField.text = [self.data[CBBKey] description];
    
    [self steppersUpdate];
}

-(void) steppersUpdate {
    self.greenCounter.value = [self.data[GreenKey] integerValue];
    self.CBBCounter.value = [self.data[CBBKey] integerValue];
    self.fungusCounter.value = [self.data[FungusKey] integerValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateFields {
    self.greenTextField.text = [self.data[GreenKey] description];
    self.CBBTextField.text = [self.data[CBBKey] description];
    self.fungusTextField.text = [self.data[FungusKey] description];
}

- (IBAction) stepperInc: (CBBNamedUIStepper *)sender {
    [self setDataObject: @(sender.value) forKey: sender.name];
    [self updateFields];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"NextTree"]) {
        [segue.destinationViewController setEditingNumber: self.editingNumber+1];
    }
}

- (IBAction)backToRoot:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)numFieldsEndedEditing: (UITextField *)sender {
    if ([sender.text isEqualToString: @""]) sender.text = @"0";
    [self setDataObject: @(sender.text.doubleValue) forKey: sender.placeholder];
    [self steppersUpdate];
    [self closeOpenKeyboard];
    
}

- (IBAction)changedEditing:(UITextField *)sender {
    [self setDataObject: @(sender.text.doubleValue) forKey: sender.placeholder];
    [self steppersUpdate];
    
}


- (IBAction)textEditingStart:(UITextField *)sender {
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
    self.selectedField = nil;
}

- (void)viewDidUnload {
    [self setGreenTextField:nil];
    [self setCBBTextField:nil];
    [self setFungusTextField:nil];
    [self setGreenTextField:nil];
    [self setCBBTextField:nil];
    [self setFungusTextField:nil];
    [self setGreenCounter:nil];
    [self setCBBCounter:nil];
    [self setFungusCounter:nil];
    [super viewDidUnload];
}

@end
