Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0249447800
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 20:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786134076; cv=none; b=Ju+vJRNIg8A1kQ944y+o4CaXOFaIIu7Hl2+JuvMRxxYBpq9hNKlrzlt6dwwjZcOpf6Y1A3Opj8d0sCQr/I6s+wMhoYX/Lwc30R80eaMFrtmXvqRlYW6UhHWLFXrL+UflyKnfNi4NhHMYW1CC+pplSrt0ZtqByGMiFRqrWKjGRFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786134076; c=relaxed/simple;
	bh=U4D2bds6vIRZf7Z7iayGAVoiAt9LSNRErOps55OMStg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMqPhN9AnTrD/6HsnChAeSkRDBJ1SMPr4aJKNVRd2EQYOdpszpQtS6AyphcLnWM027d+rEb/LaiJw9uZIsPft+f2Xx8U22WzG/WdHdxPth9ZTtBOTI3+1cmCr4WLurcXyUYvaZPmxVfV5YC78GlD/1xjo5LI/W1fg/HpzOiGYfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jm2mHeYu; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jm2mHeYu"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7e9ecb1e13cso3979594a34.3
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 13:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134074; x=1786738874; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qFD6EfRm/L4Zg2p1Y1cVpL/1kzGCx7Oqw9Sl1lvWZlg=;
        b=Jm2mHeYuVe1C9oWOfxJU+hn/H+3QP6Jmt88fiTN3I+2i9EwwDoJ+ULai5XxsbqdGdQ
         gWgKagcnMTa1TVQCz4QWA9PPWgN3WZo/X2APni0M6W7kb+PKf34iLxSN5DpIheKMjjOO
         JdOMvRIl3WdxXPVR3yeGZBgZknRAi0dj6x/gRSznp9N6k+GNiDM5PtfVNaHhAkazDkge
         ucya7o9Xrem5hzfQZY4YLKZUxjdnBdbhV82qsEftKMVsQpJvOB097B+D9fHsproSeyBD
         cIYYpqZTdhVnRnRH5IejK0HCpQPTrOUEmPAABdMTpgK/VePrtKHxlAfhJPOqbnyUACOB
         xemg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134074; x=1786738874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qFD6EfRm/L4Zg2p1Y1cVpL/1kzGCx7Oqw9Sl1lvWZlg=;
        b=it4U/57SYIHBhmxsvcgHz+YCJAtrw6Gsx3XMurwMyjorCoQ/neok8KSjxWdcUtbqzp
         YF3RxntGKVP8nOM1PIXHHQE9Ck4j2/tr6gOMZhUbHVHfQxdKy1D3XxPG2MwaJ7hV2xHS
         ZIMXEtrj9pqvzD3PJmk7GzWT7EsppCN+VotRPXZL0CYuhup60AJozr3peWwYCZLFfnFt
         Yonj6LuF8/tA7QTjM4IkdEuWH6Uidp6J3E6HWa1TckNSsLspTeaaMtTLSQnR1MPfVioo
         zttlwSaMITs6KL2eqUPrEPrH41pHMnpIKRVRAafKysfJqUmMlx3oYOPCZig7LavUPGtl
         LUlw==
X-Forwarded-Encrypted: i=1; AHgh+RqgqXuMTgmIs3Csmi0Va5Llb11d2fSjI60sgLyZ4LIO9UAMlURIImZRCr3YOajDDsu0T2F4eNd7@vger.kernel.org
X-Gm-Message-State: AOJu0YymKaYJ1PpFb9+Wwjb5V3S3UKTdgKbfYPXXKfpU65GyCuexFAo+
	beLsdlTykNwMCKEwW9b5QP5B61I5krLXVpbzDrxNqCV+Cs+Y09/HQiY+
X-Gm-Gg: AR+sD10dM+J9wUMeuYwx3BcTVOzXBU85TSpkHCIgRLTZo4Idif07cxm6BEgzthE7iqj
	Uo4zG6R0ak8iDpiQ9R9tkU2K4tIW8dqSDlMDpqsFCUCWQg/7ZwVNbEP0avXiaSF4F9Q6wd8xxlF
	37rIMEY2xSURDPQCCwP7Fy4bdZ/QqBa5GQWRwLClfBsKXMakE/jW8Vb5pEMx9y6B+lpI92xkmAt
	vxLZh+iS54gHe4hjaLbiOUNjwbC7zsYqvynOpFt9CEiHAwDffslICBKYty65Ow1e7+BVvs4730W
	kdU75mRHaHYOR7GS13SgApDugVcXUTn3i2/o0PXrWtdhVQ6YGRPI0jBx75InuuzP//V05ziHPum
	1xTtrhF2CUnB/7CVK2fdt1gQafijPZMtrsyowDk5ODPZ0Mj+QxEgnetGfpxE7opku2AmswYNm/h
	oZvrat+T20eCjGTR9SlaP6GkVNwe/2MIkMNR5tHqLZ/250zl5y5fG/dyRrhNt6ObzZOb6ha/6As
	m0SJy/ngUTzHD/D184=
