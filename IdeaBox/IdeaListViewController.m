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
#import "JMImageCache.h"
#import "SCLAlertView.h"
#import "TrackingManager.h"
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
    [TrackingManager sendScreenTracking:@"アイディア一覧画面"];
    self.ideaList = [[NSMutableArray alloc]init];
    _stubCell = [myTableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    _stubCellWithData = [myTableView dequeueReusableCellWithIdentifier:@"CustomCellWithData"];
    _stubCellWithTitle = [myTableView dequeueReusableCellWithIdentifier:@"CustomCellWithTitle"];
    // Do any additional setup after loading the view.
    myTableView.delegate = self;
    myTableView.dataSource = self;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    addFlag = NO;
    deleteFlag = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadIdeaList];
    [myTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadIdeaList{
    _mData = [[NSMutableData alloc]init];
    addFlag = NO;
    deleteFlag = NO;
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

-(void)addIdea:(NSString*)title memo:(NSString*)memo{
    _mData = [[NSMutableData alloc]init];
    addFlag = YES;
    deleteFlag = NO;
    NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    NSString* user_id = [pref objectForKey:@"UserID"];
    NSString* pin = [pref objectForKey:@"pin_code"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/idea/add",baseURL]];
    NSString* reqBody = [NSString stringWithFormat:@"user_id=%@&pin=%@&title=%@&memo=%@",user_id,pin,title,memo];
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc]initWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[reqBody dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:req delegate:self];
}

-(void)deleteIdea:(int)ID{
    _mData = [[NSMutableData alloc]init];
    addFlag = NO;
    deleteFlag = YES;
    NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    NSString* user_id = [pref objectForKey:@"UserID"];
    NSString* pin = [pref objectForKey:@"pin_code"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/idea/delete",baseURL]];
    NSString* reqBody = [NSString stringWithFormat:@"user_id=%@&pin=%@&id=%@",user_id,pin,[[self.ideaList objectAtIndex:ID] objectForKey:@"id"]];
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
        if(addFlag){
            [self loadIdeaList];
        } else if(deleteFlag) {
        }else {
            self.ideaList = [[NSMutableArray alloc]initWithArray:[dic objectForKey:@"ideaList"]];
            [myTableView reloadData];
        }
    } else {
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_mData appendData:data];
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

// TableView start

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSDictionary* dic = [self.ideaList objectAtIndex:indexPath.row];
    if(![[dic objectForKey:@"title"] isEqual:[NSNull null]]&&![[dic objectForKey:@"title"]isEqualToString:@""]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCellWithTitle" forIndexPath:indexPath];
        
        [self configureCell:cell atIndexPath:indexPath];    // 追加
    } else if([dic objectForKey:@"description"]&&![[dic objectForKey:@"description"]isEqualToString:@""]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCellWithData" forIndexPath:indexPath];
    
        [self configureCell:cell atIndexPath:indexPath];    // 追加
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];    // 追加
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.ideaList.count==0){
        return 40.0f;
    }
    CGFloat height;
    NSDictionary* dic = [self.ideaList objectAtIndex:indexPath.row];
    if(![[dic objectForKey:@"title"] isEqual:[NSNull null]]&&![[dic objectForKey:@"title"]isEqualToString:@""]){
        [self configureCell:_stubCellWithTitle atIndexPath:indexPath];
        [_stubCellWithTitle layoutSubviews];
        height = [_stubCellWithTitle.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    } else if([dic objectForKey:@"description"]&&![[dic objectForKey:@"description"]isEqualToString:@""]){
        // 計測用のプロパティ"_stubCell"を使って高さを計算する
        [self configureCell:_stubCellWithData atIndexPath:indexPath];
        [_stubCellWithData layoutSubviews];
        height = [_stubCellWithData.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    } else {
        // 計測用のプロパティ"_stubCell"を使って高さを計算する
        [self configureCell:_stubCell atIndexPath:indexPath];
        [_stubCell layoutSubviews];
        height = [_stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    
    return height + 1;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 選択状態の解除をします。
    self.selectedCell = indexPath.row;
    [self performSegueWithIdentifier:@"detailIdea" sender:self];
}

-(void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath{
    NSDictionary* dic = [self.ideaList objectAtIndex:indexPath.row];
    if(![[dic objectForKey:@"title"] isEqual:[NSNull null]]&&![[dic objectForKey:@"title"]isEqualToString:@""]){
        CustomCellWithTitle* customCellWithTitle = (CustomCellWithTitle*)cell;
        customCellWithTitle.descLabel.text = [dic objectForKey:@"description"];
        customCellWithTitle.titleLabel.text = [dic objectForKey:@"title"];
    } else if([dic objectForKey:@"description"]&&![[dic objectForKey:@"description"]isEqualToString:@""]){
        CustomCellWithData* customCellWithData = (CustomCellWithData*)cell;
        customCellWithData.personLabel.text = [[dic objectForKey:@"person"]objectForKey:@"title"];
        customCellWithData.sceneLabel.text = [[dic objectForKey:@"scene"]objectForKey:@"title"];
        customCellWithData.purposeLabel.text = [[dic objectForKey:@"purpose"]objectForKey:@"title"];
        customCellWithData.descLabel.text = [dic objectForKey:@"description"];
    } else {
        CustomCell* customCell = (CustomCell*)cell;
        customCell.personLabel.text = [[dic objectForKey:@"person"]objectForKey:@"title"];
        customCell.sceneLabel.text = [[dic objectForKey:@"scene"]objectForKey:@"title"];
        customCell.purposeLabel.text = [[dic objectForKey:@"purpose"]objectForKey:@"title"];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"%d",indexPath.row);
        [self deleteIdea:indexPath.row];
        [self.ideaList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

// TableView end

// Overlay start
- (IBAction)showEdit:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    UITextField *titleField = [alert addTextField:@"アイディア"];
    UITextField *memoField = [alert addTextField:@"メモ"];
    
    [alert addButton:@"保存する" actionBlock:^(void) {
        [self addIdea:titleField.text memo:memoField.text];
    }];
    NSString* title = @"アイディアの追加";
    NSString* subtitle;
    subtitle = [NSString stringWithFormat:@""];
    
    NSString* buttonTitle = @"キャンセル";
    [alert showEdit:self title:title subTitle:subtitle closeButtonTitle:buttonTitle duration:0.0f];
}

// Overlay end
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
