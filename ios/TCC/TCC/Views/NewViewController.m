//
//  NewViewController.m
//  TCC
//
//  Created by Thiago Dorneles on 11/26/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import "NewViewController.h"
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"
#import <RestKit/RestKit.h>
#import "Publish.h"
#import "constants.h"
#import "ProgressHUD.h"

const static CGFloat kJVFieldHeight = 44.0f;
const static CGFloat kJVFieldHMargin = 10.0f;
const static CGFloat kJVFieldFontSize = 16.0f;
const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;

@interface NewViewController () <UITextFieldDelegate, UITextViewDelegate, RKObjectLoaderDelegate, RKRequestDelegate>
{
    RKClient *client;
}

@property JVFloatLabeledTextField *titleField, *tagsField;
@property JVFloatLabeledTextView *descriptionField;

@end

@implementation NewViewController

@synthesize titleField, tagsField, descriptionField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // ....
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Novo", @"");

    [self.view setTintColor:[UIColor blueColor]];
    CGFloat topOffset = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
    UIColor *floatingLabelColor = [UIColor grayColor];
    
    UIView *buttons = [UIView new];
    buttons.frame = CGRectMake(0, topOffset, self.view.frame.size.width, 50.0f);
    buttons.tintColor = [UIColor grayColor];
    
    CGFloat larguraBotoes = self.view.frame.size.width / 2 - (kJVFieldHMargin + 5.0f);
    UIColor *corFundo = [UIColor colorWithRed:247 green:247 blue:247 alpha:1];
    
    
    UIButton *btnLocalizacao = [UIButton new];
    btnLocalizacao.frame = CGRectMake(kJVFieldHMargin, 10.0f, larguraBotoes, 40.0f);
    btnLocalizacao.enabled = NO;
    [btnLocalizacao setTitle:@"Localização" forState:UIControlStateNormal];
    btnLocalizacao.layer.borderWidth = 1.0f;
    btnLocalizacao.layer.borderColor = [UIColor grayColor].CGColor;
    btnLocalizacao.layer.cornerRadius = 20;
    btnLocalizacao.layer.masksToBounds = YES;
    [btnLocalizacao setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btnLocalizacao.backgroundColor = corFundo;
    btnLocalizacao.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [btnLocalizacao setImage:[UIImage imageNamed:@"722-location-pin.png"] forState:UIControlStateNormal];
    [btnLocalizacao setImageEdgeInsets:UIEdgeInsetsMake(10.0f, 00.0f, 10.0f, 10.0f)];
    
    [buttons addSubview:btnLocalizacao];
    
    UIButton *btnFotos = [UIButton new];
    btnFotos.highlighted =YES;
    btnFotos.frame = CGRectMake(btnLocalizacao.frame.origin.x + btnLocalizacao.frame.size.width + 10.0f, 10.0f, larguraBotoes, 40.0f);
    [btnFotos setTitle:@"Fotos" forState:UIControlStateNormal];
    btnFotos.layer.borderWidth = 1.0f;
    btnFotos.layer.borderColor = [UIColor grayColor].CGColor;
    btnFotos.layer.cornerRadius = 20;
    btnFotos.layer.masksToBounds = YES;
    [btnFotos setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btnFotos.backgroundColor = corFundo;
    btnFotos.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [btnFotos setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    [btnFotos setImageEdgeInsets:UIEdgeInsetsMake(10.0f, 00.0f, 10.0f, 10.0f)];
    [buttons addSubview:btnFotos];
    
    
    [self.view addSubview:buttons];
    
    
    self.titleField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                           CGRectMake(kJVFieldHMargin, buttons.frame.origin.y + buttons.frame.size.height, self.view.frame.size.width - 2 * kJVFieldHMargin, kJVFieldHeight)];
    self.titleField.placeholder = NSLocalizedString(@"Título", @"");
    self.titleField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    self.titleField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    self.titleField.floatingLabelTextColor = floatingLabelColor;
    self.titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.titleField.delegate = self;
    self.titleField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:self.titleField];
    
    UIView *div1 = [UIView new];
    div1.frame = CGRectMake(kJVFieldHMargin, titleField.frame.origin.y + titleField.frame.size.height,
                            self.view.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
    div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div1];
    
    self.tagsField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                           CGRectMake(kJVFieldHMargin, div1.frame.origin.y + div1.frame.size.height, self.view.frame.size.width -2 *kJVFieldHMargin, kJVFieldHeight)];
    self.tagsField.placeholder = NSLocalizedString(@"Tags", @"");
    self.tagsField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    self.tagsField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    self.tagsField.floatingLabelTextColor = floatingLabelColor;
    self.tagsField.delegate = self;
    self.tagsField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:self.tagsField];
    
    UIView *div3 = [UIView new];
    div3.frame = CGRectMake(kJVFieldHMargin, self.tagsField.frame.origin.y + self.tagsField.frame.size.height,
                            self.view.frame.size.width - 2*kJVFieldHMargin, 1.0f);
    div3.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div3];
    
    self.descriptionField = [[JVFloatLabeledTextView alloc] initWithFrame:CGRectZero];
    self.descriptionField.frame = CGRectMake(kJVFieldHMargin - self.descriptionField.textContainer.lineFragmentPadding,
                                        div3.frame.origin.y + div3.frame.size.height,
                                        self.view.frame.size.width - 2*kJVFieldHMargin + self.descriptionField.textContainer.lineFragmentPadding,
                                        kJVFieldHeight*3);
    self.descriptionField.placeholder = NSLocalizedString(@"Descrição", @"");
    self.descriptionField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    self.descriptionField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    self.descriptionField.floatingLabelTextColor = floatingLabelColor;
    self.descriptionField.delegate = self;
    self.descriptionField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.descriptionField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(BOOL)resignFirstResponder
{
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.titleField)
        [self.tagsField becomeFirstResponder];
    else if (textField == self.tagsField)
        [self.descriptionField becomeFirstResponder];
    else
        [self.descriptionField resignFirstResponder];
    return YES;
}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
//    [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    
//    if ([text isEqualToString:@""])
//    {
//        return FALSE;
//    }
//    else
//    {
//        [textView resignFirstResponder];
//        [self buttonSaveTouched:self];
//        return TRUE;
//    }
//}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return TRUE;
}

