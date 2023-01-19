From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next v3 0/3] blk-cgroup: make sure pd_free_fn() is called in order
Date: Thu, 19 Jan 2023 19:03:47 +0800
Message-ID: <20230119110350.2287325-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Changes in v3:
 - add ack tag from Tejun for patch 1,2
 - as suggested by Tejun, update commit message and comments in patch 3

The problem was found in iocost orignally([1]) that ioc can be freed in
ioc_pd_free(). And later we found that there are more problem in
iocost([2]).

After some discussion, as suggested by Tejun([3]), we decide to fix the
problem that parent pd can be freed before child pd in cgroup layer
first. And the problem in [1] will be fixed later if this patchset is
applied.

[1] https://lore.kernel.org/all/20221130132156.2836184-8-linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
[2] https://lore.kernel.org/all/aa924294-2f54-1b53-fc6e-e4f8fa019b14-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org/
[3] https://lore.kernel.org/all/20221227125502.541931-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org/

Yu Kuai (3):
  blk-cgroup: dropping parent refcount after pd_free_fn() is done
  blk-cgroup: support to track if policy is online
  blk-cgroup: synchronize pd_free_fn() from blkg_free_workfn() and
    blkcg_deactivate_policy()

 block/blk-cgroup.c     | 63 ++++++++++++++++++++++++++++++++----------
 block/blk-cgroup.h     |  1 +
 include/linux/blkdev.h |  1 +
 3 files changed, 50 insertions(+), 15 deletions(-)

-- 
2.31.1

