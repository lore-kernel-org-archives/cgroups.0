From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/4] cancel all throttled bios in blk_cleanup_queue()
Date: Wed, 22 Sep 2021 20:51:11 +0800
Message-ID: <20210922125115.381752-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

If blk_cleanup_queue() is called when some io are still throttled,
such io will not be handled until the throttle is done, which is not
necessary because the queue is already dying.

This patch series handle such in blk_cleanup_queue().

Yu Kuai (4):
  Revert "blk-throttle: remove tg_drain_bios"
  blk-throtl: don't warn in tg_drain_bios()
  blk-throtl: introduce blk_throtl_cancel_bios()
  block: cancel all throttled bios in blk_cleanup_queue()

 block/blk-core.c     |  3 ++
 block/blk-throttle.c | 70 +++++++++++++++++++++++++++++++++++++++++---
 block/blk.h          |  2 ++
 3 files changed, 71 insertions(+), 4 deletions(-)

-- 
2.31.1

