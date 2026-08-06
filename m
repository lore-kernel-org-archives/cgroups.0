Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6610E3BA235
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 18:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786041797; cv=none; b=BtJPyF3TSHKAgQ7xDKYG1JxKxy6hWBufyBpWgSqpg7ybr7MpZuS5VIbtjO1uPLRoGsGUzKVpP26zEqPDU3oCXSx/q2uDQPFNApmXBKufrlsgwrKl/BW87OJdnglJX1PF2VwWofp2DhIk/nnUG3MjBerVvDvrgh7fyLkQADVT99s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786041797; c=relaxed/simple;
	bh=kUgIWKYFgahkHMUnPHN6PokGq9uBRZ5QpQiL27RcoVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdNYMgGrMvt6VbEEtMgw4Rm4mpU7eC24Xi08bZPI6XFF+EvaylKyGQeo1fjzMKVfQx+LZ8H9n+wSNWV74uhX5MTaAm1jWnqUZChYFYSdSxpCyR0S6xalpX8rDcT4bxc72x4krVMFcQC4ydgER+UKMhdyYqn2HUA4qqWj3AH42P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hywnn4mg; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hywnn4mg"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7e6b554044fso2369351a34.0
        for <cgroups@vger.kernel.org>; Thu, 06 Aug 2026 11:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786041792; x=1786646592; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6q7yoTOhS8xVdFoqcdm5Nyx0rOXnYxJmiHBoOvthnIM=;
        b=hywnn4mgf3I5l8Rr1u+ZDavWqsSeQbYLOkXATsuEurMB66Ye8aIKLNj5hBxrt2ZTQp
         69Uvh7CGgZQQMgQOSJOQFxOUyXlWupnl6IhwDKgRblrneRWjgxhLMBNGf8h6FPWBQ0ro
         VGKZ7XQs6SuJit/gRscc/4nF/tIHr/jWL/nugBgOrTycGUN7fmvMJEACzn7+K8UFyxN4
         N+B/bWUvqtdk8gCXRPmp3n84+FB1J3MDEhb0VuA7QvqLIbzTwMczcSyiX+EEXuUIbRjn
         UmRgS90YEikSE6Bf4Vnt4Vx7relOmMMqhk815P04ppX1CQLOo9oMh0EE3dvUy/gXGsbA
         zDUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786041792; x=1786646592;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6q7yoTOhS8xVdFoqcdm5Nyx0rOXnYxJmiHBoOvthnIM=;
        b=Oy7LvN/tgSS3u8mTwUq65+xMd1EidqSNvuWcHAYrqrrdWKaRAEEDCkNUdtIrl4R1m0
         N/fDkvPmQsvkdu3x4isfCLNJaXiSi3q8WPZB/E81IRLfAU4ZG78592NnkNxBehQs/POv
         05v3e38ShcJyjsLKeaMT/2hGs618ojmmhd3USDQ7V8fMQVVmquSdXK6l5+ETdYaFMK7M
         dgCBwT0LBp7lDhacxx92Otyabfxg+mDf7cuNMhTKRQoJhDRB0dRJU30fAj8sS3aH8y3B
         D6itovMrC0ri8DZwK3ybq24qm8S9btERi9XsnRSGQSlGF6mlI9/2gPS8BaQ44BSuPb/L
         v+eQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrju+GHUuIE+hN20nubI+fMPoHOXg4Bbl5qErC8A8vl5TKeBCNJ16UvGrDNtoIzN55k0iT2qcIN@vger.kernel.org
X-Gm-Message-State: AOJu0YzCUiU4/3MSGaARyZz4TpFEzKAoS0jfdK3ALWwN3kgdwDDV93aw
	8DVh196FftnYRgcGwNrHhDS7xDvrwgtZ+R6k1GVbDQUi4jynnuOV+tgB
X-Gm-Gg: AR+sD11/SkuOTh6aasLpGQZNJqDZQ9ixknK+FL+ePHerdhILLHv/ETtjD9gIwTTGky7
	7XC2rDgGYTRyl5vsXT/TOc1c/PNkjJZebKUdz63JjEph7EKJT0JVUyyPo5B1vfxyWgFbY3g96up
	kJOs5HWQqoK73OnNv8Q0BZw7Ks28Afa7he/KvonGBZVQoPIl0Tjfz5SXi14qgTh/ALcIh0UUPZp
	N1TPdxjl+CGiGXXiVCNOrvvsIV/Gp55bF0hYEWYFlTNqBTlmQiYdtMPFFDCE88HSJNttVNOcpjR
	oUA51m9XxExnDevQJD6/BTrdL+12bWgAScCB90L1ofxGQrrywR6AiW6UTTIIsk6dHeo0dWzNYLY
	I2s0R4pe5I9EvIu00rZfv3zdfPTRog/1G+M7PqMp2evIRgBryZsW5FSOdJ4h3/55OEY7SjSLjfH
	xMuC1t+nGG3En7Yd2bLsiEcfwO8dGgGiYgB8CtpgKEjf3f7HfyhiHLY74TD8oGmBuF+AGLuwnNl
	hsWk5OlKclyjVQ9gg==
