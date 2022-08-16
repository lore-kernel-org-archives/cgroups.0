From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next 0/3] bfq simple cleanups
Date: Tue, 16 Aug 2022 09:56:28 +0800
Message-ID: <20220816015631.1323948-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Yu Kuai (3):
  block: bfq: remove unused functions
  block, bfq: remove useless checking in bfq_put_queue()
  block, bfq: remove useless parameter for bfq_add/del_bfqq_busy()

 block/bfq-cgroup.c  |  5 -----
 block/bfq-iosched.c | 14 ++++++--------
 block/bfq-iosched.h | 18 ++++++++++--------
 block/bfq-wf2q.c    |  9 ++++++---
 4 files changed, 22 insertions(+), 24 deletions(-)

-- 
2.31.1

