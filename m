From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] blk-cgroup: remove now unused blkg_print_stat_{bytes|ios}_recursive()
Date: Thu,  7 Nov 2019 11:18:02 -0800
Message-ID: <20191107191804.3735303-5-tj@kernel.org>
References: <20191107191804.3735303-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2Y+pHXtP5O8Okj4I0mI2qlT4EC3+7maC5emZuz1NNRA=;
        b=dSIVX8HNakf4UCSDoL9GG1/oa+JSiZjL1/w344VGzrazd/6fAm080EaF9aM6QD3MFA
         vq5u1kxJxiBZLyIF2H2xhW+la8wFC8tcKKkGNbQez6kyomQU1uijmoEMK9HT1AqS+CV3
         vIYYkZKpcIM/GAewRf3OCKq81YJZ1gw7Dw2T86U5a3lNuiy0/4ScCO2uJeX+RsV7PgAq
         UP1MEMD/D78B7sO0L+tyC6BPtLKx1QOf+C4p7t7ppanFT0Hp1KTAWvSpEOx9rjllz0T9
         bsRnu/XNTsEeQckp1QUWnXntos/XMOMa9VPkmJTOUiue0zs7Fx6LmS7jqs8dQQuFi1y3
         dFKA==
In-Reply-To: <20191107191804.3735303-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

These don't have users anymore.  Remove them.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c         | 83 --------------------------------------
 include/linux/blk-cgroup.h |  5 ---
 2 files changed, 88 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 1eb8895be4c6..e7e93377e320 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -615,89 +615,6 @@ u64 blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
 }
 EXPORT_SYMBOL_GPL(blkg_prfill_rwstat);
 
-static u64 blkg_prfill_rwstat_field(struct seq_file *sf,
-				    struct blkg_policy_data *pd, int off)
-{
-	struct blkg_rwstat_sample rwstat = { };
-
-	blkg_rwstat_read((void *)pd->blkg + off, &rwstat);
-	return __blkg_prfill_rwstat(sf, pd, &rwstat);
-}
-
-/**
- * blkg_print_stat_bytes - seq_show callback for blkg->stat_bytes
- * @sf: seq_file to print to
- * @v: unused
- *
- * To be used as cftype->seq_show to print blkg->stat_bytes.
- * cftype->private must be set to the blkcg_policy.
- */
-int blkg_print_stat_bytes(struct seq_file *sf, void *v)
-{
-	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
-			  blkg_prfill_rwstat_field, (void *)seq_cft(sf)->private,
-			  offsetof(struct blkcg_gq, stat_bytes), true);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(blkg_print_stat_bytes);
-
-/**
- * blkg_print_stat_bytes - seq_show callback for blkg->stat_ios
- * @sf: seq_file to print to
- * @v: unused
- *
- * To be used as cftype->seq_show to print blkg->stat_ios.  cftype->private
- * must be set to the blkcg_policy.
- */
-int blkg_print_stat_ios(struct seq_file *sf, void *v)
-{
-	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
-			  blkg_prfill_rwstat_field, (void *)seq_cft(sf)->private,
-			  offsetof(struct blkcg_gq, stat_ios), true);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(blkg_print_stat_ios);
-
-static u64 blkg_prfill_rwstat_field_recursive(struct seq_file *sf,
-					      struct blkg_policy_data *pd,
-					      int off)
-{
-	struct blkg_rwstat_sample rwstat;
-
-	blkg_rwstat_recursive_sum(pd->blkg, NULL, off, &rwstat);
-	return __blkg_prfill_rwstat(sf, pd, &rwstat);
-}
-
-/**
- * blkg_print_stat_bytes_recursive - recursive version of blkg_print_stat_bytes
- * @sf: seq_file to print to
- * @v: unused
- */
-int blkg_print_stat_bytes_recursive(struct seq_file *sf, void *v)
-{
-	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
-			  blkg_prfill_rwstat_field_recursive,
-			  (void *)seq_cft(sf)->private,
-			  offsetof(struct blkcg_gq, stat_bytes), true);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(blkg_print_stat_bytes_recursive);
-
-/**
- * blkg_print_stat_ios_recursive - recursive version of blkg_print_stat_ios
- * @sf: seq_file to print to
- * @v: unused
- */
-int blkg_print_stat_ios_recursive(struct seq_file *sf, void *v)
-{
-	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
-			  blkg_prfill_rwstat_field_recursive,
-			  (void *)seq_cft(sf)->private,
-			  offsetof(struct blkcg_gq, stat_ios), true);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(blkg_print_stat_ios_recursive);
-
 /**
  * blkg_rwstat_recursive_sum - collect hierarchical blkg_rwstat
  * @blkg: blkg of interest
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index bed9e43f9426..914ce55fa8c2 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -220,11 +220,6 @@ u64 __blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
 			 const struct blkg_rwstat_sample *rwstat);
 u64 blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
 		       int off);
-int blkg_print_stat_bytes(struct seq_file *sf, void *v);
-int blkg_print_stat_ios(struct seq_file *sf, void *v);
-int blkg_print_stat_bytes_recursive(struct seq_file *sf, void *v);
-int blkg_print_stat_ios_recursive(struct seq_file *sf, void *v);
-
 void blkg_rwstat_recursive_sum(struct blkcg_gq *blkg, struct blkcg_policy *pol,
 		int off, struct blkg_rwstat_sample *sum);
 
-- 
2.17.1

