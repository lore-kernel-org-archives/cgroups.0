From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next v3 0/5] blk-wbt: minor fix and cleanup
Date: Sat, 27 May 2023 09:06:39 +0800
Message-ID: <20230527010644.647900-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hch-jcswGhMUV9g@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Changes in v3:
 - patch 1 from v2 is sent separately, and it's removd from this series.
 - add review tag for all the patches.

Changes in v2:
 - make the code more readable for patch 1
 - add a new attr_group that is only visible for rq based device
 - explain in detail for patch 4
 - add review tag for patch 2,3,5

Yu Kuai (5):
  blk-wbt: don't create wbt sysfs entry if CONFIG_BLK_WBT is disabled
  blk-wbt: remove dead code to handle wbt enable/disable with io
    inflight
  blk-wbt: cleanup rwb_enabled() and wbt_disabled()
  blk-iocost: move wbt_enable/disable_default() out of spinlock
  blk-sysfs: add a new attr_group for blk_mq

 block/blk-iocost.c |   7 +-
 block/blk-sysfs.c  | 181 ++++++++++++++++++++++++++-------------------
 block/blk-wbt.c    |  21 +-----
 block/blk-wbt.h    |  19 -----
 4 files changed, 110 insertions(+), 118 deletions(-)

-- 
2.39.2