X-Received: by 2002:a05:6830:82fb:b0:7dc:c7aa:22bd with SMTP id 46e09a7af769-7f1e5ce763dmr15477492a34.6.1786134073875;
        Fri, 07 Aug 2026 13:21:13 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:58::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f35b56391dsm1914394a34.1.2026.08.07.13.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:13 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kairui Song <kasong@tencent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Rakie Kim <rakie.kim@sk.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [RFC PATCH v3 09/14] mm/memcontrol: Make memory.high tier-aware
Date: Fri,  7 Aug 2026 13:20:52 -0700
Message-ID: <20260807202059.2620949-10-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On machines serving multiple workloads whose memory is isolated via
the memory cgroup controller, it is currently impossible to enforce a
fair distribution of tiered memory among the workloads, as the only
enforceable limits have to do with total memory footprint, but not where
that memory resides.

This makes ensuring consistent baseline performance difficult, as each
workload's performance is heavily impacted by workload-external factors
such as which other workloads are co-located in the same host, and the
order in which the workloads are started.

Extend the existing memory.high protection to be tier-aware.

Depending on the combination of limit breaches, selectively reclaim on
tiers: when memory.high is breached, perform reclaim on all tiers.
When memory.high is safe but individual tier limits are breached,
perform targeted reclaim on those tiers only.

No-op unless the system has tiered memcg limits enabled.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 66 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 55 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 025496794cb91..44ea465b2005d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2387,6 +2387,28 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 	return 0;
 }
 
+static bool memcg_tier_over_limit(struct mem_cgroup *memcg,
+				  unsigned long *overage, int *breached_slot)
+{
+	int nr_tier_slots = mt_nr_tier_slots();
+
+	for (int slot = 0; slot < nr_tier_slots; slot++) {
+		unsigned long usage = page_counter_read(&memcg->tier[slot]);
+		unsigned long limit = READ_ONCE(memcg->tier[slot].high);
+
+		if (usage <= limit)
+			continue;
+
+		if (overage)
+			*overage = usage - limit;
+		if (breached_slot)
+			*breached_slot = slot;
+		return true;
+	}
+
+	return false;
+}
+
 static unsigned long reclaim_high(struct mem_cgroup *memcg,
 				  unsigned int nr_pages,
 				  gfp_t gfp_mask)
@@ -2395,10 +2417,19 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 
 	do {
 		unsigned long pflags;
+		const nodemask_t *reclaim_nodes = NULL;
 
 		if (page_counter_read(&memcg->memory) <=
-		    READ_ONCE(memcg->memory.high))
-			continue;
+		    READ_ONCE(memcg->memory.high)) {
+			int slot;
+
+			if (!mem_cgroup_tiered_limits())
+				continue;
+			if (!memcg_tier_over_limit(memcg, NULL, &slot))
+				continue;
+
+			reclaim_nodes = mt_tier_nodes(slot);
+		}
 
 		memcg_memory_event(memcg, MEMCG_HIGH);
 
@@ -2406,7 +2437,7 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
 							gfp_mask,
 							MEMCG_RECLAIM_MAY_SWAP,
-							NULL, NULL);
+							NULL, reclaim_nodes);
 		psi_memstall_leave(&pflags);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
@@ -2842,23 +2873,25 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * reclaim, the cost of mismatch is negligible.
 	 */
 	do {
-		bool mem_high, swap_high;
+		bool mem_high, swap_high, tier_high;
 
 		mem_high = page_counter_read(&memcg->memory) >
 			READ_ONCE(memcg->memory.high);
 		swap_high = page_counter_read(&memcg->swap) >
 			READ_ONCE(memcg->swap.high);
+		tier_high = mem_cgroup_tiered_limits() &&
+			memcg_tier_over_limit(memcg, NULL, NULL);
 
 		/* Don't bother a random interrupted task */
 		if (!in_task()) {
-			if (mem_high) {
+			if (mem_high || tier_high) {
 				schedule_work(&memcg->high_work);
 				break;
 			}
 			continue;
 		}
 
-		if (mem_high || swap_high) {
+		if (mem_high || swap_high || tier_high) {
 			/*
 			 * The allocating tasks in this cgroup will need to do
 			 * reclaim or be throttled to prevent further growth
@@ -4967,13 +5000,24 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
-		unsigned long reclaimed;
+		unsigned long reclaimed, charge;
+		const nodemask_t *reclaim_nodes = NULL;
 
 		if (high != READ_ONCE(memcg->memory.high))
 			break;
 
-		if (nr_pages <= high)
-			break;
+		if (nr_pages <= high) {
+			int slot;
+
+			if (!mem_cgroup_tiered_limits())
+				break;
+			if (!memcg_tier_over_limit(memcg, &charge, &slot))
+				break;
+
+			reclaim_nodes = mt_tier_nodes(slot);
+		} else {
+			charge = nr_pages - high;
+		}
 
 		if (signal_pending(current))
 			break;
@@ -4988,9 +5032,9 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 			continue;
 		}
 
-		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
+		reclaimed = try_to_free_mem_cgroup_pages(memcg, charge,
 					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
-					NULL, NULL);
+					NULL, reclaim_nodes);
 
 		if (!reclaimed && !nr_retries--)
 			break;
-- 
2.53.0-Meta

