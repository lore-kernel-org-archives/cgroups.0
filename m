Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792563525;
	b=vrt0skCG1O3A3oGLGV+7ur/EAUORgYkYIuusq+q431zddCTW5fGMYrrjoQhH2KtWwcN4
	 aYPUK6x213FxOH3WdVKSw6TjIWAgval27C2BMod29DMY4/P5XknrTeXYNClzWFcovh7Bp
	 mvVo48ljK6LXn7VcYiMObwWAVwRdblFL53kNHktMQeXnDuaPrQN94UN2bzqMPjYGzT8zR
	 e570Rd0FgF+NI5gfHm7m2mHLD5HOJLudtioBPBEFdbZ2MIdrKrSZilU+03LugoxdJ/ur4
	 RWtor6dG7bvKqsYrndM+K87IpMAZf2q/RiGVZ4bA0lApbiIql1KqCU0KejMsJovAcvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792563525;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=58YpRd/cYSDDR/L9xMCDYI7HHr4Po+wYl+qR/bSF0HE=;
	b=KhDl9GhUuOo7YO+4+eWZfLkzKTfvXIHeMbDXxRJ/hNxsjQ3KyWhw3R9xskgJCASa6qz9
	 i4C2JOQ07uRUoFeVw6r6/ZqopGcm7jynnVxgYkVW7noRbGtohWJusnt7aebP+Ypd14IeM
	 oY20mHoduVRn7ALPFCWtwqNiqO2QMNw4Z7i6AzYCvslqOuNgX9b/qk+KiEBg4kPINrBUW
	 9r+UFZjafZyrTY+0MkWatt0qY+ScA+6I7CBqvbbNuvsB2ptcvhJxFJbrcDGvwqkiBvyIC
	 2oLDtEGk39HwqsKgGo+PkkBrYKjryiTUu2Mc7Ke6KRL/kyi44FBGI+TNnbeGlusY4Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=etkOF1j+;
	arc=none smtp.remote-ip=209.85.128.174
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D13606A332
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 06:18:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91D13606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=etkOF1j+
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8b0d126f631so3248897b3.2
        for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 23:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792563524; x=1793168324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=58YpRd/cYSDDR/L9xMCDYI7HHr4Po+wYl+qR/bSF0HE=;
        b=etkOF1j+GA4cvkPIGm8wheqU7IVigFTXEuRubL97q+xt5XSeKPU4oEMKjGyAb6CWZS
         12JlHE4s6Xg1jDNKCrrOwYXyq1PJ2TifbU0fTlfi8LSJERCH8fkTke8EylL3UtsvKBf+
         ME42rV589WP2ZLPHtbzJ2R8XgIxDnokgCY6DGcVn/9rLr1U07EanhZp+Jla5CE2glOkw
         /ijKs1nMN1Igi41QCAzVtr0NaCWT8DOlMe8zkwmZygLsDBmJEYKyyK4y7+yjKRGYCEgm
         f3xZTf4K8s0ycGcbNE9Daqs9O8I42q5S6HR4DtnxTC3y7tJAJAe40SrcF5/z6CW8o3kZ
         EJJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792563524; x=1793168324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=58YpRd/cYSDDR/L9xMCDYI7HHr4Po+wYl+qR/bSF0HE=;
        b=wXe97H/OrZRK94pHLmmzCtSGPIr8fuvKLAoJ1QeG3Xr5uoh1nF+iWSvyXhCPaOxQ53
         /TvmnNiTT9+Bfuz2Ohya8XT0wapquzlIgzfpTC0UOupvZdb+tnrfPRikg3WGJI3PUBhQ
         sRSCc5nIprZcDm4wCc0BNVAwNkuCoBavVm5L2+b+SrGSw+k4f1t5d4Y0/9p37cZthR1a
         p7gCupQSHApZlms9sR72MxuBJ0d3/S5sr2MRqmqlHIcjzEF6psOu//0oVqK4fZ2UBLWf
         d+HWozZ7t6uO4xKutPnAXsYeqvvQwg9Eldh5WGaG6oLgFG90JQE8+9ZsKZqHGad0KIW1
         vcbA==
