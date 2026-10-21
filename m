Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792562635;
	b=2MrHviHxlsQGYz2NyOXgvPdzqA339D3M8N+km9/BS7QRGhH9k1hM+yaqs3Kbm9DDyIDB
	 ZcjZi14LaoF4UfGwQcL1XQuH8UAbDhe0IiwwOxFyhC6EPybdncvi1HYguK/k/VxKFut06
	 bmmZ3RUKhudAkGHKol0VIofKDtbZBj0nmFz4pFUpKvxbVdHmUxOvqxLzrnluyyDO4kDFR
	 D+2DgZFAEaP1Jh3zXK/0GzIksk9r8NC9LXlxUs+liqGpVx+MnFJUg77EjSm2DF2COmnQG
	 3diQWDi7TOWJT2Jp7edebQOiytkFIvOM/1RiLcDmNKzGFpoCSO2K6PZQ5x4zs3vdWjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792562635;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TQ6PzizMVNaQr1K66ok/5yRST9/OVOHC3RPUko/jHaI=;
	b=w7/ZeyOXVv6XOLGvQXU5y7WBJQIFa+YHvAjCgSgssxOXbyF3LO339I2X9Hv6XhOVq9bC
	 n/Ox+MxBVmPyc5NafOY04ypjCO6MInR0RAOvzEyHrp+4LT+UKAN27anfkKj65nLUdCLYB
	 0CR2QFMXY4C2SpdlEfh4j5QzIhVIdBFTgtTH3CuqLiDz+FmtdpldM+4AKkw5SAV3tK9ne
	 xe/J64BMrnY9FRipUJmGUGjpgSInwQHQG/5TI5x5+CRr2O+0UTFjRJv2za/gBrX0dEBX8
	 OGyivQ5cQLbSh0BXnsX5s0emp1pxJ4AcLwTWHfz2FErzqdTSMv/kL77uAYNMhU41oaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WfBEMR3F;
	arc=none smtp.remote-ip=209.85.128.173
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED4D60A3807
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 06:03:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1ED4D60A3807
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WfBEMR3F
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8b0d63f60bcso2999257b3.3
        for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 23:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792562633; x=1793167433; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TQ6PzizMVNaQr1K66ok/5yRST9/OVOHC3RPUko/jHaI=;
        b=WfBEMR3F+aKedZVeCky5irY9pD9Wqzx6zrDabK/zXAhx9JT18jThpFaepdA27P2qCU
         /rSXX+j683+xgqANDqmdjhagonQD8ZJNyNhBDutW4k+XhdiO/lPkBP3QRAmkzCE8MRvw
         0JUZ/0Jf7SjXZNFVXCNJ9MrxfVHF0RHWH2UxxdaI5kZnlJN7T+IiUxFkUo77XRkS47aW
         /VyG7NXrf/2kAOb7c1MlznrbUqzDpElXqPvFk3xYr5GAHqb8kuxM+jF6PE3m0quUTzvO
         qESfxYdwtKRUYgarmd0mOPd3cyuIKXRTbS3T8+dsVzpvVyyMxN7nvNYJHhweQWpLUCqw
         ajcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562633; x=1793167433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TQ6PzizMVNaQr1K66ok/5yRST9/OVOHC3RPUko/jHaI=;
        b=YWLmtqaqwAZjhSTsdSwY7j5+zTKmyM9MZeIpypE1Hql1CbQDq7mjczyv3J3UCeHe1y
         J6I5isQQYEkl4MsqQBLU8gfbpbUziu4P41PV/rONXsR7K/LGDevXZunouKSChOXFLDyH
         EjAMN3Jjke7pNPseFmMWfyw/4EiKauPOetAOiqpLUvTECqo8ta068P0i4mXEODis6JRd
         +IwzhFmgbwxVlS0TyM5JcB2uuTmC3ltQ5kAWZUK+JxvaJPhGKnmCt0re108Lo48n/B3s
         A2eMk0Otm9Ni10uW6aBDaV/v6aH6sievzRJhiyHTI4CrwZKdF/Avt6CzhRNOl423oKrs
         FCxw==
X-Forwarded-Encrypted: i=1; AKwUvBzMdM6MTRqVcLJL8YquVG3hvdsj2xMZuy/QHIz0T3WVNw2Do/jFJ3VABWgxvxrQapBDmi78F/xq@vger.kernel.org
X-Gm-Message-State: AFq9FYLJxhewRd4b8yyK/RRwRG67V8RxDmqbehh0eVVMXKRed4yrB/X/
	nN+dVM9rmOqlG2CLgCrZ8MvTm+4HEXoXfjZwzks/LvSgxQIw87UYoH1l
