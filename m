Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC624B0E2F
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 21:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789592791; cv=none; b=eYt2zv2Jk1slSi6cg7Wtod3imJqfXuJzvM/ieBN0yDIZciCdL+nWkLaVAMW5LwG+tH+JS1OY6JDaSbYh5ci1FcEACP0yjIzzLZw2VD0tZ7ZMlQuudlxCxuf2EVMDXM21IlbncscjSm89cIih8n4OrbqhodSBGT2hp8EJvkIyPH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789592791; c=relaxed/simple;
	bh=4iNlQRuHJ3/AP4thfCwYHevvDqFDf2gRy5/msQNXKiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NF7TF8hekj5kFer+NObKZqw1Ww0zQjQErEdez6i0RzIZ93sXK8CEHnGx3K2xlzBBhTXhnhrLXWdrzt6RCkF9NDbzAzr7tzLz6EE44Domo23Fkx/NGjI4MZHGIp3MCPuhUzM54yb+5KG9j5fqla9HqBjiS9pnCKax+il6BYUbbNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WVJkKTre; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WVJkKTre"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-80638c24bedso67127a34.0
        for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 14:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789592762; x=1790197562; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HaJwiI/6dGGbCvd8Rz5XOkB+OlzyBFXfmU7W/ZpuGJs=;
        b=WVJkKTre4aCj15aYOsoOM6QO3yqYX7djhgTpKS4/D4fvYcrrLsGWd0OtdxH+KrTN0z
         lUItTKad+25FSMAx+NyFQ5CaM28We44s0YrpE1PVoPJ9hMQ4BoSgDENApkxpFAyzeiwD
         q5KLvIvRyhR+8GBMhSSC5DXTGU0kxrghStqPQ0vRIKoa8uZBFr51pFF15VH1yrdFvXfq
         MSiOfB8T3WOPhQYnnZ0PskVFnKFixZRC51dNpCky7KuWaxiS8Dxge1d5LEeINTNZrj+3
         xh3iUeaE5scl8y3kxfh6CmmdsDDMOEzxypp0KOp3GJK5PT7+qyTcgYMVwlVfJslIUBiq
         XgZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789592762; x=1790197562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HaJwiI/6dGGbCvd8Rz5XOkB+OlzyBFXfmU7W/ZpuGJs=;
        b=Up8M/rhI3CI/YjOVQh0WNpK6spGKW0Wd0qrUHNfez+a6yd6VvCDiBc0AGzBZFuIVIp
         G87+6BPDDOBD+RDFoq8jL776yLHA6kBVxZvJ4tB/YafFeg5DloSsJmML4buT7vZ9TcfT
         0zLc/gNGiYIuQQxQiU5hE1HD3fOM+0ymLyNLriLMiRZUXkTHxwV4CqUrFEVLSgOwVom5
         7pzsC3TayG2XXH2hk9HmP6f0lV3M/O2Fli0JtQpAtubdaY7PYvBPaeQ+3BFZBdCnWq6m
         LRPoIzscxWSUsZfWa1RLAjurTghd0bzyKLpY+7c5rpqSaK+wdVUWeFgymie05DcuJZUp
         uDTA==
X-Forwarded-Encrypted: i=1; AKwUvBz38C3JbhpCyKDtDdmM13Y4MLRVS0nEPWKyxFYYSsbVnU3nCPgZ9bKoVPueOuNN5fmqmbZ090uo@vger.kernel.org
X-Gm-Message-State: AFuF++kMLBc8xAOfb+CnqUy6RFl5ZbcnykazIrhKnR8HONpLELEJEz7h
	ketfaAJXQeuLQC+mL2gtcc9uZTu1WVefcHlV1cgMjvI/YL+d2CAwedhw
