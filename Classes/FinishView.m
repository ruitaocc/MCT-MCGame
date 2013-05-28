//
//  FinishView.m
//  MCGame
//
//  Created by kwan terry on 13-5-22.
//
//

#import "FinishView.h"
#define BLACK_BAR_COMPONENTS_Finish				{ 0.22, 0.22, 0.22, 1.0, 0.07, 0.07, 0.07, 1.0 }
@implementation FinishView
@synthesize viewLoadedFromXib,finishViewType;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title{
    if ((self = [super initWithFrame:frame])) {
		
		CGFloat colors[8] = BLACK_BAR_COMPONENTS_Finish;
		[self.titleBar setColorComponents:colors];
		self.headerLabel.text = title;
		
        self.x_outerMargin = 100;
        self.y_outerMargin = 80;
        self.isShowColseBtn = YES;
        // Margin between edge of panel and the content area. Default = 20.0
        self.innerMargin =  10.0f;
        
        // Border color of the panel. Default = [UIColor whiteColor]
        self.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        
        // Border width of the panel. Default = 1.5f;
        self.borderWidth = 8.0f;
        
        // Corner radius of the panel. Default = 4.0f
        self.cornerRadius = 16;
        
        // Color of the panel itself. Default = [UIColor colorWithWhite:0.0 alpha:0.8]
        self.contentColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
        
        // Shows the bounce animation. Default = YES
        self.shouldBounce = YES;
        finishViewType = kFinishView_Default;
        // Height of the title view. Default = 40.0f
        [self setTitleBarHeight:48.0f];
        
        // The gradient style (Linear, linear reversed, radial, radial reversed, center highlight). Default = UAGradientBackgroundStyleLinear
        [[self titleBar] setGradientStyle:UAGradientBackgroundStyleLinear];
        
        // The line mode of the gradient view (top, bottom, both, none). Top is a white line, bottom is a black line.
        [[self titleBar] setLineMode: UAGradientLineModeBottom];
        
        // The noise layer opacity. Default = 0.4
        [[self titleBar] setNoiseOpacity:0.8];
        
        // The header label, a UILabel with the same frame as the titleBar
        [self headerLabel].font = [UIFont boldSystemFontOfSize:floor(self.titleBarHeight / 2.0)];
    }
    
    
    [[NSBundle mainBundle] loadNibNamed:@"myFinishView" owner:self options:nil];
    
    [self.contentView addSubview:viewLoadedFromXib];
    
	return self;

};
- (IBAction)goBackBtnPressed:(id)sender{
    finishViewType = kFinishView_GoBack;
    if ([delegate respondsToSelector:@selector(shouldCloseModalPanel:)]) {
		if ([delegate shouldCloseModalPanel:self]) {
			UADebugLog(@"Closing using delegates for modalPanel: %@", self);
			[self hide];
		}
    }
};
- (IBAction)changeNameBtnPressed:(id)sender{};
- (IBAction)oneMoreBtnPressed:(id)sender{};
- (IBAction)goCountingBtnPressed:(id)sender{};
- (IBAction)shareBtnPressed:(id)sender{};
- (void)dealloc {
	[viewLoadedFromXib release];
    [super dealloc];
}
- (void)layoutSubviews {
	[super layoutSubviews];
	
	[viewLoadedFromXib setFrame:self.contentView.bounds];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
}


@end
