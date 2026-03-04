Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5DF36D9EB;
	Wed,  4 Mar 2026 07:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772609896; cv=none; b=puzQqpdlt/7XWqnau7lKGICXEu099JzhJWuyO3wrPpCh6XqOwRKfiS9WVGONZrAyEtMlRLliHFVT7N9oFY1GIBDbA1vLQ+/cTCfVRh6uNusPHK8MW3CyawuBBsxHZy/FGmR5JW3MBP2SIk5zbqkfM+m/Ge97h9MN2fRlVWDf9Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772609896; c=relaxed/simple;
	bh=rhAh8Qt6BcEMTM98R8MnFkUNtJyn1YPkVEfNxMDnwP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KF7I2TQlu/JHlRTB4ALf5eaMhU4fJhh+y9jAwHzINMOqE+x2RGmEOQg5OpOsfiExZk/Kwxyy2SDAExwgkmXFrrmZyYONSP1+q5iOliofhBkMXZJlzCxvTCX+oYOkyNK7kNXJ3X1vmqouq54khqwkYw9iFRK/d5jXLWyzpn0uEUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3556C2BC87;
	Wed,  4 Mar 2026 07:38:13 +0000 (UTC)
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
Subject: [PATCH v3 1/7] blk-cgroup: protect q->blkg_list iteration in blkg_destroy_all() with blkcg_mutex
Date: Wed,  4 Mar 2026 15:38:02 +0800
Message-ID: <20260304073809.3438679-2-yukuai@fnnas.com>
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

