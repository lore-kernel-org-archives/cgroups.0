Received: from mail-oi2-f12.google.com (mail-oi2-f12.google.com [74.125.231.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF9D51AFD9
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 18:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789754573; cv=none; b=XaAjZPmJy/nOyvtTRlf/VzROmULD0LelLU5MFHrh8TXIvk+rOmupJsYXsLrhhNO5FlP8g4brdBuyBcgvE8I5MGEo6npUyJL/0gdVZiiyIMUYrQH9iemGgPbpI2PJb2B7phocpxi9B6qDHqY8K+W1wSFfbTAMLke3CyW36dwNzpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789754573; c=relaxed/simple;
	bh=a4iX01xeKFkOjusL7wUAwQPEtM/OuMizB+7wXsVzgZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUzPH0xmMsr1ZoGN+kNEciJbo6naJGv9uTtoT8dqbOHYSZy2Ud+mzSRGBGxNOPIbEg284EXyDVPS1bo4J94uQj/oeNhFxLbqc3KbN0PLgJBeAm+/vjW8MJCGxqP759nf+i9tvO49kOfivBOIbi+fVBmgfWQo2MdwCSEKofdCT3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fGrzyr7u; arc=none smtp.client-ip=74.125.231.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fGrzyr7u"
Received: by mail-oi2-f12.google.com with SMTP id 5614622812f47-4b37a316adfso897922b6e.2
        for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 11:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789754569; x=1790359369; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ku1DiWNPMjUzjw3oBYfS28zIvxt+bdOecf2pjvKy8dE=;
        b=fGrzyr7uJTs3/WNJ0FyvQdvRjCVZdxPuEqm2eRj7MXFqDNYyL0+J5vxPck4QaZUOyo
         5YC+Ko3ig5ecqBJRbgXx4JvslbvPVhSjOE0s/R+pIt/OdAK5m4jobwmjjVqyzN19hpuE
         bQD1GJo5hgYCxtglJIODPhg4cS5j3Il1DeSGm3pPE7PGUcDunK/HQ1ry+2GhMpzohQH6
         LCqgLTo6pUmNcCj6sAHlp5Jxckdt00FY3ZEvv4nTtiDF7P7hBsRvMMdn/laqtNdgtVVw
         WVz7qauqHTF6tuLkqh63IGwTgH3zpZ3ABnHR9pdPmbJSvFTH0iDUvXR3VCNvTy7v2V52
         9A2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789754569; x=1790359369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ku1DiWNPMjUzjw3oBYfS28zIvxt+bdOecf2pjvKy8dE=;
        b=WSbAkQRLxA0hF9SYMd74O6ShgAJbFqpxnq60CjNj9Zj8kabMX8jIE1uanEOL5/1s9j
         veZ9Ta1+1RZAGpO3D+Z1cNrECoS+yArIY2crLpyJ/VccbER9KYq45jNvD5XSV2yCyrEz
         TNfwEGv40jp3k8JZVULvvU9GrjWwW3mvvHnoVzFKBLARXPkLm8XQ5GzUMQbnm1HgzVIx
         pwnIzIlPi81KigYhLjNu0lh8uGjaAn3YaJb+G2am8D3tDfXhfxYWLexPIeG8c6VgvjRm
         4teAS3JCApI4+rRwPUEVQopdgR3Ktm5LJv/UiDKHHwrfQPE6zbDEs0KgbiN74+CgpVlc
         h2sw==
X-Forwarded-Encrypted: i=1; AKwUvBwnp57359qr9LLvuFYCyzD7DXsUWqQljh8c03yGdzqEDDlXfNn2SkBYrtjmDhBtEoORADnNcQxj@vger.kernel.org
X-Gm-Message-State: AFuF++kIJ9zKW9+DwsX0MaK+YblQLuKFW2d7AxLtXV6pAO/8sRInH3Qt
	tH0bWhNJX3eQVan5LF6wjr/EpC9CIIuca6fkRGlZ5mXNBEOLhXQ6MhoC
X-Gm-Gg: AYBFou2czlLyADDJAJioYgwKl59wlq3z6P4NwP2b+x5A7i/iQkcjRm5ZkXCfxls30pB
	dZ4pm3BjxFNTGlvCjSn4CebV7aFRCrqfEMdt9QhuFc51UlaFrSYDf/4H01CCorMtpZT9kMUqqyY
	7SZSibVpJ3cSx5qjtEM4Dm0v0+rDnOrkK/kmDbkshXl643z5JTy5BZ9G9FzZ/7y+4gb75OTcd4a
	SRrEYcsZeKGxrHmJcxPInur8+vyQ4iIEayAfSTgDCBbWk3FzbTWkfJHSLZzSiUV+udxuxnPunFR
	nBZl+2dSRIS36SBeofh2LKn1OcoBDN2hEoAvxJ/o22bXfJHjfke0WiUIXrzcghWr9eZBqRKC6C6
	mS+U4pUPxuDE/af0p6F4QBevLeKbTX898XtRG6XqB2vPsCPBNJJZ4/mJhoADIoAhmXgteQraKE6
	mL9BO5ui2s3kaXrMx6o+S/dAzTD9BYd6ARbsY9ZBt3aOqFEU3VGOiKAtYlrGGZSndoKcYAxmO51
	cYlnTUnuXgfxtyrhO0PvQ==
X-Received: by 2002:a05:6820:f007:b0:6b7:83d6:292a with SMTP id 006d021491bc7-6ca9cb53b30mr3234729eaf.45.1789754568673;
        Fri, 18 Sep 2026 11:02:48 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:11::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6cd3591d0b6sm565054eaf.12.2026.09.18.11.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:02:47 -0700 (PDT)
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
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v5 03/11] mm, swap: prepare the swap IO path for vswap
Date: Fri, 18 Sep 2026 11:02:33 -0700
Message-ID: <20260918180241.3424851-4-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260918180241.3424851-1-nphamcs@gmail.com>
References: <20260918180241.3424851-1-nphamcs@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for adding a physical swap backend for vswap, make the
swap IO path able to submit IO for a swap entry other than folio->swap.

The swap IO path derives the target device and sector from folio->swap.
For a vswap folio backed by a physical slot that entry is virtual, so it
identifies neither the backing device nor the sector to submit IO
against.

Compute the sector from an explicit entry (swap_folio_sector becomes
swap_entry_sector), thread that entry through swap_add_folio,
__swap_writeout and ops->can_merge, and stash it in swap_iocb so the
submit and completion paths address the IO from it rather than from
folio->swap.

This lets the batching path serve both vswap entries (backed by a
physical slot) and physical entries mapped directly into PTEs.

ops->can_merge changes anchor with it: swap_bdev_can_merge() compares
sectors and swap_fs_can_merge() byte offsets, and both now measure from the
batch head plus the accumulated length instead of from the previous folio
plus its size. The two agree at every step, since a batch only grows
through merges that passed the same test. The blkg comparison is unchanged
and still anchors on the last folio in the batch.

All callers pass folio->swap, so there is no functional change.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h     |  2 +-
 include/linux/swap_ops.h |  9 ++++---
 mm/page_io.c             | 54 +++++++++++++++++++---------------------
 mm/swap.h                |  3 ++-
 mm/swapfile.c            |  6 ++---
 mm/zswap.c               |  2 +-
 6 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index abf658f7861f..5ab050b2457c 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -409,7 +409,7 @@ extern int __swap_count(swp_entry_t entry);
 extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
-sector_t swap_folio_sector(struct folio *folio);
+sector_t swap_entry_sector(swp_entry_t entry);
 
 /*
  * If there is an existing swap slot reference (swap entry) and the caller
diff --git a/include/linux/swap_ops.h b/include/linux/swap_ops.h
index 57ac6c703f68..223c84548bde 100644
--- a/include/linux/swap_ops.h
+++ b/include/linux/swap_ops.h
@@ -12,6 +12,7 @@ struct swap_iocb {
 	struct bio_vec		bvecs[SWAP_CLUSTER_MAX];
 	int			nr_bvecs;
 	int			len;
+	swp_entry_t		entry;	/* first slot in the batch; addresses the IO */
 };
 
 struct swap_io_ctx {
@@ -30,15 +31,15 @@ struct swap_io_ctx {
 struct swap_ops {
 	unsigned int		flags;
 
-	bool (*can_merge)(struct folio *folio, struct folio *prev_folio,
-			size_t prev_folio_size, int rw);
+	bool (*can_merge)(struct folio *folio, swp_entry_t phys,
+			struct swap_iocb *sio, int rw);
 	void (*submit_write)(struct swap_io_ctx *ctx);
 	void (*submit_read)(struct swap_io_ctx *ctx);
 };
 
 void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter);
-bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
-		size_t prev_folio_size, int rw);
+bool swap_fs_can_merge(struct folio *folio, swp_entry_t phys,
+		struct swap_iocb *sio, int rw);
 int swap_fs_activate(struct swap_info_struct *sis, const struct swap_ops *ops);
 
 #endif /* _MM_SWAP_OPS_H */
