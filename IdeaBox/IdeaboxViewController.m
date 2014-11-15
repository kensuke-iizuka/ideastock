//
//  IdeaboxViewController.m
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/02.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "IdeaboxViewController.h"
#import "SaveIdeaListViewController.h"
#import "constants.h"
#import "TrackingManager.h"
@interface IdeaboxViewController ()

@end

@implementation IdeaboxViewController
@synthesize selectedSegment;
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
    [TrackingManager sendScreenTracking:@"アイディア振り分け画面"];
    self.ideaList = [[NSMutableArray alloc]init];
    self.i = 0;
    self.j = 0;
    self.draggableView = [[DraggableView alloc]initWithFrame:CGRectMake(15, 110, 290, 322)];
    [self.view addSubview:self.draggableView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popIdea:) name:@"popIdea" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadIdea:) name:@"reloadIdea" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backView:) name:@"backView" object:nil];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"bg"]];
    [self updateBtn];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadTimeLabel];
    [self loadIdea];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addSource:(id)sender{
    [self performSegueWithIdentifier:@"addSource" sender:self];
}

-(void)backView:(NSNotification*)center{
    self.ideaList = [[center userInfo] objectForKey:@"ideaList"];
}

-(void)loadIdea{
    _mData = [[NSMutableData alloc]init];
    NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    NSString* user_id = [pref objectForKey:@"UserID"];
    NSString* pin = [pref objectForKey:@"pin_code"];
    NSLog(@"%@ %@",user_id,pin);
    NSURL* url = (allWordBtn.selected) ? [NSURL URLWithString:[NSString stringWithFormat:@"%@/idea/generate",baseURL]] : [NSURL URLWithString:[NSString stringWithFormat:@"%@/idea/generatefrommylist",baseURL]];
    NSLog(@"%@",url);
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
        if(self.j==0){
            self.idea = [dic objectForKey:@"idea"];
            self.idea2 = [dic objectForKey:@"idea2"];
            [self refreshDraggableView];
            [self setIdea];
        } else {
            self.idea2 = [dic objectForKey:@"idea2"];
            [self refreshDraggableView];
            [self setIdea];
        }
        self.j++;
    } else {
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_mData appendData:data];
}

-(void)setIdea{
    if(self.i<10){
        personLabel.text = [NSString stringWithFormat:@"%@",[[self.idea2 objectForKey:@"person"]objectForKey:@"title"]];
        sceneLabel.text = [NSString stringWithFormat:@"%@",[[self.idea2 objectForKey:@"scene"]objectForKey:@"title"]];
        purposeLabel.text = [NSString stringWithFormat:@"%@",[[self.idea2 objectForKey:@"purpose"]objectForKey:@"title"]];
    }
}

-(IBAction)popIdea:(id)sender{
    self.idea = self.idea2;
    [self refreshDraggableView];
    [self loadIdea];
}

-(IBAction)reloadIdea:(id)sender{
    [self.ideaList addObject:self.idea];
    self.i++;
    [self reloadTimeLabel];
    if(self.i == 10){
        self.i = 0;
        [self performSegueWithIdentifier:@"saveIdeaList" sender:self];
    }
    self.idea = self.idea2;
    [self refreshDraggableView];
    [self loadIdea];
}

-(void)refreshDraggableView{
    [self.draggableView refreshContent:self.idea];
}

-(IBAction)changeWordSource:(UIButton*)sender{
    if(sender.tag==1){
        allWordBtn.selected = YES;
        myWordBtn.selected = NO;
        [self updateBtn];
    } else if(sender.tag==2){
        allWordBtn.selected = NO;
        myWordBtn.selected = YES;
        [self updateBtn];
    }
}

-(void)updateBtn{
    if(allWordBtn.selected){
        [allWordBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    }
    if(myWordBtn.selected){
        [myWordBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    }
}

-(void)reloadTimeLabel{
    timeLabel.text = [NSString stringWithFormat:@"%d/10",self.i];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"saveIdeaList"]){
        SaveIdeaListViewController* viewCtl = (SaveIdeaListViewController*)[segue destinationViewController];
        viewCtl.ideaList = self.ideaList;
    }
}


@end
