Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C6A36A036;
	Thu, 25 Jun 2026 02:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782356269; cv=none; b=MZFVmljA6NF2LKMnXahf+jhOik/a/o21HzHbhOUtu/yo6Z/U+1XrBHPRexCXNJdiqNTB0VR31uKwg7v70NdErBhzSpebYr9SYZpnLwIS0FSRkr1cQgHPLhkxCor8nzJXkYHiCePqN0uX37A1roSh4fpAAhrwl2pGdMy6UDZfnjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782356269; c=relaxed/simple;
	bh=tllAKtMLFDAEIDgoxJqle5qOgqS6E+yZJpNDoVT7kR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJcx2QwM5jJ1oY4fPesfhPcu+X7KYrVZAOdTnhN4gc3qjLvNqEmP1/Mnxqp0s1CMofqKLx8Pv+eVkTUqCoaf+IEnoqU3JWi4EXGy47t22RmSLbOcCbf2AJoZ/qEFYAALp4BqoAe/QuU6w7CQLzlNqreBiVVg0Q6qlG+RHX9Wu8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BHoSmGRI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BHoSmGRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9CD1F00A3D;
	Thu, 25 Jun 2026 02:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782356268;
	bh=aetfsBi1ZT3j5SqHYTWItN5zMONbuAxHP+2v3rB9ZQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BHoSmGRIz+CdC+t8dHpMHzTA3yQiXfbcVeq4M3jEpWSCJp0AujPG8CkP8TfnSYqt4
	 4NtufdKj6vHRmVq+Vl3oTbYYxddaGYzsXLUIlPy+RaS5QL/EkmBx0mA9j/HyXPXIAW
	 8TdEDIAbaPV8cOY1hbm6pe/lKLG7kw1thQ9JGsQ7eKBjhIA+hisglGLUfx4XjgkPVx
	 NACZeI92cHMX+MtRm4Cr9UPpf2lsbEcdASTaWTfpHpE/xqy5fO82AVwkpMeTV4r4+6
	 TINgVOl/HQKL7MpjOERj1uEIRwtzdioOUuEZZwKsv4z7slDXsaU6gNBT58U1OW4hxv
	 eyduPA2QwV+bA==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>,
	Zheng Qixing <zhengqixing@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Tang Yizhou <yizhou.tang@shopee.com>,
	Yu Kuai <yukuai@fygo.io>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/4] blk-cgroup: protect q->blkg_list iteration in blkg_destroy_all() with blkcg_mutex
Date: Thu, 25 Jun 2026 10:57:36 +0800
Message-ID: <20260625025739.2459651-2-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260625025739.2459651-1-yukuai@kernel.org>
References: <20260625025739.2459651-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

blkg_destroy_all() iterates q->blkg_list without holding blkcg_mutex,
which can race with blkg_free_workfn() that removes blkgs from the list
while holding blkcg_mutex.

Add blkcg_mutex protection around the q->blkg_list iteration to prevent
potential list corruption or use-after-free issues.

Reviewed-by: Tang Yizhou <yizhou.tang@shopee.com>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d2a1f5903f24..d22a43c545b6 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -567,10 +567,11 @@ static void blkg_destroy_all(struct gendisk *disk)
 	struct blkcg_gq *blkg;
 	int count = BLKG_DESTROY_BATCH_SIZE;
 	int i;
 
 restart:
+	mutex_lock(&q->blkcg_mutex);
 	spin_lock_irq(&q->queue_lock);
 	list_for_each_entry(blkg, &q->blkg_list, q_node) {
 		struct blkcg *blkcg = blkg->blkcg;
 
 		if (hlist_unhashed(&blkg->blkcg_node))
@@ -585,10 +586,11 @@ static void blkg_destroy_all(struct gendisk *disk)
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
 
@@ -604,10 +606,11 @@ static void blkg_destroy_all(struct gendisk *disk)
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

