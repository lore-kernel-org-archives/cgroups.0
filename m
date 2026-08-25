Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C4B489866
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 15:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787671987; cv=none; b=JiZM7OZxEJbtTQ0WAbjeUrT+qWwLK2Tuh9TlnVSZjxsmgVnxyLVGY4lt2GmlvqMS/BQEhDIGwlJ/wY8SLbqmzZp+LNMi8sKl6ChgcJm6jYbRlXJuC10Z1++WFCUyx5bxQVwMecGDnCpF2iFitf42ygaOCYkqXgfIzE9a0pZMQbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787671987; c=relaxed/simple;
	bh=ESa/aJb+Zcb+vI6rmyLQaTfjj0+Al0OL+w/Lgyn3Yu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NngPiFk0IFSVyJSlkKcK/OI9IZ+xxhFyMimvQYSaWNJCLeQWSQCS/TYzSWJPyhBp0AwWSzRTFF+rL2RZgqLpnqNj4zB2CxoirjT/uvD2+jXJIsO2AGDnuka5HeudvjeCUnJqGAtYKvhopuU6PAfIOVXPQISw5wT9YTvR4DwZPKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hjYysJX3; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hjYysJX3"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-499f6e0bbabso4125386b6e.0
        for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 08:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787671979; x=1788276779; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uAKqLnS2duDg8f3jGAvM1PgrDRSN4wgtQcZNf8+IpfY=;
        b=hjYysJX3IVpEhW0E6s0hQ6MM5lz7Gr5QgJO+Z38p3ugGbP3op1OHJorZsL+4FNXd9i
         Zh7DtUPcIMP+tgyQPfvAYEk1MmEANWLOSODa4hmBhshAcP4Bs6ey76yuSTLDupxwWx65
         sZL53TSsyXSZAx/HrBbUtHnkkR+EsLFBYNFfezy60oc3kAvH3Bs7H5zKkdBdJeX77zbT
         AnquNzbPqdPllOMVV9TlcLmx0Ia1Zw+Cf+B+ApESH4qpKSTNrnbuF3OBK7kj1eODtgQU
         dsjfOe08atULZl9xgFqModnWExflixhwG8SPVrQoF/ffaXgxKuT6ZCGbGc/WruJJlMet
         TiRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671979; x=1788276779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uAKqLnS2duDg8f3jGAvM1PgrDRSN4wgtQcZNf8+IpfY=;
        b=fzWYA72yyMcCsw1kTEipyRiXkz2nPffXCFpRZFuxC6EYS5DMMX7EqddjYDQgR6PiVU
         MlRN1qT2uT6bix49ffxZ+5rG1Z85xC6NIYWIHJA/GO2IIFwaOJJVSbwKEU+3fnjEIlvY
         1khFQsqFtRI6xkwc1Mi3GwzRcFML9+Of2IOp420//uTHhZ/AGHJ3AFMbS6Q9H7Squ/nC
         9vynTYFFn+GZtjH8EmBWHWx4OslHZDx4a2EtCDKFPF6tRhGw4fYWKhlvwaJCT6RTtaZr
         lAWzyIoz40y0rSPsEN/GznO3NGan7W41XSp78DS6Zdwq1E3vbCBffH1hukbX0ybs5Km3
         o80g==
X-Forwarded-Encrypted: i=1; AHgh+Rq17fryJEWLKj+oizkKuHlRSnDQUEhy6uGdC0eakTURixV24ReeaKFR3cl/9PMKDUSZi2L/vQ1Y@vger.kernel.org
X-Gm-Message-State: AFuF++mMnvA3iH0MbO2PV9KaCn0QXyW40KGz3gOrV/FD2OT8xdTAfuQP
	pG2h3kQFk1LspUjFoK6zR2sfFU2YXYX69qINwrJDzZLtxZHVg1Jx0x+S
