Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792562618;
	b=kGGBdtdmX2l0qXfd7QocCs1flShDIOxplR3swYKovHTysHDCtBnqh/TmO7hJJObr4Hsu
	 b50U9tpfbgNoGm4CPlQ2CVSopH6vmlFwm/BBLQAAQaxRsWeMswOuMX7FFROr+YROVYIkY
	 Iaa83krdpxL1YnjgCuTy9k9bKtqpYKNILLQnDxj3SnU5R0uzi552c482mIWpviiS/i8zp
	 ZYaCfeqRCSH/uXPIhXmr4tb5AzPFYoqtpsUuVMknwm9QqIdS4g4Avc7N4x0deBt2ozVn7
	 N8VJkOetx/8s0HYW9be0i3/JaH2I+JfWxjHa5eCK+nSYsuZpYuVyryC7LmmkMKXKuvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792562618;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dNeuvlXkDtmzEanbiS7+cKjYAzmaJIW02TKw/krsK3M=;
	b=4S0b5KfthB4LPK5whs669kpgrb0SBNdba8XIBmIv/6nO5w8Ac2vl61zNUWJMWDOIV4u4
	 h1xufH8oDH6qmn7uwkrOOuV8pndBUdLl97R869ErD0cgclcMDr53DySqXH0nRF0stS2M1
	 TnTejLuZWsnUIzrqSO2c/BRctWG/Q7D4C6QhAanjlC3v2BXBoGTp3/Cqqa/3oQMND+LL+
	 8YWNsIfJNStyjYXGMJAReXV3KmqN+YtPwVFyD46ZVjmsTX9NhRBP8ESQjJS2VhxSEq72D
	 hCIJqDqZvMlWUJ8M15iqN4vXD2Ga8J6QAEGA9oVlFWAiefbY1t7iJWlHn7ADs8Jricw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pkLYeSmp;
	arc=none smtp.remote-ip=209.85.128.177
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67F460A2613
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 06:03:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A67F460A2613
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pkLYeSmp
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8ab3d3c5761so3117197b3.1
        for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 23:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792562617; x=1793167417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dNeuvlXkDtmzEanbiS7+cKjYAzmaJIW02TKw/krsK3M=;
        b=pkLYeSmp3K2heI9H91i1L6VD/mLumW6KSD6pL5WdXGB7/XZ3n0SnjIOxChNrMsiShs
         0CjATZ59H1UEL79o2Pov02Yu02TiIG/8vAZoIK0IF/fsAAia6QvEDHtcOsqMIpI64Woq
         psFmDJa3PqlycRJCjt29dsEqZn0tzEROycw4FVjwIvGYIZAohGQR8T/uNcydGTByGSJn
         Yowj1QMSoblTu54CEB53MP191kjIeO+vhx7Un+SM3xtFrVCdydwO257cIM/l08pE8CCX
         THu0UwkZJ7WpY9+AjBEFtw9ISXS/fN8dkQ4hv+TqdrF0Deh2nESf/n8hdc+jk2NJYPOK
         YjKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562617; x=1793167417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dNeuvlXkDtmzEanbiS7+cKjYAzmaJIW02TKw/krsK3M=;
        b=knkpMHAPxTI2V01ObB9wsKsU66xGZM1EkziU7V16uBtHvDIEx93aBmSuT9CBLjRR1b
         fnOK8ED7L7SfuLajjNbfafIs4GAM6vmgkphoxxYILuHuyFTBRI9qoLFLMLYoLFIvKVmx
         n+YYzNy4QFKMStkFRtBF7n/QFs/PpUPnRO9Vt/22sg+/osoYGmcycViOcmeXrbcsq7qF
         KlRahWfgqQFSqTdZ/MYmYX9z5qEauWjNGhVa5IT+CwabswLwy/PSuk4zF33mOWSckc73
         Vv+bphSxeAVaBAq8CprJIgnG/2isJY8UFFRxQ93WjqMIKJsjgskbwn92RERS8sUnV9xo
         nokA==
