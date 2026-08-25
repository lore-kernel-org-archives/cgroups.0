Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F00548822F
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 15:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787671974; cv=none; b=eDMUkz0G6/+g81tcf25SJBu8R5Wa0QuEnhcIZgEzQBCdS6fM3easNPg9k/gL4n5cxYzSeqE9rLGPxEXNrCLGW2oMMSAg1MrXRFf/bFuLzGx2sWWrOnXU0hypswd+c6fpmB136/hOo0Zo83uI40nd3sdJs6ndriw4eSGOJSVnoDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787671974; c=relaxed/simple;
	bh=I0qBM9lAgRNZAWyiQ/VCRWTAdZZsBgP8b49S427QfMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKc39hr1HC8a24SlBtF3oDeeK+7H66TuPI/Tc6g995D1OwNBIMjv+Y606kkKiPWyuXVbbsjCCWyo2gj0qpKJuGI5BP9xQKBxq6KJBcBnIPthFwcP8SvqmXWT8+avmhuTtTtdd65aOPi/HjcTqO77m6uLZ8kyhdlUyHAIih9XKyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SG7QeVPm; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SG7QeVPm"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-4b28db06775so3395504b6e.1
        for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 08:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787671966; x=1788276766; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QhSwWX2E/V88OSmZiCSHWiUU/JQeVGndYgjPiEldJdU=;
        b=SG7QeVPmcKGGQOAXP/HmVy5I4IzjUH9dKXvWYwCAYoTYlooNYOM5EWOxArQhVlvixK
         wWfJbNhD93yvMhxjv08VLmZJet9c7Il8bE2+Mt/7SboQ9ZIoRvgF3x8f9cW8ss4xib+T
         P+2eH6JoiVHkrjcgVCUYyRpMzB7yfs33Nrt/bX02ZPNB7+5QVJBvz/k3Wuq+mzlFzGyJ
         q18WQS897uIKtv3oH9ofxI4VmknSL516xAokmo5U0IJl6mlPCz/pj0Lc5LPQx+o2jWdI
         K4C8zMwwYmID+t4it3kZOzTbgv1Hu/sWWV8TiedPtiEVkdp58pC2PEBGsgkoIw2WEVRB
         UOnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671966; x=1788276766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QhSwWX2E/V88OSmZiCSHWiUU/JQeVGndYgjPiEldJdU=;
        b=qPHWXzJmBnQe7v0sLYLvCUiVm9tCjPmN9BWoSAUO4y/mgqMZ6aB01RsCE/wEMZ7/BA
         UJbvQUetNyE/BDjc6V4m0TAKtOZuL3orPpGGATupfBOrkbAWwsad8ykut/6NK2/w4JoU
         shCmd/e2OKiPbyc7Dxg6Y4+724dn/QSjhcHEGcJGSgm83dKCa9616XnGK/NjlUAeTXpD
         exbqD1KjIIwR3/XFUHTMplol9TiJD8kSmbXuKRv2xhjaavI34p3LGAx6MT3/kVapZ4Ow
         +tnVUSCr4HZnTnWuvsG1ksCBmeCrIK9tYl2YAhdpaYZrTxu9QXGZSL4gYsmehaevQD9O
         aY3A==
X-Forwarded-Encrypted: i=1; AHgh+RpavsixrV45i1iV7QE2OhyLRBFYj3nwW440xXipf405cY8hTtquikwfxY1cBANbqMh8fEyEAhBw@vger.kernel.org
X-Gm-Message-State: AFuF++m2RXEkEiNb7p+pkCihdMyWhBTBj0WSZVQ+PUUZ3x4b8/PCvYRj
	WsXy+UBLsZuKgfU56vnhx4ZkvPo6KCtR2z8RCZ+AaRamxKdhnm22syhP
X-Gm-Gg: AR+sD11zTPFs1mkxYOM4jQr4h+XIBkaLyBPQvtSa3fzJqFYQ1gAyOot6nXS+cbPuJlV
	W94+DHvrS2e16au+hmTmVdpfLPLec6PcZK/Mk8ZiEWzxhomdZq8g9vskzwx9/fsMZerCcva387Z
	nVV94e6Zzb1fAT9LQtUT9S+hAslmlZmf7Fu3ESedVQkxkzYfcSOkd1Sq/X00tPzhhr9I7982GlA
	RfIVrY9hPkk5Q4MTliZrd33asPewhJtTDLep9S3A2koCn+5f+6LtiBtdWz5Dqf/DRCfpvjIMpgE
	FagmfrPDCvrII6U3nJ5cwGt2bv6W0RJybt+PKrb8zAE+8tWuZOkaCW2w3/07WrNYoNMljFcIxfH
	Uxf5H5lSID79hwvVJERsIxcY+vqMvrLWmxteJzdPKVNMPNuH1kt2s/puILRrUvYJunZsxCvrkjj
	50HGz9MzfLmIX4Ki212MHfTeAWnc3Q2zx5LZ0AXbtFPI6XthMkjYtji4xVShNIOuWBrs5+8lM+f
	rEQudVvvT4=
