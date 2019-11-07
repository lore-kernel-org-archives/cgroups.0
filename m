From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 0.5/5] bfq-iosched: relocate bfqg_*rwstat*() helpers
Date: Thu, 7 Nov 2019 11:04:59 -0800
Message-ID: <20191107190459.GA3622521@devbig004.ftw2.facebook.com>
References: <20191106215838.3973497-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=D2aZYGhhhD0fueEZXuZZtBxsPvMYXcl+9GQ42VL43KI=;
        b=QMrL5nCAR853//4IbtMGC+V9cyv4Cci7a5ZLezHlo8P+sBwSZ7sdElMR64J11gVzVy
         +jwOVFRlQ856q0LydViBktS8UwVaYvjFOE8Hshwk2Kg7vFAvvi4cycqMZn6M4UAWCAOk
         PeT1uWVTEy/ffwMqLCnEsdpXLFwX2HCynQx+JcUjU+LUgFlomDNbysXZjfEQjPhC59zw
         O2XpzH5to18sUHc//d8yst74RbREs30kLGGRa/MLmBzkn8XRbti2wLANRh0SLmW0ZnAY
         IQNiOZe+U5oyogrSXJDnBlKz0bgOZnAV3g17MmtlrW7o0HwvJmZA2ABKMPy4EkCZv3fy
         jLpA==
Content-Disposition: inline
In-Reply-To: <20191106215838.3973497-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, kernel-team@fb.com

From a7b9100d72d75a1472bed130b6edd271b734776f Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 7 Nov 2019 11:01:19 -0800

Collect them right under #ifdef CONFIG_BFQ_CGROUP_DEBUG.  The next
patch will use them from !DEBUG path and this makes it easy to move
them out of the ifdef block.

This is pure code reorganization.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Jens, this is an extra patch to help fixing the build bug when
!CONFIG_BFQ_CGROUP_DEBUG.  The git tree has been updated accordingly.
Please let me know if you want the whole series reposted.

Thanks.

 block/bfq-cgroup.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 86a607cf19a1..d4755d4ad009 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -1058,17 +1058,34 @@ static ssize_t bfq_io_set_weight(struct kernfs_open_file *of,
 }
 
 #ifdef CONFIG_BFQ_CGROUP_DEBUG
-static int bfqg_print_stat(struct seq_file *sf, void *v)
+static int bfqg_print_rwstat(struct seq_file *sf, void *v)
 {
-	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)), blkg_prfill_stat,
-			  &blkcg_policy_bfq, seq_cft(sf)->private, false);
+	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)), blkg_prfill_rwstat,
+			  &blkcg_policy_bfq, seq_cft(sf)->private, true);
 	return 0;
 }
 
-static int bfqg_print_rwstat(struct seq_file *sf, void *v)
+static u64 bfqg_prfill_rwstat_recursive(struct seq_file *sf,
+					struct blkg_policy_data *pd, int off)
 {
-	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)), blkg_prfill_rwstat,
-			  &blkcg_policy_bfq, seq_cft(sf)->private, true);
+	struct blkg_rwstat_sample sum;
+
+	blkg_rwstat_recursive_sum(pd_to_blkg(pd), &blkcg_policy_bfq, off, &sum);
+	return __blkg_prfill_rwstat(sf, pd, &sum);
+}
+
+static int bfqg_print_rwstat_recursive(struct seq_file *sf, void *v)
+{
+	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
+			  bfqg_prfill_rwstat_recursive, &blkcg_policy_bfq,
+			  seq_cft(sf)->private, true);
+	return 0;
+}
+
+static int bfqg_print_stat(struct seq_file *sf, void *v)
+{
+	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)), blkg_prfill_stat,
+			  &blkcg_policy_bfq, seq_cft(sf)->private, false);
 	return 0;
 }
 
@@ -1097,15 +1114,6 @@ static u64 bfqg_prfill_stat_recursive(struct seq_file *sf,
 	return __blkg_prfill_u64(sf, pd, sum);
 }
 
-static u64 bfqg_prfill_rwstat_recursive(struct seq_file *sf,
-					struct blkg_policy_data *pd, int off)
-{
-	struct blkg_rwstat_sample sum;
-
-	blkg_rwstat_recursive_sum(pd_to_blkg(pd), &blkcg_policy_bfq, off, &sum);
-	return __blkg_prfill_rwstat(sf, pd, &sum);
-}
-
 static int bfqg_print_stat_recursive(struct seq_file *sf, void *v)
 {
 	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
@@ -1114,14 +1122,6 @@ static int bfqg_print_stat_recursive(struct seq_file *sf, void *v)
 	return 0;
 }
 
-static int bfqg_print_rwstat_recursive(struct seq_file *sf, void *v)
-{
-	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
-			  bfqg_prfill_rwstat_recursive, &blkcg_policy_bfq,
-			  seq_cft(sf)->private, true);
-	return 0;
-}
-
 static u64 bfqg_prfill_sectors(struct seq_file *sf, struct blkg_policy_data *pd,
 			       int off)
 {
-- 
2.17.1
