From: Kemeng Shi <shikemeng@huawei.com>
Subject: [PATCH 4/4] blk-cgroup: Fix typo in comment
Date: Mon, 10 Oct 2022 10:38:59 +0800
Message-ID: <20221010023859.11896-5-shikemeng@huawei.com>
References: <20221010023859.11896-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221010023859.11896-1-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com

Replace assocating with associating.
Replace assocaited with associated.

Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
---
 block/blk-cgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index fc083c35dc42..f723901ef9b9 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -205,7 +205,7 @@ static inline struct blkcg *blkcg_parent(struct blkcg *blkcg)
  * @q: request_queue the new blkg is associated with
  * @gfp_mask: allocation mask to use
  *
- * Allocate a new blkg assocating @blkcg and @q.
+ * Allocate a new blkg associating @blkcg and @q.
  */
 static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
 				   gfp_t gfp_mask)
@@ -602,7 +602,7 @@ EXPORT_SYMBOL_GPL(blkcg_print_blkgs);
  * @pd: policy private data of interest
  * @v: value to print
  *
- * Print @v to @sf for the device assocaited with @pd.
+ * Print @v to @sf for the device associated with @pd.
  */
 u64 __blkg_prfill_u64(struct seq_file *sf, struct blkg_policy_data *pd, u64 v)
 {
@@ -802,7 +802,7 @@ EXPORT_SYMBOL_GPL(blkg_conf_prep);
 
 /**
  * blkg_conf_finish - finish up per-blkg config update
- * @ctx: blkg_conf_ctx intiailized by blkg_conf_prep()
+ * @ctx: blkg_conf_ctx initialized by blkg_conf_prep()
  *
  * Finish up after per-blkg config update.  This function must be paired
  * with blkg_conf_prep().
-- 
2.30.0

