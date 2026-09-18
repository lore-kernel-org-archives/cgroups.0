Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952C751C33D
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 18:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789754579; cv=none; b=EUWgOd+igFNUpmKIWE30F7wG4x1wrOLtsXev3XAZM/jhqWK7KtQ8ZRTDNaPSI4BqCeuKdlvbbiHnMsUu7MitWfGwnZrrgooYollOmVcUN3xTgTE1IvaF4U2zoOLVGMkXQkVmGfDixnv9zh3h/rfkjeEILlbtj0+5DzGyplJkZLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789754579; c=relaxed/simple;
	bh=4gZxRi8s9AvaXJeqTNZNQaZREkrt6u2IyZlzTPcet/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvQ9f/FhyendpRvYfWVzRGjZkIw4OA4ZeUr2rPHDed7DFeJMCfv1I/NXNs+2PIiI2ExUT1NDxdSwJ0fQb6/kUb84w6/UGn5FsIglGw1lW5yozX0xFzWh13hGTT1YeSCDGSGF1sBQkjV1NpyU7BQs6zl/zq8X5RMVEFofo/4KAPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NHRK1fW7; arc=none smtp.client-ip=74.125.231.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NHRK1fW7"
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4c2c08ff3f8so783189b6e.1
        for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 11:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789754574; x=1790359374; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wHkgIfdkKYj8pIFBCxdLHIsV2Dv3mqE/3ti2RlbB1g0=;
        b=NHRK1fW7E+laUZ4ltR98byxU3hHbcBIvad1I4rskbHrwoVHM1nH/smR5kY+lATMg86
         CINiimukzZAMi7eQSOApt6+wamZBquiwL0Mt9D9LVH9t3a3s6it5whBxH1eBBSUwnlTJ
         O8inhLuEXzDoR99Ques5yrfCjEyoFGFjIPhYKycxAHuAm8XhdKoMN4hV6Uw09UKBY87n
         coBFGD7HXErx1Psl4w49G5dSnlhTYSMN0yYaUoxH93AVqV1/WZdQ3i9Co/IP2qchsahY
         DD0i18zm0iJlXvFPxVZuFLAVrrU8aHyd5Yb9SzTTnWJl9T7HdnQ8ZiPq1O5ySon6dYLL
         WMvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789754574; x=1790359374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wHkgIfdkKYj8pIFBCxdLHIsV2Dv3mqE/3ti2RlbB1g0=;
        b=wH10Jg1fMZB2DGznRzZTYopqYspNBlHnGNKnruv7JMFys6UTwDnj3cQUzlyF25hFiP
         ry9u2nzsUbZiOLygTjc346z3PMYKgvZ23Uc6m0643OzCwYaKddz6b1WmqrkQRZ1gRDgn
         /TJvAdES6et0iHJRUKyqczkI/MY7bzbOuL85RSWn1x07rZ4JQ5fJqpQ/6aCQqHe4pys+
         BD+4A5fyjDaQ77oFiKgbr3iTsMWlkyRZdfCRpt7/IgurYmGRPsxQv8PAZaMzeMP+SQTu
         PekiNt7Tl16zextupppjkoIjl2ZY1xMPm0sA/otjwsmhbzJcQnNCQIYHo/cpzDm+L1Km
         YYXw==
X-Forwarded-Encrypted: i=1; AKwUvBxYfvwJzwbqv5TJQBKWVQ9F9nF1aQLxDSleXMt9Wpl5rE/dh4fm6SUIxYsvw3ZyrxPukacgnVLv@vger.kernel.org
X-Gm-Message-State: AFuF++kePvrjIrr0ytxkd9TsArTxPgVgIBWV7LCxF2Gh/KS9//4fsEL1
	D1CmcIk7KAk0bsxU1jj6N+4ukbNcdVL7M3M7XDBSvq28dxgT4cmUopOM
X-Gm-Gg: AYBFou0EiXOJKxOKtWRU3KvK7n672CgaPI8we073o4eSOv2BrChZy5WlPy3lm2gYP3V
	HjQITy/F6aRGOXBEXjyOO/eD9yBtmmG2gSkdoFwiIB7Gv7aYSbKrhOsZ0Lk0MbpWhJ0EGkirJCk
	YClbNkoFKExHPLoS85pErocgak+PLpDyltbqnhOMsE1Fz9HgBaJ4KZXW88vQ/EZ8z2ShQmnifam
	1h4hBzsO1EiqRWESciXo2GbxUod3wpptOgUgylT+lHXCK012GoLhSugjx6zdvn6F8qrGo2wb4V0
	NZgQTVaQnrN1KFdOBlESdC4KVrPF3lBA5vCdGJjgLLVhTbjyNUs75Z753ojZ/nnSXMBJodC/swO
	bTYSqTka8BUyq12jFaG5S0SVhtWDJbj2Ay21tUao8tOg9GuW5FK2bwM57MwY1HTidsv5zHxUq9N
	XQUZKm1OAHBCsal/SgeJVwyMUfHgzSx2OfQ4bEtqHKJuO+RlVwGPKVJoInp9ZFmrE9Fb6spZwix
	xMWZzGtJxE8s9TgolX3
X-Received: by 2002:a05:6808:3c47:b0:4b9:a829:f016 with SMTP id 5614622812f47-4ccf74b986fmr3815644b6e.34.1789754573817;
        Fri, 18 Sep 2026 11:02:53 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-8107dd8bd0esm154912a34.5.2026.09.18.11.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:02:53 -0700 (PDT)
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
Subject: [PATCH v5 06/11] mm, swap: write back vswap zswap entries to physical swap
Date: Fri, 18 Sep 2026 11:02:36 -0700
Message-ID: <20260918180241.3424851-7-nphamcs@gmail.com>
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

