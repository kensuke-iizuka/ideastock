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
    self.ideaList = [[NSMutableArray alloc]init];
    self.i = 0;
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadIdea];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)regenerate:(id)sender{
    [self loadIdea];
}

-(IBAction)save:(id)sender{
    [self performSegueWithIdentifier:@"saveIdea" sender:self];
}

-(void)loadIdea{
    _mData = [[NSMutableData alloc]init];
    NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    NSString* user_id = [pref objectForKey:@"UserID"];
    NSString* pin = [pref objectForKey:@"pin_code"];
    NSURL* url = (self.selectedSegment == 0) ? [NSURL URLWithString:[NSString stringWithFormat:@"%@/idea/generate",baseURL]] : [NSURL URLWithString:[NSString stringWithFormat:@"%@/idea/generateFromMyList",baseURL]];
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
        self.idea = [dic objectForKey:@"idea"];
        [self setIdea];
    } else {
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_mData appendData:data];
}

-(void)setIdea{
    personLabel.text = [NSString stringWithFormat:@"%@",[[self.idea objectForKey:@"person"]objectForKey:@"title"]];
    sceneLabel.text = [NSString stringWithFormat:@"%@",[[self.idea objectForKey:@"scene"]objectForKey:@"title"]];
    purposeLabel.text = [NSString stringWithFormat:@"%@",[[self.idea objectForKey:@"purpose"]objectForKey:@"title"]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _touchBegan = [[touches anyObject]locationInView:self.view];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"test");
    static NSInteger threshold = 100;
    CGPoint point = [[touches anyObject]locationInView:self.view];
    NSInteger distanceHorizontal = point.x - _touchBegan.x;
    if(threshold <= abs(distanceHorizontal)){
        if(distanceHorizontal > 0){
            [self.ideaList addObject:self.idea];
            self.i++;
        }
        if(self.i == 10)
            [self performSegueWithIdentifier:@"saveIdeaList" sender:self];
        [self loadIdea];
    }
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
