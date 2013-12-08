//
//  LoginViewController.m
//  TCC
//
//  Created by Thiago Dorneles on 11/20/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "User.h"
#import "BaseViewController.h"
#import <RestKit/RestKit.h>

@interface LoginViewController ()  <FBLoginViewDelegate, RKObjectLoaderDelegate>

@end

@implementation LoginViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:231 green:76 blue:60 alpha:1 ];
    [super viewDidLoad];
    
    FBLoginView *facebookLogin = [FBLoginView new];
    facebookLogin.frame = CGRectOffset(facebookLogin.frame, 5, 25);
    facebookLogin.delegate = self;
    [self.view addSubview:facebookLogin];
    [facebookLogin sizeToFit];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons Events

- (IBAction)buttonFacebookTouched:(id)sender {}

- (IBAction)buttonTwitterTouched:(id)sender {}


#pragma mark - RestKit Delegate

- (void)requestDidStartLoad:(RKRequest *)request {
    NSLog(@"requestDidStartLoad");
}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    NSLog(@"didSendBodyData");
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    if ([response statusCode] == 201) {
    }
    
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Não foi possível completar a operação." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"loginViewShowingLoggedInUser");
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)userLogged {
    User *user = [User new];
    user.name = [NSString stringWithFormat:@"%@ %@", [userLogged first_name], [userLogged last_name]];
    user.email = [userLogged objectForKey:@"email"];
    user.facebook_id = [userLogged id];
    user.facebook_user = [userLogged username];
    user.facebook_token = [[[FBSession activeSession] accessTokenData] accessToken];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager postObject:user delegate:self];

//    FBProfilePictureView *profilePicture = [FBProfilePictureView new];
//    profilePicture.profileID = user.facebook_id;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // test to see if we can use the share dialog built into the Facebook application
    FBShareDialogParams *p = [[FBShareDialogParams alloc] init];
    p.link = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
#ifdef DEBUG
    [FBSettings enableBetaFeatures:FBBetaFeaturesShareDialog];
#endif
    BOOL canShareFB = [FBDialogs canPresentShareDialogWithParams:p];
    BOOL canShareiOS6 = [FBDialogs canPresentOSIntegratedShareDialogWithSession:nil];
    [User removeLocal];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}

@end