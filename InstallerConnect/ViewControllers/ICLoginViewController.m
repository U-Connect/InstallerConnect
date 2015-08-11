//
//  ICLoginViewController.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 6/9/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "ICLoginViewController.h"
#import "ICServicesHelper.h"
#import "ICAppConstants.h"
#import "ICUtilities.h"

@interface ICLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UISwitch *rememberMe;
@property (weak, nonatomic) IBOutlet UIButton *forgotPswdBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) MBProgressHUD *mbProgressHUD;
@end

@implementation ICLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"splash.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    [self.userNameTF setReturnKeyType:UIReturnKeyNext];
    [self.passwordTF setReturnKeyType:UIReturnKeyDone];
    [self.userNameTF addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passwordTF addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self applyBottomBorder:self.userNameTF];
    [self applyBottomBorder:self.passwordTF];
    
    UIColor *color = [UIColor whiteColor];
     self.userNameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:USER_NAME_HINT_TEXT attributes:@{NSForegroundColorAttributeName: color}];
    self.passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:PASSWORD_HINT_TEXT attributes:@{NSForegroundColorAttributeName: color}];
    [self initUserDefaults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)applyBottomBorder:(UITextField*)textField {
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor whiteColor].CGColor;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    textField.layer.masksToBounds = YES;
}

- (void)textFieldFinished:(id)sender
{
    if (sender == self.userNameTF) {
        [self.userNameTF resignFirstResponder];
        [self.passwordTF becomeFirstResponder];
    } else if (sender ==  self.passwordTF) {
        [sender resignFirstResponder];
    }
}

- (BOOL) textFieldShouldReturn: (UITextField*)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.userNameTF isFirstResponder] && [touch view] != self.userNameTF) {
        [self.userNameTF resignFirstResponder];
    }
    else if ([self.passwordTF isFirstResponder] && [touch view] != self.passwordTF) {
        [self.passwordTF resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

-(BOOL)validateUserCredentials {
    if([self.userNameTF.text isEqual:@""] || [self.passwordTF.text isEqual:@""]) {
        return NO;
    }
    
    return YES;
}


- (IBAction)signInButtonTapped:(id)sender {
    if(![self.loadingIndicator isAnimating]) {
        if([self validateUserCredentials]) {
            [self updateDefaults];
            [self doLogin];
        }
        else {
            [self showAlert:nil message:LOGIN_VALIDATION_ERROR];
        }
    }
}

- (IBAction)forgotPasswordButtonTapped:(id)sender {
    if(![self.loadingIndicator isAnimating]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:TITLE_FORGOT_PASSWORD
                                                        message:RESET_PASSWORD_MSG
                                                       delegate:self
                                              cancelButtonTitle:TITLE_CANCEL
                                              otherButtonTitles:TITLE_RESET, nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [alert textFieldAtIndex:0];
        textField.delegate = self;
        textField.text = self.userNameTF.text;
        [alert show];
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    return ([[[alertView textFieldAtIndex:0] text] length]>0)?YES:NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        //Reset button pressed.
        NSString *userName = [alertView textFieldAtIndex:0].text;
        [self resetPassword:userName];
    }
}

- (void)initUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    if([defaults boolForKey:REMEMBER_ME_KEY]) {
        self.userNameTF.text = [defaults stringForKey:USER_NAME_KEY];;
        self.passwordTF.text = [defaults stringForKey:PASSWORD_KEY];;
    }
    else {
        self.userNameTF.text = @"";
        self.passwordTF.text = @"";
    }
    
}

- (void)updateDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([self.rememberMe isOn]) {
        [defaults setBool:YES forKey:REMEMBER_ME_KEY];
        [defaults setValue:self.userNameTF.text forKey:USER_NAME_KEY];
        [defaults setValue:self.passwordTF.text forKey:PASSWORD_KEY];
    }
    else {
        [defaults setBool:NO forKey:REMEMBER_ME_KEY];
        [defaults setValue:@"" forKey:USER_NAME_KEY];
        [defaults setValue:@"" forKey:PASSWORD_KEY];
    }
    [defaults synchronize];
}

- (void)doLogin {
    if([ICUtilities isConnected]) {
        //[self.loadingIndicator startAnimating];
        self.mbProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.mbProgressHUD.labelText = @"Signing In...";
        self.mbProgressHUD.dimBackground = YES;
        self.mbProgressHUD.delegate = self;
        __block ICJSONResponse *jsonResponse = nil;
        BOOL (^serviceBlock)() = ^() {
            jsonResponse = [[ICServicesHelper getInstance] doLogin:self.userNameTF.text passWord:self.passwordTF.text];
            return YES;
        };
        
        void (^mainBlock)() = ^() {
            [self.mbProgressHUD hide:YES];//[self.loadingIndicator stopAnimating];
            if(jsonResponse.success) {
                ICUserLogin *userLogin = (ICUserLogin*)jsonResponse.data;
                if([userLogin.profile.role rangeOfString:INSTALLER_ROLE options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    [self performSegueWithIdentifier:@"installations_segue" sender:self];
                }
                else {
                    [self showAlert:nil message:LOGIN_ROLE_ERROR];
                }
            }
            else {
                [self showAlert:nil message:LOGIN_EROOR];
            }
        };
        
        [AsyncInterfaceTask dispatchBackgroundTask:serviceBlock withInterfaceUpdate:mainBlock];
    }
    else {
        [self showAlert:TITLE_NO_CONNECTIVITY message:NO_CONNECTIVITY_MSG];
    }
}

- (void)resetPassword:(NSString*)userName {
    self.mbProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.mbProgressHUD.labelText = @"Reset Password...";
    self.mbProgressHUD.dimBackground = YES;
    __block ICJSONResponse *jsonResponse = nil;
    BOOL (^serviceBlock)() = ^() {
        jsonResponse = [[ICServicesHelper getInstance] resetPassword:userName];
        return YES;
    };
    
    void (^mainBlock)() = ^() {
        [self.mbProgressHUD hide:YES];
        if(jsonResponse.success) {
           [self showAlert:nil message:RESET_PASSWORD_SUCCESS];
        }
        else {
            [self showAlert:nil message:RESET_PASSWORD_ERROR];
        }
    };
    
    [AsyncInterfaceTask dispatchBackgroundTask:serviceBlock withInterfaceUpdate:mainBlock];
}

- (void)showAlert:(NSString*)title message:(NSString*)message {
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:TITLE_OK otherButtonTitles:nil] show];
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [self.mbProgressHUD removeFromSuperview];
    self.mbProgressHUD = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
