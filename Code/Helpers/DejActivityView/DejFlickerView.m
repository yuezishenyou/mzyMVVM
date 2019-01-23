//
//  DejFlickerView.m
//  ydx_login
//
//  Created by maoziyue on 2017/11/4.
//  Copyright © 2017年 meiyue. All rights reserved.
//

#import "DejFlickerView.h"


#define kBorderHeight (50)
#define kFontSizes     (15)
#define kDuration     (1.25)

@interface DejFlickerView()

@property (nonatomic, strong) UIView  *borderView;
@property (nonatomic, weak)   UIView  *originalView;
@property (nonatomic, assign) NSInteger  duration;

@end

static DejFlickerView *dejFlickerView = nil;
@implementation DejFlickerView
{
    CGFloat width;
    CGFloat height;
}



#pragma mark ------------Util----------------
- (void)setupBackground
{
    self.opaque = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}
- (CGRect)enclosingFrame;
{
    return [[UIScreen mainScreen]bounds];
}

- (UIView *)makeBorderView;
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.opaque = NO;
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    //view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    view.backgroundColor = [UIColor darkGrayColor];
    view.layer.cornerRadius = 3;
    view.layer.masksToBounds = YES;
    return view;
}



- (UILabel *)makeActivityLabelWithText:(NSString *)labelText;
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.font = [UIFont systemFontOfSize:kFontSizes];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = labelText;
    
    return label;
}

- (UIView *)viewForView:(UIView *)view;
{
    return view;
}



// ----------------------------------------------------------------------------------------
// MARK: - 基础方法
// ----------------------------------------------------------------------------------------

- (void)layoutSubviews
{
    //NSLog(@"layoutSubviews:%ld",self.dejActivityStyle);
    
    /**
     * 这里要布局
     * borderView 在布局，居中
     */
    
    self.frame = [self enclosingFrame];
    
    if (!CGAffineTransformIsIdentity(self.borderView.transform))
        return;
    
    
    NSDictionary *att = @{NSFontAttributeName:[UIFont systemFontOfSize:kFontSizes]};
    CGSize size = [self.tipLabel.text sizeWithAttributes:att];
    
    
    CGFloat borderWidth;
    CGFloat borderHeight;

    borderWidth = size.width + 50 +10;
    borderHeight = kBorderHeight;
    
    
    
    
    CGRect borderFrame = CGRectZero;
    borderFrame.size.width = borderWidth;
    borderFrame.size.height = borderHeight;
    self.borderView.frame = borderFrame;
    self.borderView.center = CGPointMake(width / 2, height /2 - 100 );
    
    
    
    
    //activityLabel
    CGRect activityLabelFrame = CGRectZero;
    activityLabelFrame.size.width = borderWidth;
    activityLabelFrame.size.height = borderHeight;
    self.tipLabel.frame = activityLabelFrame;
    
    self.tipLabel.textColor = [UIColor whiteColor];

    self.tipLabel.center = CGPointMake(borderWidth / 2, borderHeight / 2 );
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.textAlignment = NSTextAlignmentCenter;

}


- (DejFlickerView *)initForView:(UIView *)addToView withLabel:(NSString *)labelText duration:(NSInteger)duration
{
    
    if (self = [super initWithFrame:CGRectZero])
    {
        
        //NSLog(@"-----init-------");
        width = [[UIScreen mainScreen]bounds].size.width;
        height = [[UIScreen mainScreen]bounds].size.height;
        [self setupBackground];
        
        self.originalView = addToView;
        
        self.duration = duration;
        
        self.borderView = [self makeBorderView];
        
        self.tipLabel = [self makeActivityLabelWithText:labelText];
        

        
        [addToView addSubview:self];
        [self addSubview:self.borderView];
        [self.borderView addSubview:self.tipLabel];
        
        
        
        //[self animateShow];//显示动画 不好看
        
    }
    return self;
}








+ (void)removeView
{
    if (!dejFlickerView) {
        return;
    }

    [dejFlickerView removeFromSuperview];
    dejFlickerView = nil;
}

+ (void)removeViewAnimated:(BOOL)animated
{
    if (!dejFlickerView) {
        return;
    }
    if (animated){
        [dejFlickerView animationRemove];
    }else{
        [self removeView];
    }
}


- (void)animationRemove
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeAnimationDidStop:finished:context:)];
    
    self.alpha = 0.0;
    
    [UIView commitAnimations];
    
}

- (void)removeAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
{
    [[self class] removeView];
    
}

- (void)animateShow;
{
    self.alpha = 0.0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.alpha = 1.0;
    
    [UIView commitAnimations];
}










+ (DejFlickerView *)flickerViewForView:(UIView *)addToView withLabel:(NSString *)labelText duration:(NSInteger)duration
{
    if (dejFlickerView)
    {
        [self removeView];
    }
    dejFlickerView = [[self alloc]initForView:addToView withLabel:labelText duration:duration];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dejFlickerView.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[dejFlickerView class] removeViewAnimated:YES];
    });
   
    
    return dejFlickerView;
}









// ----------------------------------------------------------------------------------------
// MARK: - 自定义方法
// ----------------------------------------------------------------------------------------

+ (DejFlickerView *)flickerViewForView:(UIView *)addToView withLabel:(NSString *)labelText
{
    return [self flickerViewForView:addToView withLabel:labelText duration:kDuration];
}

+ (DejFlickerView *)flickerWithLabeText:(NSString *)labelText
{
    UIWindow *w = [UIApplication sharedApplication].keyWindow;
    return [self flickerViewForView:w withLabel:labelText duration:kDuration];
}












- (void)dealloc;
{
    if ([dejFlickerView isEqual:self])
    {
        dejFlickerView = nil;
    }
    //NSLog(@"--提示框释放---");
}

@end