X-Forwarded-Encrypted: i=1; AKwUvBy4izTIPsEOiLptUwx7w1WncOBxJSjfW/3kK7nNJVGFKdaygK78hKpTPRG4MeJr6dwtc5JWQWse@vger.kernel.org
X-Gm-Message-State: AFq9FYITl18jUG2ffme3Id9rHEphK0P/RLf6Wz5V1Qx9c1XPXQjXqCUa
	5AdEbO2a15HMT3Bn4MLZ87xySYp3iKnuz24/zbTzry+dHL5G7LEncQP9
X-Gm-Gg: AYBFou2KMfuZ+3kpgwjKvFUofvQCq1FWKmhe+sYkORsDTONC28GHDRcV4X0uvtcK2+C
	kCOcA8uDcn0q/+j0DV/UKT6zq4GbIIglZpdrhxgtXDnok38HgQr+pcM1oCstq7xKTvFbUs4d7xS
	ugfcyltnxQoWcIHjeCBwBX94gGkuDC4VJ/KPwLhkmVJIc5vKVF8L93gWtv6Z7//xjEqEvD0jOfO
	gGxnx246e4y4Jl33VEiRSIYwaukHkLFTHSnLuibpWBBPqkg12/Ja5JE2oiyft0ILdrgEJt9Ol9l
	7rvsQP9INaFDsSmwpmXWZEnfRRTAJoHp9bauqwlnm6YG+ZJmjNfnItt3DCpucxKnLxr6jOkLNII
	oJz87Plrjs7nBEm1vu6Db4LGTtI/KArxxtZ5eIUd1RC6LQu24Yz+2YcKycJPaG8bE2igD3GMtE0
	Qy9BXb8Cyx+ySxcfb9LU8IFEjatASdPB9VLtLbtR3YUW2PquYiRoe/E2eKHcuzOORvb+XG0dCNk
	yG+RS7uvIvU2RrXmfI1k5QHTwrPv0lgEtOiqSuYc5DMSee+1OvfdxNIdIm64owWjUgqaf6yICfO
	PMORy3nfNabx20il16YkaqOPomS2g/vCCIN/pxUC/+Jr7oUlxLzaQ/xHZhKd7Pv3c4DlicykiI/
	lKp0Mk8nXTQ==
X-Received: by 2002:a05:690e:1489:b0:677:bf19:f09b with SMTP id 956f58d0204a3-67a0e0331abmr712381d50.13.1792563524445;
        Tue, 20 Oct 2026 23:18:44 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5c::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a0e1851cfsm653829d50.1.2026.10.20.23.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:18:42 -0700 (PDT)
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
Subject: [PATCH v6 11/12] mm, swap: add vmstat and memcg counters for vswap
Date: Tue, 20 Oct 2026 23:18:36 -0700
Message-ID: <20261021061837.1569125-2-nphamcs@gmail.com>
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

Add nr_vswap to /proc/vmstat and vswap to cgroup's memory.stat to report
virtual swap usage.

These counters help diagnose swapping issues. Userspace can also use
vswap as a component of a workload's logical memory footprint when
making policy decisions.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 .../admin-guide/cgroup-v1/memory.rst          |  1 +
 Documentation/admin-guide/cgroup-v2.rst       |  3 +++
 include/linux/memcontrol.h                    |  1 +
 include/linux/swap.h                          |  1 +
 include/linux/vmstat.h                        |  3 +++
 mm/memcontrol-v1.c                            |  6 +++++-
 mm/memcontrol.c                               | 20 +++++++++++++++----
 mm/swapfile.c                                 | 10 +++++++---
 mm/vmstat.c                                   |  6 ++++++
 9 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 2a67356d25a0..8ca9ef2bca9f 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -555,6 +555,7 @@ memory.stat file includes following statistics:
                     cgroup.
     swap            # of bytes of physical swap usage
     swapcached      # of bytes of swap cached in memory
