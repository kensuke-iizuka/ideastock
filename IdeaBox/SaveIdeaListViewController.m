//
//  SaveIdeaListViewController.m
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/06.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "SaveIdeaListViewController.h"
#import "SaveIdeaViewController.h"

@interface SaveIdeaListViewController ()

@end

@implementation SaveIdeaListViewController
@synthesize myTableView;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"CustomCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UILabel* personLabel = (UILabel*)[cell viewWithTag:1];
    UILabel* sceneLabel = (UILabel*)[cell viewWithTag:2];
    UILabel* purposeLabel = (UILabel*)[cell viewWithTag:3];
    UIImageView* personImageView = (UIImageView*)[cell viewWithTag:4];
    UIImageView* sceneImageView = (UIImageView*)[cell viewWithTag:5];
    UIImageView* purposeImageView = (UIImageView*)[cell viewWithTag:6];
    personLabel.text = [[[self.ideaList objectAtIndex:indexPath.row]objectForKey:@"person"]objectForKey:@"title"];
    sceneLabel.text = [[[self.ideaList objectAtIndex:indexPath.row]objectForKey:@"scene"]objectForKey:@"title"];
    purposeLabel.text = [[[self.ideaList objectAtIndex:indexPath.row]objectForKey:@"purpose"]objectForKey:@"title"];
    [personImageView setImage:[UIImage imageNamed:@"person.png"]];
    [sceneImageView setImage:[UIImage imageNamed:@"scene.png"]];
    [purposeImageView setImage:[UIImage imageNamed:@"purpose.png"]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.ideaList count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 選択状態の解除をします。
    self.selectedCell = indexPath.row;
    [self performSegueWithIdentifier:@"saveIdea" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"saveIdea"]){
        SaveIdeaViewController* viewCtl = (SaveIdeaViewController*)[segue destinationViewController];
        viewCtl.idea = [self.ideaList objectAtIndex:self.selectedCell];
    }
}
@end