diff --git a/mm/page_io.c b/mm/page_io.c
index 2e7fb335eb01..632683232622 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -265,7 +265,7 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
 
-	__swap_writeout(ctx, folio);
+	__swap_writeout(ctx, folio, folio->swap);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -336,24 +336,22 @@ int sio_pool_init(void)
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
@@ -366,6 +364,7 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 		ctx->sio = sio = mempool_alloc(sio_pool, GFP_NOIO);
 		sio->nr_bvecs = 0;
 		sio->len = 0;
+		sio->entry = phys;
 	}
 	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
@@ -386,7 +385,8 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 	}
 }
 
-void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
+void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio,
+		swp_entry_t phys)
 {
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
@@ -402,7 +402,7 @@ void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 
 	folio_start_writeback(folio);
 	folio_unlock(folio);
-	swap_add_folio(ctx, folio, WRITE);
+	swap_add_folio(ctx, folio, phys, WRITE);
 }
 
 /*
@@ -506,7 +506,7 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
-	swap_add_folio(ctx, folio, READ);
+	swap_add_folio(ctx, folio, folio->swap, READ);
 
 finish:
 	if (workingset) {
@@ -538,8 +538,6 @@ static void swap_fs_write_complete(struct kiocb *iocb, long ret)
 	bool failed = ret != sio->len;
 
 	if (failed) {
-		struct folio *folio = bvec_folio(&sio->bvecs[0]);
-
 		/*
 		 * In the case of swap-over-nfs, this can be a temporary failure
 		 * if the system has limited memory for allocating transmit
@@ -547,7 +545,7 @@ static void swap_fs_write_complete(struct kiocb *iocb, long ret)
 		 * folio_rotate_reclaimable but rate-limit the messages.
 		 */
 		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