+    vswap           # of bytes of virtual swap usage
     dirty           # of bytes that are waiting to get written back to the disk.
     writeback       # of bytes of file/anon cache that are queued for syncing to
                     disk.
diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 623d29ea8c41..b1f97a61a1dc 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1633,6 +1633,9 @@ The following nested keys are defined.
 		against memory usage, and against swap usage when the swap
 		entry has physical backing.
 
+	  vswap
+		Amount of virtual swap usage.
+
 	  anon_thp
 		Amount of memory used in anonymous mappings backed by
 		transparent hugepages
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b9072a3c9a2a..99beb676d8e7 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -41,6 +41,7 @@ enum memcg_stat_item {
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
+	MEMCG_VSWAP,
 	MEMCG_NR_STAT,
 };
 
diff --git a/include/linux/swap.h b/include/linux/swap.h
index a05189c92dae..891442264ca9 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -371,6 +371,7 @@ bool current_is_kswapd(void);
 
 #ifdef CONFIG_SWAP
 bool mem_cgroup_can_vswap(struct mem_cgroup *memcg);
+unsigned long vswap_usage_in_pages(void);
 
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 		unsigned long nr_pages, sector_t start_block);
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 5b31d8e7ae40..37aff1ffac08 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -33,6 +33,9 @@ enum vm_stat_item {
 	NR_DIRTY_BG_THRESHOLD,
 	NR_MEMMAP_PAGES,	/* page metadata allocated through buddy allocator */
 	NR_MEMMAP_BOOT_PAGES,	/* page metadata allocated through boot allocator */
+#ifdef CONFIG_SWAP
+	NR_VSWAP,		/* pages occupying a virtual swap slot */
+#endif
 	NR_VM_STAT_ITEMS,
 };
 
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 4e4946728db5..8fa7b2fb109d 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -300,7 +300,9 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 	 */
 	nr_entries = folio_nr_pages(folio);
 	private_id = mem_cgroup_private_id_get(memcg, nr_entries);
-	if (!is_vswap_entry(folio->swap))
+	if (is_vswap_entry(folio->swap))
+		mod_memcg_state(memcg, MEMCG_VSWAP, nr_entries);
+	else
 		mod_memcg_state(memcg, MEMCG_SWAP, nr_entries);
 
 	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries, private_id);
@@ -1842,6 +1844,7 @@ static const unsigned int memcg1_stats[] = {
 #ifdef CONFIG_SWAP
 	MEMCG_SWAP,
 	NR_SWAPCACHE,
+	MEMCG_VSWAP,
 #endif
 };
 
@@ -1860,6 +1863,7 @@ static const char *const memcg1_stat_names[] = {
 #ifdef CONFIG_SWAP
 	"swap",
 	"swapcached",
+	"vswap",
 #endif
 };
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e2aa75a292ed..eedaa094a867 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -66,6 +66,7 @@
 #include "internal.h"
 #include "swap.h"
 #include "swap_table.h"
+#include "vswap.h"
 #include <net/sock.h>
 #include <net/ip.h>
 #include "slab.h"
@@ -459,6 +460,7 @@ static const unsigned int memcg_stat_items[] = {
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
+	MEMCG_VSWAP,
 };
 
 #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
@@ -1628,6 +1630,7 @@ static const struct memory_stat memory_stats[] = {
 	{ "file_writeback",		NR_WRITEBACK			},
 #ifdef CONFIG_SWAP
 	{ "swapcached",			NR_SWAPCACHE			},
+	{ "vswap",			MEMCG_VSWAP			},
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	{ "anon_thp",			NR_ANON_THPS			},
@@ -6004,6 +6007,7 @@ unsigned short __mem_cgroup_swap_get(struct folio *folio)
 	unsigned int nr_pages = folio_nr_pages(folio);
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
+	unsigned short id;
 
 	if (do_memsw_account())
 		return 0;
@@ -6020,7 +6024,12 @@ unsigned short __mem_cgroup_swap_get(struct folio *folio)
 		return 0;
 	}
 
