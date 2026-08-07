Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0842F443E27
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 20:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786134069; cv=none; b=a4fCwIT4TmV5pgdsiLThPyedDA4YYcYuks6TdXUBZKZnF+LFt71hX1dv9tMN2INcsQpI0XK/chSSMSHsQT7OUuzNlDVBJzECNIAaz6nfKCABpDZL9hSEkfwA5ZK0YQY4evdfIFHW01K9ijgUMpQ5cVYnFobHEB7bARzSH8mraDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786134069; c=relaxed/simple;
	bh=HOogZ2bJZOmmIkJdY9y2MvQwya6iwHgtaiK7/Q90pew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7pyzRviEd1On7irgfajDmjElOLdyigZPzPEjrTFh2bt1wi16rje6EhFBcTiIRqDEjiw4MyTDV7JhiwDZ2/xy4G+1rXqEvdZ+EcGa6E6ZXrdS52j2tp0632LrrmqnScMV928FC4nFbcS6oV0jTruyNRgPQQwKPQRqcD9UEUFVy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M9hMxhB9; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M9hMxhB9"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-4a4cb36ae00so2295565b6e.0
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 13:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134067; x=1786738867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k/MfpY/lSQ8qNOiw/HDxNskiAGRLvzb2J5gjoLFAHE4=;
        b=M9hMxhB9Mc0kTXstxl+cRR9/7LncgF70NavK4eY8cZqzmEnowNmrOIJXooDSIn3X1j
         WhPqb/FVSXTJoWMRNIiB9aB5YI67OpqwzwNeXEP+EvzM3KICEGWAKHkkHCdJxu5nAv2f
         1PMINmLpHOA50SfoEQa3qIwAr5EKSUE7F6IpOf7xDghkureoKdZVOhw+defdahYELp3U
         UF1I4BDH82TnNKUOM9raSOLr3ec5ZceCH8D5jSNKgnLOTcekclZlcWgq5X11VUBOqW4m
         dDl4ST52QN9Q107+haUtnsfR+TTlCOjAalYgKbMb4ShmanJJtE+vCV+uiMr0UO2EHHCI
         rgxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134067; x=1786738867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=k/MfpY/lSQ8qNOiw/HDxNskiAGRLvzb2J5gjoLFAHE4=;
        b=j9enE0jVwIllO9xxR7eYcxm+UEEF3rndAKaqe6Fu7Z2I6ELSSGoHbzcjmIp4wDKpBf
         LnhwFVKlifc72pmFge2vZ/7DhH8rVdR7HUAxc9Mwsjz9iKFZQLk6zfgDF1rGOqOIhYpt
         V5/vTj/rxd9YcT8Tdw6r1PeCJEF5TDFBsmZiUQe/DDA8nEdJFR2Mt9DizJ7FoOcB9l5h
         5blOFXrYWxF7uFN/68onzp9Nqvw8UjUERBpRJxhOyEnsyg4H9fn83elM2+Nm1+wphbHx
         IUWBlwFdp4Flzm6G+f/yOJcudSlaiMol1hunIUrDdKyJ0FFaCNkmJfZgCcxf4EO0R4zG
         UzJg==
X-Forwarded-Encrypted: i=1; AHgh+RpEtBbESOyXI/3EHmewj0n4IrgKuK7JSoZ1bFsVAMR6H4RLeui15GXNy9TWCVsI0zlaqKHl4VuL@vger.kernel.org
X-Gm-Message-State: AOJu0Yzi7ZD6JamBQpQSvwwgwAbY2cdSdF+8FsSO9tlIkIWXvrHakzTD
	AfjQWqU7BqSIe29NHV3VegNnkO9X7zgajoRCpuSRwz9BV7Lg7+IHyFWy
X-Gm-Gg: AR+sD10eUWLX8w/AIu6rHVKa0eLqU4+hWu0jTFDJNjcAHA3lcZRoiUPIPRK3RdjOQqg
	7GPk7sYFmlwYFWfab6zrVDONt/Uy4aq+Y0Xfb5KPqLOBQkimzsRj7jtuaCbSLxkKMozH22sO9lb
	T+6kB6Jhy5fXn21CjDyerj3BbQ2ZAhhRXWi5MtY0D5/GSU02qxuf9czptaNqfPwLNoXfuzBsZpS
	4A6+1ESqRcBzO2RuLfmYSh3TzbbfK5SX7lnWZ2lZG3DXi4XzBLbK1Ie69qI5mLG0eJ4PxUy3MHQ
	wrftDgl7r1VbqfUGUr5BQZGAPNNujO+Afz3PLdmrTgBWQtfvXl+U9V6Fi02RmNkVpET4jDlZopq
	1I1LGqi1cBP9R9hLFm7uf1bnWzTmxkh75vyRrXrVJ+AowBQhxUX6Xq/r7bVnEI5k/g5GEzVdtrd
	E+CWXAc0xF2jA6lpfBI+UUVAbFk4jDEf880NDypjDLTQ0vyU6m16Ch705kmAKwIfLvBBW2rRrIi
	LSEJtAbiaQkciXBRmk=