X-Gm-Gg: AYBFou0/LZ4xa2x9aiCFYt5Nk9JPWqN5fHAB9jsq1T0FIpPMpPBgqhzm/DAENuPiV9S
	WPgvBloWVP3vyb6zZxW5NC1rtw/nXHZSbv2h+5MX/0qICXgXpqsXghrPGGwTtrzjHfJFiZcEMvW
	8O8EUWovFz4cjo5JfTm53eo6PIhrgEcgbW1ZFfcL6JZoaDjtIs5vyIz6PddlmmGpXrFJYEGtn3N
	WQuPqsMprA+iuGDFPqjzfEWJ//8yW1emAUhKPZMN41QnAKdTZHKEkFESUeJzBs6kaRU7rRrfAPe
	nLbXC5Dh7vS5hHADV00PFZN+tWWckyXeHymrb6WEvcV8D+ttBVpqZwrgz6cKFo/NfVzEDFtTkCn
	0AZvBdrOMD1+uQ8mDWThYLtTEt6+3faW1NdS5ENmCMgSAYkJtTKZCsR1kl70w2/ktQLaFYzYaAd
	lTPWXPP3wwUTIZNWGTo412hYQncTkJcmEKU9Z7BmLShphGzL+QGr82CmOtlftRQH05ZJBl4N3lu
	7SW3G+kVphPJLpsEQEfCCvB6TDCi4nva/uWcKy51pMetWjx+xIU+jx6wLKmA7Cv0JTvvd2MHtII
	wVIOx71reBxu5qVejZBCsOHG/GI5c8CemkavAclsQxnGWoBNfNxGH4DXStmbfggV
X-Received: by 2002:a05:690c:6e85:b0:8b0:d837:364b with SMTP id 00721157ae682-8b133b4d733mr5943067b3.7.1792562632908;
        Tue, 20 Oct 2026 23:03:52 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:49::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b130074aa6sm7266277b3.10.2026.10.20.23.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:03:50 -0700 (PDT)
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
Subject: [PATCH v6 08/12] mm, swap: only charge physical swap entries
Date: Tue, 20 Oct 2026 23:03:19 -0700
Message-ID: <20261021060323.553433-9-nphamcs@gmail.com>
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

Zswap-backed and zero-filled pages occupy no swap space, but were charged
against memcg->swap, the memcg's swap cgroup counter, as though they did.

Charge memcg->swap when a vswap entry acquires physical backing rather
than when it is allocated.

With vswap enabled, this changes what the counter means and when the
charge can fail:

* Virtual swap entries count towards memory.swap.current only when
  backed by physical swap slots.
* A cgroup can reclaim its anon memory even with memory.swap.max set to 0,
  provided zswap is allowed for it.
* The charge can fail at writeback rather than at allocation.
  swap_writeout() returns AOP_WRITEPAGE_ACTIVATE and
  zswap_writeback_entry() returns -ENOMEM for a cgroup at its limit.
* The zswap shrinker skips such a cgroup rather than walking its LRUs.

Also refactor the swap memcg operations into separate get, record, charge,
uncharge and put helpers, since recording the owner and charging it no
longer happen at the same time.

Direct-mapped physical swap charging is unchanged. In cgroup v1, vswap
entries are still accounted against the memsw counter.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 .../admin-guide/cgroup-v1/memcg_test.rst      |   2 +-
 .../admin-guide/cgroup-v1/memory.rst          |   2 +-
 Documentation/admin-guide/cgroup-v2.rst       |  51 +++---
 include/linux/swap.h                          |  73 ++++++++-
 mm/memcontrol-v1.c                            |   9 +-
 mm/memcontrol.c                               | 148 ++++++++++++------
 mm/swapfile.c                                 | 114 ++++++++++++--
 mm/zswap.c                                    |  22 ++-
 8 files changed, 316 insertions(+), 105 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memcg_test.rst b/Documentation/admin-guide/cgroup-v1/memcg_test.rst
index d9951c319ef5..cd565626c435 100644
--- a/Documentation/admin-guide/cgroup-v1/memcg_test.rst
+++ b/Documentation/admin-guide/cgroup-v1/memcg_test.rst
@@ -43,7 +43,7 @@ Please note that implementation details can be changed.
 	mem_cgroup_uncharge()
 	  Called when a page's refcount goes down to 0.
 
-	mem_cgroup_uncharge_swap()
+	mem_cgroup_swap_uncharge()
 	  Called when swp_entry's refcnt goes down to 0. A charge against swap
 	  disappears.
 
diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 7d2a44af52c9..2a67356d25a0 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -553,7 +553,7 @@ memory.stat file includes following statistics:
     pgpgout         # of uncharging events to the memory cgroup. The uncharging
                     event happens each time a page is unaccounted from the
                     cgroup.
-    swap            # of bytes of swap usage
+    swap            # of bytes of physical swap usage
     swapcached      # of bytes of swap cached in memory
     dirty           # of bytes that are waiting to get written back to the disk.
     writeback       # of bytes of file/anon cache that are queued for syncing to
diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 8d2603751c51..623d29ea8c41 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1630,7 +1630,8 @@ The following nested keys are defined.
 
 	  swapcached
 		Amount of swap cached in memory. The swapcache is accounted
-		against both memory and swap usage.
+		against memory usage, and against swap usage when the swap
+		entry has physical backing.
 
 	  anon_thp
 		Amount of memory used in anonymous mappings backed by
@@ -1845,16 +1846,17 @@ The following nested keys are defined.
 	A read-only single value file which exists on non-root
 	cgroups.
 
-	The total amount of swap currently being used by the cgroup
-	and its descendants.
+	The total amount of physical swap currently being used by the
+	cgroup and its descendants.
 
   memory.swap.high
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "max".
 
-	Swap usage throttle limit.  If a cgroup's swap usage exceeds
-	this limit, all its further allocations will be throttled to
-	allow userspace to implement custom out-of-memory procedures.
+	Physical swap usage throttle limit.  If a cgroup's physical
+	swap usage exceeds this limit, all its further allocations will
+	be throttled to allow userspace to implement custom
+	out-of-memory procedures.
 
 	This limit marks a point of no return for the cgroup. It is NOT
 	designed to manage the amount of swapping a workload does
@@ -1867,8 +1869,9 @@ The following nested keys are defined.
   memory.swap.peak
 	A read-write single value file which exists on non-root cgroups.
 
-	The max swap usage recorded for the cgroup and its descendants since
-	the creation of the cgroup or the most recent reset for that FD.
+	The max physical swap usage recorded for the cgroup and its
+	descendants since the creation of the cgroup or the most recent
+	reset for that FD.
 
 	A write of any non-empty string to this file resets it to the
 	current memory usage for subsequent reads through the same
@@ -1878,8 +1881,9 @@ The following nested keys are defined.
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "max".
 
-	Swap usage hard limit.  If a cgroup's swap usage reaches this
-	limit, anonymous memory of the cgroup will not be swapped out.
+	Physical swap usage hard limit.  If a cgroup's physical swap
+	usage reaches this limit, anonymous memory of the cgroup will
+	not be swapped out to a physical swap device.
 
   memory.swap.events
 	A read-only flat-keyed file which exists on non-root cgroups.
@@ -1888,23 +1892,24 @@ The following nested keys are defined.
 	modified event.
 
 	  high
-		The number of times the cgroup's swap usage was over
-		the high threshold.
+		The number of times the cgroup's physical swap usage
+		was over the high threshold.
 
 	  max
-		The number of times the cgroup's swap usage was about
-		to go over the max boundary and swap allocation
-		failed.
+		The number of times the cgroup's physical swap usage
+		was about to go over the max boundary and physical
+		swap allocation failed.
 
 	  fail
-		The number of times swap allocation failed either
-		because of running out of swap system-wide or max
-		limit.
+		The number of failed physical swap allocation or charge
+		attempts. This includes physical backing allocation for
+		virtual swap entries.
 
-	When reduced under the current usage, the existing swap
-	entries are reclaimed gradually and the swap usage may stay
-	higher than the limit for an extended period of time.  This
-	reduces the impact on the workload and memory management.
+	When reduced under the current usage, the existing physical
+	swap entries are reclaimed gradually and the physical swap
+	usage may stay higher than the limit for an extended period of
+	time.  This reduces the impact on the workload and memory
+	management.
 
   memory.zswap.current
 	A read-only single value file which exists on non-root
@@ -1934,8 +1939,6 @@ The following nested keys are defined.
 	reclaim inefficiency after disabling writeback (because the same
 	pages might be rejected again and again).
 