X-Gm-Gg: AYBFou0Sns70RyREgMbZTMdKOX6iHBejkbU3sioqXFQrCoF0RAgTnZgDlsHBeR6r+k1
	ax/9GBrDJvlkOMuZQ9VLMDmZeKgFC8rrJZFgITo4O8TsQY7d6d0rkDiqf6n2hhUeCBmk103rfaV
	JweaP+Qz0bj0nw5Lw1MQ55Y9xulIWnIGzhuGx7SFjCkYTyIwTXxCUeiIPYEShlIzebNcJ9WLeqq
	96KLy/nF9flWypUmesFrlpDIzjATWYAJLGHXMHBc84CMgucUQTFoN9ypbYG9Yr+M+0Jspgk02t/
	99WqsryJQ5flHGOmAKL0ZYmSxneRA2/R1NHoRPLajnzz0BBVqQEfKa6ZHfyA5YLYlMFfUOCj1Lf
	/bGCAD7KlA1xOAopRX/j3lTnxk+9oO1Rx5XY5zAW65KYWtA9aRshKT3mg1djJPb3SH6ZyKD8jrq
	t5LmR/cgW8BK5NJ0Rieh31+XAUYtCdi01FKZ9UW5+Bf847h+3CKUumglaYia3nGsOZo2KDGn/RL
	MJ8NLSK6MQ8F6qeSBRTRlXuJzToBw==
X-Received: by 2002:a05:6830:a1d0:10b0:805:5bf7:4ab with SMTP id 46e09a7af769-80c4bd14b16mr715864a34.1.1789592762077;
        Wed, 16 Sep 2026 14:06:02 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:2e::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-80c466a2dcesm1019834a34.11.2026.09.16.14.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 14:06:01 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v6 5/5] mm/memcontrol: add stock to the memsw page counter
Date: Wed, 16 Sep 2026 14:05:51 -0700
Message-ID: <20260916210552.891730-6-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260916210552.891730-1-joshua.hahnjy@gmail.com>
References: <20260916210552.891730-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Attach legacy memsw page counters to their own seven-slot per-CPU
stock. Charge, refill, drain, and hotplug handling now operate on the
memory and memsw banks independently.

Factor the common drain scheduling into schedule_stock_drain() now
that both stocks use it.

Keep the existing direct memsw rollback when the memory charge fails,
ensuring that failed allocations do not replenish the newly
attached memsw stock.

The separate banks can hit, contend, evict, and drain independently,
so their raw counters can temporarily drift by their cached amounts.
The previous patch preserves the user-visible cgroup-v1 invariant by
reporting memory.memsw.usage_in_bytes as the larger raw value.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 62 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1a209ad535540..7d5b2539c5699 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2056,6 +2056,13 @@ static DEFINE_PER_CPU_ALIGNED(struct page_counter_stock_pcp, memory_stock) = {
 	.base = &memory_stock,
 };
 
