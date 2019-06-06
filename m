From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] blk-cgroup: factor out a helper to read rwstat counter
Date: Thu,  6 Jun 2019 12:26:19 +0200
Message-ID: <20190606102624.3847-2-hch@lst.de>
References: <20190606102624.3847-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Uku4X1NuSYOSYwe5/8VxCfVwayC53Kz39W46rZr6FMs=; b=jyjUMcjKtlmDS6MuQDI0Cem2ZQ
        J15PJwpYIyAkxKU3IjxHvJV9MbWP3qg6yrYgpX/VWd+Iqj0NwcTpo4VEnp2sorXMzPXnDav8cB9fN
        OqwfX9nV3xscLwreTSp45yY1fAp4KxgRHPrM0aLPZghvg+Fmb8USmritRYrjEvCpkkRYh24WM/xoT
        aPCpUM+Hj8nUdzU4SrsCEus+XH6Did6p3toEVhpCvdBRMNcAKqXBd3O9aAMGpB2XpOQ7SBelgDlZG
        8HTMzToYYb0F3qJvyPp9Yx0+KNj7LlpjwiFoofbzvDEqWcLmU5nBaQSv/05h3hAmECT86ViNsoOjs
In-Reply-To: <20190606102624.3847-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Paolo Valente <paolo.valente@linaro.org>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Trying to break up the crazy statements to something readable.
Also switch to an unsigned counter as it can't ever turn negative.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-cgroup.c         | 5 ++---
 include/linux/blk-cgroup.h | 7 +++++++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index b97b479e4f64..6f79ace02be4 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -750,7 +750,7 @@ struct blkg_rwstat blkg_rwstat_recursive_sum(struct blkcg_gq *blkg,
 	struct blkcg_gq *pos_blkg;
 	struct cgroup_subsys_state *pos_css;
 	struct blkg_rwstat sum = { };
-	int i;
+	unsigned int i;
 
 	lockdep_assert_held(&blkg->q->queue_lock);
 
@@ -767,8 +767,7 @@ struct blkg_rwstat blkg_rwstat_recursive_sum(struct blkcg_gq *blkg,
 			rwstat = (void *)pos_blkg + off;
 
 		for (i = 0; i < BLKG_RWSTAT_NR; i++)
-			atomic64_add(atomic64_read(&rwstat->aux_cnt[i]) +
-				percpu_counter_sum_positive(&rwstat->cpu_cnt[i]),
+			atomic64_add(blkg_rwstat_read_counter(rwstat, i),
 				&sum.aux_cnt[i]);
 	}
 	rcu_read_unlock();
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 76c61318fda5..06236f56a840 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -198,6 +198,13 @@ int blkcg_activate_policy(struct request_queue *q,
 void blkcg_deactivate_policy(struct request_queue *q,
 			     const struct blkcg_policy *pol);
 
+static inline u64 blkg_rwstat_read_counter(struct blkg_rwstat *rwstat,
+		unsigned int idx)
+{
+	return atomic64_read(&rwstat->aux_cnt[idx]) +
+		percpu_counter_sum_positive(&rwstat->cpu_cnt[idx]);
+}
+
 const char *blkg_dev_name(struct blkcg_gq *blkg);
 void blkcg_print_blkgs(struct seq_file *sf, struct blkcg *blkcg,
 		       u64 (*prfill)(struct seq_file *,
-- 
2.20.1

