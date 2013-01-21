SlimeRefresh
=================================================

A lovely refreshing style looks like ``` UIRefreshControl ```. It looks like the Slime so I named it SlimeRefresh.

Screenshot:

![screenshots](http://zhaorenzhi.cn/wp-content/uploads/2012/07/screenshot1.png)
![screenshots](http://zhaorenzhi.cn/wp-content/uploads/2012/07/screenshot2.png)
![screenshots](http://zhaorenzhi.cn/wp-content/uploads/2012/07/screenshot3.png)
![screenshots](http://zhaorenzhi.cn/wp-content/uploads/2012/07/screenshot4.png)


![screenshots](http://zhaorenzhi.cn/wp-content/uploads/2012/12/ss1.png)


![screenshots](http://zhaorenzhi.cn/wp-content/uploads/2012/12/ss2.png)


![screenshots](http://zhaorenzhi.cn/wp-content/uploads/2012/12/ss3.png)

Usage
==================================================

1,download the source from https://github.com/dbsGen/SlimeRefresh/ 

- git : ``` git clone https://github.com/dbsGen/SlimeRefresh.git SlimeRefresh ```

2,add all under SlimeRefresh/SlimeRefresh to your project.

3,#import "SRRefreshView.h"

4,init SRRefreshView and add it to a UIScrollView.

just like:

        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        [_tableView addSubview:_slimeView];

Callback 
==================================================

A protocol and a block, choise one.

    - (void)slimeRefreshStartRefresh:(SRRefreshView*)refreshView;
    
Only one protocol, you have to implement. it will be called when the refreshing will be executed.

and here is the other way:

    @property (nonatomic, copy)     SRRefreshBlock  block;
    
as you see there is a block to receive the refresh event.just like:

    __block __unsafe_unretained id this = self;
    [refreshView setBlock:^(SRRefreshView* sender) { 
        [this load];    //replace this line to your refreshing code.
    }];


Style
==================================================

- Refere to the demo.

- The reflesh arrow image :
  - refreshView.refleshView.image = [UIImage imaggeNamed:@"Yours"];
  - refreshView.refreshView.bounds = CGRectMake(0, 0, 23, 23);
  - I'm sorry, it is not a good name.

Bug
==================================================

- When in the animation the view controller dealloc, that will make application creash.
  - Use the new version and remove refreshView from it's super view, when view controller dealloced.
    
<code>
    - (void)dealloc 
    {
          [refreshView removeFromSuperview];
    }
</code>
  
Others
==================================================

Ok, that is all. Enjoy it, and this is my blog:http://zhaorenzhi.cn.
