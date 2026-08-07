Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01D842640D
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 20:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786134064; cv=none; b=U/os7iyOMAzf35r/UowhLYGy63o9VbM4tDbcwLlChm5mKFntwRICvnsXpO7Y0wAX6HbCmNiEqnw6fnVC+B7fr/O3vKSqgqbkFRijdcRjNGF6ZSfQKpsAQjTjhlUfBCQzakxxsH1H11+G47U37sGoDgjMwSUfqsmgtvTLJQg6cyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786134064; c=relaxed/simple;
	bh=x6+zULnjVSGwKnGUnc1/UzJDwmZxjXg8KnI3HpUc3JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3ZllitqKG7Sm5Ysnz0EOGjEvzckHLjsYjLfvp5smJeFYfpLZEYc2faxHFRSX1Pq57Mw6jJa3DIh/ZxXCVFHyoRHk29SOfx1z9Vfm25LudowXgobn3MEyCDWjKAu2U6qfWorKED2jYJ1O7lIjJOc97K/UJl0/sU+BaiSJEMUvJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D0Y2G/E+; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D0Y2G/E+"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7eb68bdf53aso1531160a34.3
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 13:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134061; x=1786738861; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HwNwt7qn0Dj2QjnweBxCilOvMKex3+n+ntJRoPVYrE4=;
        b=D0Y2G/E+peOkW9difLI0B2hdOxQhXBum0CQfAU5NerFA7QrCfSs4+JUHybGD8PI3hx
         8veDigyVuMn1Uu3q4VN6zCu72zVR0USFLNecNETtes/YY2sbWz9SN8ZlURH4fYeCPhmn
         KrnrEkFA80zfW5sQreM5DW26cG4/xs8W1YC659sq6fyMGR57apg70E8K7fS61ck+x80y
         j3qlPzekZj4NgSCKdLJY4nQ07fF53YoiFvdOJbZPZHQsampYJTZQObl7y3tbBjewqb9M
         Fz1dnzLal2Vja4UGC7xc+LWKi52qJ4QIPgN5PiFB6M8eiar2b5BCUb5QFa9VTZmo0Jhb
         b/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134062; x=1786738862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HwNwt7qn0Dj2QjnweBxCilOvMKex3+n+ntJRoPVYrE4=;
        b=MD+TSF7oX1UnJezSPb3Bs6qeNctu61RNCRlzzzH4DbWV4gVQ17SmRzVDox7ElckXDW
         3rTJXf5v0vpr+B6BBvvyW9ZNQHYQAV5SBog4EIlhnaQ2Wg9FG9KvAvCcvesmPgBtlmI9
         VOLIpgHQYTn9+n7FVqPrUzAvn0TRMhPt3XO2Am+YLgYOP53bDj8tkFOMnoFmZWfRxPpb
         I6xx2Ix3o439HgpQnBeBQ0pni4enTxa7vCEvJowKTYq/b2JF1gpIYTZQhFsisjLJ++9T
         uIJ1McVkiFuWDq5cP+578RMjm8BS2/xJPIQ0RDM7t/D1FwrKgOSoG8ubAKv12ruTDcmy
         O9CA==
X-Forwarded-Encrypted: i=1; AHgh+RroEvr7Lv0bQ54U/oDeOR+ik1dzWuOAM/ohz1o3bWud/bMGPVEShQv9f+ZPhKhQw2VltOWCA9Yv@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6WqGJsZ7Fr3wdX4REBLoWrXi1MPndAX3/UJi7LZ/wqk8qXhN8
	zKCtsYNpoPsAkpa21XyOrx/kt3IJyFKhFZurvCHQuDB6bEAIslCSZZsR
X-Gm-Gg: AR+sD126A7s1S6wGMirb3QE9pPKPPxlWzLy8h+hH7xyDATvRZFhSjgum187EswSra1t
	A5UzBfSjzt7gb6z0nM0pVatXKFd3EfM+SabQY1z8s3+dcMiCFc69eq00E3+r9j88e68Sluj34D4
	gePt/zlVR4tfhXd5GA7DOIntYvss28rAeUp5M42w92jvj1WygDAlPsO7AaYUXSMWj3bi/V/JCMO
	pW7D3cEuP/Ir0KX5GJC+lfGEt5RxSfBGBSyR20Czdz7hBcc/SJGHii/a4pOO6NmaR/uyhUAs5yi
	yP93SPQWbASWYsgPJEqGuthNYLKGOV23Bl/a1fZnK2157BAe+c+ZucBI0hTKIZ+Os3D8fdssGS3
	qV2IN5xu78iJbU4QbLDg6VMM+MpC+qW3dZxbDN5dEs73r3A9kLOHTyKecGXB+D8Ebq2OERgbot5
	um0+X68eR9MEqfmnT2eetTynuS8AS03AYh1xSigBxGfS4cxrpGbKeAS3nVbEIIdsukfJA4Wz/vg
	XsKmKALoEDHY2zLbWgfcUV6xJVO2w==