+#ifdef CONFIG_MEMCG_V1
+static DEFINE_PER_CPU_ALIGNED(struct page_counter_stock_pcp, memsw_stock) = {
+	.lock = INIT_LOCAL_TRYLOCK(lock),
+	.base = &memsw_stock,
+};
+#endif
+
 /*
  * NR_OBJ_STOCK is sized so the entire hot path of obj_stock_pcp
  * (lock, accounting metadata, nr_bytes[] and cached[]) fits within a
@@ -2160,12 +2167,30 @@ static bool schedule_drain_work(int cpu, struct work_struct *work)
 	return true;
 }
 
+static void schedule_stock_drain(struct page_counter_stock_pcp __percpu *stock,
+				 struct cgroup_subsys_state *root_css,
+				 int cpu, int curcpu)
+{
+	struct page_counter_stock_pcp *pcp_stock = per_cpu_ptr(stock, cpu);
+
+	if (test_bit(FLUSHING_CACHED_CHARGE, &pcp_stock->flags) ||
+	    !page_counter_stock_flush_required(pcp_stock, root_css) ||
+	    test_and_set_bit(FLUSHING_CACHED_CHARGE, &pcp_stock->flags))
+		return;
+
+	if (cpu == curcpu)
+		drain_local_stock(&pcp_stock->work);
+	else if (!schedule_drain_work(cpu, &pcp_stock->work))
+		clear_bit(FLUSHING_CACHED_CHARGE, &pcp_stock->flags);
+}
+
 /*
  * Drains all per-CPU charge caches for given root_memcg resp. subtree
  * of the hierarchy under it.
  */
 void drain_all_stock(struct mem_cgroup *root_memcg)
 {
+	struct cgroup_subsys_state *root_css = &root_memcg->css;
 	int cpu, curcpu;
 
 	/* If someone's already draining, avoid adding running more workers. */
@@ -2180,21 +2205,13 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 	migrate_disable();
 	curcpu = smp_processor_id();
 	for_each_online_cpu(cpu) {
-		struct page_counter_stock_pcp *memory_st =
-			per_cpu_ptr(&memory_stock, cpu);
 		struct obj_stock_pcp *obj_st = &per_cpu(obj_stock, cpu);
 
-		if (!test_bit(FLUSHING_CACHED_CHARGE, &memory_st->flags) &&
-		    page_counter_stock_flush_required(memory_st,
-						      &root_memcg->css) &&
-		    !test_and_set_bit(FLUSHING_CACHED_CHARGE,
-				      &memory_st->flags)) {
-			if (cpu == curcpu)
-				drain_local_stock(&memory_st->work);
-			else if (!schedule_drain_work(cpu, &memory_st->work))
-				clear_bit(FLUSHING_CACHED_CHARGE,
-					  &memory_st->flags);
-		}
+		schedule_stock_drain(&memory_stock, root_css, cpu, curcpu);
+#ifdef CONFIG_MEMCG_V1
+		if (do_memsw_account())
+			schedule_stock_drain(&memsw_stock, root_css, cpu, curcpu);
+#endif
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
 		    obj_stock_flush_required(obj_st, root_memcg) &&
@@ -2221,6 +2238,11 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 	stock = per_cpu_ptr(&memory_stock, cpu);
 	page_counter_drain_stock_fully(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
+#ifdef CONFIG_MEMCG_V1
+	stock = per_cpu_ptr(&memsw_stock, cpu);
+	page_counter_drain_stock_fully(stock);
+	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
+#endif
 
 	/*
 	 * A drain work queued before the CPU went away is executed by an
@@ -2524,8 +2546,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 retry:
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (do_memsw_account() &&
-	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter, false,
-				     NULL)) {
+	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter,
+				     may_batch, NULL)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
 		goto reclaim;
@@ -3004,7 +3026,7 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 	if (!mem_cgroup_is_root(memcg)) {
 		page_counter_refill_stock(&memcg->memory, nr_pages);
 		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, nr_pages);
+			page_counter_refill_stock(&memcg->memsw, nr_pages);
 	}
 
 	css_put(&memcg->css);
@@ -4108,6 +4130,10 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		memcg->memory.stock_css = &memcg->css;
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
+		if (!memcg_on_dfl) {
+			memcg->memsw.stock = &memsw_stock;
+			memcg->memsw.stock_css = &memcg->css;
+		}
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 		memcg->memory.track_failcnt = !memcg_on_dfl;
 		memcg->memsw.track_failcnt = !memcg_on_dfl;
@@ -5735,6 +5761,10 @@ int __init mem_cgroup_init(void)
 	for_each_possible_cpu(cpu) {
 		INIT_WORK(&per_cpu_ptr(&memory_stock, cpu)->work,
 			  drain_local_stock);
+#ifdef CONFIG_MEMCG_V1
+		INIT_WORK(&per_cpu_ptr(&memsw_stock, cpu)->work,
+			  drain_local_stock);
+#endif
 		INIT_WORK(&per_cpu_ptr(&obj_stock, cpu)->work,
 			  drain_local_obj_stock);
 	}
-- 
2.53.0-Meta