X-Forwarded-Encrypted: i=1; AKwUvBzmsRQcTgxMEP+MzRpqGpnaH5IUQngDMmjE5q94rwxpSGMuJEesbUOn7PwOQsrp1dTOTJ8B4fam@vger.kernel.org
X-Gm-Message-State: AFq9FYLkRizyWqBPn/7Pc5OEYM2cP/SXuz2Z90uvz/WMRbJbuLArqZbV
	lBE0scuqKvcsNW/Yv9ISL5DCyb19olMY5wxbft0hQrqjGg6XKxgP5T1n
X-Gm-Gg: AYBFou1V6S/2tprEpsJx948x4euhXI0uRM5bCeYIbjSzvaaEtlJa3XwwTfy8HvbS2+e
	0KvDJxQTUaDg7B0/LjcR3YbKdSij+RtAdFD1yPs9za70VnQDVvj65JSd8iYDLrXk3IijOHxyTpd
	zWeBowbihXtVsEZ0nAI1BATByv66b6iF4w9P70oops44MOozNOrI3sRLgusIuULMySawjdVb6ya
	gnxZz4zj654k76XwiEkHHl4fUvjqMxp/K0Ki6hzRfPK7H3t85YMgJm92vGnoRsMuOcH6yJMrsRQ
	4vnKHlK2BkL3aukA+hAq2m5P8nbnXzwhMJsXAFWf0xk5jzROzLCrubdSNuUtOuOmQFp3aEUDlx1
	tQ2+yVVxyOjWukwrpP8Mh2hclL4bpmpfMt59TVZ3Fbzp1IbK22S0egTufsD8ShWSfx4YQQIQO5t
	Ci0KgN3SvgvdQpQoyJhPUIWGB5easiHTDXU3Ah52udKQx0GbwYCxEKTExKdx8q+uTuLZcXBQ7ys
	M3Aa/oXpFTBaEDGgDYhOX8x6P1IMAtNft9Z+J3czuTnwK/I6DyLedMP7XHOFhEtB9vl/fifFxgq
	x5W7gy5ChhjebjY/skzwShXFarjGe3oWh0AklshqW1Np+WWtCp+ZeWw68RqCHxxO
X-Received: by 2002:a05:690c:e3c3:b0:8af:1843:a9e5 with SMTP id 00721157ae682-8b133d0636bmr5788747b3.23.1792562616594;
        Tue, 20 Oct 2026 23:03:36 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:42::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1300c85c9sm7295167b3.23.2026.10.20.23.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:03:34 -0700 (PDT)
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
	rdunlap@infradead.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v6 03/12] mm, swap: prepare the swap IO path for vswap
Date: Tue, 20 Oct 2026 23:03:14 -0700
Message-ID: <20261021060323.553433-4-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021060323.553433-1-nphamcs@gmail.com>
References: <20261021060323.553433-1-nphamcs@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
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

Carry reclaim's NOFS restriction in the I/O context. A subsequent patch
uses it when zswap_store() fails and writeout falls back to physical swap.

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
 include/linux/swap_ops.h | 10 +++++---
 mm/page_io.c             | 54 +++++++++++++++++++---------------------
 mm/swap.h                |  3 ++-
 mm/swapfile.c            |  6 ++---
 mm/vmscan.c              |  4 ++-
 mm/zswap.c               |  2 +-
 7 files changed, 42 insertions(+), 39 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 1479914d545d..4066d99f896e 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -414,7 +414,7 @@ extern int __swap_count(swp_entry_t entry);
 extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
