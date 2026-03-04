Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A6D36D9EB;
	Wed,  4 Mar 2026 07:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772609899; cv=none; b=Eq7n7op5wjzObuy3soeLEAKcZl/j348GkWVrhuSaVuF+WDnzt/aXGTH18DhoSC/OAKls01eaaQqvZSHatPeqLnKHq61G4ik5ew1vTp5QmLedhT+bk1nJNVGKuYeCSgopWuYRPdCPvamQmTPQA+bZ5mJQBeOcilDvtSY86mOpVw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772609899; c=relaxed/simple;
	bh=1NXvgTVosEtMAJVxyd/ZLi5HROrezuItv5ZNVXIfWjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdZ1SGbzsk2IwWHevUetQcBIwkW4rpuKUAz3Lg3k/zU6wernlR2zhzoC9bDQVjGxKdRydr1zCNxeyNCj6+sd2PWAcRQ/TsfTkzZbBmi9SR4T4EgCtsyvMrMpg1tULhp2OeE2/4Me5l15BO3+VKEZbwKnUsvR9EbYxi89NRCG49k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A757FC19423;
	Wed,  4 Mar 2026 07:38:16 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zheng Qixing <zhengqixing@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>
Subject: [PATCH v3 2/7] bfq: protect q->blkg_list iteration in bfq_end_wr_async() with blkcg_mutex
Date: Wed,  4 Mar 2026 15:38:03 +0800
Message-ID: <20260304073809.3438679-3-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260304073809.3438679-1-yukuai@fnnas.com>
References: <20260304073809.3438679-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bfq_end_wr_async() iterates q->blkg_list while only holding bfqd->lock,
but not blkcg_mutex. This can race with blkg_free_workfn() that removes
blkgs from the list while holding blkcg_mutex.

Add blkcg_mutex protection in bfq_end_wr() before taking bfqd->lock to
ensure proper synchronization when iterating q->blkg_list.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 block/bfq-cgroup.c  | 3 ++-
 block/bfq-iosched.c | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 6a75fe1c7a5c..839d266a6aa6 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -940,7 +940,8 @@ void bfq_end_wr_async(struct bfq_data *bfqd)
 	list_for_each_entry(blkg, &bfqd->queue->blkg_list, q_node) {
 		struct bfq_group *bfqg = blkg_to_bfqg(blkg);
 
-		bfq_end_wr_async_queues(bfqd, bfqg);
+		if (bfqg)
+			bfq_end_wr_async_queues(bfqd, bfqg);
 	}
 	bfq_end_wr_async_queues(bfqd, bfqd->root_group);
 }
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index b180ce583951..14ca67a616b7 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2645,6 +2645,9 @@ static void bfq_end_wr(struct bfq_data *bfqd)
 	struct bfq_queue *bfqq;
 	int i;
 
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+	mutex_lock(&bfqd->queue->blkcg_mutex);
+#endif
 	spin_lock_irq(&bfqd->lock);
 
 	for (i = 0; i < bfqd->num_actuators; i++) {
@@ -2656,6 +2659,9 @@ static void bfq_end_wr(struct bfq_data *bfqd)
 	bfq_end_wr_async(bfqd);
 
 	spin_unlock_irq(&bfqd->lock);
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+	mutex_unlock(&bfqd->queue->blkcg_mutex);
+#endif
 }
 
 static sector_t bfq_io_struct_pos(void *io_struct, bool request)
-- 
2.51.0

