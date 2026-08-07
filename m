Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B21244238E
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 20:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786134072; cv=none; b=Rh1PiaWAufu5vUKGsc15UfofDdQIeYsIJ+7lwkruor42kj4qOgA6a35a/Tk/sZJHGLTDSqRYqqtpcJK7Up/1zd0w3Ivoy5uEkD9fGJfO+PGY7bZyZiSfY4WCCEv4G0Oc0Sm9yTPyybfEvL98QzFSFniYqYY8SehC16C3vaZJGnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786134072; c=relaxed/simple;
	bh=cvy8xs5odfKdlZvQWmVQYRS0OJ7R2YTEIC6VhLVlmYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+HszriF6UjzdrhNv5a4Uxjdvduaqnf1V8kTHmkKlUz1KIGKQyJ3ZLKrsEaaesrlVUxQjIL8/27F8qNn+1uxXnOdrbhskyYHapTd6ssHth2X8dhCvfWO8gv24oALilqesi6CNvCSe1B6+IcAQ0H2U+jEDOmEDapxfFhIyijweA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m/2p5+DC; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m/2p5+DC"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6b031d400feso601812eaf.1
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 13:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134069; x=1786738869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5vEVg85rEvrzvIwoN3Uc+WskLG7iLQIioETffuSYNDk=;
        b=m/2p5+DCfwh579mm/HZea72TYbGe8crCuFyyofCi0a3O8phGn1dASa0vl4MbFUDaVc
         6RQdJKkPxcgB5yfLJLJ6a4opsxS1I8EtaeNslV6UhTBFPwVKII+WVxkStDfGNCt9uHXG
         5ugJp+ORVYI8I8kqYQ/zKw17tuWDZE2sAIcnWMgujVfoj0Gon7z0JxfErBJHHz1GlhE5
         dPNHRpseCBQktp0JMI1sJt7VOo5zaeRAjp9qNCxga4XcPZsJE1DfdtQ+32Sb7ipdopYv
         VocqQNa3aptoknWpVUw6lBILejtklpuIjrmEgFRibQTrEQEAcdsjQZuluLb4gipw+DVj
         uhbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134069; x=1786738869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5vEVg85rEvrzvIwoN3Uc+WskLG7iLQIioETffuSYNDk=;
        b=SyqGg2ZpiASfLKnLypU0NFpcrzmwoD9f9stBfAi7O699k0GHD4X+kLcqT2KRndpZB8
         AGN6AQ2IdweUnptq6n4X7ikIYeLHWck+jgjTh4Wk+vvnHbKP2sE2G/gg7vwYbtrNaUp8
         5He4NCdGJ9MHFMCXXOLgAeFMNuqZXKyj6M4wHu1N+9gjQ1kqY6RJUdSURojm0ky2qEpR
         8rqRSr0MWo7UQe5Aqi3xcf6jtN5P6U/yqeDqy5sHqeCelSE8jGLnQ8sWrQV9k5eDaHF/
         7tC1HwSzuta+Sjt5pj/nEHjN/Ka56CcXuNYKrv4WwwLsaqn9BvJjZ+QxAxqHKeJZ2S5V
         I7Dg==
X-Forwarded-Encrypted: i=1; AHgh+RqsUgvT+WCjTljGDVz6IiyUqDwldjAQFb+kPPajxO44B2LRxC6KMdWg6vDlcqoMhiMuHdhNzF5v@vger.kernel.org
X-Gm-Message-State: AOJu0YxOBrxIAtb68zSEOPHdA5VeGM4MC7oj3tTK4OgPZde83kdQEk5w
	+67BE7MvqoN9Ewd4P1qXTqYvURk2A+i6acgnOFGTUXhvMjDx5e8+1oRA
