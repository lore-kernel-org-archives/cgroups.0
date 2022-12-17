From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next 0/4] blk-cgroup: synchronize del_gendisk() with configuring cgroup policy
Date: Sat, 17 Dec 2022 11:09:04 +0800
Message-ID: <20221217030908.1261787-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

iocost is initialized when it's configured the first time, and iocost
initializing can race with del_gendisk(), which will cause null pointer
dereference:

t1				t2
ioc_qos_write
 blk_iocost_init
  rq_qos_add
  				del_gendisk
  				 rq_qos_exit
  				 //iocost is removed from q->roqs
  blkcg_activate_policy
   pd_init_fn
    ioc_pd_init
     ioc = q_to_ioc(blkg->q)
     //can't find iocost and return null

And iolatency is about to switch to the same lazy initialization.

This patchset fix this problem by synchronize rq_qos_add() and
blkcg_activate_policy() with rq_qos_exit().

Yu Kuai (4):
  block/rq_qos: protect 'q->rq_qos' with queue_lock in rq_qos_exit()
  block/rq_qos: fail rq_qos_add() after del_gendisk()
  blk-cgroup: add a new interface blkcg_conf_close_bdev()
  blk-cgroup: synchronize del_gendisk() with configuring cgroup policy

 block/blk-cgroup.c     | 12 ++++++++++--
 block/blk-cgroup.h     |  1 +
 block/blk-iocost.c     |  8 ++++----
 block/blk-rq-qos.c     | 25 ++++++++++++++++++++-----
 block/blk-rq-qos.h     | 17 +++++++++++++----
 include/linux/blkdev.h |  1 +
 6 files changed, 49 insertions(+), 15 deletions(-)

-- 
2.31.1