X-Received: by 2002:a05:6808:448d:b0:4b3:3e1:4a25 with SMTP id 5614622812f47-4b350513b86mr7973433b6e.11.1787671966152;
        Tue, 25 Aug 2026 08:32:46 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5b::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b32c690a5asm6225953b6e.8.2026.08.25.08.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:32:45 -0700 (PDT)
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
Subject: [PATCH v4 03/11] mm, swap: prepare the swap IO path for vswap
Date: Tue, 25 Aug 2026 08:32:29 -0700
Message-ID: <20260825153238.2695446-4-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260825153238.2695446-1-nphamcs@gmail.com>
References: <20260825153238.2695446-1-nphamcs@gmail.com>
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
__swap_writepage and ops->can_merge, and stash it in swap_iocb so the
submit and completion paths address the IO from it rather than from
folio->swap.

This lets the batching path serve both vswap entries (backed by a
physical slot) and physical entries mapped directly into PTEs.

All callers pass folio->swap for now, so there is no functional change.

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
index 5339323486d5..f57f4aeeb822 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -388,7 +388,7 @@ extern int __swap_count(swp_entry_t entry);
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
index 3bc69c2dbe4d..a3aaa61d6c79 100644
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
@@ -334,24 +334,22 @@ int sio_pool_init(void)
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
@@ -364,6 +362,7 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 		ctx->sio = sio = mempool_alloc(sio_pool, GFP_NOIO);
 		sio->nr_bvecs = 0;
 		sio->len = 0;
+		sio->entry = phys;
 	}
 	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
@@ -384,7 +383,8 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 	}
 }
 
-void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
+void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio,
+		swp_entry_t phys)
 {
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
@@ -400,7 +400,7 @@ void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
 
 	folio_start_writeback(folio);
 	folio_unlock(folio);
-	swap_add_folio(ctx, folio, WRITE);
+	swap_add_folio(ctx, folio, phys, WRITE);
 }
 
 /*
@@ -504,7 +504,7 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
-	swap_add_folio(ctx, folio, READ);
+	swap_add_folio(ctx, folio, folio->swap, READ);
 
 finish:
 	if (workingset) {
@@ -536,8 +536,6 @@ static void swap_fs_write_complete(struct kiocb *iocb, long ret)
 	bool failed = ret != sio->len;
 
 	if (failed) {
-		struct page *page = sio->bvecs[0].bv_page;
-
 		/*
 		 * In the case of swap-over-nfs, this can be a temporary failure
 		 * if the system has limited memory for allocating transmit
@@ -545,7 +543,7 @@ static void swap_fs_write_complete(struct kiocb *iocb, long ret)
 		 * folio_rotate_reclaimable but rate-limit the messages.
 		 */
 		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
-				   ret, swap_dev_pos(page_swap_entry(page)));
+				   ret, swap_dev_pos(sio->entry));
 	}
 
 	swap_write_end(sio, failed);
@@ -617,7 +615,7 @@ static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
 	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
 			REQ_OP_WRITE | REQ_SWAP);
 	bio->bi_iter.bi_size = sio->len;
-	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio->bi_iter.bi_sector = swap_entry_sector(sio->entry);
 	bio_associate_blkg_from_page(bio, bio_first_folio_all(bio));
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
@@ -637,7 +635,7 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
 	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
 			REQ_OP_READ);
 	bio->bi_iter.bi_size = sio->len;
-	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio->bi_iter.bi_sector = swap_entry_sector(sio->entry);
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
 		/*
@@ -655,13 +653,14 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
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
@@ -677,7 +676,7 @@ void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter)
 	struct swap_iocb *sio = ctx->sio;
 
 	init_sync_kiocb(&sio->iocb, ctx->sis->swap_file);
-	sio->iocb.ki_pos = swap_dev_pos(bvec_folio(&sio->bvecs[0])->swap);
+	sio->iocb.ki_pos = swap_dev_pos(sio->entry);
 	if (rw == WRITE)
 		sio->iocb.ki_complete = swap_fs_write_complete;
 	else
@@ -688,11 +687,10 @@ void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter)
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
index 1cc9f3f5105e..f2b64920ae5b 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -320,7 +320,8 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio);
 void swap_read_submit(struct swap_io_ctx *ctx);
 void swap_write_submit(struct swap_io_ctx *ctx);
 int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
-void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio);
+void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio,
+		swp_entry_t phys);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index e0b603a247c0..f5fd01307a67 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -343,14 +343,14 @@ offset_to_swap_extent(struct swap_info_struct *sis, unsigned long offset)
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
index e5a9922b951a..54506935ceba 100644
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