-	Note that this is subtly different from setting memory.swap.max to
-	0, as it still allows for pages to be written to the zswap pool.
 	This setting has no effect if zswap is disabled, and swapping
 	is allowed unless memory.swap.max is set to 0.
 
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4066d99f896e..a05189c92dae 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -535,20 +535,57 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 #endif
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
-int __mem_cgroup_try_charge_swap(struct folio *folio);
-static inline int mem_cgroup_try_charge_swap(struct folio *folio)
+unsigned short __mem_cgroup_swap_get(struct folio *folio);
+static inline unsigned short mem_cgroup_swap_get(struct folio *folio)
 {
 	if (mem_cgroup_disabled())
 		return 0;
-	return __mem_cgroup_try_charge_swap(folio);
+	return __mem_cgroup_swap_get(folio);
 }
 
-extern void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages);
-static inline void mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
+void __mem_cgroup_swap_fail(unsigned short id);
+static inline void mem_cgroup_swap_fail(unsigned short id)
 {
 	if (mem_cgroup_disabled())
 		return;
-	__mem_cgroup_uncharge_swap(id, nr_pages);
+	__mem_cgroup_swap_fail(id);
+}
+
+int __mem_cgroup_swap_charge(unsigned short id, unsigned int nr_pages);
+static inline int mem_cgroup_swap_charge(unsigned short id,
+					 unsigned int nr_pages)
+{
+	if (mem_cgroup_disabled())
+		return 0;
+	return __mem_cgroup_swap_charge(id, nr_pages);
+}
+
+void __mem_cgroup_swap_record(struct folio *folio, unsigned short id);
+static inline void mem_cgroup_swap_record(struct folio *folio,
+					  unsigned short id)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_swap_record(folio, id);
+}
+
+void __mem_cgroup_swap_uncharge(unsigned short id, unsigned int nr_pages);
+static inline void mem_cgroup_swap_uncharge(unsigned short id,
+					    unsigned int nr_pages)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_swap_uncharge(id, nr_pages);
+}
+
+void __mem_cgroup_swap_put(unsigned short id, unsigned int nr_pages,
+			   bool is_vswap);
+static inline void mem_cgroup_swap_put(unsigned short id,
+				       unsigned int nr_pages, bool is_vswap)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_swap_put(id, nr_pages, is_vswap);
 }
 
 long mem_cgroup_get_folio_swap_margin(const struct folio *folio);
@@ -556,16 +593,36 @@ long mem_cgroup_get_nr_swap_pages(const struct mem_cgroup *memcg);
 bool mem_cgroup_can_swap(struct mem_cgroup *memcg, long nr_pages);
 bool mem_cgroup_swap_full(const struct folio *folio);
 #else
-static inline int mem_cgroup_try_charge_swap(struct folio *folio)
+static inline unsigned short mem_cgroup_swap_get(struct folio *folio)
 {
 	return 0;
 }
 
-static inline void mem_cgroup_uncharge_swap(unsigned short id,
+static inline void mem_cgroup_swap_fail(unsigned short id)
+{
+}
+
+static inline int mem_cgroup_swap_charge(unsigned short id,
+					 unsigned int nr_pages)
+{
+	return 0;
+}
+
+static inline void mem_cgroup_swap_record(struct folio *folio,
+					  unsigned short id)
+{
+}
+
+static inline void mem_cgroup_swap_uncharge(unsigned short id,
 					    unsigned int nr_pages)
 {
 }
 
+static inline void mem_cgroup_swap_put(unsigned short id,
+				       unsigned int nr_pages, bool is_vswap)
+{
+}
+
 static inline long mem_cgroup_get_folio_swap_margin(const struct folio *folio)
 {
 	return PAGE_COUNTER_MAX;
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index b7f286888507..4e4946728db5 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -15,6 +15,7 @@
 #include "internal.h"
 #include "swap.h"
 #include "swap_table.h"
+#include "vswap.h"
 #include "memcontrol-v1.h"
 
 /* for OOM */
@@ -299,7 +300,8 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 	 */
 	nr_entries = folio_nr_pages(folio);
 	private_id = mem_cgroup_private_id_get(memcg, nr_entries);
-	mod_memcg_state(memcg, MEMCG_SWAP, nr_entries);
+	if (!is_vswap_entry(folio->swap))
+		mod_memcg_state(memcg, MEMCG_SWAP, nr_entries);
 
 	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries, private_id);
 
@@ -371,7 +373,10 @@ void memcg1_swapin(struct folio *folio)
 	id = __swap_cgroup_clear(ci, swp_cluster_offset(folio->swap),
 				 nr_pages);
 	swap_cluster_unlock(ci);
-	mem_cgroup_uncharge_swap(id, nr_pages);
+	if (!id)
+		return;
+	mem_cgroup_swap_uncharge(id, nr_pages);
+	mem_cgroup_swap_put(id, nr_pages, is_vswap_entry(folio->swap));
 }
 #endif
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b8ab5a55df59..e2aa75a292ed 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5989,21 +5989,21 @@ int __init mem_cgroup_init(void)
 
 #ifdef CONFIG_SWAP
 /**
- * __mem_cgroup_try_charge_swap - try charging swap space for a folio
+ * __mem_cgroup_swap_get - pin the memcg to account a folio's swap slots to
  * @folio: folio being added to swap
  *
- * Try to charge @folio's memcg for the swap space at folio->swap.
+ * Pins one private ID ref per page of @folio on its memcg, or on its closest
+ * online ancestor if it has been offlined. The caller charges and records
+ * against whichever ID is returned, so both land on the same one.
  *
- * Returns 0 on success, -ENOMEM on failure.
+ * Return: the pinned private ID, or 0 if there is nothing to account. Drop
+ * the pins with __mem_cgroup_swap_put().
  */
