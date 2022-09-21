From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH 0/2] blk-throttle: improve bypassing bios checkings
Date: Wed, 21 Sep 2022 17:53:07 +0800
Message-ID: <20220921095309.1481289-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Currently, "tg->has_rules" and "tg->flags & THROTL_TG_HAS_IOPS_LIMIT"
both try to bypass bios that don't need to be throttled, however, they are
a little redundant and both not perfect:

1) "tg->has_rules" only distinguish read and write, but not iops and bps
   limit.
2) "tg->flags & THROTL_TG_HAS_IOPS_LIMIT" only check if iops limit
   exist, read and write is not distinguished, and bps limit is not
   checked.

With this patchset, biowon't be bypassedd if:

1) Bio is read/write, and corresponding read/write iops limit exist.
2) If corresponding iops limit doesn't exist, corresponding bps limit
exist and bio is not throttled before.

Yu Kuai (2):
  blk-throttle: remove THROTL_TG_HAS_IOPS_LIMIT
  blk-throttle: improve bypassing bios checkings

 block/blk-throttle.c | 21 +++++++--------------
 block/blk-throttle.h | 28 +++++++++++++++++++---------
 2 files changed, 26 insertions(+), 23 deletions(-)

-- 
2.31.1

