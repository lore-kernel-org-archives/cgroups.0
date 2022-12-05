From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: [PATCH v3 0/9] A few bugfix and cleanup patches for blk-throttle
Date: Mon,  5 Dec 2022 19:57:00 +0800
Message-ID: <20221205115709.251489-1-shikemeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com, linfeilong@huawei.com, liuzhiqiang26@huawei.com

Hi, this series contain a few patches to fix problem when on the default
hierarchy, corret comment and so on. More details can be found in
respective changelogs. Thanks.

---
V2->V3:
 -Thanks for the review and advice from Tejun. Now all patches are acked
  by Tejun.
 -remove quotes around parent in corrected comment in patch "blk-throttle:
  correct stale comment in throtl_pd_init"
 -improve log message and rename throtl_tg_reach_low_limit to
  throtl_low_limit_reached.
 -drop patch "blk-throttle: avoid dead code in
  throtl_hierarchy_can_upgrade"
---
V1->V2:
 -Thanks for the review and advice from Tejun. The corrected comment of
  "blk-throttle: correct stale comment in throtl_pd_init" and the
  solution of "blk-throttle: Fix that bps of child could exceed bps
  limited in parent" are from reply of Tejun.
 -Collect Ack from Tejun.
 -Fix the compile problem when CONFIG_BLK_DEV_THROTTLING_LOW is set.
 -Drop "blk-throttle: Limit whole system if root group is configured
  when on the default hierarchy", "blk-throttle: remove unnecessary check
  for validation of limit index" and "blk-throttle: remove unused variable
  td in tg_update_has_rules"
 -Add "blk-throttle: correct stale comment in throtl_pd_init" and
  "blk-throttle: avoid dead code in throtl_hierarchy_can_upgrade"
 -Use solution that set the BIO_BPS_THROTTLED flag only when the bio
  traversed the entire tree to fix that bps of child could exceed bps
  limited in parent in patch 2/10.
 -Improve the description and comment of most commits.
---

Kemeng Shi (9):
  blk-throttle: correct stale comment in throtl_pd_init
  blk-throttle: Fix that bps of child could exceed bps limited in parent
  blk-throttle: ignore cgroup without io queued in
    blk_throtl_cancel_bios
  blk-throttle: correct calculation of wait time in tg_may_dispatch
  blk-throttle: simpfy low limit reached check in throtl_tg_can_upgrade
  blk-throttle: fix typo in comment of throtl_adjusted_limit
  blk-throttle: remove incorrect comment for tg_last_low_overflow_time
  blk-throttle: remove repeat check of elapsed time from last upgrade in
    throtl_hierarchy_can_downgrade
  blk-throttle: Use more siutable time_after check for update of
    slice_start

 block/blk-throttle.c | 102 +++++++++++++++++++++++--------------------
 1 file changed, 55 insertions(+), 47 deletions(-)

-- 
2.30.0