-int __mem_cgroup_try_charge_swap(struct folio *folio)
+unsigned short __mem_cgroup_swap_get(struct folio *folio)
 {
 	unsigned int nr_pages = folio_nr_pages(folio);
-	struct swap_cluster_info *ci;
-	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
-	unsigned short private_id;
 
 	if (do_memsw_account())
 		return 0;
@@ -6013,56 +6013,115 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	if (!objcg)
 		return 0;
 
-	scoped_guard(rcu) {
-		memcg = obj_cgroup_memcg(objcg);
-		if (!folio_test_swapcache(folio)) {
-			memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-			return 0;
-		}
+	guard(rcu)();
+	memcg = obj_cgroup_memcg(objcg);
+	if (!folio_test_swapcache(folio)) {
+		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
+		return 0;
+	}
 
-		private_id = mem_cgroup_private_id_get(memcg, nr_pages);
+	return mem_cgroup_private_id_get(memcg, nr_pages);
+}
 
-		if (!mem_cgroup_private_id_is_root(private_id) &&
-		    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
-			memcg_memory_event(memcg, MEMCG_SWAP_MAX);
-			memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-			mem_cgroup_private_id_put(private_id, nr_pages);
-			return -ENOMEM;
-		}
-		mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
+/**
+ * __mem_cgroup_swap_fail - report a failed physical swap allocation
+ * @id: the pinned private ID of the swap owner (may be 0)
+ */
+void __mem_cgroup_swap_fail(unsigned short id)
+{
+	struct mem_cgroup *memcg;
+
+	if (do_memsw_account() || !id)
+		return;
+
+	guard(rcu)();
+	memcg = obj_cgroup_memcg(obj_cgroup_from_private_id(id));
+	memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
+}
+
+/**
+ * __mem_cgroup_swap_charge - charge physical swap space
+ * @id: the private ID to charge (may be 0)
+ * @nr_pages: the amount of swap space to charge
+ *
+ * Return: 0 on success, -ENOMEM if memory.swap.max is exceeded.
+ */
+int __mem_cgroup_swap_charge(unsigned short id, unsigned int nr_pages)
+{
+	struct page_counter *counter;
+	struct mem_cgroup *memcg;
+
+	if (do_memsw_account() || !id)
+		return 0;
+
+	guard(rcu)();
+	memcg = obj_cgroup_memcg(obj_cgroup_from_private_id(id));
+	if (!mem_cgroup_private_id_is_root(id) &&
+	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
+		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
+		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
+		return -ENOMEM;
 	}
+	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
+	return 0;
+}
+
+/**
+ * __mem_cgroup_swap_record - record the owner of a folio's swap slots
+ * @folio: folio being added to swap
+ * @id: the private ID pinned by __mem_cgroup_swap_get()
+ */
+void __mem_cgroup_swap_record(struct folio *folio, unsigned short id)
+{
+	struct swap_cluster_info *ci;
 
 	ci = swap_cluster_get_and_lock(folio);
-	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages, private_id);
+	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap),
+			  folio_nr_pages(folio), id);
 	swap_cluster_unlock(ci);
-
-	return 0;
 }
 
 /**
- * __mem_cgroup_uncharge_swap - uncharge swap space
- * @id: cgroup id to uncharge
+ * __mem_cgroup_swap_uncharge - uncharge physical swap space
+ * @id: the private ID to uncharge (may be 0)
  * @nr_pages: the amount of swap space to uncharge
  */