X-Gm-Gg: AR+sD11eLYIf5OSsFXjsVltzXoXh1sZfpKBi4k3VGk0KJ6XEQoIpD4LxLXtcvJgZ/t3
	Kc04zw2TKg5aD/JIFZTaO2lky0iNrmeX16ZEEcPXQaROfxswmVW2tvf3Oyt0SKPaFWisnfICxFh
	QuybddJMQakPGUxzZaZrpa2PZNbOM7Ou5UGXV/ZlgG4gmocUYJw/YxAbQ84meJuVe2W9nDP4xQe
	J5/xWvqOD7P1FSnTwTzFz9oRU9djad5voxZrRU6EOSUm6yQYnaQJ4LAMkgt58IKjt4JseG0xbMS
	XOIanAj/KzRIZorvzFRtxGfDekQu2cYACDet/i0tV7L8RGDweBrdufZz7ZiTs8yJA+fpY10UGAp
	9HYfEjOkSwgxfApPS+d4eJEAFK3+a7dbLrQe8Y/dNMwZL2KXjGxqbo9y76pFdjYMtOd3bDBm4FA
	koS/kZFCBAA7R0rYwQIuq9ueEwc1UVSX8xuip9S/HGNARWfg98Aq2iqq3tg0ncSjisF2LrNV61v
	56PT2o2EyE=
X-Received: by 2002:a05:6808:4f49:b0:495:ff85:d33d with SMTP id 5614622812f47-4b35059a824mr7724933b6e.12.1787671978714;
        Tue, 25 Aug 2026 08:32:58 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:28::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b32c690f27sm5952581b6e.7.2026.08.25.08.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:32:58 -0700 (PDT)
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
Subject: [PATCH v4 11/11] mm, swap: widen swap_info_struct max/pages to unsigned long
Date: Tue, 25 Aug 2026 08:32:37 -0700
Message-ID: <20260825153238.2695446-12-nphamcs@gmail.com>
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

Widen swap_info_struct->max and ->pages from unsigned int to
unsigned long so the vswap device can exceed the previous 16 TB cap
with 4 KB pages (ALIGN_DOWN(UINT_MAX, SWAPFILE_CLUSTER) pages).

