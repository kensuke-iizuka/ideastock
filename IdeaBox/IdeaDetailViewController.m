//
//  IdeaDetailViewController.m
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/03.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "IdeaDetailViewController.h"

@interface IdeaDetailViewController ()

@end

@implementation IdeaDetailViewController
@synthesize idea;
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setData];
}

-(void)setData{
    personLabel.text = [NSString stringWithFormat:@"%@",[[idea objectForKey:@"person"]objectForKey:@"title"]];
    sceneLabel.text = [NSString stringWithFormat:@"%@",[[idea objectForKey:@"scene"]objectForKey:@"title"]];
    purposeLabel.text = [NSString stringWithFormat:@"%@",[[idea objectForKey:@"purpose"]objectForKey:@"title"]];
    textView.text = [NSString stringWithFormat:@"%@",[idea objectForKey:@"description"]];
    textView.editable = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
