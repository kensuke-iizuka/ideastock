//
//  IdeaDetailViewController.m
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/03.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "IdeaDetailViewController.h"
#import "UpdateIdeaViewController.h"
#import "JMImageCache.h"
#import "TrackingManager.h"
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
    [TrackingManager sendScreenTracking:@"アイディア詳細画面"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setData];
}

-(void)setData{
    personLabel.text = [NSString stringWithFormat:@"%@",[[idea objectForKey:@"person"]objectForKey:@"title"]];
    sceneLabel.text = [NSString stringWithFormat:@"%@",[[idea objectForKey:@"scene"]objectForKey:@"title"]];
    purposeLabel.text = [NSString stringWithFormat:@"%@",[[idea objectForKey:@"purpose"]objectForKey:@"title"]];
    NSLog(@"%@",[idea objectForKey:@"description"]);
    textView.text = [NSString stringWithFormat:@"%@",[idea objectForKey:@"description"]];
    textView.editable = NO;
    [self loadImage:[NSString stringWithFormat:@"%@",[[idea objectForKey:@"image"] objectForKey:@"url"]] imageView:self.imageView];
}

// imageのロード
-(void)loadImage:(NSString*)imageUrl imageView:(UIImageView*)imageView{
    [[JMImageCache sharedCache]imageForURL:[NSURL URLWithString:imageUrl] completionBlock:^(UIImage *image) {
        [imageView setAlpha:0];
        [UIView animateWithDuration:0.5 animations:^{
            [imageView setImage:image];
            [imageView setAlpha:1];
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier]isEqualToString:@"updateIdea"]){
        UpdateIdeaViewController* viewCtl = (UpdateIdeaViewController*)[segue destinationViewController];
        viewCtl.idea = idea;
    }
}

@end
