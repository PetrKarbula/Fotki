#import <UIKit/UIKit.h>

@interface SidebarViewController : UITableViewController
{
    NSMutableArray *autocompleteSuggestions;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