-	return mem_cgroup_private_id_get(memcg, nr_pages);
+	id = mem_cgroup_private_id_get(memcg, nr_pages);
+	if (is_vswap_entry(folio->swap)) {
+		memcg = obj_cgroup_memcg(obj_cgroup_from_private_id(id));
+		mod_memcg_state(memcg, MEMCG_VSWAP, nr_pages);
+	}
+	return id;
 }
 
 /**
@@ -6109,7 +6118,7 @@ void __mem_cgroup_swap_uncharge(unsigned short id, unsigned int nr_pages)
  * __mem_cgroup_swap_put - drop the private ID refs taken for swap slots
  * @id: the pinned private ID
  * @nr_pages: number of refs to drop
- * @is_vswap: whether the released swap slots are virtual
+ * @is_vswap: release virtual-swap accounting along with the refs
  */
 void __mem_cgroup_swap_put(unsigned short id, unsigned int nr_pages,
 			   bool is_vswap)
@@ -6117,9 +6126,12 @@ void __mem_cgroup_swap_put(unsigned short id, unsigned int nr_pages,
 	struct mem_cgroup *memcg;
 
 	guard(rcu)();
-	if (do_memsw_account() && !is_vswap) {
+	if (is_vswap || do_memsw_account()) {
 		memcg = obj_cgroup_memcg(obj_cgroup_from_private_id(id));
-		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
+		if (is_vswap)
+			mod_memcg_state(memcg, MEMCG_VSWAP, -nr_pages);
+		else
+			mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
 	}
 	mem_cgroup_private_id_put(id, nr_pages);
 }
diff --git a/mm/swapfile.c b/mm/swapfile.c
index e95f2441fdd7..fe5460d15f55 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2612,9 +2612,8 @@ static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
 }
 
 /*
- * Release the cgroup accounting of a batch of freed slots. For vswap the
- * physical swap was already uncharged by __vswap_release_backing(), so only
- * the ID ref is left to drop.
+ * Release cgroup accounting for freed swap slots. Physical backing of
+ * vswap entries was already uncharged by __vswap_release_backing().
  */
 static void memcg_swap_free(unsigned short id, unsigned int nr, bool is_vswap)
 {
@@ -4922,6 +4921,11 @@ early_param("vswap", early_vswap);
 /* vswap does no IO on its own. */
 static const struct swap_ops vswap_ops = { };
 
+unsigned long vswap_usage_in_pages(void)
+{
+	return vswap_is_enabled() ? swap_usage_in_pages(vswap_si) : 0;
+}
+
 static int vswap_used_get(void *data, u64 *val)
 {
 	*val = swap_usage_in_pages(vswap_si);
diff --git a/mm/vmstat.c b/mm/vmstat.c
index a3e809c57f29..b7077a6f244d 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1320,6 +1320,9 @@ const char * const vmstat_text[] = {
 	[I(NR_DIRTY_BG_THRESHOLD)]		= "nr_dirty_background_threshold",
 	[I(NR_MEMMAP_PAGES)]			= "nr_memmap_pages",
 	[I(NR_MEMMAP_BOOT_PAGES)]		= "nr_memmap_boot_pages",
+#ifdef CONFIG_SWAP
+	[I(NR_VSWAP)]				= "nr_vswap",
+#endif
 #undef I
 
 #if defined(CONFIG_VM_EVENT_COUNTERS)
@@ -1936,6 +1939,9 @@ static void *vmstat_start(struct seq_file *m, loff_t *pos)
 			    v + NR_DIRTY_THRESHOLD);
 	v[NR_MEMMAP_PAGES] = atomic_long_read(&nr_memmap_pages);
 	v[NR_MEMMAP_BOOT_PAGES] = atomic_long_read(&nr_memmap_boot_pages);
+#ifdef CONFIG_SWAP
+	v[NR_VSWAP] = vswap_usage_in_pages();
+#endif
 	v += NR_VM_STAT_ITEMS;
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
-- 
2.53.0-Meta

