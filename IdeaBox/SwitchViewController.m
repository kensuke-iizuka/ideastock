//
//  SwitchViewController.m
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/03.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "SwitchViewController.h"
#import "IdeaboxViewController.h"
@interface SwitchViewController ()

@end

@implementation SwitchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)nextView:(id)sender{
    [self performSegueWithIdentifier:@"switchView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"switchView"]){
        IdeaboxViewController* viewCtl = (IdeaboxViewController*)[segue destinationViewController];
        viewCtl.selectedSegment = switchSegment.selectedSegmentIndex;
    }
}
@end
