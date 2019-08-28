From: Fam Zheng <zhengfeiran@bytedance.com>
Subject: [PATCH v3 2/3] bfq: Extract bfq_group_set_weight from bfq_io_set_weight_legacy
Date: Wed, 28 Aug 2019 11:54:52 +0800
Message-ID: <20190828035453.18129-3-zhengfeiran@bytedance.com>
References: <20190828035453.18129-1-zhengfeiran@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Spd8tWh4JGn3fBDEW8q9V28IkZ0ZVpCm4ISnu3nMaQM=;
        b=aQ2B4fFB6wrF6qbAgHFZWLIJBhdhVTA/hv4KAiq7MVYvRbBqWjbP6CrvRB/d4Ulqx1
         tRKuf+FbiNADlKz00WPw49rPF4mULQpIOTB+kw/E2Y6UwD9re9KqwiCxrBa3LvPOQZxB
         CRFelNFwgRThHt/CP9knGc0RrVtZSieKNJrnXkTRCah08mW/Q9Najk8yXZ9lyN05ivTL
         3SXFC3gQHIkTVYriMvQtHHPhHv5EmY5AmL0qwbYs99S9wjJAi8i+NqkhVRSzcgKlLbhX
         lhKWX4P7PqsksULwa+wWvhUYYh/yIn+RxNYVaBrtxNgLQki5OHp17zyR+AGns9sF50HT
         auHA==
In-Reply-To: <20190828035453.18129-1-zhengfeiran@bytedance.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, paolo.valente@linaro.org, fam@euphon.net, duanxiongchun@bytedance.com, cgroups@vger.kernel.org, zhangjiachen.jc@bytedance.com, tj@kernel.org, linux-block@vger.kernel.org

This function will be useful when we update weight from the soon-coming
per-device interface.

Signed-off-by: Fam Zheng <zhengfeiran@bytedance.com>
Reviewed-by: Paolo Valente <paolo.valente@linaro.org>
---
 block/bfq-cgroup.c | 60 ++++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 28 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 0f6cd688924f..28e5a9241237 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -918,6 +918,36 @@ static int bfq_io_show_weight(struct seq_file *sf, void *v)
 	return 0;
 }
 
+static void bfq_group_set_weight(struct bfq_group *bfqg, u64 weight)
+{
+	/*
+	 * Setting the prio_changed flag of the entity
+	 * to 1 with new_weight == weight would re-set
+	 * the value of the weight to its ioprio mapping.
+	 * Set the flag only if necessary.
+	 */
+	if ((unsigned short)weight != bfqg->entity.new_weight) {
+		bfqg->entity.new_weight = (unsigned short)weight;
+		/*
+		 * Make sure that the above new value has been
+		 * stored in bfqg->entity.new_weight before
+		 * setting the prio_changed flag. In fact,
+		 * this flag may be read asynchronously (in
+		 * critical sections protected by a different
+		 * lock than that held here), and finding this
+		 * flag set may cause the execution of the code
+		 * for updating parameters whose value may
+		 * depend also on bfqg->entity.new_weight (in
+		 * __bfq_entity_update_weight_prio).
+		 * This barrier makes sure that the new value
+		 * of bfqg->entity.new_weight is correctly
+		 * seen in that code.
+		 */
+		smp_wmb();
+		bfqg->entity.prio_changed = 1;
+	}
+}
+
 static int bfq_io_set_weight_legacy(struct cgroup_subsys_state *css,
 				    struct cftype *cftype,
 				    u64 val)
@@ -936,34 +966,8 @@ static int bfq_io_set_weight_legacy(struct cgroup_subsys_state *css,
 	hlist_for_each_entry(blkg, &blkcg->blkg_list, blkcg_node) {
 		struct bfq_group *bfqg = blkg_to_bfqg(blkg);
 
-		if (!bfqg)
-			continue;
-		/*
-		 * Setting the prio_changed flag of the entity
-		 * to 1 with new_weight == weight would re-set
-		 * the value of the weight to its ioprio mapping.
-		 * Set the flag only if necessary.
-		 */
-		if ((unsigned short)val != bfqg->entity.new_weight) {
-			bfqg->entity.new_weight = (unsigned short)val;
-			/*
-			 * Make sure that the above new value has been
-			 * stored in bfqg->entity.new_weight before
-			 * setting the prio_changed flag. In fact,
-			 * this flag may be read asynchronously (in
-			 * critical sections protected by a different
-			 * lock than that held here), and finding this
-			 * flag set may cause the execution of the code
-			 * for updating parameters whose value may
-			 * depend also on bfqg->entity.new_weight (in
-			 * __bfq_entity_update_weight_prio).
-			 * This barrier makes sure that the new value
-			 * of bfqg->entity.new_weight is correctly
-			 * seen in that code.
-			 */
-			smp_wmb();
-			bfqg->entity.prio_changed = 1;
-		}
+		if (bfqg)
+			bfq_group_set_weight(bfqg, val);
 	}
 	spin_unlock_irq(&blkcg->lock);
 
-- 
2.22.1

