//
//  DLUltimasNoticiasViewController.m
//  RSN
//
//  Created by jossiecs on 3/27/14.
//  Copyright (c) 2014 DreamLabs. All rights reserved.
//

#import "DLUltimosSismosViewController.h"
#import "DLSismosTableViewController.h"
#import "DLCenterViewController.h"
#import "DLMainViewController.h"
#import "DLRSNModel.h"
#import <QuartzCore/QuartzCore.h>

@interface DLUltimosSismosViewController () <UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic,weak) IBOutlet UITextField *fechaTxt;
@property (weak, nonatomic) IBOutlet UILabel *titleUltimosSismosLabel;
@property (nonatomic,strong) DLSismosTableViewController *sismosTableViewController;
@property (nonatomic,weak) IBOutlet UILabel *descripcion;
@property (nonatomic,strong) NSString *dateString;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) DLCenterViewController *centerViewController;

@end

@implementation DLUltimosSismosViewController

@synthesize sismosTableViewController;
@synthesize descripcion;
@synthesize dateString;
@synthesize titleUltimosSismosLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    
    dateString = [dateFormat stringFromDate:date];
    
    descripcion.textAlignment = NSTextAlignmentJustified;
    titleUltimosSismosLabel.text = @"Últimos 10 Sismos";
    
    //@NOTE: Change title color and text to navigationbar
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]; // change this color
    self.navigationItem.titleView = label;
    label.text = @"Ultimos Sismos";
    [label sizeToFit];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Atrás" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //@NOTE: Create datePicker as selection date for textfield fecha
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    
    NSDateFormatter *minimunDateFormatter = [[NSDateFormatter alloc] init];
    [minimunDateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *minmunDateString = @"01-09-2012";
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [minimunDateFormatter dateFromString:minmunDateString];
    [datePicker setMinimumDate:dateFromString];
    [datePicker setMaximumDate:[NSDate date]];
    
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    
    //@NOTE: Adds gesture recognizer 1 tap to dismiss the datepicker view
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDate:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    tapGestureRecognize.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognize];
    
    //@NOTE: locates the datepicker inside the texfield fecha
    [self.fechaTxt setInputView:datePicker];
    self.fechaTxt.layer.borderColor=[[UIColor colorWithRed:(208.0f/255.0f) green:(208.0f/255.0f) blue:(208.0f/255.0f) alpha:1.0f]CGColor];
    self.fechaTxt.layer.borderWidth= 1.0f;
    [self setUpTableView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [sismosTableViewController getLastTenSismos];
}

-(void) mapaButtonPressed{
    [self.fechaTxt setText:@""];
    if ([self.fechaTxt isFirstResponder]) {
        [self.fechaTxt resignFirstResponder];
        
    }
    [sismosTableViewController cleanTable];
    [self setUpTableView];
    [self.cancelButton setHidden:YES];
    [self.doneButton setHidden:YES];
    titleUltimosSismosLabel.text = @"Últimos 10 Sismos";
}

-(void)getSismosWithDateString{
    [sismosTableViewController cleanTable];
    [self updateTableWithDate:dateString];
}


-(void) setUpTableView{
    sismosTableViewController = [[DLSismosTableViewController alloc]init];
    if (isiPhone5) {
        [sismosTableViewController.view setFrame:CGRectMake(10, 180, 300, 380)];
    }else{
        [sismosTableViewController.view setFrame:CGRectMake(10, 180, 300, 300)];
    }
    
    
    [self addChildViewController:sismosTableViewController];
    [sismosTableViewController didMoveToParentViewController:self];
    
    [self.view insertSubview:sismosTableViewController.view belowSubview:self.doneButton];
    
    sismosTableViewController.getToday = YES;
    [sismosTableViewController getLastTenSismos];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissDatePicker:) name:DLMainViewControllerShowMenu object:nil];

}


- (IBAction)checkButtonPressed {
    [sismosTableViewController cleanTable];
    UIDatePicker *picker = (UIDatePicker*)self.fechaTxt.inputView;
    dateString = [self formatDate:picker.date];
    [self.fechaTxt resignFirstResponder];
    [self.doneButton setHidden:YES];
    [self.cancelButton setHidden:NO];
    titleUltimosSismosLabel.text = @"Resultados de búsqueda";
    [sismosTableViewController reloadTableData];
    [self updateTableWithDate:dateString];
}

- (void)dismissDate:(UIGestureRecognizer *)gestureRecognizer {
    
}

-(void)dismissDatePicker:(id)sender{
    [self.fechaTxt resignFirstResponder];
    [self.doneButton setHidden:YES];
    [self updateTableWithDate:dateString];
}

-(void)updateTextField:(id)sender{
    UIDatePicker *picker = (UIDatePicker*)self.fechaTxt.inputView;
    self.fechaTxt.text = [self formatDateForPresentation:picker.date];
    dateString = [self formatDate:picker.date];
}

- (NSString *)formatDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy'/'MM'/'dd"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

- (NSString *)formatDateForPresentation:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd'/'MM'/'yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}


-(void)addSismosTableViewControllerDelegate:(id)delegate{
    [sismosTableViewController setDelegate:delegate];
}

- (void) updateTableWithDate:(NSString*)date{
    [sismosTableViewController getSismosWithDateString:date];

    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (touch.view == self.cancelButton){

        [self.fechaTxt setText:@""];
        if ([self.fechaTxt isFirstResponder]) {
            [self.fechaTxt resignFirstResponder];
            
        }
        [sismosTableViewController cleanTable];
        [self setUpTableView];
        [self.cancelButton setHidden:YES];
        [self.doneButton setHidden:YES];
        titleUltimosSismosLabel.text = @"Últimos 10 Sismos";
        return NO;
    }
    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField ==self.fechaTxt) {
        [self.doneButton setHidden:NO];
    }
    return YES;
}
@end