The new vswap cap is the cluster_info_pool xarray's allocator
limit. XA_FLAGS_ALLOC stores allocated IDs in u32, so
max_pages = UINT_MAX * SWAPFILE_CLUSTER (~8 PB at the typical
SWAPFILE_CLUSTER=512 layout).

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h |  4 +--
 mm/swapfile.c        | 63 ++++++++++++++++++++++----------------------
 2 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 95386a86d3fd..5310ac0f3faa 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -246,7 +246,7 @@ struct swap_info_struct {
 	signed short	prio;		/* swap priority of this type */
 	struct plist_node list;		/* entry in swap_active_head */
 	signed char	type;		/* strange name for an index */
-	unsigned int	max;		/* size of this swap device */
+	unsigned long	max;		/* size of this swap device */
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
@@ -254,7 +254,7 @@ struct swap_info_struct {
 					/* list of cluster that contains at least one free slot */
 	struct list_head frag_clusters[SWAP_NR_ORDERS];
 					/* list of cluster that are fragmented or contented */
-	unsigned int pages;		/* total of usable pages of swap */
+	unsigned long pages;		/* total of usable pages of swap */
 	atomic_long_t inuse_pages;	/* number of those currently in use */
 	struct swap_sequential_cluster *global_cluster; /* Use one global cluster for rotating device */
 	spinlock_t global_cluster_lock;	/* Serialize usage of global cluster */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8c80544a7d25..9860fb3b079f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -429,10 +429,10 @@ static inline unsigned int cluster_index(struct swap_info_struct *si,
 	return ci - si->cluster_info;
 }
 
-static inline unsigned int cluster_offset(struct swap_info_struct *si,
-					  struct swap_cluster_info *ci)
+static inline unsigned long cluster_offset(struct swap_info_struct *si,
+					   struct swap_cluster_info *ci)
 {
-	return cluster_index(si, ci) * SWAPFILE_CLUSTER;
+	return (unsigned long)cluster_index(si, ci) * SWAPFILE_CLUSTER;
 }
 
 static void swap_cluster_free_table_folio_rcu_cb(struct rcu_head *head)
@@ -848,7 +848,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 
 	/* si->max may got shrunk by swap swap_activate() */
 	if (offset >= si->max && !mask) {
-		pr_debug("Ignoring bad slot %u (max: %u)\n", offset, si->max);
+		pr_debug("Ignoring bad slot %u (max: %lu)\n", offset, si->max);
 		return 0;
 	}
 	/*
@@ -1085,13 +1085,13 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 }
 
 /* Try use a new cluster for current CPU and allocate from it. */
-static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
-					    struct swap_cluster_info *ci,
-					    struct folio *folio,
-					    unsigned long offset,
-					    bool *nomem)
+static unsigned long alloc_swap_scan_cluster(struct swap_info_struct *si,
+					     struct swap_cluster_info *ci,
+					     struct folio *folio,
+					     unsigned long offset,
+					     bool *nomem)
 {
-	unsigned int next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
+	unsigned long next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
 	unsigned int order = likely(folio) ? folio_order(folio) : 0;
 	unsigned long end = start + SWAPFILE_CLUSTER;
@@ -1168,12 +1168,12 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	return found;
 }
 
-static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
-					 struct list_head *list,
-					 struct folio *folio,
-					 bool scan_all)
+static unsigned long alloc_swap_scan_list(struct swap_info_struct *si,
+					  struct list_head *list,
+					  struct folio *folio,
+					  bool scan_all)
 {
-	unsigned int found = SWAP_ENTRY_INVALID;
+	unsigned long found = SWAP_ENTRY_INVALID;
 	bool nomem = false;
 
 	/*
@@ -1196,8 +1196,8 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 	return found;
 }
 
-static unsigned int vswap_alloc_cluster(struct swap_info_struct *si,
-					struct folio *folio)
+static unsigned long vswap_alloc_cluster(struct swap_info_struct *si,
+					 struct folio *folio)
 {
 	struct swap_cluster_info_dynamic *ci_dyn;
 	struct swap_cluster_info *ci;
@@ -1324,7 +1324,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 {
 	struct swap_cluster_info *ci;
 	unsigned int order = likely(folio) ? folio_order(folio) : 0;
-	unsigned int offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
+	unsigned long offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 
 	/*
 	 * Swapfile is not block device so unable
@@ -3423,10 +3423,10 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
  * Return 0 if there are no inuse entries after prev till end of
  * the map.
  */
-static unsigned int find_next_to_unuse(struct swap_info_struct *si,
-					unsigned int prev)
+static unsigned long find_next_to_unuse(struct swap_info_struct *si,
+					unsigned long prev)
 {
-	unsigned int i;
+	unsigned long i;
 	unsigned long swp_tb;
 
 	/*
@@ -3464,7 +3464,8 @@ static int try_to_unuse(unsigned int type)
 	struct swap_io_ctx ctx;
 	swp_entry_t entry, vswap_entry;
 	unsigned long swp_tb;
-	unsigned int i, j;
+	unsigned long i;
+	unsigned int j;
 
 	if (!swap_usage_in_pages(si))
 		goto success;
@@ -3921,7 +3922,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	struct file *swap_file, *victim;
 	struct address_space *mapping;
 	struct inode *inode;
-	unsigned int maxpages;
+	unsigned long maxpages;
 	int err, found = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -4343,12 +4344,8 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 		pr_warn("Truncating oversized swap area, only using %luk out of %luk\n",
 			K(maxpages), K(last_page));
 	}
-	if (maxpages > last_page) {
+	if (maxpages > last_page)
 		maxpages = last_page + 1;
-		/* p->max is an unsigned int: don't overflow it */
-		if ((unsigned int)maxpages == 0)
-			maxpages = UINT_MAX;
-	}
 
 	if (!maxpages)
 		return 0;
@@ -4589,7 +4586,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 	if (si->pages != si->max - 1) {
-		pr_err("swap:%u != (max:%u - 1)\n", si->pages, si->max);
+		pr_err("swap:%lu != (max:%lu - 1)\n", si->pages, si->max);
 		error = -EINVAL;
 		goto bad_swap_unlock_inode;
 	}
@@ -4677,7 +4674,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
 	enable_swap_info(si);
 
-	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
+	pr_info("Adding %luk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,
 		K((unsigned long long)span),
 		(si->flags & SWP_SOLIDSTATE) ? "SS" : "",
@@ -4884,8 +4881,12 @@ static int __init vswap_init(void)
 		return 0;
 	}
 
+	/*
+	 * One u32 xarray ID per cluster, so the device cannot be larger
+	 * than UINT_MAX clusters.
+	 */
 	maxpages = min(swapfile_maximum_size,
-		       ALIGN_DOWN((unsigned long)UINT_MAX, SWAPFILE_CLUSTER));
+		       (unsigned long)UINT_MAX * SWAPFILE_CLUSTER);
 	/*
 	 * SWP_WRITEOK enables slot allocation. SWP_SOLIDSTATE selects
 	 * per-CPU cluster allocation; vswap has no si->global_cluster.
-- 
2.53.0-Meta

