From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: [PATCH v3] blk-cgroup: Fix typo in comment
Date: Tue,  6 Dec 2022 17:33:07 +0800
Message-ID: <20221206093307.378249-1-shikemeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linfeilong@huawei.com, liuzhiqiang26@huawei.com

From: Kemeng Shi <shikemeng@huawei.com>

Replace assocating with associating.
Replace intiailized with initialized.

Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>

---
v3:
 -add reviewed-by
v2:
 -based on current mainline code
 -add acked-by
---
 block/blk-cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index ed761c62ad0a..8197246ba8c6 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -577,7 +577,7 @@ EXPORT_SYMBOL_GPL(blkcg_print_blkgs);
  * @pd: policy private data of interest
  * @v: value to print
  *
- * Print @v to @sf for the device assocaited with @pd.
+ * Print @v to @sf for the device associated with @pd.
  */
 u64 __blkg_prfill_u64(struct seq_file *sf, struct blkg_policy_data *pd, u64 v)
 {
@@ -765,7 +765,7 @@ EXPORT_SYMBOL_GPL(blkg_conf_prep);
 
 /**
  * blkg_conf_finish - finish up per-blkg config update
- * @ctx: blkg_conf_ctx intiailized by blkg_conf_prep()
+ * @ctx: blkg_conf_ctx initialized by blkg_conf_prep()
  *
  * Finish up after per-blkg config update.  This function must be paired
  * with blkg_conf_prep().
-- 
2.30.0