Add support for writing back zswap-backed vswap entries to physical
swap. The mechanism mirrors the existing zswap writeback path, except
the backing physical slot is allocated on demand at writeback time
rather than already being pinned by the PTE.

The zswap shrinker no longer skips vswap entries, unless we are out of
physical swap space.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/zswap.c | 67 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 21 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 3e1aa295f9dd..56315298c291 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1025,12 +1025,13 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 static int zswap_writeback_entry(struct zswap_entry *entry,
 				 swp_entry_t swpentry)
 {
-	struct xarray *tree;
 	pgoff_t offset = swp_offset(swpentry);
 	struct folio *folio;
 	struct mempolicy *mpol;
 	struct swap_info_struct *si;
 	struct swap_io_ctx ctx = {};
+	swp_entry_t phys = {};
+	bool is_vswap;
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -1038,12 +1039,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (IS_ERR_OR_NULL(si))
 		return -ENOENT;
 
-	/* Vswap entries have no physical backing to write to. */
-	if (swap_is_vswap(si)) {
-		put_swap_device(si);
-		return -EINVAL;
-	}
-
+	is_vswap = swap_is_vswap(si);
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
 				       NO_INTERLEAVE_INDEX);
@@ -1062,24 +1058,44 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	/*
 	 * folio is locked, and the swapcache is now secured against
 	 * concurrent swapping to and from the slot, and concurrent
-	 * swapoff so we can safely dereference the zswap tree here.
+	 * swapoff so we can safely dereference the zswap tree (or vswap
+	 * vtable) here.
 	 * Verify that the swap entry hasn't been invalidated and recycled
 	 * behind our backs, to avoid overwriting a new swap folio with
 	 * old compressed data. Only when this is successful can the entry
 	 * be dereferenced.
 	 */
-	tree = swap_zswap_tree(swpentry);
-	if (entry != xa_load(tree, offset)) {
+	if (entry != zswap_entry_load(swpentry)) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	if (is_vswap) {
+		/*
+		 * Allocate physical backing before decompress so a failure
+		 * wastes no work.
+		 */
+		phys = folio_realloc_swap(folio);
+		if (!phys.val) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+
 	if (!zswap_decompress(entry, folio)) {
 		ret = -EIO;
+		/*
+		 * The phys allocation above took the entry out of the vtable.
+		 * Restore the zswap entry to the vtable, which also frees the
+		 * allocated physical swap space.
+		 */
+		if (is_vswap)
+			vswap_zswap_store(swpentry, entry);
 		goto out;
 	}
 
-	xa_erase(tree, offset);
+	if (!is_vswap)
+		xa_erase(swap_zswap_tree(swpentry), offset);
 
 	count_vm_event(ZSWPWB);
 	if (entry->objcg)
@@ -1094,7 +1110,10 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writeout(&ctx, folio, folio->swap);
+	if (is_vswap)
+		__swap_writeout(&ctx, folio, phys);
+	else
+		__swap_writeout(&ctx, folio, folio->swap);
 	swap_write_submit(&ctx);
 
 out:
@@ -1109,6 +1128,15 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 /*********************************
 * shrinker functions
 **********************************/
+/*
+ * vswap zswap entries get a physical slot allocated on demand at writeback
+ * time. Skip the shrinker when none is available.
+ */
+static bool zswap_writeback_possible(void)
+{
+	return !vswap_is_enabled() || get_nr_swap_pages() > 0;
+}
+
 /*
  * The dynamic shrinker is modulated by the following factors:
  *
@@ -1246,7 +1274,7 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	if (!zswap_shrinker_enabled || !mem_cgroup_zswap_writeback_enabled(memcg))
 		return 0;
 
-	if (vswap_is_enabled())
+	if (!zswap_writeback_possible())
 		return 0;
 
 	/*
@@ -1332,7 +1360,8 @@ static struct shrinker *zswap_alloc_shrinker(void)
  * were scanned but none could be written back, or -ENOENT if @memcg has
  * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
  *
- * Also returns -ENOENT when vswap is enabled.
+ * Also returns -ENOENT when vswap is enabled and there is no physical
+ * swap to write back to.
  */
 static int shrink_memcg(struct mem_cgroup *memcg)
 {
@@ -1341,7 +1370,7 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
 		return -ENOENT;
 
-	if (vswap_is_enabled())
+	if (!zswap_writeback_possible())
 		return -ENOENT;
 
 	/*
@@ -1372,11 +1401,7 @@ static void shrink_worker(struct work_struct *w)
 	int ret, failures = 0, attempts = 0;
 	unsigned long thr;
 
-	/*
-	 * When vswap is enabled, zswap entries are almost all vswap backed,
-	 * with no slot to write back to.
-	 */
-	if (vswap_is_enabled())
+	if (!zswap_writeback_possible())
 		return;
 
 	/* Reclaim down to the accept threshold */
@@ -1457,7 +1482,7 @@ static void shrink_worker(struct work_struct *w)
 			break;
 resched:
 		cond_resched();
-	} while (zswap_total_pages() > thr);
+	} while (zswap_total_pages() > thr && zswap_writeback_possible());
 }
 
 /*********************************
-- 
2.53.0-Meta

