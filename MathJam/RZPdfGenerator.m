//
//  RZPdfGenerator.m
//  MathJam
//
//  Created by Rusty Zarse on 3/21/13.
//  Copyright (c) 2013 Levous, LLC. All rights reserved.
//

#import "RZPdfGenerator.h"
#import <UIKit/UIKit.h>

static CGFloat  kBorderInset = 20.0;
static CGFloat  kMarginInset = 20.0;

static CGFloat  kBorderWidth = 1.0;
static CGFloat  kLineWidth = 1.0;


@implementation RZPdfGenerator
- (NSString *) demoPdf{
    pageSize = CGSizeMake(612, 792);
    NSString *fileName = @"Demo.pdf";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFileName = [documentsDirectory stringByAppendingPathComponent:fileName];

    [self generatePdfWithFilePath:pdfFileName];
    return pdfFileName;
}

- (void) generatePdfWithFilePath: (NSString *)thefilePath
{
	UIGraphicsBeginPDFContextToFile(thefilePath, CGRectZero, nil);
    
	NSInteger currentPage = 0;
	BOOL done = NO;
	do
	{
		// Mark the beginning of a new page.
		UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        
		// Draw a page number at the bottom of each page.
		currentPage++;
		[self drawPageNumber:currentPage];
        
		//Draw a border for each page.
		[self drawBorder];
        
		//Draw text fo our header.
		[self drawHeader];
        
		//Draw a line below the header.
		[self drawLine];
        
		//Draw content for the page.
		[self drawContent];
        
		//Draw an image
	//	[self drawImage];
		done = YES;
	}
	while (!done);
    
	// Close the PDF context and write the contents out.
	UIGraphicsEndPDFContext();
}

- (void)drawPageNumber:(NSInteger)pageNumber
{
    NSString* pageNumberString = [NSString stringWithFormat:@"Page %d", pageNumber];
    UIFont* theFont = [UIFont systemFontOfSize:12];
    
    CGSize pageNumberStringSize = [pageNumberString sizeWithFont:theFont
                                               constrainedToSize:pageSize
                                                   lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect stringRenderingRect = CGRectMake(kBorderInset,
                                            pageSize.height - 40.0,
                                            pageSize.width - 2*kBorderInset,
                                            pageNumberStringSize.height);
    
    [pageNumberString drawInRect:stringRenderingRect withFont:theFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
}


- (void) drawBorder
{
	CGContextRef	currentContext = UIGraphicsGetCurrentContext();
	UIColor *borderColor = [UIColor brownColor];
	CGRect rectFrame = CGRectMake(kBorderInset, kBorderInset, pageSize.width-kBorderInset*2, pageSize.height-kBorderInset*2);
	CGContextSetStrokeColorWithColor(currentContext, borderColor.CGColor);
	CGContextSetLineWidth(currentContext, kBorderWidth);
	CGContextStrokeRect(currentContext, rectFrame);
}

- (void) drawHeader
{
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.3, 0.7, 0.2, 1.0);
    
    NSString *textToDraw = @"MathJam";
    
    UIFont *font = [UIFont systemFontOfSize:24.0];
    
    CGSize stringSize = [textToDraw sizeWithFont:font constrainedToSize:CGSizeMake(pageSize.width - 2*kBorderInset-2*kMarginInset, pageSize.height - 2*kBorderInset - 2*kMarginInset) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect renderingRect = CGRectMake(kBorderInset + kMarginInset, kBorderInset + kMarginInset, pageSize.width - 2*kBorderInset - 2*kMarginInset, stringSize.height);
    
    [textToDraw drawInRect:renderingRect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
}

- (void) drawLine
{
	CGContextRef	currentContext = UIGraphicsGetCurrentContext();
    
	CGContextSetLineWidth(currentContext, kLineWidth);
    
	CGContextSetStrokeColorWithColor(currentContext, [UIColor blueColor].CGColor);
    
	CGPoint startPoint = CGPointMake(kMarginInset + kBorderInset, kMarginInset + kBorderInset + 40.0);
	CGPoint endPoint = CGPointMake(pageSize.width - 2*kMarginInset -2*kBorderInset, kMarginInset + kBorderInset + 40.0);
    
	CGContextBeginPath(currentContext);
	CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
	CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
	CGContextClosePath(currentContext);
	CGContextDrawPath(currentContext, kCGPathFillStroke);
}

- (void) drawText
{
	CGContextRef	currentContext = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    
	NSString *textToDraw = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius. Claritas est etiam processus dynamicus, qui sequitur mutationem consuetudium lectorum. Mirum est notare quam littera gothica, quam nunc putamus parum claram, anteposuerit litterarum formas humanitatis per seacula quarta decima et quinta decima. Eodem modo typi, qui nunc nobis videntur parum clari, fiant sollemnes in futurum.";
    
	UIFont *font = [UIFont systemFontOfSize:14.0];
    
	CGSize stringSize = [textToDraw sizeWithFont:font
							   constrainedToSize:CGSizeMake(pageSize.width - 2*kBorderInset-2*kMarginInset, pageSize.height - 2*kBorderInset - 2*kMarginInset)
								   lineBreakMode:NSLineBreakByWordWrapping];
    
	CGRect renderingRect = CGRectMake(kBorderInset + kMarginInset, kBorderInset + kMarginInset + 50.0, pageSize.width - 2*kBorderInset - 2*kMarginInset, stringSize.height);
    
	[textToDraw drawInRect:renderingRect
				  withFont:font
			 lineBreakMode:NSLineBreakByWordWrapping
				 alignment:NSTextAlignmentLeft];
}

- (void) drawContent{
    
	CGRect renderingRect = CGRectMake(kBorderInset + kMarginInset, kBorderInset + kMarginInset + 50.0, pageSize.width - 2*kBorderInset - 2*kMarginInset, pageSize.height-(kBorderInset + kMarginInset) - 100); // need to subtract header and footer height properly
    
    CGContextRef	currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.3, 0.3, 0.3, 1.0);
    
    
	if(self.contentDelegate){
        [self.contentDelegate rzpdf_DrawContentInRectangle:renderingRect];
    }else{
        [self drawText];
    }
}


- (void) drawImage
{
	UIImage * demoImage = [UIImage imageNamed:@"Default.png"];
	[demoImage drawInRect:CGRectMake( (pageSize.width - demoImage.size.width/2)/2, 350, demoImage.size.width/2, demoImage.size.height/2)];
}




@end
