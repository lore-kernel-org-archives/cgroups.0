Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75BE3890FB;
	Wed, 24 Jun 2026 06:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283602; cv=none; b=MFmzGi3OkloLjCNQF5yQ2Dy4yZPpGwArICMz7STrwgcTzhgIKbz3pfaeI5GlS2TIkmbN01/Tr3SHXY/h0BqOqwpMzc/yQDTM2Tfo484Pa7X/sv4xYOZequGkn2XBrrnuNKQxme/sxdw6SGkjceRFfG7zAeCQ67UuykKMi7pXKLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283602; c=relaxed/simple;
	bh=C52EdCW5XFC6KgQLdjHjJZezLWxutkrxkBgkRFNsqL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtrTUXrS01ey2uLCMzZNFnkNKIdXGPZ8NyNKLVi8k4nYDKPReZfqfWbHMfZf7jsPdMFLeFIMuKxScn55MBSNT4v4XUhk8vWQJen+4JHXTEiDRZh3ja4pZTI7sX5Ryr4YS0felL0Cjpuv1S0e3L8rk62J8cSFTIcAUUoAMBGxHVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j2S1/o4q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j2S1/o4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E761F000E9;
	Wed, 24 Jun 2026 06:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283601;
	bh=Aql1atmvU4bkWk/jrAwFgTZHPUQQkKk8gBqO1pEE6O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j2S1/o4qlwVhoQtE9FzHhwpHqrQTBAYx1omclz7Rcoq1AhVK8mIBxyrHSIa1zYERz
	 yzoNv4snB3NQ1RPOrDcyruK9yFEHuAD83TWMXWCKcz95Lv9cLvQded5nSqReGSdzY4
	 b7l7e1rlVd+y2UmBbxfalNr5ahvOyiv8cGMBsM5kSKvY1k/dYzlnYv7dfH7BaqbjYW
	 /Qfgdfh5Cc602+JKQWAAKO9Kwr0eJBMq2uvC6UaYALmNXPfZHDQOMNS0tKFGr+S14l
	 efi4H3trmWsqAFh+uA1LMKyTA7nEL0XqTltjnMSAnhWsXN3xCUfuolCe/77C1YpE8C
	 6f8TYmEYnJVLA==
From: Yu Kuai <yukuai@kernel.org>
To: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: Zheng Qixing <zhengqixing@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Tang Yizhou <yizhou.tang@shopee.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Ming Lei <ming.lei@redhat.com>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] blk-cgroup: protect q->blkg_list iteration in blkg_destroy_all() with blkcg_mutex
Date: Wed, 24 Jun 2026 14:46:22 +0800
Message-ID: <20260624064625.1743650-4-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260624064625.1743650-1-yukuai@kernel.org>
References: <20260624064625.1743650-1-yukuai@kernel.org>
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
index ee076ab795d3..7baccfb690fe 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -574,10 +574,11 @@ static void blkg_destroy_all(struct gendisk *disk)
 	struct blkcg_gq *blkg;
 	int count = BLKG_DESTROY_BATCH_SIZE;
 	int i;
 
 restart:
+	mutex_lock(&q->blkcg_mutex);
 	spin_lock_irq(&q->queue_lock);
 	list_for_each_entry(blkg, &q->blkg_list, q_node) {
 		struct blkcg *blkcg = blkg->blkcg;
 
 		if (hlist_unhashed(&blkg->blkcg_node))
@@ -592,10 +593,11 @@ static void blkg_destroy_all(struct gendisk *disk)
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
 
@@ -611,10 +613,11 @@ static void blkg_destroy_all(struct gendisk *disk)
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