-void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
+void __mem_cgroup_swap_uncharge(unsigned short id, unsigned int nr_pages)
 {
-	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
 
-	rcu_read_lock();
-	objcg = obj_cgroup_from_private_id(id);
-	memcg = obj_cgroup_memcg(objcg);
-	if (memcg) {
-		if (!mem_cgroup_private_id_is_root(id)) {
-			if (do_memsw_account())
-				page_counter_uncharge(&memcg->memsw, nr_pages);
-			else
-				page_counter_uncharge(&memcg->swap, nr_pages);
-		}
+	if (!id)
+		return;
+
+	guard(rcu)();
+	memcg = obj_cgroup_memcg(obj_cgroup_from_private_id(id));
+	if (!mem_cgroup_private_id_is_root(id)) {
+		if (do_memsw_account())
+			page_counter_uncharge(&memcg->memsw, nr_pages);
+		else
+			page_counter_uncharge(&memcg->swap, nr_pages);
+	}
+	if (!do_memsw_account())
+		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
+}
+
+/**
+ * __mem_cgroup_swap_put - drop the private ID refs taken for swap slots
+ * @id: the pinned private ID
+ * @nr_pages: number of refs to drop
+ * @is_vswap: whether the released swap slots are virtual
+ */
+void __mem_cgroup_swap_put(unsigned short id, unsigned int nr_pages,
+			   bool is_vswap)
+{
+	struct mem_cgroup *memcg;
+
+	guard(rcu)();
+	if (do_memsw_account() && !is_vswap) {
+		memcg = obj_cgroup_memcg(obj_cgroup_from_private_id(id));
 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		__mem_cgroup_private_id_put(objcg, id, nr_pages);
 	}
-	rcu_read_unlock();
+	mem_cgroup_private_id_put(id, nr_pages);
 }
 
 long mem_cgroup_get_nr_swap_pages(const struct mem_cgroup *memcg)
@@ -6107,11 +6166,8 @@ long mem_cgroup_get_folio_swap_margin(const struct folio *folio)
  */
 bool mem_cgroup_can_swap(struct mem_cgroup *memcg, long nr_pages)
 {
-	if (!mem_cgroup_disabled() && !do_memsw_account() &&
-	    page_counter_margin(&memcg->swap) < nr_pages)
-		return false;
-
-	return mem_cgroup_can_vswap(memcg) || get_nr_swap_pages() >= nr_pages;
+	return mem_cgroup_can_vswap(memcg) ||
+	       mem_cgroup_get_nr_swap_pages(memcg) >= nr_pages;
 }
 
 bool mem_cgroup_swap_full(const struct folio *folio)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 640e38a55497..341077fee23b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -46,6 +46,7 @@
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
+#include "memcontrol-v1.h"
 #include "swap_table.h"
 #include "vswap.h"
 #include "internal.h"
@@ -2031,6 +2032,7 @@ static swp_entry_t folio_alloc_phys_swap(struct folio *folio)
 int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
+	unsigned short memcg_id;
 	unsigned int size = 1 << order;
 	bool may_vswap;
 
@@ -2060,10 +2062,20 @@ int folio_alloc_swap(struct folio *folio)
 	if (!may_vswap || !vswap_alloc(folio))
 		folio_alloc_phys_swap(folio);
 
-	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio))) {
-		swap_cache_del_folio(folio);
-		goto failed;
+	/*
+	 * Need to call this even if allocation failed, for MEMCG_SWAP_FAIL.
+	 * A vswap entry has no physical swap yet, so only record the memcg.
+	 * folio_realloc_swap() charges it once backing is allocated.
+	 */
+	memcg_id = mem_cgroup_swap_get(folio);
+	if (memcg_id) {
+		if (!is_vswap_entry(folio->swap) &&
+		    unlikely(mem_cgroup_swap_charge(memcg_id, size))) {
+			mem_cgroup_swap_put(memcg_id, size, false);
+			swap_cache_del_folio(folio);
+		} else {
+			mem_cgroup_swap_record(folio, memcg_id);
+		}
 	}
 
 	if (unlikely(!folio_test_swapcache(folio)))
@@ -2074,7 +2086,7 @@ int folio_alloc_swap(struct folio *folio)
 failed:
 	if (get_nr_swap_pages() <= 0 && !may_vswap)
 		return -ENOSPC;
-	if (mem_cgroup_get_folio_swap_margin(folio) <= 0)
+	if (!may_vswap && mem_cgroup_get_folio_swap_margin(folio) <= 0)
 		return -ENOMEM;
 
 	return order ? -E2BIG : -ENOMEM;
@@ -2125,6 +2137,32 @@ static void vswap_clear_cache_only(struct swap_cluster_info *ci,
 	}
 }
 
