Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96615314D35;
	Wed,  3 Jun 2026 13:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780493281; cv=none; b=OgrUgtejjJ++MiRmnNIAa7avareA/INDEuRfqucRzGQDI23zLbr0/JNHUE3dKf7QY155iZfV7JwWCo5Oy2hD38+A+m5ig91IEhytexVWvqkgTJe+zrClBauXjM4abc5hCi0Uh2JcYyDQrnQxEdcM+TM07qWFTaiYeFUDZWOsUeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780493281; c=relaxed/simple;
	bh=+bW8TuG9nbXBGA9Q8CVmvFkxaNdWjWVVyjvtj/3M5oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CL5XtN4qNrmp+MlV7ph4e9wseR3Hmf/zNTHocziKds9YaKse416k5o4goS5YQqM8j30inP5iicz7NwuE6d+KIrDy/HYxFXJUWilwSHM/DSg3/KC+VtEoCBHGIhEU0dQyECmO8VrvttlyFAf2iN0VKeUL4NxVG0XnyhSDJ33repI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AABF01F00899;
	Wed,  3 Jun 2026 13:27:57 +0000 (UTC)
From: Yu Kuai <yukuai@fygo.io>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] bfq: protect q->blkg_list iteration in bfq_end_wr_async() with blkcg_mutex
Date: Wed,  3 Jun 2026 21:27:42 +0800
Message-ID: <89f9448c5d703e6123e1be6c8e0550c803e9c057.1780492756.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1780492756.git.yukuai@fygo.io>
References: <cover.1780492756.git.yukuai@fygo.io>
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

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/bfq-cgroup.c  | 3 ++-
 block/bfq-iosched.c | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 37ab70930c8d..f765e767d36a 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -939,11 +939,12 @@ void bfq_end_wr_async(struct bfq_data *bfqd)
 	struct blkcg_gq *blkg;
 
 	list_for_each_entry(blkg, &bfqd->queue->blkg_list, q_node) {
 		struct bfq_group *bfqg = blkg_to_bfqg(blkg);
 
-		bfq_end_wr_async_queues(bfqd, bfqg);
+		if (bfqg)
+			bfq_end_wr_async_queues(bfqd, bfqg);
 	}
 	bfq_end_wr_async_queues(bfqd, bfqd->root_group);
 }
 
 static int bfq_io_show_weight_legacy(struct seq_file *sf, void *v)
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 141c602d5e85..42ccfd0c6140 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2643,10 +2643,13 @@ void bfq_end_wr_async_queues(struct bfq_data *bfqd,
 static void bfq_end_wr(struct bfq_data *bfqd)
 {
 	struct bfq_queue *bfqq;
 	int i;
 
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+	mutex_lock(&bfqd->queue->blkcg_mutex);
+#endif
 	spin_lock_irq(&bfqd->lock);
 
 	for (i = 0; i < bfqd->num_actuators; i++) {
 		list_for_each_entry(bfqq, &bfqd->active_list[i], bfqq_list)
 			bfq_bfqq_end_wr(bfqq);
@@ -2654,10 +2657,13 @@ static void bfq_end_wr(struct bfq_data *bfqd)
 	list_for_each_entry(bfqq, &bfqd->idle_list, bfqq_list)
 		bfq_bfqq_end_wr(bfqq);
 	bfq_end_wr_async(bfqd);
 
 	spin_unlock_irq(&bfqd->lock);
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+	mutex_unlock(&bfqd->queue->blkcg_mutex);
+#endif
 }
 
 static sector_t bfq_io_struct_pos(void *io_struct, bool request)
 {
 	if (request)
-- 
2.51.0

