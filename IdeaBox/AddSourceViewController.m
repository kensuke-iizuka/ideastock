//
//  AddSourceViewController.m
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/02.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "AddSourceViewController.h"
#import "constants.h"
#import "SVProgressHUD.h"
#import "SCLAlertView.h"
#import "TrackingManager.h"
@implementation AddSourceViewController
@synthesize wordTableView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [TrackingManager sendScreenTracking:@"要素追加画面"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(personInsert:) name:@"personInsert" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sceneInsert:) name:@"sceneInsert" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(purposeInsert:) name:@"purposeInsert" object:nil];
    [wordTableView setDataSource:self];
    [wordTableView setDelegate:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.perFlag = NO;
    self.sceFlag = NO;
    self.purFlag = NO;
    self.postFlag = NO;
    [self setPerson];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)personInsert:(NSNotification*)center{
    NSString* person = [[center userInfo]objectForKey:@"person"];
    [self post:@"person" text:person];
}

-(void)sceneInsert:(NSNotification*)center{
    NSString* scene = [[center userInfo]objectForKey:@"scene"];
    [self post:@"scene" text:scene];
}

-(void)purposeInsert:(NSNotification*)center{
    NSString* purpose = [[center userInfo]objectForKey:@"purpose"];
    [self post:@"purpose" text:purpose];
}

// Overlay start
- (IBAction)showEdit:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    UITextField *textField = [alert addTextField:@"Enter your word"];
    
    [alert addButton:@"保存する" actionBlock:^(void) {
        NSLog(@"Text value: %@", textField.text);
        NSString* type;
        if(self.perFlag){
            type = [NSString stringWithFormat:@"person"];
        } else if(self.sceFlag){
            type = [NSString stringWithFormat:@"scene"];
        } else if(self.purFlag){
            type = [NSString stringWithFormat:@"purpose"];
        }
        [self post:type text:textField.text];
    }];
    NSString* title = @"要素の追加";
    NSString* subtitle;
    if(self.perFlag){
        subtitle = [NSString stringWithFormat:@"誰が"];
    } else if(self.sceFlag){
        subtitle = [NSString stringWithFormat:@"どこで"];
    } else if(self.purFlag){
        subtitle = [NSString stringWithFormat:@"なんのために"];
    }
    NSString* buttonTitle = @"キャンセル";
    [alert showEdit:self title:title subTitle:subtitle closeButtonTitle:buttonTitle duration:0.0f];
}

// Overlay end

// Tableその他の切り替え start

-(IBAction)changeView:(UIButton*)sender{
    switch (sender.tag) {
        case 1:
            [self setPerson];
            break;
        case 2:
            [self setScene];
            break;
        default:
            [self setPurpose];
            break;
    }
}

-(void)setPerson{
    self.perFlag = YES;
    self.sceFlag = NO;
    self.purFlag = NO;
    bgImageView.image = [UIImage imageNamed:@"list_card_1"];
    [self getWordList:@"person"];
}

-(void)setScene{
    self.perFlag = NO;
    self.sceFlag = YES;
    self.purFlag = NO;
    bgImageView.image = [UIImage imageNamed:@"list_card_2"];
    [self getWordList:@"scene"];
}

-(void)setPurpose{
    self.perFlag = NO;
    self.sceFlag = NO;
    self.purFlag = YES;
     bgImageView.image = [UIImage imageNamed:@"list_card_3"];
    [self getWordList:@"purpose"];
}
// Tableその他の切り替え end

// HTTP通信 start
-(void)post:(NSString*)type text:(NSString*)text{
    _mData = [[NSMutableData alloc]init];
    self.postFlag = YES;
    NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    NSString* user_id = [pref objectForKey:@"UserID"];
    NSString* pin = [pref objectForKey:@"pin_code"];
    [SVProgressHUD showWithStatus:@"ソースを追加中" maskType:SVProgressHUDMaskTypeBlack];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/source/insert",baseURL]];
    NSString* reqBody = [NSString stringWithFormat:@"user_id=%@&pin=%@&type=%@&text=%@",user_id,pin,type,text];
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc]initWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[reqBody dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:req delegate:self];
}

-(void)getWordList:(NSString*)type{
    _mData = [[NSMutableData alloc]init];
    self.postFlag = NO;
    NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    NSString* user_id = [pref objectForKey:@"UserID"];
    NSString* pin = [pref objectForKey:@"pin_code"];
    [SVProgressHUD showWithStatus:@"取得中" maskType:SVProgressHUDMaskTypeBlack];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/source/getlist",baseURL]];
    NSString* reqBody = [NSString stringWithFormat:@"user_id=%@&pin=%@&type=%@",user_id,pin,type];
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
        if(!self.postFlag){
            self.wordLists = [dic objectForKey:@"wordList"];
            [wordTableView reloadData];
            self.postFlag = NO;
            [SVProgressHUD showSuccessWithStatus:@"成功"];
        } else {
            NSString* type;
            if(self.perFlag){
                type = [NSString stringWithFormat:@"person"];
            } else if(self.sceFlag){
                type = [NSString stringWithFormat:@"scene"];
            } else if(self.purFlag){
                type = [NSString stringWithFormat:@"purpose"];
            }
            [self getWordList:type];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"失敗"];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_mData appendData:data];
}
// HTTP通信 end

//tableView start
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"wordCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.contentView.alpha = 0.8;
    NSDictionary* word = [self.wordLists objectAtIndex:indexPath.row];
    UIImageView* imageView = (UIImageView*)[cell viewWithTag:1];
    if([word objectForKey:@"my_flag"]==0){
        imageView.image = [UIImage imageNamed:@"list_oval_gray"];
    } else {
        imageView.image = [UIImage imageNamed:@"list_oval_blue"];
    }
    UILabel* textLabel = (UILabel*)[cell viewWithTag:2];
    textLabel.text = [NSString stringWithFormat:@"%@",[word objectForKey:@"title"]];
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
    return [self.wordLists count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 選択状態の解除をします。
}

//tableView end

@end