- (IBAction)buttonSaveTouched:(id)sender
{
    [ProgressHUD show:@"Enviando..."];
    
    [self.titleField resignFirstResponder];
    [self.tagsField resignFirstResponder];
    [self.descriptionField resignFirstResponder];
    
    Publish *publish = [Publish new];
    publish.title = self.titleField.text;
    publish.description = self.descriptionField.text;
    publish.tags = [NSMutableArray arrayWithArray:[[self.tagsField.text lowercaseString] componentsSeparatedByString:@","]];
    publish.user = 1;
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURLString:URL_SERVER];
    manager.acceptMIMEType = RKMIMETypeJSON;
    manager.serializationMIMEType = RKMIMETypeJSON;
    
    RKObjectMapping *publishMapping = [RKObjectMapping mappingForClass:[Publish class]];
    [publishMapping mapKeyPath:@"title" toAttribute:@"title"];
    [publishMapping mapKeyPath:@"description" toAttribute:@"description"];
    [publishMapping mapKeyPath:@"user" toAttribute:@"user"];
    [publishMapping mapKeyPath:@"tags" toAttribute:@"tags"];
    [manager.mappingProvider setMapping:publishMapping forKeyPath:@""];
    
    RKObjectMapping *publishSerializer = [publishMapping inverseMapping];
    [manager.mappingProvider setSerializationMapping:publishSerializer forClass:[Publish class]];
    
    [manager.router routeClass:[Publish class] toResourcePath:@"/publishs/"];
    [manager.router routeClass:[Publish class] toResourcePath:@"/publishs/" forMethod:RKRequestMethodPOST];
    
    [manager postObject:publish delegate:self];
    [self uploadImage:publish];
}

-(void)uploadImage:(Publish*)publish
{
    client = [[RKClient alloc] initWithBaseURLString:URL_SERVER];
    RKParams* params = [RKParams params];
//    RKParams *params = [RKParams paramsWithDictionary:[NSDictionary dictionaryWithKeysAndObjects:@"publish_id", publish.pk, nil]];

    // Attach the Image from Image View
    UIImage* image = [UIImage imageNamed:@"acidente.png"];
    NSData* imageData = UIImagePNGRepresentation(image);
    [params setData:imageData MIMEType:@"image/png" forParam:@"image"];

    // Log info about the serialization
//    NSLog(@"RKParams HTTPHeaderValueForContentType = %@", [params HTTPHeaderValueForContentType]);
//    NSLog(@"RKParams HTTPHeaderValueForContentLength = %d", [params HTTPHeaderValueForContentLength]);

    // Send it for processing!
    [client post:@"/upload/" params:params delegate:self];
}

- (void)requestDidStartLoad:(RKRequest *)request {
    NSLog(@"requestDidStartLoad");

}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    NSLog(@"didSendBodyData");
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    [self.descriptionField resignFirstResponder];
    [ProgressHUD dismiss];

    
    if ([response statusCode] == 201) {
        [ProgressHUD showSuccess:@"Sucesso!"];
    }
    
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [ProgressHUD dismiss];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Não foi possível completar a operação." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
