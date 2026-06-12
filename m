Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E1237C106
	for <cgroups@vger.kernel.org>; Fri, 12 Jun 2026 19:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781293074; cv=none; b=pnzsSg2rEcbOCtLqm1Jz614PQ+J6DJ9SHW7aWXr+pNWeVyI2Jfz9SAi7rkr/0Xe4ZeZeICMKxh36SL2SiueWwQyEmLW0ZvZPiisFPApeVVph1SB4lw72FGZMriFzgY4A8v1bj4qowln3sBUcZuWaeYSlocEyy05R6fm1yfODJF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781293074; c=relaxed/simple;
	bh=boT4hTmiJb4CYITTUAWnpqWSqFVMJOJQMg2yKrFCTAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MS3kEHvi2bwFsbC9b8AJJy7Thm0UvW6BgZcENSxktbVDzPbR3epmugr0ccMLZQ3POEkiyFXrfS/9NSrlumjjUHcIGOF4wENVXKijByjyjuEcXjnBrELmLNG3jLdtDdbxfBIoLy5y7ZbRvp5Db2S9Bo1A37DUg90SEgeR+j24llA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oclwqe+G; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oclwqe+G"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-43d2ff651f2so1142252fac.2
        for <cgroups@vger.kernel.org>; Fri, 12 Jun 2026 12:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781293072; x=1781897872; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wF1YM3iIffsWq3aue3unk5VZq1rQajY4MddWtIHftpQ=;
        b=oclwqe+G1ooR/70JDiZkNs1EWc65NhyHQR7MMbni8WrsB0H2AWlWs1zSCW3b3gimEz
         56q+IEW6clVgo8eEIeMkWj+QkdxfStgz7lenh7Nwrjp3EuDtVKCtClmkmB7lzecg97ho
         ZmuaPT3WVqxLtbbC94HE507c+VZfIREAo/NpFEFMF/pIFdrha+y2wyv33y9Jh2iytrA3
         crwwx5/oRi0W0VlQHF2guQkYhspQ4YxLKEyx1bockH08YxOXM7LCp1hyfmi1B3DrR7wU
         5j8tsMLlKG1zkMcCkzcrhoVfS5MC/FXPxiVKpi8KYFVHCFPzWHDi6WKlOjXGc3SsgSa6
         mVWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781293072; x=1781897872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wF1YM3iIffsWq3aue3unk5VZq1rQajY4MddWtIHftpQ=;
        b=WcTSFDYCpRmAXJHchDWfWdaUxPggiynXVFVnSxBKirKyMT3bR8zjfml/+RmTCvvh4y
         sPIuxll39e/H6optK04Ouvkf9/D8siSoFJPbpM/3Sw8w6UG9ESbpLHNqUVd3GsTNmksu
         o14xXXHUbO6qn5f43Tg34yFCWCYlAJ8IrSqiqvH+sJ0Obk1sPCdTo5qNGG3nLz4nwSXm
         Eui7xbp4/FSBZ4USn7LA13CI4HypNBTBrdIeO6Ry6g3SldULF2Q6jXk5GJiBzRfNVbgB
         mvTuCv2So+xSFJsPIQchGHTvc5fZg/E7/cdL1kqiSg3GGMxPqzf7V6Nt3vXpvCV+j54g
         ZHIw==
X-Forwarded-Encrypted: i=1; AFNElJ9HmBngaGMqS+R6wp4Q/4lZyaZjJXMvEvmUEE9JbOC3l6DbE9HLCXu2mgVhapwAuM5497TLjVwH@vger.kernel.org
X-Gm-Message-State: AOJu0YwbdJRoufYQGACLaFvaUp+jn1hYrWtp5BD+VpItRv34gvigiL5z
	z7JdKOKPmkJbUu6GScMgwFwxNrMCfQxvQGSnrIwWN9iAn6jUiDM+BAIY
X-Gm-Gg: Acq92OEHC5u9F+tb81xjDUovbZS5cvFjTx047Euva9G2QL6b1u0SgYKlq2PnpXOKOIW
	YzS3iOuxmHSk8nOl7Op7clVCMC6cZ0VTgu+DKZfzL9NoDmdyw36/dBL/TH/b2otRvvy/X4fMBvD
	YtDjWiwUISrkQ2y3gmN4oiC/HxhQX6dSVCbH48QtB7ELUCkdW+Su1qCOEEBZpLEwnVSlmxH7eIZ
	RNpHCKNLGEHz0WDagzqRFhqS+lSoPvOfAHkh6TFyHtKSp2s6hpXpH9VjsY7/YDKoE8CLzn3pK+d
	mYY2RmR07C/0833PGWuszi+aWFC3s0otFrduHn/oNVx8qlsqlMpxfmuRCZSYNq6bFpBAIxC6h9T
	9p2PMVa+oCrqn/WP6ACF+51mlxWdAEujWW5L+3evXlgZVXSS6nNRBdjKE84xy66O9EQ2wZE78ne
	NsUUalwJlZX5RVHESRl9T6zJnQkMmsiwSh31aOZqqAcuCJvA==
