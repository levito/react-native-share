#import <MessageUI/MessageUI.h>
#import "RNShare.h"
#import "RCTConvert.h"

@implementation RNShare
- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(test)
{
  // Your implementation here
}
RCT_EXPORT_METHOD(open:(NSDictionary *)options :(RCTResponseSenderBlock)callback)
{
    // Your implementation here
    NSString *shareText = [RCTConvert NSString:options[@"share_text"]];
    NSString *shareUrl = [RCTConvert NSString:options[@"share_URL"]];
    NSString *shareFile = [RCTConvert NSString:options[@"share_file"]];
    //some app extension need a NSURL or UIImage Object to share
    NSURL *cardUrl = [NSURL URLWithString:shareUrl];
    
    if ([shareFile length] == 0) {
        
        NSArray *itemsToShare = @[shareText, shareUrl, cardUrl];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        /*activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo,
         UIActivityTypeMessage,
         UIActivityTypeMail,
         UIActivityTypePrint,
         UIActivityTypeCopyToPasteboard,
         UIActivityTypeAssignToContact,
         UIActivityTypeSaveToCameraRoll,
         UIActivityTypeAddToReadingList,
         UIActivityTypePostToFlickr,
         UIActivityTypePostToVimeo,
         UIActivityTypePostToTencentWeibo,
         UIActivityTypeAirDrop];*/
        UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        
        
        
        //if iPhone
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [root presentViewController:activityVC animated:YES completion:nil];
        }
        //if iPad
        else {
            // Change Rect to position Popover
            UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];
            [popup presentPopoverFromRect:CGRectMake(root.view.frame.size.width/2, root.view.frame.size.height/4, 0, 0)inView:root.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
    } else {
        
        NSURL *file = [NSURL fileURLWithPath:shareFile];
        
        self.documentController = [UIDocumentInteractionController interactionControllerWithURL:file];
        self.documentController.delegate = self;
        
        UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        
        if (![self.documentController presentOpenInMenuFromRect:ctrl.view.bounds inView:ctrl.view animated:YES]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"There are no installed apps that can open this file." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }
    
}
@end
