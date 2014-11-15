//
//  SaveIdeaListViewController.m
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/06.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "SaveIdeaListViewController.h"
#import "SaveIdeaViewController.h"
#import "TrackingManager.h"
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
    [TrackingManager sendScreenTracking:@"一時アイディアストック画面"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeIdea:) name:@"removeIdea" object:nil];
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
    personLabel.text = [[[self.ideaList objectAtIndex:indexPath.row]objectForKey:@"person"]objectForKey:@"title"];
    sceneLabel.text = [[[self.ideaList objectAtIndex:indexPath.row]objectForKey:@"scene"]objectForKey:@"title"];
    purposeLabel.text = [[[self.ideaList objectAtIndex:indexPath.row]objectForKey:@"purpose"]objectForKey:@"title"];
    return cell;
}

// TableView start

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

//TableView end

-(void)goToHome{
    [self performSegueWithIdentifier:@"home" sender:self];
}

-(void)removeIdea:(NSNotification*)center{
    int ideaID = [[[center userInfo]objectForKey:@"ideaID"] intValue];
    [self.ideaList removeObjectAtIndex:ideaID];
    [myTableView reloadData];
}

-(IBAction)deleteIdea:(id)sender{
    self.ideaList = nil;
}
-(void)viewDidDisappear:(BOOL)animated{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
        [[NSNotificationCenter defaultCenter]postNotificationName:@"backView" object:nil userInfo:@{@"ideaList":self.ideaList}];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"saveIdea"]){
        SaveIdeaViewController* viewCtl = (SaveIdeaViewController*)[segue destinationViewController];
        viewCtl.idea = [self.ideaList objectAtIndex:self.selectedCell];
        viewCtl.ideaID = self.selectedCell;
    }
}
@end
