From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/5] A few cleanup and bugfix patches for blk-iocost
Date: Tue, 18 Oct 2022 20:19:27 +0800
Message-ID: <20221018121932.10792-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

This series contain a few patch to correct comment, correct trace of
vtime_rate and so on. More detail can be found in the respective
changelogs.

---
v2:
 Thanks Tejun for review and comment!
 Add Acked-by tag from Tejun.
 Correct description in patch 3/5 and 4/5.
 Drop "blk-iocost: Avoid to call current_hweight_max if iocg->inuse
== iocg->active"
 Drop "blk-iocost: Remove redundant initialization of struct ioc_gq"
 Drop "blk-iocost: Get ioc_now inside weight_updated"
---

Kemeng Shi (5):
  blk-iocost: Fix typo in comment
  blk-iocost: Reset vtime_base_rate in ioc_refresh_params
  blk-iocost: Trace vtime_base_rate instead of vtime_rate
  blk-iocost: Remove vrate member in struct ioc_now
  blk-iocost: Correct comment in blk_iocost_init

 block/blk-iocost.c            | 16 +++++++++-------
 include/trace/events/iocost.h |  4 ++--
 2 files changed, 11 insertions(+), 9 deletions(-)

-- 
2.30.0