-sector_t swap_folio_sector(struct folio *folio);
+sector_t swap_entry_sector(swp_entry_t entry);
 
 /*
  * If there is an existing swap slot reference (swap entry) and the caller
diff --git a/include/linux/swap_ops.h b/include/linux/swap_ops.h
index 57ac6c703f68..1c65e346e127 100644
--- a/include/linux/swap_ops.h
+++ b/include/linux/swap_ops.h
@@ -12,11 +12,13 @@ struct swap_iocb {
 	struct bio_vec		bvecs[SWAP_CLUSTER_MAX];
 	int			nr_bvecs;
 	int			len;
+	swp_entry_t		entry;	/* first slot in the batch; addresses the IO */
 };
 
 struct swap_io_ctx {
 	struct swap_iocb	*sio;
 	struct swap_info_struct	*sis;
+	bool			nofs;
 };
 
 /*
@@ -30,15 +32,15 @@ struct swap_io_ctx {
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
index f849c285ba22..61bb5c6e9759 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -263,7 +263,7 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
 
-	__swap_writeout(ctx, folio);
+	__swap_writeout(ctx, folio, folio->swap);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -338,24 +338,22 @@ int sio_pool_init(void)
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
@@ -368,6 +366,7 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 		ctx->sio = sio = mempool_alloc(sio_pool, GFP_NOIO);
 		sio->nr_bvecs = 0;
 		sio->len = 0;
+		sio->entry = phys;
 	}
 	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
@@ -388,7 +387,8 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 	}
 }
 
-void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
+void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio,
+		swp_entry_t phys)
 {
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
@@ -404,7 +404,7 @@ void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 
 	folio_start_writeback(folio);
 	folio_unlock(folio);
-	swap_add_folio(ctx, folio, WRITE);
+	swap_add_folio(ctx, folio, phys, WRITE);
 }
 
 /*
@@ -508,7 +508,7 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
-	swap_add_folio(ctx, folio, READ);
+	swap_add_folio(ctx, folio, folio->swap, READ);
 
 finish:
 	if (workingset) {
@@ -540,8 +540,6 @@ static void swap_fs_write_complete(struct kiocb *iocb, long ret)
 	bool failed = ret != sio->len;
 
 	if (failed) {
-		struct folio *folio = bvec_folio(&sio->bvecs[0]);
-
 		/*
 		 * In the case of swap-over-nfs, this can be a temporary failure
 		 * if the system has limited memory for allocating transmit
@@ -549,7 +547,7 @@ static void swap_fs_write_complete(struct kiocb *iocb, long ret)
 		 * folio_rotate_reclaimable but rate-limit the messages.
 		 */
 		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
-				   ret, swap_dev_pos(folio->swap));
+				   ret, swap_dev_pos(sio->entry));
 	}
 
 	swap_write_end(sio, failed);
@@ -621,7 +619,7 @@ static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
 	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
 			REQ_OP_WRITE | REQ_SWAP);
 	bio->bi_iter.bi_size = sio->len;
-	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio->bi_iter.bi_sector = swap_entry_sector(sio->entry);
 	bio_associate_blkg_from_folio(bio, bio_first_folio_all(bio));
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
@@ -650,7 +648,7 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
 	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
 			REQ_OP_READ);
 	bio->bi_iter.bi_size = sio->len;
-	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio->bi_iter.bi_sector = swap_entry_sector(sio->entry);
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
 		/*
@@ -668,13 +666,14 @@ static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
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
@@ -690,7 +689,7 @@ void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter)
 	struct swap_iocb *sio = ctx->sio;
 
 	init_sync_kiocb(&sio->iocb, ctx->sis->swap_file);
-	sio->iocb.ki_pos = swap_dev_pos(bvec_folio(&sio->bvecs[0])->swap);
+	sio->iocb.ki_pos = swap_dev_pos(sio->entry);
 	if (rw == WRITE)
 		sio->iocb.ki_complete = swap_fs_write_complete;
 	else
@@ -701,11 +700,10 @@ void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter)
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
index d0e7c991a4c0..b0a092b47fce 100644
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
index 81ac45b4856e..69fac2d905a4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -341,14 +341,14 @@ offset_to_swap_extent(struct swap_info_struct *sis, unsigned long offset)
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
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4c5f0f97c1c7..b9c5e92757f3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1172,7 +1172,9 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	unsigned int nr_reclaimed = 0, nr_demoted = 0;
 	unsigned int pgactivate = 0;
 	bool do_demote_pass;
-	struct swap_io_ctx ctx = {};
+	struct swap_io_ctx ctx = {
+		.nofs = !(sc->gfp_mask & __GFP_FS),
+	};
 
 	folio_batch_init(&free_folios);
 	memset(stat, 0, sizeof(*stat));
diff --git a/mm/zswap.c b/mm/zswap.c
index 1ba191cbc26f..73c6b82aa593 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1159,7 +1159,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_put(folio);
 
 	/* start writeback */
-	__swap_writeout(&ctx, folio);
+	__swap_writeout(&ctx, folio, folio->swap);
 	swap_write_submit(&ctx);
 
 	return 0;
-- 
2.53.0-Meta

