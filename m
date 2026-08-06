Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBEF3AD52E
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 18:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786041784; cv=none; b=gnh547pzSH7AJfU3CAu7CTrygD2KUXqRDZy8nwIBbKjuPiGIZidpZEk+Lpo5rXsotI576MP1BJwdaeiSK0Rl31KcAmhc7DlYA++j5bm1tXip4EltXsJ6d4TF24S4uMWMT2tAa6QkckHd2zInj6RpkFKWtrJk1XvayT/LnB9g0MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786041784; c=relaxed/simple;
	bh=Z/V1Am93T/YF1wpxfRBBd7cgF7WxgTBIYTqrA/LI+Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZEWnyhU7Q9LJ2nj1HW2Ja1Xf7Y1dYqerKFlDK1ycS+g7B6FLRnqoCxXxRz45a+zOIG7c+x6tz4giTSAylVWTWtpfY0XYDYKuuaqgSogmOOwdJLkEYacd3zsI5bpll6dAIXKQAy7cgyBB0ThNKg3NjP8jcT0l+RS9BMiMFVbfXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JrdpIn3h; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JrdpIn3h"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6b01abe5cdbso511215eaf.3
        for <cgroups@vger.kernel.org>; Thu, 06 Aug 2026 11:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786041781; x=1786646581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7uMnAqaoMp1MP/2YeQ3uTyWm7ZJYM3hk0so38h+N6NA=;
        b=JrdpIn3hpQoTAWxShBprh3ajI796WtrN2YjCgo/qcVvwZreM8+VBzRa4SDYVELNdM2
         TcIvKsFe6YpbYZnuXenO4mjC6SXItCaXQorvpJYy/d1QC0h1GeeikP18Rllk+paGzd0o
         xFR/3uxRPK9aPck2Sx6ojkct2x+p6Wwv2nJX/5JIWbUe33+i9oJ06QKWHcujpQ2gvtFQ
         5uh4qJw0ENPiCjQFK0/o/Ex3nu27JW/OMpAcxruYhbIq+QsuzHqLDRMRU9spWTiLmYQI
         h7fB0qq+ei698MMzNv6t6qYu6aWLzv/iF5CAthFFiY6Zn1c7CfuYhS8lZePpFesQ7qAq
         FTPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786041781; x=1786646581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7uMnAqaoMp1MP/2YeQ3uTyWm7ZJYM3hk0so38h+N6NA=;
        b=QGwd/PYE3mgrVIW6toqzPzN7u/e9ru0u3IAT7kfm6RB6gF1APmzlXl7LWOk92UMR0U
         S7YAzKqnw8zVHE7Ro+iKRh+PpjnRjbF5pUIvaXz+NTa9+hO3djDfm1vm+7q31kZ2vVWd
         huyfmPN7xi2lDFJbr+sQOkJSM3J0suIOg7+D3MDisXY08PWe4BDTiABg64YRDq629sx+
         tQopFIAyOkp8oF/1rSwzI57ADxUlhIWzk20HI8FlcK2TnmCmsjmxuDW2gWF9LtfAs+bs
         dk1D73wtEjw3/UDcsBLCjbFeeHMk0zsO/bvb8aweofsCsjU4rfQvArULr18s4mFcs72m
         1jmA==
X-Forwarded-Encrypted: i=1; AHgh+Ro5HJpc7DwE7mCrgzMEial2q2rO2RaOlSYARJYmA20NlqmXv5ltzxjBD2QowtTf8/gpp05wlaJF@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4cdH4rqzWbKdTTWfvOAI8a79gRP7yxUGhdHbwl0jY2Fogxse/
	mqU850jtetldMBogwKe+QAXeIGSCAwchLBiTgZP5VP5jl6/OulQ8an68
X-Gm-Gg: AR+sD10ke9I6QUkmLWKku4o1ECzxPR5P5AZ79yADwZcGzy4lB+j6zTwq8j93mhVCvIy
	SbuMRSjBNmKE+80TZMH4M177pU+9+2+gGHygyKsRjqGov+skLUgOMTUrSGoRlhnwsXI9+gJh49x
	gstAfXAq8r1zdEsLjL0Tj3adhw4GOgjXTFgTG9PMXC0bGCpbxAIVWsZfm3sn6B59mc/Jp2PT1xd
	u2WpZ/PhihkNQ5Vro1dk6+PJusL/gtOO8m9HlEVswyQ/qo8g0VKkeKObYl6ADHcjQMOX3/0CxVU
	2/un8zwdbc5Y5c4qoQwJy4YSo8MPsRLT+hOddt5gSacPHlSuNtbjooBcvD4tF28dszSCc6Dbbqu
	NOXGFw05fQE65vo2P60iOVEQGA/Ao0L8xGZzlRRAKg1yeJEa0r9+pw/sdlGrqtmriDdsIlRZqHd
	2LpW6tHqKsHMK2qNVhPpRObOUE8XbQGok1VDs0GGX+0aIEbKEDGCNZMvAACxYoipFOOEcCmvFv2
	5PRZnytj6U=
