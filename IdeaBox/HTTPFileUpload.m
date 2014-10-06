//
//  HTTPFileUpload.m
//  FWeedApp
//
//  Created by 井上裕太 on 2014/07/08.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "HTTPFileUpload.h"
#import "SVProgressHUD.h"

#define KEY_POST_NAME            @"postName"
#define KEY_POST_STRING          @"postString"
#define KEY_POST_IMAGE           @"postImage"
#define KEY_POST_IMAGE_FILE_NAME @"postImageFileName"

#define BOUNDARY                 @"----iOSAppsFormBoundaryByHTTPFileUpload"


@implementation HTTPFileUpload

- (id)init {
    self = [super init];
    if (self) {
        postStrings = [[NSMutableArray alloc] initWithCapacity:0];
        postImages = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)setPostString:(NSString *)stringValue
         withPostName:(NSString *)postName
{
    NSDictionary *stringDictionary;
    stringDictionary = [NSDictionary dictionaryWithObjectsAndKeys:stringValue, KEY_POST_STRING,
                        postName, KEY_POST_NAME, nil];
    [postStrings addObject:stringDictionary];
}

- (void)setPostImage:(UIImage *)image
        withPostName:(NSString *)postName
            fileName:(NSString *)fileName
{
    NSDictionary *imageDictionary;
    imageDictionary = [NSDictionary dictionaryWithObjectsAndKeys:image, KEY_POST_IMAGE,
                       postName, KEY_POST_NAME,
                       fileName, KEY_POST_IMAGE_FILE_NAME, nil];
    [postImages addObject:imageDictionary];
}

- (void)postWithUri:(NSString *)uri
{
    [SVProgressHUD showWithStatus:@"投稿中..." maskType:SVProgressHUDMaskTypeBlack];
	NSMutableData *postData = [[NSMutableData alloc] init];
    
    // Create string data.
    for (NSDictionary *stringDictionary in postStrings) {
        [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",
                               [stringDictionary objectForKey:KEY_POST_NAME]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"%@\r\n",
                               [stringDictionary objectForKey:KEY_POST_STRING]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // Create image data.
    NSRegularExpression *regExp;
    NSTextCheckingResult *match;
    NSError *error = nil;
    regExp = [NSRegularExpression regularExpressionWithPattern:@"[.](?:jpg|jpeg)$"
                                                       options:NSRegularExpressionCaseInsensitive
                                                         error:&error];
    NSData *imageData;
    NSString *contentType;
    for (NSDictionary *imageDictionary in postImages) {
        match = [regExp firstMatchInString:[imageDictionary objectForKey:KEY_POST_IMAGE_FILE_NAME]
                                   options:0
                                     range:NSMakeRange(0, [[imageDictionary objectForKey:KEY_POST_IMAGE_FILE_NAME] length])];
        if (match != nil) {
            imageData = UIImageJPEGRepresentation([imageDictionary objectForKey:KEY_POST_IMAGE], 1.0f);
            contentType = @"image/jpeg";
        } else {
            imageData = UIImagePNGRepresentation([imageDictionary objectForKey:KEY_POST_IMAGE]);
            contentType = @"image/png";
        }
        
        [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",
                               [imageDictionary objectForKey:KEY_POST_NAME],
                               [imageDictionary objectForKey:KEY_POST_IMAGE_FILE_NAME]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n", contentType] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:imageData];
        [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [postData appendData:[[NSString stringWithFormat:@"--%@--\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Post data.
    NSMutableURLRequest *request;
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:uri]
                                            cachePolicy:NSURLRequestReloadIgnoringCacheData
                                        timeoutInterval:30];
	[request setHTTPMethod:@"POST"];
	[request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
	[request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDARY] forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    resultData = [[NSMutableData alloc] initWithCapacity:0];
    [NSURLConnection connectionWithRequest:request delegate:self];
}


#pragma mark - NSURLConnection delegate.
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"エラー"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [connection cancel];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    [resultData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSError* error;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:&error];
    if ([[dic objectForKey:@"result" ]isEqualToString:@"success"]) {
        if([dic objectForKey:@"image_url"]){
            NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
            [pref setObject:[dic objectForKey:@"image_url"] forKey:@"user_image"];
        }
        [SVProgressHUD showSuccessWithStatus:@"送信しました"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SuccessPostToUserTimeline" object:self];
    } else {
        [SVProgressHUD showErrorWithStatus:@"エラー"];
        
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [connection cancel];
}

@end