//
//  IdeaListViewController.m
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/02.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "IdeaListViewController.h"
#import "constants.h"
#import "IdeaDetailViewController.h"

@implementation IdeaListViewController
@synthesize myTableView;
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
    [self loadIdeaList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadIdeaList{
    _mData = [[NSMutableData alloc]init];
    NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    NSString* user_id = [pref objectForKey:@"UserID"];
    NSString* pin = [pref objectForKey:@"pin_code"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/idea/myList",baseURL]];
    NSString* reqBody = [NSString stringWithFormat:@"user_id=%@&pin=%@",user_id,pin];
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc]initWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[reqBody dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:req delegate:self];
}

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection{
    NSError* error;
    NSString* response = [[NSString alloc] initWithData:_mData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",response);
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:_mData options:0 error:&error];
    if([[dic objectForKey:@"result"] isEqualToString:@"success"]){
        self.ideaList = [dic objectForKey:@"ideaList"];
        [myTableView reloadData];
    } else {
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_mData appendData:data];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    // Always a single section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of items in the todoService items array
    return [self.ideaList count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 選択状態の解除をします。
    self.selectedCell = indexPath.row;
    [self performSegueWithIdentifier:@"detailIdea" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"detailIdea"]){
        IdeaDetailViewController* viewCtl = (IdeaDetailViewController*)[segue destinationViewController];
        viewCtl.idea = [self.ideaList objectAtIndex:self.selectedCell];
    }
}

@end
