From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/4] cancel all throttled bios in del_gendisk()
Date: Sat, 27 Nov 2021 18:10:55 +0800
Message-ID: <20211127101059.477405-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

If del_gendisk() is done when some io are still throttled, such io
will not be handled until the throttle is done, which is not
necessary.

This patch series handle such io in del_gendisk().

Yu Kuai (4):
  Revert "blk-throttle: remove tg_drain_bios"
  blk-throtl: don't warn in tg_drain_bios()
  blk-throtl: introduce blk_throtl_cancel_bios()
  block: cancel all throttled bios in del_gendisk()

 block/blk-throttle.c | 68 +++++++++++++++++++++++++++++++++++++++++---
 block/blk-throttle.h |  2 ++
 block/genhd.c        |  2 ++
 3 files changed, 68 insertions(+), 4 deletions(-)

-- 
2.31.1

