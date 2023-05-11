From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next 0/6] blk-wbt: minor fix and cleanup
Date: Thu, 11 May 2023 09:45:03 +0800
Message-ID: <20230511014509.679482-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hch-jcswGhMUV9g@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Yu Kuai (6):
  blk-wbt: fix that wbt can't be disabled by default
  blk-wbt: don't create wbt sysfs entry if CONFIG_BLK_WBT is disabled
  blk-wbt: don't enable wbt for bio based device
  blk-wbt: remove deadcode to handle wbt enable/disable with io inflight
  blk-wbt: cleanup rwb_enabled() and wbt_disabled()
  blk-iocost: move wbt_enable/disable_default() out of spinlock

 block/blk-iocost.c |   7 ++-
 block/blk-sysfs.c  | 147 ++++++++++++++++++++++++---------------------
 block/blk-wbt.c    |  26 ++------
 block/blk-wbt.h    |  19 ------
 4 files changed, 88 insertions(+), 111 deletions(-)

-- 
2.39.2

