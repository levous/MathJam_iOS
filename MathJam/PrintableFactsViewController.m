//
//  PrintableFactsViewController.m
//  MathJam
//
//  Created by Rusty Zarse on 2/15/13.
//  Copyright (c) 2013 Levous, LLC. All rights reserved.
//

#import "PrintableFactsViewController.h"
#import "PrintableFactsLayoutHelper.h"
#import "RZPdfGenerator.h"
#import "PrintableFactsPdfGeneratorContentDelegate.h"

@interface PrintableFactsViewController ()

@end

@implementation PrintableFactsViewController

static int  NUMBER_OF_COLUMNS       = 3,
            NUMBER_OF_EQUATIONS     = 30;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    layoutHelper = [[PrintableFactsLayoutHelper alloc] initWithContainerSize:self.view.frame.size numberOfEquations:NUMBER_OF_EQUATIONS columns:NUMBER_OF_COLUMNS];
    
    RZPdfGenerator *g = [[RZPdfGenerator alloc] init];
    PrintableFactsPdfGeneratorContentDelegate *pdfdelegate = [[PrintableFactsPdfGeneratorContentDelegate alloc] init];
    pdfdelegate.practiceSession = self.practiceSession;
    g.contentDelegate = pdfdelegate;
    NSString *fileName = [g demoPdf];
    [self printContent:fileName];
    
    [self loadEquationLabels];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) printContent:(NSString *)fileName{
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    NSURL *url = [NSURL fileURLWithPath:fileName];
    if  (pic && [UIPrintInteractionController canPrintURL:url] ) {
        pic.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"MathJame Sheet";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
        pic.showsPageRange = YES;
        pic.printingItem = url;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            if (!completed && error)
                NSLog(@"FAILED! due to error in domain %@ with error code %u",
                      error.domain, error.code);
            
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        /*if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [pic presentFromBarButtonItem:self.printButton animated:YES
                        completionHandler:completionHandler];
        } else {*/
            [pic presentAnimated:YES completionHandler:completionHandler];
        //}
    }
}

- (void)loadEquationLabels{
    int idx = 0;
    
    RZMissingNumberEquation *equation = [[RZMissingNumberEquation alloc] init];
    equation.practiceSession = self.practiceSession;
    for(idx = 0;idx < NUMBER_OF_EQUATIONS;++idx){
        [equation generateNewFactors];
                
        CGRect frame = [self calculateFrameForEquationAtIndex:idx];
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.text = [[equation toText] stringByReplacingOccurrencesOfString:@"?" withString:@"___"];
        label.font = [UIFont fontWithName:kRZ_DEFAULT_FONT_NAME size:12.0];
        [self.view addSubview:label];
    }
    
}

- (CGRect)calculateFrameForEquationAtIndex:(int)equationIdx{
    return [layoutHelper calculateFrameForEquationAtIndex:equationIdx];

}

- (void)saveToPdf{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
