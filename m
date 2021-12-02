From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 0/2] cancel all throttled bios in del_gendisk()
Date: Thu, 2 Dec 2021 21:04:38 +0800
Message-ID: <20211202130440.1943847-1-yukuai3@huawei.com>
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

Changes in v2:
 - move WARN_ON_ONCE() from throtl_rb_first() to it's caller
 - merge some patches into one.

Changes in v3:
 - some code optimization in patch 1
 - hold queue lock to cancel bios in patch 2

Changes in v4:
 - delete rcu_read_lock() and rcu_read_unlock() in patch 2

Yu Kuai (2):
  blk-throtl: move WARN_ON_ONCE() from throtl_rb_first() to it's caller
  block: cancel all throttled bios in del_gendisk()

 block/blk-throttle.c | 74 ++++++++++++++++++++++++++++++++++++++++++--
 block/blk-throttle.h |  2 ++
 block/genhd.c        |  2 ++
 3 files changed, 75 insertions(+), 3 deletions(-)

-- 
2.31.1

