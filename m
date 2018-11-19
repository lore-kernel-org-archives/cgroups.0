From: Paolo Valente <paolo.valente@linaro.org>
Subject: [PATCH V2 02/10] block, cgroup: pass cftype to functions that need to use it
Date: Mon, 19 Nov 2018 11:34:16 +0100
Message-ID: <20181119103424.3853-3-paolo.valente@linaro.org>
References: <20181119103424.3853-1-paolo.valente@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xE31UGISHMijh6BWsEpclRZoNNImo7FAKtEIn5NIV0A=;
        b=SU4gX9UrHxz7m4v1tXtIXnFVKBC85SmHhU3WWiQYYH5YJWdQrx77/09MmnpPILr2Gv
         PCbKmtQgB2koGowWyZFjNRJlKJFv9udeNRVF/Tx2HHxFCDZQhXGe45I/uov9rCuAnB50
         t7iYiiNqnQaObo/r0EtTj0WBdzrK0QxzCGtFc=
In-Reply-To: <20181119103424.3853-1-paolo.valente@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, broonie@kernel.org, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Paolo Valente <paolo.valente@linaro.org>

Some seq_show functions need to access the cftype they belong to, for
retrieving the data to show. These functions get their cftype by using
the seq_cft accessor for the seq_file. This solution is no longer
viable in case a seq_file is shared among more than one cftype,
because the accessor always returns (only) the first of the cftypes
sharing the seq_file.

This commit enables these seq_show functions to be passed their
cftype, by replacing their prototype with that of the newly defined
seq_show_cft hook, and by invoking these functions through this new
hook.

Signed-off-by: Angelo Ruocco <angeloruocco90@gmail.com>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
---
 block/bfq-cgroup.c         | 54 ++++++++++++++++++++++++----------------------
 block/blk-cgroup.c         | 22 ++++++++++++-------
 block/blk-throttle.c       |  8 +++----
 include/linux/blk-cgroup.h | 10 +++++----
 4 files changed, 52 insertions(+), 42 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index a7a1712632b0..038e418fa64f 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -918,17 +918,17 @@ static ssize_t bfq_io_set_weight(struct kernfs_open_file *of,
 }
 
 #ifdef CONFIG_DEBUG_BLK_CGROUP
-static int bfqg_print_stat(struct seq_file *sf, void *v)
+static int bfqg_print_stat(struct seq_file *sf, struct cftype *cft, void *v)
 {
 	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)), blkg_prfill_stat,
-			  &blkcg_policy_bfq, seq_cft(sf)->private, false);
+			  &blkcg_policy_bfq, cft->private, false);
 	return 0;
 }
 
-static int bfqg_print_rwstat(struct seq_file *sf, void *v)
+static int bfqg_print_rwstat(struct seq_file *sf, struct cftype *cft, void *v)
 {
 	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)), blkg_prfill_rwstat,
-			  &blkcg_policy_bfq, seq_cft(sf)->private, true);
+			  &blkcg_policy_bfq, cft->private, true);
 	return 0;
 }
 
@@ -949,19 +949,21 @@ static u64 bfqg_prfill_rwstat_recursive(struct seq_file *sf,
 	return __blkg_prfill_rwstat(sf, pd, &sum);
 }
 
-static int bfqg_print_stat_recursive(struct seq_file *sf, void *v)
+static int bfqg_print_stat_recursive(struct seq_file *sf, struct cftype *cft,
+				     void *v)
 {
 	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
 			  bfqg_prfill_stat_recursive, &blkcg_policy_bfq,
-			  seq_cft(sf)->private, false);
+			  cft->private, false);
 	return 0;
 }
 
-static int bfqg_print_rwstat_recursive(struct seq_file *sf, void *v)
+static int bfqg_print_rwstat_recursive(struct seq_file *sf, struct cftype *cft,
+				       void *v)
 {
 	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
 			  bfqg_prfill_rwstat_recursive, &blkcg_policy_bfq,
-			  seq_cft(sf)->private, true);
+			  cft->private, true);
 	return 0;
 }
 
