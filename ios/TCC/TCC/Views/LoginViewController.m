//
//  LoginViewController.m
//  TCC
//
//  Created by Thiago Dorneles on 11/20/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <RestKit/RestKit.h>
#import <Social/Social.h>
#import "BaseViewController.h"
#import "User.h"
#import "ProgressHUD.h"
#import "constants.h"

@interface LoginViewController ()  <FBLoginViewDelegate, RKObjectLoaderDelegate>

@end

@implementation LoginViewController

@synthesize viewFacebook;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sharingStatus) name:ACAccountStoreDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:ACAccountStoreDidChangeNotification];
}

- (void)sharingStatus {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        NSLog(@"service available");
    } else {
        NSLog(@"service unavailable");
    }
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:231 green:76 blue:60 alpha:1 ];
    [super viewDidLoad];
    
    [[FBSession activeSession] closeAndClearTokenInformation];
    [FBSession setActiveSession:nil];
    [User removeLocal];
    
    FBLoginView *facebookLogin = [FBLoginView new];
//    facebookLogin.frame = self.viewFacebook.frame;
    facebookLogin.delegate = self;
    [self.viewFacebook addSubview:facebookLogin];
    [facebookLogin sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Post User
-(void)saveUser:(User *)user
{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager postObject:user delegate:self];
}


#pragma mark - Buttons Events

- (IBAction)buttonFacebookTouched:(id)sender {}

- (IBAction)buttonTwitterTouched:(id)sender
{
    [ProgressHUD show:@"Processando..."];
    
    ACAccountStore *accountStore = [ACAccountStore new];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            NSArray *acc = [accountStore accountsWithAccountType:accountType];
            NSMutableArray *accounts = [NSMutableArray arrayWithArray:acc];
            [accounts removeObjectAtIndex:0];

            if ([accounts count] > 0) {
                NSURL *urlAuthenticate = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authenticate?%@", TWITTER_TOKEN]];
                NSURL *urlProfile = [NSURL URLWithString:@"https://api.twitter.com/1/account/verify_credentials.json"];
                
                for (ACAccount *twitterAccount in accounts) {
                    SLRequest *twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:urlAuthenticate parameters:nil];
                    [twitterRequest setAccount:twitterAccount];
                    
                    SLRequest *profileRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:urlProfile parameters:nil];
                    [profileRequest setAccount:twitterAccount];
                    

                    
                    [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                        NSLog(@"teste");
                    }];
                    
                    
                    [profileRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                        if (responseData) {
                            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                                
                                NSError *jsonError;
                                NSDictionary *profileData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                             options:NSJSONReadingAllowFragments
                                                                                               error:&jsonError];
                                if (profileData) {
//                                    
//                                    SLComposeViewController *compose = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//                                    [compose setInitialText:@"Testando tweet"];
//                                    [compose setCompletionHandler:^(SLComposeViewControllerResult result) {
//
//                                        switch (result) {
//                                            case SLComposeViewControllerResultCancelled:
//                                                NSLog(@"Cancelado");
//                                                break;
//                                                
//                                            case SLComposeViewControllerResultDone:
//                                                NSLog(@"enviado");
//                                                break;
//                                        }
//                                    }];
//                                    [self presentViewController:compose animated:YES completion:nil];
                                    
                                    User *user = [User new];
                                    user.name = [profileData objectForKey:@"name"];
                                    user.twitter_user = [profileData objectForKey:@"screen_name"];
                                    user.twitter_id = [profileData objectForKey:@"id"];
                                    user.twitter_token = [profileData objectForKey:@"id"];
                                    user.image_url = [profileData objectForKey:@"profile_image_url"];
                                    [self saveUser:user];
                                    [ProgressHUD dismiss];
                                }
                                else {
                                    [ProgressHUD dismiss];
                                    NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                                }
                            }
                            else {
                                [ProgressHUD dismiss];
                                NSLog(@"The response status code is %d", urlResponse.statusCode);
                            }
                        }
                    }];
                    
                }
            }
        }
    }];
    
}


#pragma mark - RestKit Delegate

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [ProgressHUD dismiss];
    User *user = (User*)[objects objectAtIndex:0];
    [user saveLocal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [ProgressHUD dismiss];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Não foi possível completar a operação." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    NSLog(@"didFailWithError = %@", error);
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    [ProgressHUD show:@"Processando..."];
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
    
    [self saveUser:user];
    [ProgressHUD dismiss];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
//    BOOL canShareFB = [FBDialogs canPresentShareDialogWithParams:p];
//    BOOL canShareiOS6 = [FBDialogs canPresentOSIntegratedShareDialogWithSession:nil];
    [ProgressHUD dismiss];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}

@end