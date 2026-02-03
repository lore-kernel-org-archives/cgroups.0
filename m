Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632772DF6F6;
	Tue,  3 Feb 2026 08:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770105971; cv=none; b=rn86WasSB6OiS5fiCfBdPpsGRlFCOeablf1gCGqnwtsp1yVVsTK3s4R9RzuoPLTDZs4rcsyLDy91l2/nrFc6zRyXxuj2A1itnIb2MG0T1npkC8yGoI4weZpo+K2ZnRcnrRE5dwKUa69eTdIWamC82WUgAALmLiAU2XltNCbXdMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770105971; c=relaxed/simple;
	bh=rhAh8Qt6BcEMTM98R8MnFkUNtJyn1YPkVEfNxMDnwP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHWiFdqJgG+CzH82G+9/BJxQITZJXwaWjYecKeDom/k6v/op+GaUG4r+vWQBEEURZASJuebOU6ssNn/5aWjq6uShyrndRhjCpuoWGo9laepR/ygMCtocPpHKNveOvxgilacrReQtWYq5XszdnWY0ZgM+NCnTkWs6dByzF+dIX6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63559C19422;
	Tue,  3 Feb 2026 08:06:08 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: tj@kernel.org,
	josef@toxicpanda.com,
	axboe@kernel.dk
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai@fnnas.com,
	zhengqixing@huawei.com,
	mkoutny@suse.com,
	hch@infradead.org,
	ming.lei@redhat.com,
	nilay@linux.ibm.com
Subject: [PATCH v2 1/7] blk-cgroup: protect q->blkg_list iteration in blkg_destroy_all() with blkcg_mutex
Date: Tue,  3 Feb 2026 16:05:56 +0800
Message-ID: <20260203080602.726505-2-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260203080602.726505-1-yukuai@fnnas.com>
References: <20260203080602.726505-1-yukuai@fnnas.com>
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

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 block/blk-cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 3cffb68ba5d8..0bc7b19399b6 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -574,6 +574,7 @@ static void blkg_destroy_all(struct gendisk *disk)
 	int i;
 
 restart:
+	mutex_lock(&q->blkcg_mutex);
 	spin_lock_irq(&q->queue_lock);
 	list_for_each_entry(blkg, &q->blkg_list, q_node) {
 		struct blkcg *blkcg = blkg->blkcg;
@@ -592,6 +593,7 @@ static void blkg_destroy_all(struct gendisk *disk)
 		if (!(--count)) {
 			count = BLKG_DESTROY_BATCH_SIZE;
 			spin_unlock_irq(&q->queue_lock);
+			mutex_unlock(&q->blkcg_mutex);
 			cond_resched();
 			goto restart;
 		}
@@ -611,6 +613,7 @@ static void blkg_destroy_all(struct gendisk *disk)
 
 	q->root_blkg = NULL;
 	spin_unlock_irq(&q->queue_lock);
+	mutex_unlock(&q->blkcg_mutex);
 }
 
 static void blkg_iostat_set(struct blkg_iostat *dst, struct blkg_iostat *src)
-- 
2.51.0