@@ -1063,18 +1065,18 @@ struct cftype bfq_blkcg_legacy_files[] = {
 	{
 		.name = "bfq.io_service_bytes",
 		.private = (unsigned long)&blkcg_policy_bfq,
-		.seq_show = blkg_print_stat_bytes,
+		.seq_show_cft = blkg_print_stat_bytes,
 	},
 	{
 		.name = "bfq.io_serviced",
 		.private = (unsigned long)&blkcg_policy_bfq,
-		.seq_show = blkg_print_stat_ios,
+		.seq_show_cft = blkg_print_stat_ios,
 	},
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	{
 		.name = "bfq.time",
 		.private = offsetof(struct bfq_group, stats.time),
-		.seq_show = bfqg_print_stat,
+		.seq_show_cft = bfqg_print_stat,
 	},
 	{
 		.name = "bfq.sectors",
@@ -1083,22 +1085,22 @@ struct cftype bfq_blkcg_legacy_files[] = {
 	{
 		.name = "bfq.io_service_time",
 		.private = offsetof(struct bfq_group, stats.service_time),
-		.seq_show = bfqg_print_rwstat,
+		.seq_show_cft = bfqg_print_rwstat,
 	},
 	{
 		.name = "bfq.io_wait_time",
 		.private = offsetof(struct bfq_group, stats.wait_time),
-		.seq_show = bfqg_print_rwstat,
+		.seq_show_cft = bfqg_print_rwstat,
 	},
 	{
 		.name = "bfq.io_merged",
 		.private = offsetof(struct bfq_group, stats.merged),
-		.seq_show = bfqg_print_rwstat,
+		.seq_show_cft = bfqg_print_rwstat,
 	},
 	{
 		.name = "bfq.io_queued",
 		.private = offsetof(struct bfq_group, stats.queued),
-		.seq_show = bfqg_print_rwstat,
+		.seq_show_cft = bfqg_print_rwstat,
 	},
 #endif /* CONFIG_DEBUG_BLK_CGROUP */
 
@@ -1106,18 +1108,18 @@ struct cftype bfq_blkcg_legacy_files[] = {
 	{
 		.name = "bfq.io_service_bytes_recursive",
 		.private = (unsigned long)&blkcg_policy_bfq,
-		.seq_show = blkg_print_stat_bytes_recursive,
+		.seq_show_cft = blkg_print_stat_bytes_recursive,
 	},
 	{
 		.name = "bfq.io_serviced_recursive",
 		.private = (unsigned long)&blkcg_policy_bfq,
-		.seq_show = blkg_print_stat_ios_recursive,
+		.seq_show_cft = blkg_print_stat_ios_recursive,
 	},
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	{
 		.name = "bfq.time_recursive",
 		.private = offsetof(struct bfq_group, stats.time),
-		.seq_show = bfqg_print_stat_recursive,
+		.seq_show_cft = bfqg_print_stat_recursive,
 	},
 	{
 		.name = "bfq.sectors_recursive",
@@ -1126,22 +1128,22 @@ struct cftype bfq_blkcg_legacy_files[] = {
 	{
 		.name = "bfq.io_service_time_recursive",
 		.private = offsetof(struct bfq_group, stats.service_time),
-		.seq_show = bfqg_print_rwstat_recursive,
+		.seq_show_cft = bfqg_print_rwstat_recursive,
 	},
 	{
 		.name = "bfq.io_wait_time_recursive",
 		.private = offsetof(struct bfq_group, stats.wait_time),
-		.seq_show = bfqg_print_rwstat_recursive,
+		.seq_show_cft = bfqg_print_rwstat_recursive,
 	},
 	{
 		.name = "bfq.io_merged_recursive",
 		.private = offsetof(struct bfq_group, stats.merged),
-		.seq_show = bfqg_print_rwstat_recursive,
+		.seq_show_cft = bfqg_print_rwstat_recursive,
 	},
 	{
 		.name = "bfq.io_queued_recursive",
 		.private = offsetof(struct bfq_group, stats.queued),
-		.seq_show = bfqg_print_rwstat_recursive,
+		.seq_show_cft = bfqg_print_rwstat_recursive,
 	},
 	{
 		.name = "bfq.avg_queue_size",
@@ -1150,22 +1152,22 @@ struct cftype bfq_blkcg_legacy_files[] = {
 	{
 		.name = "bfq.group_wait_time",
 		.private = offsetof(struct bfq_group, stats.group_wait_time),
-		.seq_show = bfqg_print_stat,
+		.seq_show_cft = bfqg_print_stat,
 	},
 	{
 		.name = "bfq.idle_time",
 		.private = offsetof(struct bfq_group, stats.idle_time),
-		.seq_show = bfqg_print_stat,
+		.seq_show_cft = bfqg_print_stat,
 	},
 	{
 		.name = "bfq.empty_time",
 		.private = offsetof(struct bfq_group, stats.empty_time),
-		.seq_show = bfqg_print_stat,
+		.seq_show_cft = bfqg_print_stat,
 	},
 	{
 		.name = "bfq.dequeue",
 		.private = offsetof(struct bfq_group, stats.dequeue),
-		.seq_show = bfqg_print_stat,
+		.seq_show_cft = bfqg_print_stat,
 	},
 #endif	/* CONFIG_DEBUG_BLK_CGROUP */
 	{ }	/* terminate */
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 63d226a084cd..772d32bbecae 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -565,15 +565,16 @@ static u64 blkg_prfill_rwstat_field(struct seq_file *sf,
 /**
  * blkg_print_stat_bytes - seq_show callback for blkg->stat_bytes
  * @sf: seq_file to print to
+ * @cft: cftype holding the data
  * @v: unused
  *
  * To be used as cftype->seq_show to print blkg->stat_bytes.
  * cftype->private must be set to the blkcg_policy.
  */
-int blkg_print_stat_bytes(struct seq_file *sf, void *v)
+int blkg_print_stat_bytes(struct seq_file *sf, struct cftype *cft, void *v)
 {
 	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
-			  blkg_prfill_rwstat_field, (void *)seq_cft(sf)->private,
+			  blkg_prfill_rwstat_field, (void *)cft->private,
 			  offsetof(struct blkcg_gq, stat_bytes), true);
 	return 0;
 }
@@ -582,15 +583,16 @@ EXPORT_SYMBOL_GPL(blkg_print_stat_bytes);
 /**
  * blkg_print_stat_bytes - seq_show callback for blkg->stat_ios
  * @sf: seq_file to print to
+ * @cft: cftype holding the data
  * @v: unused
  *
  * To be used as cftype->seq_show to print blkg->stat_ios.  cftype->private
  * must be set to the blkcg_policy.
  */
-int blkg_print_stat_ios(struct seq_file *sf, void *v)
+int blkg_print_stat_ios(struct seq_file *sf, struct cftype *cft, void *v)
 {
 	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
-			  blkg_prfill_rwstat_field, (void *)seq_cft(sf)->private,
+			  blkg_prfill_rwstat_field, (void *)cft->private,
 			  offsetof(struct blkcg_gq, stat_ios), true);
 	return 0;
 }
@@ -608,13 +610,15 @@ static u64 blkg_prfill_rwstat_field_recursive(struct seq_file *sf,
 /**
  * blkg_print_stat_bytes_recursive - recursive version of blkg_print_stat_bytes
  * @sf: seq_file to print to
+ * @cft: cftype holding the data
  * @v: unused
  */
-int blkg_print_stat_bytes_recursive(struct seq_file *sf, void *v)
+int blkg_print_stat_bytes_recursive(struct seq_file *sf, struct cftype *cft,
+				    void *v)
 {
 	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
 			  blkg_prfill_rwstat_field_recursive,
-			  (void *)seq_cft(sf)->private,
+			  (void *)cft->private,
 			  offsetof(struct blkcg_gq, stat_bytes), true);
 	return 0;
 }
@@ -623,13 +627,15 @@ EXPORT_SYMBOL_GPL(blkg_print_stat_bytes_recursive);
 /**
  * blkg_print_stat_ios_recursive - recursive version of blkg_print_stat_ios
  * @sf: seq_file to print to
+ * @cft: cftype holding the data
  * @v: unused
  */
-int blkg_print_stat_ios_recursive(struct seq_file *sf, void *v)
+int blkg_print_stat_ios_recursive(struct seq_file *sf, struct cftype *cft,
+				  void *v)
 {
 	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
 			  blkg_prfill_rwstat_field_recursive,
-			  (void *)seq_cft(sf)->private,
+			  (void *)cft->private,
 			  offsetof(struct blkcg_gq, stat_ios), true);
 	return 0;
 }
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 8f0a104770ee..6bfdaac53b6f 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1493,22 +1493,22 @@ static struct cftype throtl_legacy_files[] = {
 	{
 		.name = "throttle.io_service_bytes",
 		.private = (unsigned long)&blkcg_policy_throtl,
-		.seq_show = blkg_print_stat_bytes,
+		.seq_show_cft = blkg_print_stat_bytes,
 	},
 	{
 		.name = "throttle.io_service_bytes_recursive",
 		.private = (unsigned long)&blkcg_policy_throtl,
-		.seq_show = blkg_print_stat_bytes_recursive,
+		.seq_show_cft = blkg_print_stat_bytes_recursive,
 	},
 	{
 		.name = "throttle.io_serviced",
 		.private = (unsigned long)&blkcg_policy_throtl,
-		.seq_show = blkg_print_stat_ios,
+		.seq_show_cft = blkg_print_stat_ios,
 	},
 	{
 		.name = "throttle.io_serviced_recursive",
 		.private = (unsigned long)&blkcg_policy_throtl,
-		.seq_show = blkg_print_stat_ios_recursive,
+		.seq_show_cft = blkg_print_stat_ios_recursive,
 	},
 	{ }	/* terminate */
 };
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index a9e2e2037129..770b59e0d35f 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -207,10 +207,12 @@ u64 __blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
 u64 blkg_prfill_stat(struct seq_file *sf, struct blkg_policy_data *pd, int off);
 u64 blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
 		       int off);
-int blkg_print_stat_bytes(struct seq_file *sf, void *v);
-int blkg_print_stat_ios(struct seq_file *sf, void *v);
-int blkg_print_stat_bytes_recursive(struct seq_file *sf, void *v);
-int blkg_print_stat_ios_recursive(struct seq_file *sf, void *v);
+int blkg_print_stat_bytes(struct seq_file *sf, struct cftype *cft, void *v);
+int blkg_print_stat_ios(struct seq_file *sf, struct cftype *cft, void *v);
+int blkg_print_stat_bytes_recursive(struct seq_file *sf, struct cftype *cft,
+				    void *v);
+int blkg_print_stat_ios_recursive(struct seq_file *sf, struct cftype *cft,
+				  void *v);
 
 u64 blkg_stat_recursive_sum(struct blkcg_gq *blkg,
 			    struct blkcg_policy *pol, int off);
-- 
2.16.1