X-Received: by 2002:a4a:ee88:0:b0:687:d4de:1f9d with SMTP id 006d021491bc7-69edc68d84cmr2637237eaf.24.1781293071874;
        Fri, 12 Jun 2026 12:37:51 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:50::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4426b2f8a9csm2643507fac.13.2026.06.12.12.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 12:37:51 -0700 (PDT)
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
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 6/7] mm, swap: defer memcg_table allocation on physical clusters
Date: Fri, 12 Jun 2026 12:37:37 -0700
Message-ID: <20260612193738.2183968-7-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260612193738.2183968-1-nphamcs@gmail.com>
References: <20260612193738.2183968-1-nphamcs@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Physical swap clusters whose slots only serve as Pointer-tagged
vswap backings never have their memcg_table read or written.
Vswap-layer memcg charging records on the VSWAP cluster's table,
not the physical cluster's. Allocating memcg_table eagerly for
such clusters wastes SWAPFILE_CLUSTER * sizeof(unsigned short)
bytes per cluster, which adds up on vswap-heavy workloads where
zswap writeback is the only consumer of physical swap.

Allocate eagerly only when the cluster is known to need a memcg
table: any cluster in a !CONFIG_VSWAP build (all slots are direct
use), or any vswap cluster (every vswap allocation records memcg).
For physical clusters in CONFIG_VSWAP builds, defer the allocation
to alloc_swap_scan_cluster, which lazy-allocates on the first
direct-use slot and skips entirely when the cluster only holds
Pointer-tagged vswap backings (folio in swap cache).

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 48 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 8 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index afb118ab8179..0d48240de345 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -493,7 +493,8 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
 		 swap_cluster_free_table_folio_rcu_cb);
 }
 
-static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
+static int swap_cluster_alloc_table(struct swap_info_struct *si,
+				    struct swap_cluster_info *ci, gfp_t gfp)
 {
 	struct swap_table *table = NULL;
 	struct folio *folio;
@@ -516,7 +517,16 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
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
@@ -590,8 +600,8 @@ swap_cluster_populate(struct swap_info_struct *si,
 		lockdep_assert_held(&si->global_cluster_lock);
 	lockdep_assert_held(&ci->lock);
 
-	if (!swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					  __GFP_NOWARN))
+	if (!swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					      __GFP_NOWARN))
 		return ci;
 
 	/*
@@ -609,8 +619,8 @@ swap_cluster_populate(struct swap_info_struct *si,
 	if (!swap_is_vswap(si))
 		local_unlock(&percpu_swap_cluster.lock);
 
-	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					   GFP_KERNEL);
+	ret = swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					       GFP_KERNEL);
 
 	/*
 	 * Back to atomic context. We might have migrated to a new CPU with a
@@ -883,7 +893,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 
 	ci = cluster_info + idx;
 	/* Need to allocate swap table first for initial bad slot marking. */
-	if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL))
+	if (!ci->count && swap_cluster_alloc_table(si, ci, GFP_KERNEL))
 		return -ENOMEM;
 	spin_lock(&ci->lock);
 	/* Check for duplicated bad swap slots. */
@@ -1175,6 +1185,28 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 			if (!ret)
 				continue;
 		}
+#ifdef CONFIG_MEMCG
+		/*
+		 * Physical cluster in a CONFIG_VSWAP build: lazy alloc
+		 * memcg_table on the first direct-use slot. Checked here
+		 * (not above the loop) because cluster_reclaim_range may
+		 * have dropped ci->lock and a concurrent vswap-backing
+		 * alloc could have freed and re-populated the cluster
+		 * without the lazy alloc firing (that path has
+		 * folio_test_swapcache(folio) true and skips it). For
+		 * vswap-backing allocs here, the lazy alloc is also
+		 * skipped because vswap-backing slots never touch
+		 * memcg_table on the physical cluster.
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
@@ -1241,7 +1273,7 @@ static unsigned int alloc_swap_scan_dynamic(struct swap_info_struct *si,
 	spin_lock_init(&ci_dyn->ci.lock);
 	INIT_LIST_HEAD(&ci_dyn->ci.list);
 
-	if (swap_cluster_alloc_table(&ci_dyn->ci, GFP_ATOMIC)) {
+	if (swap_cluster_alloc_table(si, &ci_dyn->ci, GFP_ATOMIC)) {
 		kfree(ci_dyn);
 		return SWAP_ENTRY_INVALID;
 	}
-- 
2.53.0-Meta

