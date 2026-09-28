Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990F347126A;
	Mon, 28 Sep 2026 08:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790583750; cv=none; b=dCe7sQvGRNo5N4VEOUS0K0Nbs1hSbSHaitk6g/8604tolRfuTgkQcw4Yu6+pPqzb/xTlnVtV9BlQwtqgb7q0FPSusRmKRK/jpXuzm/+d8PlCrbh7CIwgsmAzOT1igeMC9xMGK2wukcVuq1qgZxevNuPTHd0PXhLx9eDMbRockSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790583750; c=relaxed/simple;
	bh=Gck/KM1EilDjxxmrPmjNDlhIL11i0u8eYg6X3jR22eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f74pG2RTc6C9CvBEkKwrnjR14CD3DlqV7VYiuMNFgUJH+IUlwIiJGfs633WQgPVPRS6FR/babQJsktZY8rUTnvQSGpuCxZf0z2uWUZIpJW7nB61TlxU0bws2SW4M23zTyM9gna+8/kdONopXNnKi305j0KU6sybj3e2IqybEuBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 1C93F3EBA1;
	Mon, 28 Sep 2026 08:22:23 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [RFC PATCH 3/4] mm/zswap: allow writeback to be throttled by the cgroup IO controllers
Date: Mon, 28 Sep 2026 10:18:38 +0200
Message-ID: <20260928081900.4187482-4-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928081900.4187482-1-alex@ghiti.fr>
References: <20260928081900.4187482-1-alex@ghiti.fr>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTEW6N0v/qhbP15hg7rOtVRroKWhPIQwcq/TVt0qEZDhT+eUHNB5EQJEYoFuoBx9qmMf9D2NwLWxd+d/fibAsDoF8JQVfAcRijfNdurquHJPescUKhuoiULW+oLv+b1vYSyAI916kdOv/Q1kOdPYUQv5Y6Y2UnOafceg2u84CLd8giuFKsAY6iUfyh1IilMhqnUHFuHdNUeqpGxAfL0MQv0xA3bdtFYg3UkeqvM+hh6FGR35z7hxyf2k/2W1TpUTyr9yKMGdnlHJysoSILZdKapVYfY4huAkx9McOMFIJNffUjSUU1FqF8CNOP4hpapHQzU35sos8POl5KBYenunmngIoa3Zq0hQ3IavtSZxCqnU4f5J/ImKy3j5SLbeDTywKsP96a6D9RVNBVEbSzPOxcc/JxQ4cTrQisYytX+kcF+fehOw9Nb6VTh4h25eh9vgujk7J8FA5OWo3oFmiCn1DETgJCE3kM8zxbbhoIrzJLnGLD1L3p2Ra1hmXqMS2QLyI5GNzYV7VMR8cIVE39umIrLNxLfDp9I71MuX7FYnEKwL/bM5QIZzzxkyJixOIscQTZRuraPIPreFOl5ATqrpEAcje1d2fM2RrwDFBMYuRheyF0JvUoFicil7eMbQT4oLDrJbcPtPUN+be7QFP5ttyzuwSlSpNDINMBFzDO+R2eJRXA

bio_issue_as_root_blkg() exempts REQ_SWAP bios from the cgroup IO
controllers. The exemption avoids priority inversion: reclaim issues
swap writes on behalf of the whole system, so making them wait on one
cgroup's IO budget stalls memory reclaim for everyone.

For zswap writeback the exemption does harm: the write is charged to the
cgroup's IO budget anyway, afterwards, but is issued ahead of the
synchronous swapin and page cache reads that the workload blocks on.

Let zswap writeback opt out of it with REQ_BACKGROUND.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 include/linux/swap_ops.h |  1 +
 mm/page_io.c             |  7 +++++--
 mm/zswap.c               | 20 ++++++++++++++++----
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/include/linux/swap_ops.h b/include/linux/swap_ops.h
index 57ac6c703f68..152598ce6c4f 100644
--- a/include/linux/swap_ops.h
+++ b/include/linux/swap_ops.h
@@ -17,6 +17,7 @@ struct swap_iocb {
 struct swap_io_ctx {
 	struct swap_iocb	*sio;
 	struct swap_info_struct	*sis;
+	bool			throttled;
 };
 
 /*
diff --git a/mm/page_io.c b/mm/page_io.c
index 88962571cb93..14dd54ae6d65 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -591,9 +591,12 @@ static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
 {
 	struct swap_iocb *sio = ctx->sio;
 	struct bio *bio = &sio->bio;
+	blk_opf_t opf = REQ_OP_WRITE | REQ_SWAP;
 
-	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
-			REQ_OP_WRITE | REQ_SWAP);
+	if (ctx->throttled)
+		opf |= REQ_BACKGROUND;
+
+	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs), opf);
 	bio->bi_iter.bi_size = sio->len;
 	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
 	bio_associate_blkg_from_page(bio, bio_first_folio_all(bio));
diff --git a/mm/zswap.c b/mm/zswap.c
index 8925b6100402..3b902f29ed4c 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -983,16 +983,21 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
  * in the first place.  After the folio has been decompressed into
  * the swap cache, the compressed version stored by zswap can be
  * freed.
+ *
+ * @throttled lets the cgroup IO controllers throttle the write rather than
+ * issue it as root.
  */
 static int zswap_writeback_entry(struct zswap_entry *entry,
-				 swp_entry_t swpentry)
+				 swp_entry_t swpentry, bool throttled)
 {
 	struct xarray *tree;
 	pgoff_t offset = swp_offset(swpentry);
 	struct folio *folio;
 	struct mempolicy *mpol;
 	struct swap_info_struct *si;
-	struct swap_io_ctx ctx = {};
+	struct swap_io_ctx ctx = {
+		.throttled = throttled,
+	};
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -1070,8 +1075,14 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
  *
  * ZSWAP_SHRINK_SWAPCACHE (out) is set when the walk stopped at an entry whose
  * folio is already in the swap cache.
+ *
+ * ZSWAP_SHRINK_THROTTLED (in) lets the cgroup IO controllers throttle the
+ * writeback rather than issue it as root. Only the memory pressure shrinker
+ * sets it. The pool limit path must not: once the pool is full zswap_store()
+ * rejects everything until this writeback drains it.
  */
 #define ZSWAP_SHRINK_SWAPCACHE	BIT(0)
+#define ZSWAP_SHRINK_THROTTLED	BIT(1)
 
 /*
  * The dynamic shrinker is modulated by the following factors:
@@ -1154,7 +1165,8 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 	 */
 	spin_unlock(&l->lock);
 
-	writeback_result = zswap_writeback_entry(entry, swpentry);
+	writeback_result = zswap_writeback_entry(entry, swpentry, flags &&
+						 (*flags & ZSWAP_SHRINK_THROTTLED));
 
 	if (writeback_result) {
 		zswap_reject_reclaim_fail++;
@@ -1180,7 +1192,7 @@ static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 		struct shrink_control *sc)
 {
 	unsigned long shrink_ret;
-	unsigned int flags = 0;
+	unsigned int flags = ZSWAP_SHRINK_THROTTLED;
 
 	if (!zswap_shrinker_enabled ||
 			!mem_cgroup_zswap_writeback_enabled(sc->memcg)) {
-- 
2.53.0-Meta

