Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2DF381E94;
	Sun,  2 Aug 2026 11:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785669958; cv=none; b=OBOSxnmlArgnPP0yHu+8nmaVTQqg0G4yrzXSGn1ldZxFBfgu1F0m6DCtu8G2DC/nEPwtuEOr0cRjTb3uay6So7nwY0q2sC6JYKv6FBsM/ywMmWIE4PqPE0sjZhITbHdGWDqXEIQw1LeCW8kvl4YrXkv+VeYo9+sV+00MxkF3NBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785669958; c=relaxed/simple;
	bh=jel9Va4aEJ32X+R8Wb9KTKWlQY6onZovT4E5m9mtEe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tttRc+XObJqSACJ0Udd+n2lbTnx4zgI5wuQNc+FzcObFTy86UdR25Ba+qBL2QckwLgMdpDLjp0I+PxvV7BkHHSVXaOsAUU3BHu6WpBGSh78ItBQA35p2JODXh2pX+TNZAwgrcNLzxL4lz7xX5y6PsUMBTXhp/sJTUDZvvWVoWTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MHl2FXRa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MHl2FXRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646481F00A3A;
	Sun,  2 Aug 2026 11:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785669957;
	bh=whxTPtkSCFbK3RhJqyiIvmWdhRx7SscEg9SF0mVf0Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MHl2FXRaO35rSiqFTTP0HdmBDkJ2fUESZLuh+9W1GxqaoOiejE+7b+ak+ZVnhfhGi
	 5oDd5BAvH3eLfumLJqatVLBUcZPsTQ2OQ2UjAO67QvLMySDfF1dcpyoW14BbBSQWMV
	 umIMeIWMlQOUNMaaFbVZeXkYPOyudNQfZ/GXRtxkaLowsUNLAue2SH/3wbV67vcli0
	 tqA+cr64cVJy6haH1UPHGquJe4HW+yP2KkkpfLgMue7xX2FWoIZpfcg8x+kzDBk9o5
	 WyCXHj7pAiPnp2u0ibq665kPhUZe4j1v7Tik85O8fSIu3ShDhBRrMEFiGM9fo5noUi
	 bn8LqSBqHbVmQ==
From: Yu Kuai <yukuai@kernel.org>
To: tj@kernel.org,
	axboe@kernel.dk
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhengqixing@huawei.com,
	hch@lst.de,
	yizhou.tang@shopee.com,
	yukuai@fygo.io,
	nilay@linux.ibm.com
Subject: [PATCH v4 4/4] blk-cgroup: factor policy pd teardown loop into helper
Date: Sun,  2 Aug 2026 19:25:20 +0800
Message-ID: <20260802112525.3933753-5-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260802112525.3933753-1-yukuai@kernel.org>
References: <20260802112525.3933753-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zheng Qixing <zhengqixing@huawei.com>

Move the teardown sequence which offlines and frees per-policy
blkg_policy_data (pd) into a helper for readability.

No functional change intended.

Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Tang Yizhou <yizhou.tang@shopee.com>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 57 ++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 30 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d1895bc60fcf..354637f3b158 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1529,6 +1529,31 @@ struct cgroup_subsys io_cgrp_subsys = {
 };
 EXPORT_SYMBOL_GPL(io_cgrp_subsys);
 
+/*
+ * Tear down per-blkg policy data for @pol on @q.
+ */
+static void blkcg_policy_teardown_pds(struct request_queue *q,
+				      const struct blkcg_policy *pol)
+{
+	struct blkcg_gq *blkg;
+
+	list_for_each_entry(blkg, &q->blkg_list, q_node) {
+		struct blkcg *blkcg = blkg->blkcg;
+		struct blkg_policy_data *pd;
+
+		spin_lock(&blkcg->lock);
+		pd = blkg->pd[pol->plid];
+		if (pd) {
+			if (pd->online && pol->pd_offline_fn)
+				pol->pd_offline_fn(pd);
+			pd->online = false;
+			pol->pd_free_fn(pd);
+			WRITE_ONCE(blkg->pd[pol->plid], NULL);
+		}
+		spin_unlock(&blkcg->lock);
+	}
+}
+
 /**
  * blkcg_activate_policy - activate a blkcg policy on a gendisk
  * @disk: gendisk of interest
@@ -1644,21 +1669,7 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 enomem:
 	/* alloc failed, take down everything */
 	spin_lock_irq(&q->queue_lock);
-	list_for_each_entry(blkg, &q->blkg_list, q_node) {
-		struct blkcg *blkcg = blkg->blkcg;
-		struct blkg_policy_data *pd;
-
-		spin_lock(&blkcg->lock);
-		pd = blkg->pd[pol->plid];
-		if (pd) {
-			if (pd->online && pol->pd_offline_fn)
-				pol->pd_offline_fn(pd);
-			pd->online = false;
-			pol->pd_free_fn(pd);
-			WRITE_ONCE(blkg->pd[pol->plid], NULL);
-		}
-		spin_unlock(&blkcg->lock);
-	}
+	blkcg_policy_teardown_pds(q, pol);
 	spin_unlock_irq(&q->queue_lock);
 	ret = -ENOMEM;
 	goto out;
@@ -1677,7 +1688,6 @@ void blkcg_deactivate_policy(struct gendisk *disk,
 			     const struct blkcg_policy *pol)
 {
 	struct request_queue *q = disk->queue;
-	struct blkcg_gq *blkg;
 	unsigned int memflags;
 
 	if (!blkcg_policy_enabled(q, pol))
@@ -1690,20 +1700,7 @@ void blkcg_deactivate_policy(struct gendisk *disk,
 	spin_lock_irq(&q->queue_lock);
 
 	__clear_bit(pol->plid, q->blkcg_pols);
-
-	list_for_each_entry(blkg, &q->blkg_list, q_node) {
-		struct blkcg *blkcg = blkg->blkcg;
-
-		spin_lock(&blkcg->lock);
-		if (blkg->pd[pol->plid]) {
-			if (blkg->pd[pol->plid]->online && pol->pd_offline_fn)
-				pol->pd_offline_fn(blkg->pd[pol->plid]);
-			pol->pd_free_fn(blkg->pd[pol->plid]);
-			blkg->pd[pol->plid] = NULL;
-		}
-		spin_unlock(&blkcg->lock);
-	}
-
+	blkcg_policy_teardown_pds(q, pol);
 	spin_unlock_irq(&q->queue_lock);
 	mutex_unlock(&q->blkcg_mutex);
 
-- 
2.51.0

