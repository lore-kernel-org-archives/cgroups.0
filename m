Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F2D218592;
	Sat,  4 Jul 2026 19:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783194835; cv=none; b=XE0U/vylYAgZej7AGZ+v9joiRBjD0HdBFAkonJlKBLTck91GB41j97jkw6Be1vb7ybvp5gHJt+qWJQtFmlxEpZRe0qVvo+Xrjufjp+M44eXP6MQiYeGNg5ZKvxGugeubS2XzWMBJk3LNUgH/qZytR5SnCCP51+ZVTc1pY1rF9UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783194835; c=relaxed/simple;
	bh=L1kBwNt15m1gN/Zb1cgZqAXgwqBjnoGkzuTjZZBrdo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qejQI/GRijYG6cmRpC7qqvze3UIvlbRDMKpeVqt9ErKaGcgKOq1NbeD9wkp2kq8q9xGREkFpUtkMnGhRblq5OF4vAEil8DKheAgU2qtyhGfcxTXgf+6XXms2ndn6+059FTt1uZbUF38b0zgHV18Xo2F7w4/xF1ffnib0Rn1zNlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bnPjrSXo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bnPjrSXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C477A1F000E9;
	Sat,  4 Jul 2026 19:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783194834;
	bh=+BiKm4kVK4oPKVGcsKEfBVImUZcHd9qj5zTEiTKcjs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bnPjrSXoAI1pj9LrT9/YYsJtmp5BA7OGXwpAMroDo3L6eJWrMBi03RQaGLvD9OriC
	 CGw47ifQXwsu6nuSAIceH1OkAeijT15S/VCDrk/EtRqF9POH6jafoU/0XxchU6L9Qq
	 za9TtK25VBeCcT01PxbjLBWuZqZycT8VIaFLEfodUFtirF8RHRmoejk9/yKeDyYMaX
	 mO6hz2zf3Dr7K22UlOxzhJza6AXvQEyjhl4ZHewyxQvmzLsTLXwKmn3SaJTfc0cFOB
	 SoV0Bx1Dk37H7tOJ4DtcHCETnzNadD4VfXYBZSbTsTRE4tc9bg60iuRlCQDHgTqPrt
	 +9Xq1ySEdQ3jw==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alasdair Kergon <agk@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>,
	Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Josef Bacik <josef@toxicpanda.com>,
	Yu Kuai <yukuai@fygo.io>,
	Nilay Shroff <nilay@linux.ibm.com>,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	dm-devel@lists.linux.dev,
	linux-bcache@vger.kernel.org
Subject: [RFC PATCH v1 11/17] block: avoid scheduling from non-blocking helper allocations
Date: Sun,  5 Jul 2026 03:51:18 +0800
Message-ID: <20260704195124.1375075-12-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260704195124.1375075-1-yukuai@kernel.org>
References: <20260704195124.1375075-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

blk_alloc_discard_bio() and blk_rq_map_bio_alloc() can be used with
non-blocking GFP masks.  Their bio allocation now handles bdev association in
nowait mode, so the helpers can pass the target bdev directly and avoid local
open-coded association paths.

The discard helper can also be reached from io_uring with GFP_NOWAIT.  Keep
its long-loop cond_resched() only for blocking callers.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-lib.c | 3 ++-
 block/blk-map.c | 7 +------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 688bc67cbf73..b5645f8f69b6 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -56,7 +56,8 @@ struct bio *blk_alloc_discard_bio(struct block_device *bdev,
 	 * discards (like mkfs).  Be nice and allow us to schedule out to avoid
 	 * softlocking if preempt is disabled.
 	 */
-	cond_resched();
+	if (gfpflags_allow_blocking(gfp_mask))
+		cond_resched();
 	return bio;
 }
 
diff --git a/block/blk-map.c b/block/blk-map.c
index 768549f19f97..75c7b864c15a 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -46,14 +46,9 @@ static struct bio *blk_rq_map_bio_alloc(struct request *rq,
 		unsigned int nr_vecs, gfp_t gfp_mask)
 {
 	struct block_device *bdev = rq->q->disk ? rq->q->disk->part0 : NULL;
-	struct bio *bio;
 
-	bio = bio_alloc_bioset(bdev, nr_vecs, rq->cmd_flags, gfp_mask,
+	return bio_alloc_bioset(bdev, nr_vecs, rq->cmd_flags, gfp_mask,
 				&fs_bio_set);
-	if (!bio)
-		return NULL;
-
-	return bio;
 }
 
 /**
-- 
2.51.0