X-Received: by 2002:a05:6820:4b8b:b0:6ac:b3b1:a5a4 with SMTP id 006d021491bc7-6ae968c1761mr9319789eaf.0.1786041781003;
        Thu, 06 Aug 2026 11:43:01 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4d::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b02bc7f3d1sm191834eaf.8.2026.08.06.11.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:43:00 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v3 03/11] mm, swap: prepare the swap IO path for vswap
Date: Thu,  6 Aug 2026 11:42:46 -0700
Message-ID: <20260806184254.3790858-4-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260806184254.3790858-1-nphamcs@gmail.com>
References: <20260806184254.3790858-1-nphamcs@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for adding a physical swap backend for vswap, make the
swap IO path able to submit IO for a swap entry other than folio->swap.

swap_add_folio() and __swap_writepage() derive the target device and
sector from folio->swap. For a vswap folio backed by a physical slot
that entry is virtual, so it identifies neither the backing device nor
the sector to submit IO against.

Compute the sector from an explicit entry (swap_folio_sector becomes
swap_entry_sector), thread that entry through swap_add_folio,
__swap_writepage and ops->can_merge, and stash it in swap_iocb so the
submit path addresses the IO from it rather than from folio->swap.

This lets the batching path serve both vswap entries (backed by a
physical slot) and physical entries mapped directly into PTEs.

All callers pass folio->swap for now, so there is no functional change.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h |  2 +-
 mm/page_io.c         | 51 ++++++++++++++++++++++----------------------
 mm/swap.h            |  7 +++---
 mm/swapfile.c        |  6 +++---
 mm/zswap.c           |  2 +-
 5 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index a955bd60dd58..8359134d08cb 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -389,7 +389,7 @@ extern int __swap_count(swp_entry_t entry);
 extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
-sector_t swap_folio_sector(struct folio *folio);
+sector_t swap_entry_sector(swp_entry_t entry);
 
 /*
  * If there is an existing swap slot reference (swap entry) and the caller
diff --git a/mm/page_io.c b/mm/page_io.c
index b1894cd014b3..5c780bda92bb 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -265,7 +265,7 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
 
-	__swap_writepage(ctx, folio);
+	__swap_writepage(ctx, folio, folio->swap);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -326,6 +326,7 @@ struct swap_iocb {
 	struct bio_vec		bvecs[SWAP_CLUSTER_MAX];
 	int			nr_bvecs;
 	int			len;
+	swp_entry_t		entry;	/* first slot in the batch; addresses the IO */
 };
 static mempool_t *sio_pool;
 
@@ -343,24 +344,22 @@ int sio_pool_init(void)
 }
 
 static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
-		int rw)
+		swp_entry_t phys, int rw)
 {
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
-	struct bio_vec *last_bv = &ctx->sio->bvecs[ctx->sio->nr_bvecs - 1];
-	struct folio *prev_folio = bvec_folio(last_bv);
-	size_t prev_folio_size = folio_size(prev_folio);
+	struct swap_info_struct *sis = __swap_entry_to_info(phys);
 
 	if (ctx->sis != sis)
 		return false;
-	return sis->ops->can_merge(folio, prev_folio, prev_folio_size, rw);
+	return sis->ops->can_merge(folio, phys, ctx->sio, rw);
 }
 
-static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
+static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio,
+		swp_entry_t phys, int rw)
 {
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
+	struct swap_info_struct *sis = __swap_entry_to_info(phys);
 	struct swap_iocb *sio = ctx->sio;
 
-	if (sio && !swap_can_merge(ctx, folio, rw)) {
+	if (sio && !swap_can_merge(ctx, folio, phys, rw)) {
 		if (rw == WRITE)
 			swap_write_submit(ctx);
 		else
@@ -373,6 +372,7 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 		ctx->sio = sio = mempool_alloc(sio_pool, GFP_NOIO);
 		sio->nr_bvecs = 0;
 		sio->len = 0;
+		sio->entry = phys;
 	}
 	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
@@ -384,7 +384,8 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 	}
 }
 