+static void vswap_uncharge_cgroup_batch(unsigned short memcg_id,
+					unsigned int batch_nr,
+					unsigned int batch_nr_swapfile)
+{
+	unsigned int n;
+
+	/*
+	 * v1 (memsw): entries keep their memsw charge across swapout
+	 * regardless of backing, so uncharge all of them. v2: only
+	 * swapfile-backed entries are charged, so uncharge just those.
+	 *
+	 * On v1 the id is written by __memcg1_swapout() as the folio leaves the
+	 * swap cache and cleared by memcg1_swapin() when it comes back, both
+	 * under the cluster lock. Callers still holding a cached folio are
+	 * outside that window and see @memcg_id == 0, so only the free path
+	 * uncharges. On v2 the id is set when swap is allocated, so those
+	 * callers do uncharge, which balances the charge folio_realloc_swap()
+	 * took.
+	 */
+	n = do_memsw_account() ? batch_nr : batch_nr_swapfile;
+	if (!n)
+		return;
+
+	mem_cgroup_swap_uncharge(memcg_id, n);
+}
+
 /**
  * __vswap_release_backing - release the backing of a range of vtable slots
  * @ci: the locked vswap cluster
@@ -2145,12 +2183,25 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 	unsigned int ci_off;
 	unsigned long vt;
 	swp_entry_t phys_first = {};
+	unsigned short batch_id, cur_id;
+	unsigned int batch_nr = 0, batch_nr_swapfile = 0;
 
 	lockdep_assert_held(&ci->lock);
 	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+	batch_id = __swap_cgroup_get(ci, ci_start);
 
 	for (ci_off = ci_start; ci_off < ci_start + nr; ci_off++) {
 		vt = __vtable_get(ci_dyn, ci_off);
+		cur_id = __swap_cgroup_get(ci, ci_off);
+
+		if (cur_id != batch_id) {
+			vswap_uncharge_cgroup_batch(batch_id, batch_nr,
+						    batch_nr_swapfile);
+			batch_id = cur_id;
+			batch_nr = 0;
+			batch_nr_swapfile = 0;
+		}
+		batch_nr++;
 
 		/* The free helper takes one contiguous run within one cluster. */
 		if (phys_off_start != phys_off_end &&
@@ -2168,6 +2219,7 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 
 		switch (vtable_type(vt)) {
 		case VSWAP_SWAPFILE:
+			batch_nr_swapfile++;
 			if (phys_off_start == phys_off_end) {
 				phys_first = vtable_to_phys(vt);
 				phys_off_start = swp_offset(phys_first);
@@ -2199,6 +2251,8 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 				phys_off_start % SWAPFILE_CLUSTER,
 				phys_off_end - phys_off_start);
 	}
+
+	vswap_uncharge_cgroup_batch(batch_id, batch_nr, batch_nr_swapfile);
 }
 
 /**
@@ -2289,6 +2343,8 @@ swp_entry_t folio_realloc_swap(struct folio *folio)
 	struct swap_cluster_info *ci;
 	struct swap_cluster_info_dynamic *ci_dyn;
 	unsigned int voff;
+	unsigned long vt;
+	unsigned short memcg_id;
 	swp_entry_t phys_entry = {};
 	swp_entry_t pe;
 	int i, nr = folio_nr_pages(folio);
@@ -2297,18 +2353,33 @@ swp_entry_t folio_realloc_swap(struct folio *folio)
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 	VM_WARN_ON(!is_vswap_entry(vswap_entry));
 
-	phys_entry = vswap_to_phys(vswap_entry);
-	if (phys_entry.val)
-		return phys_entry;
+	voff = swp_cluster_offset(vswap_entry);
+	ci = __swap_entry_to_cluster(vswap_entry);
+	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+
+	spin_lock(&ci->lock);
+	vt = __vtable_get(ci_dyn, voff);
+	if (vtable_type(vt) == VSWAP_SWAPFILE) {
+		spin_unlock(&ci->lock);
+		return vtable_to_phys(vt);
+	}
+	memcg_id = __swap_cgroup_get(ci, voff);
+	spin_unlock(&ci->lock);
 
 	phys_entry = folio_alloc_phys_swap(folio);
-	if (!phys_entry.val)
+	if (!phys_entry.val) {
+		mem_cgroup_swap_fail(memcg_id);
 		return (swp_entry_t){};
+	}
 
-	voff = swp_cluster_offset(vswap_entry);
+	if (mem_cgroup_swap_charge(memcg_id, nr)) {
+		__swap_cluster_free_phys_backing(__swap_entry_to_info(phys_entry),
+						 __swap_entry_to_cluster(phys_entry),
+						 swp_cluster_offset(phys_entry),
+						 nr);
+		return (swp_entry_t){};
+	}
 
-	ci = __swap_entry_to_cluster(vswap_entry);
-	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
 	spin_lock(&ci->lock);
 	/*
 	 * Install PHYS backing without freeing any prior contents of the
@@ -2493,6 +2564,18 @@ static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
 	swap_cluster_unlock(pci);
 }
 
+/*
+ * Release the cgroup accounting of a batch of freed slots. For vswap the
+ * physical swap was already uncharged by __vswap_release_backing(), so only
+ * the ID ref is left to drop.
+ */
+static void memcg_swap_free(unsigned short id, unsigned int nr, bool is_vswap)
+{
+	if (!is_vswap)
+		mem_cgroup_swap_uncharge(id, nr);
+	mem_cgroup_swap_put(id, nr, is_vswap);
+}
+
 /*
  * Free a set of swap slots after their swap count dropped to zero, or will be
  * zero after putting the last ref (saves one __swap_cluster_put_entry call).
@@ -2505,10 +2588,11 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 	unsigned short batch_id = 0, id_cur;
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
 	unsigned int batch_off = ci_off;
+	bool is_vswap = swap_is_vswap(si);
 
 	VM_WARN_ON(ci->count < nr_pages);
 
-	if (swap_is_vswap(si))
+	if (is_vswap)
 		__vswap_release_backing(ci, ci_start, nr_pages);
 
 	ci->count -= nr_pages;
@@ -2532,14 +2616,14 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 		id_cur = __swap_cgroup_clear(ci, ci_off, 1);
 		if (batch_id != id_cur) {
 			if (batch_id)
-				mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
+				memcg_swap_free(batch_id, ci_off - batch_off, is_vswap);
 			batch_id = id_cur;
 			batch_off = ci_off;
 		}
 	} while (++ci_off < ci_end);
 
 	if (batch_id)
-		mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
+		memcg_swap_free(batch_id, ci_off - batch_off, is_vswap);
 
 	__swap_cluster_finish_free(si, ci, ci_start, nr_pages);
 }
diff --git a/mm/zswap.c b/mm/zswap.c
index fd0c2f126b57..22baac2662d2 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1197,11 +1197,17 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
  * With vswap disabled, all zswap entries use directly mapped physical swap
  * entries. With vswap enabled, such entries are rare.
  *
- * A zswap-backed vswap entry needs physical swap capacity for writeback.
+ * A zswap-backed vswap entry needs physical swap capacity for writeback
+ * and cgroup swap margin where applicable. @memcg may be NULL to check
+ * device capacity alone.
  */
