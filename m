Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F8730DD00;
	Sun, 23 Aug 2026 15:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787498987; cv=none; b=Ava6xyJ22yXJPLYpfmz4LhQuHJ8/C41eq87e3udHMvCJ6mXvQUKJfr20+McH9hd3zs9mrUfyxhWxCfEGT1GnJWQrCzrmqguarF+ikH0GnxfxWG+Oe/lKrD0XBWicassUqTOTvEvxSnywJqsTsLgVoX+a+8YhtzkQ2oy0JxE1KHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787498987; c=relaxed/simple;
	bh=vTimXbnqV249kP52RAAyLMwrcCBOog1Sw5F4yoZMlO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCXI/NHYSt3Hf3KzELJVGqVU42hZf8FlkaZ2xboMPLaTDwzZOizsDA/0e3TnqYY6Uv+Fa4eU+CkkxEouAgpladHTp2Adeanv1PsLXVqppl88OITm2t1yidfUJoE4r82iX6h6wC8jhcFZ/GprBet7qgqCSjIgxyl1XWciDXZLxdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DdqbPaJp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DdqbPaJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3011F00A3A;
	Sun, 23 Aug 2026 15:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787498985;
	bh=Q6DK2HsdZTqxAvuZnTy1Sfa9gNOhsZSg4TnUdkLSdB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DdqbPaJpNnuyG/FbAkt5F9fqAI8cV/oz8Lbya61BXXLyTtqtEwf/BsKBEVZ6DTkFM
	 fJxva+MyJL80OoBnZYGvCIGEnjl2GVbgzpWB2jeDTrChfijVEvp3+pWco84FMitR8D
	 +2g4/bYdqamtHh2PPL9wBHz+gv+mmFlo3sFLPSvaONyIXjABO5ch5uvAQ2U9sIh1nq
	 qo+73MmekdFUp/CuA7pVIM/ZNZe0jFQ761T4fSaJCXlcS341CYNRt00FafNSu9m80w
	 G/TLcACLbNDs5Y4StaX/BInucW8ScltR7IfWdt3YZG6v3nTksi6IjhetGoZnvUaOg2
	 6wR891i/XmaRg==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Tao Cui <cui.tao@linux.dev>,
	Hannes Reinecke <hare@suse.de>,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 1/6] blk-cgroup: call pd_free_fn() outside spinlocks
Date: Sun, 23 Aug 2026 23:29:20 +0800
Message-ID: <20260823152926.1043863-2-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260823152926.1043863-1-yukuai@kernel.org>
References: <20260823152926.1043863-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

blkcg_policy_teardown_pds() calls pd_free_fn() while holding both
q->queue_lock and blkcg->lock.  This is not safe for policies such as
iocost, whose ioc_pd_free() calls hrtimer_cancel().  On PREEMPT_RT the
hrtimer cancellation slow path can sleep while waiting for a soft hrtimer
callback to finish.

Keep the offline callback and policy data detachment protected by the
existing spinlocks, but tear down one policy data object at a time and drop
the locks before invoking pd_free_fn().  q->blkcg_mutex serializes the
operation against blkg_free_workfn(), so the associated blkg remains valid
while the callback runs.

Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 1bd91223367c..5b51be2fefc1 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1548,33 +1548,51 @@ struct cgroup_subsys io_cgrp_subsys = {
 	.depends_on = 1 << memory_cgrp_id,
 #endif
 };
 EXPORT_SYMBOL_GPL(io_cgrp_subsys);
 
-/*
- * Tear down per-blkg policy data for @pol on @q.
- */
-static void blkcg_policy_teardown_pds(struct request_queue *q,
-				      const struct blkcg_policy *pol)
+static struct blkg_policy_data *
+blkcg_policy_detach_pd(struct request_queue *q,
+		       const struct blkcg_policy *pol)
 {
+	struct blkg_policy_data *pd = NULL;
 	struct blkcg_gq *blkg;
 
+	lockdep_assert_held(&q->blkcg_mutex);
+
+	spin_lock_irq(&q->queue_lock);
 	list_for_each_entry(blkg, &q->blkg_list, q_node) {
 		struct blkcg *blkcg = blkg->blkcg;
-		struct blkg_policy_data *pd;
 
 		spin_lock(&blkcg->lock);
 		pd = blkg->pd[pol->plid];
 		if (pd) {
 			if (pd->online && pol->pd_offline_fn)
 				pol->pd_offline_fn(pd);
 			pd->online = false;
-			pol->pd_free_fn(pd);
 			WRITE_ONCE(blkg->pd[pol->plid], NULL);
 		}
 		spin_unlock(&blkcg->lock);
+
+		if (pd)
+			break;
 	}
+	spin_unlock_irq(&q->queue_lock);
+
+	return pd;
+}
+
+/*
+ * Tear down per-blkg policy data for @pol on @q.
+ */
+static void blkcg_policy_teardown_pds(struct request_queue *q,
+				      const struct blkcg_policy *pol)
+{
+	struct blkg_policy_data *pd;
+
+	while ((pd = blkcg_policy_detach_pd(q, pol)))
+		pol->pd_free_fn(pd);
 }
 
 /**
  * blkcg_activate_policy - activate a blkcg policy on a gendisk
  * @disk: gendisk of interest
@@ -1687,13 +1705,11 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 		pol->pd_free_fn(pd_prealloc);
 	return ret;
 
 enomem:
 	/* alloc failed, take down everything */
-	spin_lock_irq(&q->queue_lock);
 	blkcg_policy_teardown_pds(q, pol);
-	spin_unlock_irq(&q->queue_lock);
 	ret = -ENOMEM;
 	goto out;
 }
 EXPORT_SYMBOL_GPL(blkcg_activate_policy);
 
@@ -1719,12 +1735,13 @@ void blkcg_deactivate_policy(struct gendisk *disk,
 
 	mutex_lock(&q->blkcg_mutex);
 	spin_lock_irq(&q->queue_lock);
 
 	__clear_bit(pol->plid, q->blkcg_pols);
-	blkcg_policy_teardown_pds(q, pol);
 	spin_unlock_irq(&q->queue_lock);
+
+	blkcg_policy_teardown_pds(q, pol);
 	mutex_unlock(&q->blkcg_mutex);
 
 	if (queue_is_mq(q))
 		blk_mq_unfreeze_queue(q, memflags);
 }
-- 
2.51.0

