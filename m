From: Kemeng Shi <shikemeng@huawei.com>
Subject: [PATCH v2 00/10] A few bugfix and cleanup patches for blk-throttle
Date: Tue, 29 Nov 2022 11:01:37 +0800
Message-ID: <20221129030147.27400-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com

Hi, this series contain a few patches to fix problem when on the default
hierarchy, corrent comment and so on. More detail can be found in
respective changelogs. Thanks.

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

Kemeng Shi (10):
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
  blk-throttle: avoid dead code in throtl_hierarchy_can_upgrade

 block/blk-throttle.c | 104 +++++++++++++++++++++++--------------------
 1 file changed, 56 insertions(+), 48 deletions(-)

-- 
2.30.0

