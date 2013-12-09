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
#import <CoreLocation/CoreLocation.h>

const static CGFloat kJVFieldHeight = 44.0f;
const static CGFloat kJVFieldHMargin = 10.0f;
const static CGFloat kJVFieldFontSize = 16.0f;
const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;

@interface NewViewController () <UITextFieldDelegate, UITextViewDelegate, RKObjectLoaderDelegate, RKRequestDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>
{
    RKClient *client;
    UIButton *btnFotos, *btnLocalizacao;
    CLLocationManager *locationManager;
    BOOL firstView;
}

@property UIImage *photo;
@property JVFloatLabeledTextField *titleField, *tagsField;
@property JVFloatLabeledTextView *descriptionField;

@end

@implementation NewViewController

@synthesize titleField, tagsField, descriptionField, photo;

#pragma mark - View

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // ....
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setTintColor:[UIColor blueColor]];
    [self setTitle: NSLocalizedString(@"Novo", @"")];
    [self createView];
    firstView = TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)createView
{
    CGFloat topOffset = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
    UIColor *floatingLabelColor = [UIColor grayColor];
    
    UIView *buttons = [UIView new];
    buttons.frame = CGRectMake(0, topOffset, self.view.frame.size.width, 50.0f);
    buttons.tintColor = [UIColor grayColor];
    
    CGFloat larguraBotoes = self.view.frame.size.width / 2 - (kJVFieldHMargin + 5.0f);
    UIColor *corFundo = [UIColor colorWithRed:247 green:247 blue:247 alpha:1];
    
    
    btnLocalizacao = [UIButton new];
    btnLocalizacao.frame = CGRectMake(kJVFieldHMargin, 10.0f, larguraBotoes, 40.0f);
    [btnLocalizacao setTitle:@"Localização" forState:UIControlStateNormal];
    btnLocalizacao.layer.borderWidth = 1.0f;
    btnLocalizacao.layer.borderColor = [UIColor grayColor].CGColor;
    btnLocalizacao.layer.cornerRadius = 20;
    btnLocalizacao.layer.masksToBounds = YES;
    [btnLocalizacao setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btnLocalizacao.backgroundColor = corFundo;
    btnLocalizacao.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [btnLocalizacao setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    [btnLocalizacao setImage:[UIImage imageNamed:@"location-selected.png"] forState:UIControlStateSelected];
    [btnLocalizacao setImageEdgeInsets:UIEdgeInsetsMake(10.0f, 00.0f, 10.0f, 10.0f)];
    [btnLocalizacao addTarget:self action:@selector(buttonLocationTouched:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addSubview:btnLocalizacao];
    
    btnFotos = [UIButton new];
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
    [btnFotos setImage:[UIImage imageNamed:@"camera-selected.png"] forState:UIControlStateSelected];
    [btnFotos setImageEdgeInsets:UIEdgeInsetsMake(10.0f, 00.0f, 10.0f, 10.0f)];
    [btnFotos addTarget:self action:@selector(buttonCameraTouched:) forControlEvents:UIControlEventTouchUpInside];
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
    self.tagsField.placeholder = NSLocalizedString(@"Tags (contextos separados por vírgulas)", @"");
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

#pragma mark - TextField Delegate

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

#pragma mark - Buttons events

-(IBAction)buttonLocationTouched:(id)sender
{
    if (btnLocalizacao.selected) {
        locationManager = nil;
        [btnLocalizacao setSelected:NO];
    }
    else {
        if (locationManager == nil) {
            locationManager = [[CLLocationManager alloc] init];
        }
        
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
    }
}

-(IBAction)buttonCameraTouched:(id)sender
{
    UIActionSheet *options = [[UIActionSheet alloc] initWithTitle:nil
                                                         delegate:self
                                                cancelButtonTitle:@"Cancelar"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"Camera", @"Rolo de camera", @"Ver fotos", nil];
    [options showInView:self.view];
}

- (IBAction)buttonCancelTouched:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonSaveTouched:(id)sender
{
    if (![self validForm]) {
        return;
    }
    
    [ProgressHUD show:@"Enviando..."];
    
    [self.titleField resignFirstResponder];
    [self.tagsField resignFirstResponder];
    [self.descriptionField resignFirstResponder];
    
    Publish *publish = [Publish new];
    publish.title = self.titleField.text;
    publish.description = self.descriptionField.text;
    publish.tags = [NSMutableArray arrayWithArray:[[self.tagsField.text lowercaseString] componentsSeparatedByString:@","]];
    publish.user = 1;
    
    if (locationManager) {
        publish.location = [NSString stringWithFormat:@"%f, %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    }
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURLString:URL_SERVER];
    manager.acceptMIMEType = RKMIMETypeJSON;
    manager.serializationMIMEType = RKMIMETypeJSON;
    
    RKObjectMapping *publishMapping = [RKObjectMapping mappingForClass:[Publish class]];
    [publishMapping mapKeyPath:@"id" toAttribute:@"pk"];
    [publishMapping mapKeyPath:@"title" toAttribute:@"title"];
    [publishMapping mapKeyPath:@"description" toAttribute:@"description"];
    [publishMapping mapKeyPath:@"user" toAttribute:@"user"];
    [publishMapping mapKeyPath:@"tags" toAttribute:@"tags"];
    [publishMapping mapKeyPath:@"location" toAttribute:@"location"];
    [manager.mappingProvider setMapping:publishMapping forKeyPath:@""];
    
    RKObjectMapping *publishSerializer = [publishMapping inverseMapping];
    [manager.mappingProvider setSerializationMapping:publishSerializer forClass:[Publish class]];
    
    [manager.router routeClass:[Publish class] toResourcePath:@"/publishs/"];
    [manager.router routeClass:[Publish class] toResourcePath:@"/publishs/" forMethod:RKRequestMethodPOST];
    
    [manager postObject:publish delegate:self];
}

-(void)takePhoto:(BOOL)openLibray {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
#if TARGET_IPHONE_SIMULATOR
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    if (openLibray) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else {;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
#endif
//    imagePickerController.editing = YES;
    imagePickerController.delegate = (id)self;
    [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takePhoto:FALSE];
            break;
        case 1:
            [self takePhoto:TRUE];
            break;
    }
}

#pragma mark - Image picker delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.photo = [self scaleAndRotateImage:image];
    [picker dismissViewControllerAnimated:NO completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:nil];
}

- (UIImage*)scaleAndRotateImage:(UIImage *)image
{
    int kMaxResolution = 600; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageCopy;
}

-(void)clearForm
{
    self.titleField.text = @"";
    self.tagsField.text = @"";
    self.descriptionField.text = @"";
    self.photo = nil;
    locationManager = nil;
    btnLocalizacao.selected = NO;
}

-(BOOL)validForm
{
    BOOL valid = true;
    if ([self.titleField.text isEqualToString:@""]) {
        valid = false;
    }
    
    if (valid && [self.descriptionField.text isEqualToString:@""] && self.photo == nil)
    {
        valid = false;
    }
    
    
    if (!valid) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dados incompletos"
                                                        message:@"Deve preencher os campos para poder enviar a noticia. Informe no mínimo o título e o descritivo ou uma imagem"
                                                       delegate:self
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    return valid;
}

#pragma mark - RestKit Delegate

-(void)uploadImage:(NSInteger)publish_id
{
    [ProgressHUD show:@"Enviando imagens"];
    
    client = [[RKClient alloc] initWithBaseURLString:URL_SERVER];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", publish_id] forKey:@"publish_id"];
    RKParams *params = [RKParams paramsWithDictionary:dict];
    
    // Attach the Image from Image View
    NSData* imageData = UIImagePNGRepresentation(self.photo);
    [params setData:imageData MIMEType:@"image/png" forParam:@"image"];
    
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
//    [ProgressHUD dismiss];

    if ([response statusCode] == 201) {
        if ([[request resourcePath] rangeOfString:@"upload"].location == NSNotFound && self.photo == nil) {
            [ProgressHUD showSuccess:@"Sucesso!"];
        }
        else {
            [ProgressHUD showSuccess:@"Sucesso!"];
        }
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    if ([[objectLoader resourcePath] rangeOfString:@"upload"].location == NSNotFound) {
        if (self.photo != nil) {
            Publish *p = (Publish*)[objects objectAtIndex:0];
            [self uploadImage:p.pk];
        }
        [self clearForm];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [ProgressHUD dismiss];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Não foi possível completar a operação." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - LocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorized) {
        [locationManager stopUpdatingLocation];
        btnLocalizacao.selected = YES;
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    btnLocalizacao.selected = NO;
    if ([error.domain isEqualToString: kCLErrorDomain] && error.code == kCLErrorDenied && firstView == FALSE) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                        message:@"Não é possível determinar sua localização. Para isso vá em Ajustes do sistema e autorize o aplicativo a buscar sua localização"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}


@end