X-Received: by 2002:a05:6808:15a6:b0:49b:c387:36c5 with SMTP id 5614622812f47-4afae16d6cfmr14165498b6e.17.1786134066779;
        Fri, 07 Aug 2026 13:21:06 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:42::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b1af0b57f6sm442378b6e.5.2026.08.07.13.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:06 -0700 (PDT)
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
Subject: [RFC PATCH v3 04/14] mm/memcontrol: Allocate per-tier page_counters
Date: Fri,  7 Aug 2026 13:20:47 -0700
Message-ID: <20260807202059.2620949-5-joshua.hahnjy@gmail.com>
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

Tier-aware limits need one page_counter per memory tier.  Add a
page_counter array (memcg->tier) to struct mem_cgroup, sized to
nr_node_ids (an upper bound on the number of tiers) and allocated only
when tiered limits are enabled, so memcgs pay nothing when the feature is
off.  Initialise and parent-link every slot in mem_cgroup_css_alloc(),
and free the array in __mem_cgroup_free().

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 23 +++++++++++++++++++++++
 mm/memory-tiers.c          | 17 ++++++++++++++---
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index dce03df7eae05..bb5bde87ac85a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -207,6 +207,7 @@ struct mem_cgroup {
 
 	/* Accounted resources */
 	struct page_counter memory;		/* Both v1 & v2 */
+	struct page_counter *tier;		/* v2 only */
 
 	union {
 		struct page_counter swap;	/* v2 only */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ec28512de6a23..d096010366515 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -53,6 +53,7 @@
 #include <linux/seq_file.h>
 #include <linux/vmpressure.h>
 #include <linux/memremap.h>
+#include <linux/memory-tiers.h>
 #include <linux/mm_inline.h>
 #include <linux/cpu.h>
 #include <linux/oom.h>
@@ -4126,6 +4127,7 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 	memcg1_free_events(memcg);
 	kfree(memcg->vmstats);
 	free_percpu(memcg->vmstats_percpu);
+	kfree(memcg->tier);
 	kfree(memcg);
 }
 
@@ -4178,6 +4180,13 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 		if (!alloc_mem_cgroup_per_node_info(memcg, node))
 			goto fail;
 
+	if (mem_cgroup_tiered_limits()) {
+		memcg->tier = kcalloc(nr_node_ids, sizeof(*memcg->tier),
+				      GFP_KERNEL);
+		if (!memcg->tier)
+			goto fail;
+	}
+
 	if (memcg_wb_domain_init(memcg, GFP_KERNEL))
 		goto fail;
 
@@ -4206,6 +4215,16 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	return ERR_PTR(error);
 }
 
+static void memcg_init_tier_counters(struct mem_cgroup *memcg,
+				     struct mem_cgroup *parent, bool protection)
+{
+	for (int i = 0; i < nr_node_ids; i++) {
+		page_counter_init(&memcg->tier[i],
+				  parent ? &parent->tier[i] : NULL, protection);
+		page_counter_set_high(&memcg->tier[i], PAGE_COUNTER_MAX);
+	}
+}
+
 static struct cgroup_subsys_state * __ref
 mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 {
@@ -4231,6 +4250,8 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
 		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
+		if (mem_cgroup_tiered_limits())
+			memcg_init_tier_counters(memcg, parent, memcg_on_dfl);
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
@@ -4243,6 +4264,8 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		init_memcg_stats();
 		init_memcg_events();
 		page_counter_init(&memcg->memory, NULL, true);
+		if (mem_cgroup_tiered_limits())
+			memcg_init_tier_counters(memcg, NULL, true);
 		page_counter_init(&memcg->swap, NULL, false);
 #ifdef CONFIG_MEMCG_V1
 		page_counter_init(&memcg->kmem, NULL, false);
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 36187c0ea9ded..bd5c78cd26ec4 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -52,6 +52,7 @@ static int nr_tier_slots;
 static int tier_slot_ids[MAX_NUMNODES]   = {[0 ... MAX_NUMNODES - 1] = -1,};
 static int node_tier_slots[MAX_NUMNODES] = {[0 ... MAX_NUMNODES - 1] = -1,};
 static nodemask_t tier_nodemasks[MAX_NUMNODES];
+static unsigned long tier_capacity[MAX_NUMNODES];
 
 struct memory_dev_type *default_dram_type;
 nodemask_t default_dram_nodes __initdata = NODE_MASK_NONE;
@@ -307,8 +308,10 @@ static void establish_tier_slots(void)
 
 	lockdep_assert_held_once(&memory_tier_lock);
 
-	for (int slot = 0; slot < old_nr_tier_slots; slot++)
+	for (int slot = 0; slot < old_nr_tier_slots; slot++) {
 		nodes_clear(tier_nodemasks[slot]);
+		WRITE_ONCE(tier_capacity[slot], 0);
+	}
 
 	for (int nid = 0; nid < nr_node_ids; nid++) {
 		struct memory_tier *memtier = NULL;
@@ -323,8 +326,16 @@ static void establish_tier_slots(void)
 
 		WRITE_ONCE(node_tier_slots[nid], slot);
 
-		if (slot != -1)
-			node_set(nid, tier_nodemasks[slot]);
+		if (slot < 0)
+			continue;
+
+		node_set(nid, tier_nodemasks[slot]);
+		for (int i = 0; i < MAX_NR_ZONES; i++) {
+			struct zone *zone = &NODE_DATA(nid)->node_zones[i];
+
+			WRITE_ONCE(tier_capacity[slot],
+				tier_capacity[slot] + zone_managed_pages(zone));
+		}
 	}
 	WRITE_ONCE(nr_tier_slots, highest_slot);
 }
-- 
2.53.0-Meta