X-Received: by 2002:a05:6820:1791:b0:6ae:ab01:9199 with SMTP id 006d021491bc7-6b042266f4fmr1570536eaf.34.1786134061552;
        Fri, 07 Aug 2026 13:21:01 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:25::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b02bc2631esm3229086eaf.4.2026.08.07.13.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:00 -0700 (PDT)
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
Subject: [RFC PATCH v3 01/14] mm/memcontrol: Introduce cgroup.memory=tiered_limits boot parameter
Date: Fri,  7 Aug 2026 13:20:44 -0700
Message-ID: <20260807202059.2620949-2-joshua.hahnjy@gmail.com>
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

Introduce a "tiered_limits" option for the cgroup.memory= kernel
commandline parameter to enable tier-proportional scaling and
enforcing of the memory cgroup controller limits
memory.{min, low, high}. Since mem_cgroup_tiered_limits() will
become a hotpath in the later commits to gate charging, demotion,
and promotion decisions, use a static key so that cgroups not using
tier-aware-memcg limits has minimal overhead.

Enable it by adding to the kernel command line:
	cgroup.memory=tiered_limits

The option is boot-time only, since flipping the bit at runtime could
leave charges uncharged in the future, or uncharges for folios that
were never charged.

This feature is incompatible with cgroup v1, and wil raise a single
warning statement if a system booted with tiered limits mounts a
legacy cgroup:

[XXX] cgroup.memory=tiered_limits should not be enabled with cgroupv1

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h | 18 ++++++++++++++++++
 mm/memcontrol.c            | 19 +++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 2118d5b33d051..dce03df7eae05 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -530,6 +530,19 @@ static inline bool mem_cgroup_disabled(void)
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
+#ifdef CONFIG_NUMA
+DECLARE_STATIC_KEY_FALSE(memcg_tiered_limits_key);
+static inline bool mem_cgroup_tiered_limits(void)
+{
+	return static_branch_unlikely(&memcg_tiered_limits_key);
+}
+#else
+static inline bool mem_cgroup_tiered_limits(void)
+{
+	return false;
+}
+#endif
+
 static inline void mem_cgroup_protection(struct mem_cgroup *root,
 					 struct mem_cgroup *memcg,
 					 unsigned long *min,
@@ -1083,6 +1096,11 @@ static inline bool mem_cgroup_disabled(void)
 	return true;
 }
 
+static inline bool mem_cgroup_tiered_limits(void)
+{
+	return false;
+}
+
 static inline void memcg_memory_event(struct mem_cgroup *memcg,
 				      enum memcg_memory_event event)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 29330f5f9d4eb..cefe33b5fd285 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -320,6 +320,13 @@ EXPORT_SYMBOL(memcg_kmem_online_key);
 DEFINE_STATIC_KEY_FALSE(memcg_bpf_enabled_key);
 EXPORT_SYMBOL(memcg_bpf_enabled_key);
 
+#ifdef CONFIG_NUMA
+DEFINE_STATIC_KEY_FALSE(memcg_tiered_limits_key);
+
+/* Tier-proportional scaling of memory controller limits enabled? */
+static bool cgroup_memory_tiered_limits __ro_after_init;
+#endif
+
 /**
  * get_mem_cgroup_css_from_folio - acquire a css of the memcg associated with a folio
  * @folio: folio of interest
@@ -4202,6 +4209,9 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	struct mem_cgroup *memcg, *old_memcg;
 	bool memcg_on_dfl = cgroup_subsys_on_dfl(memory_cgrp_subsys);
 
+	if (mem_cgroup_tiered_limits() && !memcg_on_dfl)
+		pr_warn_once("cgroup.memory=tiered_limits should not be enabled with cgroupv1\n");
+
 	old_memcg = set_active_memcg(parent);
 	memcg = mem_cgroup_alloc(parent);
 	set_active_memcg(old_memcg);
@@ -5584,6 +5594,10 @@ static int __init cgroup_memory(char *s)
 			cgroup_memory_nokmem = true;
 		if (!strcmp(token, "nobpf"))
 			cgroup_memory_nobpf = true;
+#ifdef CONFIG_NUMA
+		if (!strcmp(token, "tiered_limits"))
+			cgroup_memory_tiered_limits = true;
+#endif
 	}
 	return 1;
 }
@@ -5630,6 +5644,11 @@ int __init mem_cgroup_init(void)
 	memcg_pn_cachep = KMEM_CACHE(mem_cgroup_per_node,
 				     SLAB_PANIC | SLAB_HWCACHE_ALIGN);
 
+#ifdef CONFIG_NUMA
+	if (cgroup_memory_tiered_limits)
+		static_branch_enable(&memcg_tiered_limits_key);
+#endif
+
 	return 0;
 }
 
-- 
2.53.0-Meta