-void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
+void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio,
+		swp_entry_t phys)
 {
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
@@ -400,7 +401,7 @@ void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
 
 	folio_start_writeback(folio);
 	folio_unlock(folio);
-	swap_add_folio(ctx, folio, WRITE);
+	swap_add_folio(ctx, folio, phys, WRITE);
 }
 
 /*
@@ -504,7 +505,7 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
-	swap_add_folio(ctx, folio, READ);
+	swap_add_folio(ctx, folio, folio->swap, READ);
 
 finish:
 	if (workingset) {
@@ -617,7 +618,7 @@ static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
 	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
 			REQ_OP_WRITE | REQ_SWAP);
 	bio->bi_iter.bi_size = sio->len;
-	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio->bi_iter.bi_sector = swap_entry_sector(sio->entry);
 	bio_associate_blkg_from_page(bio, bio_first_folio_all(bio));
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
@@ -637,7 +638,7 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
 	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
 			REQ_OP_READ);
 	bio->bi_iter.bi_size = sio->len;
-	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio->bi_iter.bi_sector = swap_entry_sector(sio->entry);
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
 		/*
@@ -655,13 +656,14 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
 	}
 }
 
-static bool swap_bdev_can_merge(struct folio *folio, struct folio *prev_folio,
-		size_t prev_folio_size, int rw)
+static bool swap_bdev_can_merge(struct folio *folio, swp_entry_t phys,
+		struct swap_iocb *sio, int rw)
 {
-	if (swap_folio_sector(folio) !=
-	    swap_folio_sector(prev_folio) + (prev_folio_size >> SECTOR_SHIFT))
+	if (swap_entry_sector(phys) !=
+	    swap_entry_sector(sio->entry) + (sio->len >> SECTOR_SHIFT))
 		return false;
-	if (rw == WRITE && !folio_blkg_can_merge(folio, prev_folio))
+	if (rw == WRITE && !folio_blkg_can_merge(folio,
+			bvec_folio(&sio->bvecs[sio->nr_bvecs - 1])))
 		return false;
 	return true;
 }
@@ -679,7 +681,7 @@ static void swap_fs_submit(struct swap_io_ctx *ctx, int rw)
 	int ret;
 
 	init_sync_kiocb(&sio->iocb, ctx->sis->swap_file);
-	sio->iocb.ki_pos = swap_dev_pos(bvec_folio(&sio->bvecs[0])->swap);
+	sio->iocb.ki_pos = swap_dev_pos(sio->entry);
 	if (rw == WRITE)
 		sio->iocb.ki_complete = swap_fs_write_complete;
 	else
@@ -702,11 +704,10 @@ static void swap_fs_submit_read(struct swap_io_ctx *ctx)
 	swap_fs_submit(ctx, READ);
 }
 
-static bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
-		size_t prev_folio_size, int rw)
+static bool swap_fs_can_merge(struct folio *folio, swp_entry_t phys,
+		struct swap_iocb *sio, int rw)
 {
-	return swap_dev_pos(folio->swap) ==
-		swap_dev_pos(prev_folio->swap) + prev_folio_size;
+	return swap_dev_pos(phys) == swap_dev_pos(sio->entry) + sio->len;
 }
 
 static const struct swap_ops swap_fs_ops = {
diff --git a/mm/swap.h b/mm/swap.h
index d241e81e967e..88ca9be71b7e 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -103,8 +103,8 @@ struct swap_io_ctx {
 struct swap_ops {
 	unsigned int		flags;
 
-	bool (*can_merge)(struct folio *folio, struct folio *prev_folio,
-			size_t prev_folio_size, int rw);
+	bool (*can_merge)(struct folio *folio, swp_entry_t phys,
+			struct swap_iocb *sio, int rw);
 	void (*submit_write)(struct swap_io_ctx *ctx);
 	void (*submit_read)(struct swap_io_ctx *ctx);
 };
@@ -313,7 +313,8 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio);
 void swap_read_submit(struct swap_io_ctx *ctx);
 void swap_write_submit(struct swap_io_ctx *ctx);
 int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
-void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio);
+void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio,
+		swp_entry_t phys);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index a26cfe5751c8..b8fdb426514c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -355,14 +355,14 @@ offset_to_swap_extent(struct swap_info_struct *sis, unsigned long offset)
 	BUG();
 }
 
-sector_t swap_folio_sector(struct folio *folio)
+sector_t swap_entry_sector(swp_entry_t entry)
 {
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
+	struct swap_info_struct *sis = __swap_entry_to_info(entry);
 	struct swap_extent *se;
 	sector_t sector;
 	pgoff_t offset;
 
-	offset = swp_offset(folio->swap);
+	offset = swp_offset(entry);
 	se = offset_to_swap_extent(sis, offset);
 	sector = se->start_block + (offset - se->start_page);
 	return sector << (PAGE_SHIFT - 9);
diff --git a/mm/zswap.c b/mm/zswap.c
index e19bde9df722..789079c3945b 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1076,7 +1076,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writepage(&ctx, folio);
+	__swap_writepage(&ctx, folio, folio->swap);
 	swap_write_submit(&ctx);
 
 out:
-- 
2.53.0-Meta

