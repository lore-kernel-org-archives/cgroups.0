Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2053F488DAD
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 15:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787671980; cv=none; b=tTBoMMXpRsd8rMw6NMOPXc3QuYZsJi+zitP4E1LqnZ8wmH3pODzN87r51I+2nyASu+P5Izo3K4GvtPfnU+nygntj9D0QpUdIHPmicMVJUX0ZKvdhChcvsf/csXJNJaIrb5cTm4tVeV5MYC76qx2a1K4ohm+Fag/SFLuWlC8JD/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787671980; c=relaxed/simple;
	bh=dzGLx7hmRStu+44RUZgGTXgypJylAAmdzWxuKyL5v4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MfESKS5tp8ux7qyY285wdkoLmaI20fbK2SknZJoQBSDeaqSuDTr/jzqanEMew5LNmKw6w9o+oDrGhBTd9ZH4v0Ee11Idps1eTMsGT9Mj0C8wTPiuOG60CKReSZGfdse6Pol2yjjbjmNAowel1NS8GsdlyLGOrZXXh3L3jonGDP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V5f9hGjb; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V5f9hGjb"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7eb5bdb50fcso4695582a34.1
        for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 08:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787671971; x=1788276771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1juMVOhJOgcK/kg6XX4IK6P14Ov4AD2HCrXjeUjkxQU=;
        b=V5f9hGjbPzOwoM5i8m1SfnkswVKQj7oUtFUKPpLoQN5qlTiBJcuyhGbxyMf/unnn8j
         X0Bvazpe/PLXAcIlstjDndiUMdTt4FuCcuJFEJ4uSsBx1BbmRUwRqBW3ERs7h04X8tBm
         jVtR8iVlJSMRfJNaA2PjpuAT3KVLnNM1i93nWsWjBi8cU1FM+72xiUmBgOtCd7ZkHsfo
         0HQv8hbxr1uCzSGlj9suqem4c2EUzA5v0WRA3f1GOW+LdJSUbzwLGr3BSXz6vUd1m5p5
         Jz8AsEu/eOz/u2eb5dqukWVKreV18VBKx4k4zRyRWIYVh5Qra8Fy2LRzzFX5r00eoFUc
         4L1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671971; x=1788276771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1juMVOhJOgcK/kg6XX4IK6P14Ov4AD2HCrXjeUjkxQU=;
        b=mDk8eYFSy1MUvOi3yW+Oj44DJ6u1AuinZg9ls4sS9XAfq9SXIfbYGri0kBDY4gx6Tx
         N8+gyRLqvIOwnjde7AUQLkRsG6mdTQbjXZ1AzKLNz4BmIg8g4Q4dNLM0mGdalB/9twoW
         RVMg3SFnLbGkkVSoTbkdPNBQnzUUb0hYEf2sBN1iEeiHuxZGj5GPCI6nhr7q3oW0aZys
         tZIvVFknQJ0iniJD/I09N05OhpZxo351/vIU51HK5YPWqsV8q3sAI8MvUebN2SjQTl7l
         ZhlXSBqNabz4eQKRj8uHW9G5OLwPZrcWAr12fD5XfgaZvRuX9XDOJQupjopZNrbacMNs
         iACQ==
X-Forwarded-Encrypted: i=1; AHgh+RprXvG5irRQ2pVw+uFiEogncnaGPro0+SofBWW27nfy+T3Oeo0/VDwYo9DwMT37TNCJj8yQnBBr@vger.kernel.org
X-Gm-Message-State: AFuF++loMV94cwjfvokQ+yQV5uK/mbGTJrEk5n7+ap4gfdPB8D/B4tbv
	cVKg2fhf2CZRg4T+eSNnEwY9E4OftuFBFyPqXi52zB1lSIeS1mCtykhi
X-Gm-Gg: AR+sD135z9rGMBk5ekHjm+gnmi7TWuSfpU6Smb0kjEO+/Sjm/UzWk27LleQjJiDtYCA
	bo0pEJGp2wWDs2sA62vSL3Z0AfHweBGeblNWwVFXxeAABGjLtY9e3Ire+zwsjstMcImZd4S+DKi
	JhA3cR/ZxT+Q2kQn55UIxXb+ByYrzuBhV7gMk8fJJWDJJYaf+UDhMttAegbsx53I/jEVxfxykeI
	X15UsQX+YtRPzE4CbOWe8KjC5Auu7EEbU72AJGShwATWBJAj2xA5b0DQHvFYkrTV5Q093xEpYHk
	Im7cpZZZt9jqNpjSoKjfq+XYOx8+7wAYKWHFLa1BiHyAf2lju4iiupnN960I+zLMiYQcESXZ4Uk
	kEOO+HY9PICWjWvZSYsK7CewHt2skBRGWC1ThI+xgrrrCeC+CVoGJNncQwNpX8/kepAjoQ6qYGR
	EnmpmIXaeQKviI00B8aOR2/t/3aqBzVbtjCfCxPijs2vJfL92DlY059LXdFQHKva3J9n6+Ci7vL
	fnYmXoUwS0=
X-Received: by 2002:a05:6830:448f:b0:7eb:3af8:8c1a with SMTP id 46e09a7af769-7f4af99833dmr6541276a34.9.1787671971139;
        Tue, 25 Aug 2026 08:32:51 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:70::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f48fc4f427sm6969227a34.16.2026.08.25.08.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:32:50 -0700 (PDT)
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
Subject: [PATCH v4 06/11] mm, swap: write back vswap zswap entries to physical swap
Date: Tue, 25 Aug 2026 08:32:32 -0700
Message-ID: <20260825153238.2695446-7-nphamcs@gmail.com>
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
index f16c0b44b5d5..70ad8010f18a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1007,12 +1007,13 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
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
@@ -1020,12 +1021,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (!si)
 		return -EEXIST;
 
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
@@ -1044,24 +1040,44 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
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
@@ -1076,7 +1092,10 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writepage(&ctx, folio, folio->swap);
+	if (is_vswap)
+		__swap_writepage(&ctx, folio, phys);
+	else
+		__swap_writepage(&ctx, folio, folio->swap);
 	swap_write_submit(&ctx);
 
 out:
@@ -1091,6 +1110,15 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
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
@@ -1228,7 +1256,7 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	if (!zswap_shrinker_enabled || !mem_cgroup_zswap_writeback_enabled(memcg))
 		return 0;
 
-	if (vswap_is_enabled())
+	if (!zswap_writeback_possible())
 		return 0;
 
 	/*
@@ -1314,7 +1342,8 @@ static struct shrinker *zswap_alloc_shrinker(void)
  * were scanned but none could be written back, or -ENOENT if @memcg has
  * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
  *
- * Also returns -ENOENT when vswap is enabled.
+ * Also returns -ENOENT when vswap is enabled and there is no physical
+ * swap to write back to.
  */
 static int shrink_memcg(struct mem_cgroup *memcg)
 {
@@ -1323,7 +1352,7 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
 		return -ENOENT;
 
-	if (vswap_is_enabled())
+	if (!zswap_writeback_possible())
 		return -ENOENT;
 
 	/*
@@ -1354,11 +1383,7 @@ static void shrink_worker(struct work_struct *w)
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
@@ -1439,7 +1464,7 @@ static void shrink_worker(struct work_struct *w)
 			break;
 resched:
 		cond_resched();
-	} while (zswap_total_pages() > thr);
+	} while (zswap_total_pages() > thr && zswap_writeback_possible());
 }
 
 /*********************************
-- 
2.53.0-Meta

