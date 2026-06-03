Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58124314D35;
	Wed,  3 Jun 2026 13:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780493278; cv=none; b=tzOFBP2mVvIPM4H5hGVV1TSlt2ivafQUn0rRGWlY6j6DOXz+0n5nn2SDGNNk2VIR+OViJ/seZJ0t0psi4/uUTvEpRP647gcwRqoLl1k/ifRpfUxaFy3nRRSOckYP8CsEezPXDTeizhOn6NAsOrugbIWFHCwqtUK4xDfRFD+vHsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780493278; c=relaxed/simple;
	bh=peDdqXYx5KZT1Fn7SH5gTZ3zbKz0fSIE/13BLxdI1qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=We7r7WjWIVgmG18QARtS1gkaAcyxBub8leXaq/BKU/TlkthKfVPt8CC+zJkEe+XqrI4O95GWfVXUD3UjfBvCU0eVyNjYFTpFLKnfV01BF7GKL3fzMpIMr9Cv0mwyBVbStchYHqDIj8AcU5DYOQGLJwzDPqL1cKsZRoAw0Zm9AT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245C01F00898;
	Wed,  3 Jun 2026 13:27:53 +0000 (UTC)
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
Subject: [PATCH 1/5] blk-cgroup: protect q->blkg_list iteration in blkg_destroy_all() with blkcg_mutex
Date: Wed,  3 Jun 2026 21:27:41 +0800
Message-ID: <70b7126772552b910a2dccbe1e913eaec8eb6a8b.1780492756.git.yukuai@fygo.io>
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

blkg_destroy_all() iterates q->blkg_list without holding blkcg_mutex,
which can race with blkg_free_workfn() that removes blkgs from the list
while holding blkcg_mutex.

Add blkcg_mutex protection around the q->blkg_list iteration to prevent
potential list corruption or use-after-free issues.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 554c87bb4a86..a98a22e06fd1 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -573,10 +573,11 @@ static void blkg_destroy_all(struct gendisk *disk)
 	struct blkcg_gq *blkg;
 	int count = BLKG_DESTROY_BATCH_SIZE;
 	int i;
 
 restart:
+	mutex_lock(&q->blkcg_mutex);
 	spin_lock_irq(&q->queue_lock);
 	list_for_each_entry(blkg, &q->blkg_list, q_node) {
 		struct blkcg *blkcg = blkg->blkcg;
 
 		if (hlist_unhashed(&blkg->blkcg_node))
@@ -591,10 +592,11 @@ static void blkg_destroy_all(struct gendisk *disk)
 		 * it when a batch of blkgs are destroyed.
 		 */
 		if (!(--count)) {
 			count = BLKG_DESTROY_BATCH_SIZE;
 			spin_unlock_irq(&q->queue_lock);
+			mutex_unlock(&q->blkcg_mutex);
 			cond_resched();
 			goto restart;
 		}
 	}
 
@@ -610,10 +612,11 @@ static void blkg_destroy_all(struct gendisk *disk)
 			__clear_bit(pol->plid, q->blkcg_pols);
 	}
 
 	q->root_blkg = NULL;
 	spin_unlock_irq(&q->queue_lock);
+	mutex_unlock(&q->blkcg_mutex);
 
 	wake_up_var(&q->root_blkg);
 }
 
 static void blkg_iostat_set(struct blkg_iostat *dst, struct blkg_iostat *src)
-- 
2.51.0

