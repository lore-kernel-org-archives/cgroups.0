From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/11] A few bugfix and cleanup patches for blk-throttle
Date: Wed, 23 Nov 2022 14:03:50 +0800
Message-ID: <20221123060401.20392-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hi, this series contain a few patches to fix problem when on the default
hierarchy, corrent comment and so on. More detail can be found in
respective changelogs. Thanks.

Kemeng Shi (11):
  blk-throttle: Limit whole system if root group is configured when on
    the default hierarchy
  blk-throttle: Fix that bps of child could exceed bps limited in parent
  blk-throttle: ignore cgroup without io queued in
    blk_throtl_cancel_bios
  blk-throttle: correct calculation of wait time in tg_may_dispatch
  blk-throttle: simpfy low limit reached check in throtl_tg_can_upgrade
  blk-throttle: fix typo in comment of throtl_adjusted_limit
  blk-throttle: remove incorrect comment for tg_last_low_overflow_time
  blk-throttle: remove repeat check of elapsed time from last upgrade in
    throtl_hierarchy_can_downgrade
  blk-throttle: remove unnecessary check for validation of limit index
  blk-throttle: remove unused variable td in tg_update_has_rules
  blk-throttle: Use more siutable time_after check for update
    slice_start

 block/blk-throttle.c | 98 ++++++++++++++++++--------------------------
 1 file changed, 39 insertions(+), 59 deletions(-)

-- 
2.30.0