X-Gm-Gg: AR+sD11JkGmp2O4VJEw9K0JbBKsVPWbx737AaOzrtNNDi5lSD6LibZUJyjkt5hPSXj8
	PLa2FBqTlTOeTfuyerp12WE16ls4+MKZR0EaZHInJWr/tzrqnNhcPwSajs30ZI09P+3OwSj3k8W
	kMNMhrKGv/Z05Jp6HO3G52vJ4CGtwkasD3Zg2JdSiJ++j5a3KcqOeg4fXM6B7BbCZA5v57PSyMr
	jn5wFrLrT9rP7q6saQI0QojfyMR0Og1MR0DjeHV8FPohJvcOfTWq/q6N7DqTOYSykNkq/m4AGdT
	+Nu2NY4Ajq//gKfTCQjhBjoLw/pfnSr3xrELwbWMvLbK55hg58pOsisTTK/SYowl9rwYNb9qcy8
	RXnaUeUZYcFxkBD7IN/qJAKBgD+t+a7fDG55pGQGGFn49wSiIZyfkIldCMNnSoHbgSv8WDP3PjJ
	gD2Aw/jPak7PVD5JT0ScD6EgQyh7+Os30VUzP+/HLwrsWbYLPCLRGZ/QuxNdAjhjC6WqLsfAVUT
	bHATAKqNimi1eqKeQ==
X-Received: by 2002:a05:6820:168f:b0:6ae:9b39:68d1 with SMTP id 006d021491bc7-6b0420d5753mr1429497eaf.23.1786134068227;
        Fri, 07 Aug 2026 13:21:08 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b02be475f7sm2836904eaf.9.2026.08.07.13.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:07 -0700 (PDT)
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
Subject: [RFC PATCH v3 05/14] mm/memcontrol: Set tier limits proportional to memory limits
Date: Fri,  7 Aug 2026 13:20:48 -0700
Message-ID: <20260807202059.2620949-6-joshua.hahnjy@gmail.com>
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

Compute proportional per-tier limits based on memory limits when
users write to memory limit sysfs files, or when memory hotplug causes
tier proportions to be shifted.

No-op unless the system has tiered memcg limits enabled.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h   | 10 +++++++
 include/linux/memory-tiers.h |  6 ++++
 mm/memcontrol.c              | 54 ++++++++++++++++++++++++++++++++++++
 mm/memory-tiers.c            | 13 +++++++++
 4 files changed, 83 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index bb5bde87ac85a..f7a92b66330ec 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -537,11 +537,17 @@ static inline bool mem_cgroup_tiered_limits(void)
 {
 	return static_branch_unlikely(&memcg_tiered_limits_key);
 }
+
+void establish_memcg_tier_limits(void);
 #else
 static inline bool mem_cgroup_tiered_limits(void)
 {
 	return false;
 }
+
+static inline void establish_memcg_tier_limits(void)
+{
+}
 #endif
 
 static inline void mem_cgroup_protection(struct mem_cgroup *root,
@@ -1102,6 +1108,10 @@ static inline bool mem_cgroup_tiered_limits(void)
 	return false;
 }
 
+static inline void establish_memcg_tier_limits(void)
+{
+}
+
 static inline void memcg_memory_event(struct mem_cgroup *memcg,
 				      enum memcg_memory_event event)
 {
diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 0e49645cdd1a9..04b396f60b457 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -55,6 +55,7 @@ struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 						  struct list_head *memory_types);
 void mt_put_memory_types(struct list_head *memory_types);
 const nodemask_t *mt_tier_nodes(int slot);
+unsigned long mt_scale_by_tier(unsigned long val, int slot);
 #ifdef CONFIG_NUMA_MIGRATION
 int next_demotion_node(int node, const nodemask_t *allowed_mask);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
@@ -169,5 +170,10 @@ static inline const nodemask_t *mt_tier_nodes(int slot)
 {
 	return NULL;
 }
+
+static inline unsigned long mt_scale_by_tier(unsigned long val, int slot)
+{
+	return val;
+}
 #endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d096010366515..defd04acfb3fd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4421,6 +4421,35 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 	mem_cgroup_free(memcg);
 }
 
