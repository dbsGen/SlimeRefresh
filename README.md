SlimeRefresh
=================================================

A lovely refreshing style looks like ``` UIRefreshControl ```. It's looks like the Slime so I named it SlimeRefresh.

Screenshot:

![screenshots](http://zhaorenzhi.cn/wp-content/uploads/2012/07/screenshot1.png)
![screenshots](http://zhaorenzhi.cn/wp-content/uploads/2012/07/screenshot2.png)
![screenshots](http://zhaorenzhi.cn/wp-content/uploads/2012/07/screenshot3.png)
![screenshots](http://zhaorenzhi.cn/wp-content/uploads/2012/07/screenshot4.png)

How to use?
==================================================

1,down the source from https://github.com/dbsGen/SlimeRefresh/

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

    __block typeof(self) this = self;
    [refreshView setBlock:^(SRRefreshView* sender) { 
        [this load];    //replace this line to your refreshing code.
    }];


Style
==================================================

- Change to style of the slime, You have to get the instance of SRSlimeView by this ```    refreshView.slime    ```
  - ``` viscous ``` this property to set how the limit of the slime being pulled apart.
  - ``` radius ``` to set the size of slime.
  - ``` bodyColor ``` to set the fill color.
  - ``` skinColor ``` to set the line color.

- How to set the arrow image?
  - ``` refreshView.refleshView.image ``` use this to set the arrow image.

Up inset
==================================================

Some time you maybe want to add the ``` SRRefreshView ``` to a ``` UIScrollView ``` which 

have setted the ``` contentInset ```. At this time you will set the ``` upInset ``` , you 

just need to set the top.

Action
==================================================

- call ``` scrollViewDidScroll ``` in the protocol ``` scrollViewDidScroll: ``` of ``` UIScrollViewDelegate ```.
- call ```  scrollViewDidEndDraging ``` in the ``` scrollViewDidEndDragging:willDecelerate: ```.
- and if the refresh loading over you will call ``` endRefresh ```.

Last
==================================================

Ok, that is all. Enjoy it, and this is my blog:http://zhaorenzhi.cn.