-				   ret, swap_dev_pos(folio->swap));
+				   ret, swap_dev_pos(sio->entry));
 	}
 
 	swap_write_end(sio, failed);
@@ -619,7 +617,7 @@ static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
 	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
 			REQ_OP_WRITE | REQ_SWAP);
 	bio->bi_iter.bi_size = sio->len;
-	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio->bi_iter.bi_sector = swap_entry_sector(sio->entry);
 	bio_associate_blkg_from_folio(bio, bio_first_folio_all(bio));
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
@@ -639,7 +637,7 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
 	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
 			REQ_OP_READ);
 	bio->bi_iter.bi_size = sio->len;
-	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio->bi_iter.bi_sector = swap_entry_sector(sio->entry);
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
 		/*
@@ -657,13 +655,14 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
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
@@ -679,7 +678,7 @@ void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter)
 	struct swap_iocb *sio = ctx->sio;
 
 	init_sync_kiocb(&sio->iocb, ctx->sis->swap_file);
-	sio->iocb.ki_pos = swap_dev_pos(bvec_folio(&sio->bvecs[0])->swap);
+	sio->iocb.ki_pos = swap_dev_pos(sio->entry);
 	if (rw == WRITE)
 		sio->iocb.ki_complete = swap_fs_write_complete;
 	else
@@ -690,11 +689,10 @@ void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter)
 }
 EXPORT_SYMBOL_GPL(swap_fs_prepare_rw);
 
-bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
-		size_t prev_folio_size, int rw)
+bool swap_fs_can_merge(struct folio *folio, swp_entry_t phys,
+		struct swap_iocb *sio, int rw)
 {
-	return swap_dev_pos(folio->swap) ==
-		swap_dev_pos(prev_folio->swap) + prev_folio_size;
+	return swap_dev_pos(phys) == swap_dev_pos(sio->entry) + sio->len;
 }
 EXPORT_SYMBOL_GPL(swap_fs_can_merge);
 
diff --git a/mm/swap.h b/mm/swap.h
index 81e47dc36a02..df323d5e8da8 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -320,7 +320,8 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio);
 void swap_read_submit(struct swap_io_ctx *ctx);
 void swap_write_submit(struct swap_io_ctx *ctx);
 int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
-void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
+void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio,
+		swp_entry_t phys);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 67a2399cf1ae..af6a162c4450 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -342,14 +342,14 @@ offset_to_swap_extent(struct swap_info_struct *sis, unsigned long offset)
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
index 3466c80ac188..c2430dbfc653 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1094,7 +1094,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writeout(&ctx, folio);
+	__swap_writeout(&ctx, folio, folio->swap);
 	swap_write_submit(&ctx);
 
 out:
-- 
2.53.0-Meta

