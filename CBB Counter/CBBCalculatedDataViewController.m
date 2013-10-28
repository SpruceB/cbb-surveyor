//
//  CBBCalculatedDataViewController.m
//  CBB Counter
//
//  Created by Spruce Bondera on 9/7/13.
//  Copyright (c) 2013 Spruce Bondera. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CBBCalculatedDataViewController.h"
#import "Common.h"

@interface CBBCalculatedDataViewController ()
@property (weak, nonatomic) IBOutlet UILabel *positionResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *infestationRateLabel;
@property (readonly, strong, nonatomic) NSDictionary *positionalData;
@property (readonly, strong, nonatomic) NSArray *treeData;

@property (weak, nonatomic) IBOutlet UILabel *fungusSprayLabel;

@end

@implementation CBBCalculatedDataViewController

@synthesize positionResultLabel = _positionResultLabel;

-(NSDictionary *) positionalData {
    @try {
        return [[NSUserDefaults standardUserDefaults] objectForKey: BeansDataKey];
    }
    @catch (NSException *exception){
        return nil;
    }
}

-(NSArray *) treeData {
    @try {
        return [[NSUserDefaults standardUserDefaults] objectForKey: TreesDataKey];
    }
    @catch (NSException *exception) {
        return nil;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    if (!self.positionalData || [[self.positionalData.allValues valueForKeyPath:@"@sum.floatValue"] doubleValue] == 0){
        self.positionResultLabel.text = @"No Input";
        self.positionResultLabel.backgroundColor = [UIColor whiteColor];
        self.fungusSprayLabel.text = @"";
    } else {
        double percentage = (([self.positionalData[ABAliveKey] doubleValue]/[[self.positionalData.allValues valueForKeyPath:@"@sum.floatValue"] doubleValue])*100);
        self.positionResultLabel.text = [NSString stringWithFormat: @"%.1f%%", percentage];
        
        if (percentage >= 5) {
            self.positionResultLabel.backgroundColor = [UIColor redColor];
            self.fungusSprayLabel.text = @"Spray!";
        } else if (percentage >= 2) {
            self.positionResultLabel.backgroundColor = [UIColor yellowColor];
            self.fungusSprayLabel.text = @"Consider spraying.";
        } else {
            self.positionResultLabel.backgroundColor = [UIColor greenColor];
            self.fungusSprayLabel.text = @"Don't spray!";
        }
    }
    self.positionResultLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.positionResultLabel.layer.borderWidth = 2.0;
    
    
    if (!self.treeData || self.treeData.count == 0) {
        self.infestationRateLabel.text = @"No Input";
    } else {
        double cbb = 0;
        double green = 0;
        for (NSMutableDictionary *tree in self.treeData){
            cbb += [tree[CBBKey] doubleValue] + [tree[FungusKey] doubleValue];
            green += [[tree.allValues valueForKeyPath:@"@sum.self"] doubleValue];
        }
        
        self.infestationRateLabel.text = green == 0 ? @"No Input" : [NSString stringWithFormat: @"%.1f%%", (cbb/green)*100];
    }
    
    self.infestationRateLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.infestationRateLabel.layer.borderWidth = 2.0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPositionResultLabel:nil];
    [self setInfestationRateLabel:nil];
    [self setFungusSprayLabel:nil];
    [super viewDidUnload];
}
@end