-static bool zswap_writeback_possible(void)
+static bool zswap_writeback_possible(struct mem_cgroup *memcg)
 {
-	return !vswap_is_enabled() || get_nr_swap_pages() > 0;
+	if (!vswap_is_enabled())
+		return true;
+	if (!memcg)
+		return get_nr_swap_pages() > 0;
+	return mem_cgroup_get_nr_swap_pages(memcg) > 0;
 }
 
 /*
@@ -1341,7 +1347,7 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	if (!zswap_shrinker_enabled || !mem_cgroup_zswap_writeback_enabled(memcg))
 		return 0;
 
-	if (!zswap_writeback_possible())
+	if (!zswap_writeback_possible(memcg))
 		return 0;
 
 	/*
@@ -1428,7 +1434,7 @@ static struct shrinker *zswap_alloc_shrinker(void)
  * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
  *
  * Also returns -ENOENT when vswap is enabled and there is no physical
- * swap to write back to.
+ * swap for @memcg to write back to.
  */
 static int shrink_memcg(struct mem_cgroup *memcg)
 {
@@ -1437,7 +1443,7 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
 		return -ENOENT;
 
-	if (!zswap_writeback_possible())
+	if (!zswap_writeback_possible(memcg))
 		return -ENOENT;
 
 	/*
@@ -1468,7 +1474,7 @@ static void shrink_worker(struct work_struct *w)
 	int ret, failures = 0, attempts = 0;
 	unsigned long thr;
 
-	if (!zswap_writeback_possible())
+	if (!zswap_writeback_possible(NULL))
 		return;
 
 	/* Reclaim down to the accept threshold */
@@ -1549,7 +1555,7 @@ static void shrink_worker(struct work_struct *w)
 			break;
 resched:
 		cond_resched();
-	} while (zswap_total_pages() > thr && zswap_writeback_possible());
+	} while (zswap_total_pages() > thr && zswap_writeback_possible(NULL));
 }
 
 /*********************************
-- 
2.53.0-Meta