X-Received: by 2002:a05:6820:c8b:b0:6ac:8e23:3078 with SMTP id 006d021491bc7-6ae96c10021mr8748486eaf.5.1786041791947;
        Thu, 06 Aug 2026 11:43:11 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b02bc2631esm203436eaf.4.2026.08.06.11.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:43:11 -0700 (PDT)
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
Subject: [PATCH v3 10/11] mm, swap: defer memcg_table allocation for physical swap clusters
Date: Thu,  6 Aug 2026 11:42:53 -0700
Message-ID: <20260806184254.3790858-11-nphamcs@gmail.com>
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

Stop allocating a memcg table for every physical swap cluster that only
ever holds vswap backings. The table costs SWAPFILE_CLUSTER *
sizeof(unsigned short) per cluster, 1 KB per 2 MB of swap on a 64-bit
kernel with 4 KB pages. On a vswap-heavy workload, where zswap writeback
is the only consumer of physical swap, that is the common case.

Such clusters never have their memcg_table read or written: vswap-layer
charging records on the vswap cluster's table, not the physical one.

Allocate eagerly only when the cluster is known to need a table: any
cluster in a !CONFIG_VSWAP build, or any vswap cluster. For physical
clusters in CONFIG_VSWAP builds, defer to alloc_swap_scan_cluster(),
which allocates on the first direct-use slot and skips entirely when the
cluster only holds pointer-tagged vswap backings.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index b4d7af21ca1c..65559647eeb4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -492,7 +492,8 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
 		 swap_cluster_free_table_folio_rcu_cb);
 }
 
-static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
+static int swap_cluster_alloc_table(struct swap_info_struct *si,
+				    struct swap_cluster_info *ci, gfp_t gfp)
 {
 	struct swap_table *table = NULL;
 	struct folio *folio;
@@ -515,7 +516,16 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 	rcu_assign_pointer(ci->table, table);
 
 #ifdef CONFIG_MEMCG
-	if (!mem_cgroup_disabled()) {
+	/*
+	 * Allocate memcg_table eagerly only when we know it will be used:
+	 * any cluster in a !CONFIG_VSWAP build (all slots are direct use),
+	 * or any vswap cluster (every vswap alloc records memcg). Physical
+	 * clusters in a CONFIG_VSWAP build defer to alloc_swap_scan_cluster,
+	 * which allocates on the first direct-use slot and skips entirely
+	 * when the cluster only holds Pointer-tagged vswap backings.
+	 */
+	if ((!IS_ENABLED(CONFIG_VSWAP) || swap_is_vswap(si)) &&
+	    !mem_cgroup_disabled()) {
 		VM_WARN_ON_ONCE(ci->memcg_table);
 		ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
 		if (!ci->memcg_table) {
@@ -589,8 +599,8 @@ swap_cluster_populate(struct swap_info_struct *si,
 		lockdep_assert_held(&si->global_cluster_lock);
 	lockdep_assert_held(&ci->lock);
 
-	if (!swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					  __GFP_NOWARN))
+	if (!swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					      __GFP_NOWARN))
 		return ci;
 
 	/*
@@ -608,8 +618,8 @@ swap_cluster_populate(struct swap_info_struct *si,
 	if (!swap_is_vswap(si))
 		local_unlock(&percpu_swap_cluster.lock);
 
-	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					   GFP_KERNEL);
+	ret = swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					       GFP_KERNEL);
 
 	/*
 	 * Back to atomic context. We might have migrated to a new CPU with a
@@ -911,7 +921,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 
 	ci = cluster_info + idx;
 	/* Need to allocate swap table first for initial bad slot marking. */
-	if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL))
+	if (!ci->count && swap_cluster_alloc_table(si, ci, GFP_KERNEL))
 		return -ENOMEM;
 	spin_lock(&ci->lock);
 	/* Check for duplicated bad swap slots. */
@@ -1193,6 +1203,20 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 			if (!ret)
 				continue;
 		}
+#ifdef CONFIG_MEMCG
+		/*
+		 * Lazy-allocate memcg_table on the first direct-use slot of a
+		 * physical cluster.
+		 */
+		if (IS_ENABLED(CONFIG_VSWAP) && folio &&
+		    !folio_test_swapcache(folio) && !mem_cgroup_disabled() &&
+		    !ci->memcg_table) {
+			ci->memcg_table = kzalloc_obj(*ci->memcg_table,
+						      GFP_ATOMIC | __GFP_NOWARN);
+			if (!ci->memcg_table)
+				goto out;
+		}
+#endif
 		if (!__swap_cluster_alloc_entries(si, ci, folio, offset % SWAPFILE_CLUSTER))
 			break;
 		found = offset;
@@ -1259,7 +1283,7 @@ static unsigned int alloc_swap_scan_dynamic(struct swap_info_struct *si,
 	spin_lock_init(&ci_dyn->ci.lock);
 	INIT_LIST_HEAD(&ci_dyn->ci.list);
 
-	if (swap_cluster_alloc_table(&ci_dyn->ci, GFP_ATOMIC)) {
+	if (swap_cluster_alloc_table(si, &ci_dyn->ci, GFP_ATOMIC)) {
 		kfree(ci_dyn);
 		return SWAP_ENTRY_INVALID;
 	}
-- 
2.53.0-Meta