+static inline unsigned long page_counter_max_or_scale(unsigned long val,
+						      int slot)
+{
+	return val == PAGE_COUNTER_MAX ? PAGE_COUNTER_MAX :
+					 mt_scale_by_tier(val, slot);
+}
+
+static void memcg_scale_tier_limits(struct mem_cgroup *memcg)
+{
+	unsigned long min = READ_ONCE(memcg->memory.min);
+	unsigned long low = READ_ONCE(memcg->memory.low);
+	unsigned long high = READ_ONCE(memcg->memory.high);
+	unsigned long max = READ_ONCE(memcg->memory.max);
+	int nr_tier_slots = mt_nr_tier_slots();
+
+	for (int slot = 0; slot < nr_tier_slots; slot++) {
+		unsigned long new_min = page_counter_max_or_scale(min, slot);
+		unsigned long new_low = page_counter_max_or_scale(low, slot);
+		unsigned long new_high = page_counter_max_or_scale(high, slot);
+		unsigned long new_max = page_counter_max_or_scale(max, slot);
+		struct page_counter *tier = &memcg->tier[slot];
+
+		page_counter_set_min(tier, new_min);
+		page_counter_set_low(tier, new_low);
+		page_counter_set_high(tier, new_high);
+		xchg(&tier->max, new_max);
+	}
+}
+
 /**
  * mem_cgroup_css_reset - reset the states of a mem_cgroup
  * @css: the target css
@@ -4454,6 +4483,8 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
 	memcg1_soft_limit_reset(memcg);
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
+	if (mem_cgroup_tiered_limits())
+		memcg_scale_tier_limits(memcg);
 	memcg_wb_domain_size_changed(memcg);
 }
 
@@ -4797,6 +4828,21 @@ static ssize_t memory_peak_write(struct kernfs_open_file *of, char *buf,
 			  &memcg->memory_peaks);
 }
 
+#ifdef CONFIG_NUMA
+void establish_memcg_tier_limits(void)
+{
+	struct mem_cgroup *memcg;
+
+	if (!mem_cgroup_tiered_limits())
+		return;
+
+	for_each_mem_cgroup_tree(memcg, NULL) {
+		if (memcg != root_mem_cgroup)
+			memcg_scale_tier_limits(memcg);
+	}
+}
+#endif
+
 #undef OFP_PEAK_UNSET
 
 static int memory_min_show(struct seq_file *m, void *v)
@@ -4818,6 +4864,8 @@ static ssize_t memory_min_write(struct kernfs_open_file *of,
 		return err;
 
 	page_counter_set_min(&memcg->memory, min);
+	if (mem_cgroup_tiered_limits())
+		memcg_scale_tier_limits(memcg);
 
 	return nbytes;
 }
@@ -4841,6 +4889,8 @@ static ssize_t memory_low_write(struct kernfs_open_file *of,
 		return err;
 
 	page_counter_set_low(&memcg->memory, low);
+	if (mem_cgroup_tiered_limits())
+		memcg_scale_tier_limits(memcg);
 
 	return nbytes;
 }
@@ -4866,6 +4916,8 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 		return err;
 
 	page_counter_set_high(&memcg->memory, high);
+	if (mem_cgroup_tiered_limits())
+		memcg_scale_tier_limits(memcg);
 
 	if (of->file->f_flags & O_NONBLOCK)
 		goto out;
@@ -4925,6 +4977,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 		return err;
 
 	xchg(&memcg->memory.max, max);
+	if (mem_cgroup_tiered_limits())
+		memcg_scale_tier_limits(memcg);
 
 	if (of->file->f_flags & O_NONBLOCK)
 		goto out;
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index bd5c78cd26ec4..e2c99f51c36d1 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -810,6 +810,7 @@ static int __init memory_tier_late_init(void)
 
 	establish_demotion_targets();
 	establish_tier_slots();
+	establish_memcg_tier_limits();
 	put_online_mems();
 
 	return 0;
@@ -967,6 +968,16 @@ const nodemask_t *mt_tier_nodes(int slot)
 	return &tier_nodemasks[slot];
 }
 
+unsigned long mt_scale_by_tier(unsigned long val, int slot)
+{
+	unsigned long total_capacity = totalram_pages();
+
+	if (slot < 0 || !total_capacity)
+		return 0;
+
+	return mult_frac(val, READ_ONCE(tier_capacity[slot]), total_capacity);
+}
+
 static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 					      unsigned long action, void *_arg)
 {
@@ -979,6 +990,7 @@ static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 		if (clear_node_memory_tier(nn->nid)) {
 			establish_demotion_targets();
 			establish_tier_slots();
+			establish_memcg_tier_limits();
 		}
 		mutex_unlock(&memory_tier_lock);
 		break;
@@ -988,6 +1000,7 @@ static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 		if (!IS_ERR(memtier)) {
 			establish_demotion_targets();
 			establish_tier_slots();
+			establish_memcg_tier_limits();
 		}
 		mutex_unlock(&memory_tier_lock);
 		break;
-- 
2.53.0-Meta

