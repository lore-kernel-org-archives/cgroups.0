Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793835039;
	b=yAyppc/7SB0Tj6+Q8TwoCVtvEwktBENWnXkouOmmPOVWpvm8mHhqJS4FyPXhad9Tgak5
	 sCnjGnOPzGXV53VPS3zOozQm/MTlfAmDopPsga9cTaaln2NkXZ1YPRLmglfY4uT+c6hVN
	 4YD0XmZW0g0tCjp2BQFuIZ/XIZNPSUHecoaEWKp0aHo89Q0rXbfRpAkK+E4pVfnz7Le04
	 9riIQpBojxVTQkIqYc1GrCnM4ACoSDM2DwXVP7cgldGVAgncQXa3bFW1hSUs9RsjjJ09l
	 UvPYfF5PSxLpaIcj33+oat3SSRo4gmIsNGdNZDPSSpc8sr2R3N8DmC2Bxnc1N7OE2SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793835039;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hn/N6JyJM+zFqKp8YocwwBTkzd8kLSS3qrHaopPl4Mo=;
	b=MmoslFCtQtwGvZ12SBTP5wcsTEN16JWpPS+JGYpPkRSwZynpgSoxTmnMiS6SrFPXLMb+
	 Q5GQjaylO4MHQ0jMa46Bv7ArAiDSPX0ZNdWXE34Jztpz9X4ZXRnF9etpOzw8C7wCUiu/r
	 yKahpBXjL9uNmWWlWJBFQ86ZDCllfrHAsriOhOlhAe7Qbk/I9adlQJRhxiDLI1Lq0FRu0
	 nY7Tbsypb05EmL9REF3STNYWXS+F8lvRTEqCANsdYcDs9pm9pMy8jLCmCiZ3W6THIiEPl
	 efuTjdZc7TWb27P28pSFbJS+X4LotmRIUbwVOmFtuexTK1iH5ToHof6YO2MQ/AetI7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DuzodLrx;
	arc=none smtp.remote-ip=209.85.128.180
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0762D606D833
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 23:30:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0762D606D833
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DuzodLrx
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-8871ada1a26so12152477b3.1
        for <cgroups@vger.kernel.org>; Wed, 04 Nov 2026 15:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793835038; x=1794439838; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hn/N6JyJM+zFqKp8YocwwBTkzd8kLSS3qrHaopPl4Mo=;
        b=DuzodLrxdMj+GfzWex6ritx8NxJzn0FR4MyaYCcMtLBdmngiL0QeVbe/Q89VB99WfL
         W6I1b7CBeZUK2I3HLMXTCKV7LFFOIBEd29X/K8FR0C9Zu/Dr4HceqcVdFORKoNgLaXwG
         XfvWjxJd9QURrf5faRB3OgJgXgL+ssqGEPd8vTXmkpTs8oZKrn1QUPzjtDYu8ONeWFE0
         EFl04lh24zxKu93Bq3x5C2FXViyNfXLUZZgaOALqxzB9SZFBQdF2FSYRZXBOCZsUgN9c
         YhCR1Sy0U28v8NzQH2Z+IOGzfPmOpbW8VZJ3aMtbiQjL6tdgLcSoookipuWHK3QebmIR
         BhyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793835038; x=1794439838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Hn/N6JyJM+zFqKp8YocwwBTkzd8kLSS3qrHaopPl4Mo=;
        b=io2lPLw+H66cxuKk+2lj9w9QsWjM3DrOVD9E1PL2i/t/kGYtDhBTVniIKAGLWZzKPM
         L2+hhLY9PexlheUGZ9YFfeHFFzRFaVqdxB/JybRo1fvKwmSbwAKeWRqmkinju/2UtSIR
         Y2GuPYcIqfJf93wmjuNM0a8xqvyzPbMeQ5Oi/I8huPl9UHpnlQpvSckM5e5S/U0S6xIn
         S3S+RMlrE30zN9YseDtnHH4SLAux5hTSRpJBW8C560X3xmoOgGbXt3AScLnYxZlWTiFr
         6YStP99XzOFPQ0uzTgXAG6tXeGHQ7mMIsBaWoOhttmIxxHAznrmRe3rYuXPmbSh5UxrU
         x8Mg==
X-Forwarded-Encrypted: i=1; AKwUvBw4p6SBkm2JVa/HcBQ57ko0P83LiyGbVdlmsxZTBVhRVMM91vVNtQtyu0b9A5BHVXdQg+LN7GBz@vger.kernel.org
X-Gm-Message-State: APuU4Z+lN3omYbNb9Fr3ZsYi5k/3WZxuxvfZPpCf563Q6nTZTpxoJ7ww
	9bIaWgMCMAG7WFmYIigPrC2jchv/0y/DskNozaMDjGQnrfvpO+l6EOaD
X-Gm-Gg: AYBFou32sQOIpjIatzPvAgPvZ6j1PIe+OGnk/5Z+0tdZp01SezPmKCLc35MWUu52H5A
	UG7oqtQojAyPCngV4/R+A4F/pYII+fn2TnBtFqk2odsUvv654mzmHqs4Y3zWOhWNzWIONl0Xbwi
	Lm7ak6dOo1LOFR/ehpnIoIGup8udAiTzPGekOCB5ICQHfO/FVseo5peJCC/Qujk5wd2lyQ+oMup
	SMB6LgLMurhwsETzQG0pgGfTl3eUQ4a7xiiErx5sVdDcw+Ph8k8JZw5Qv4XsImVxAfEPV8Mh/6I
	r/GC76nEIkZnhRB+qOeAR9+GmdaTb5E+9XVPUMJ/3yvJb1qX+xGOWxNyy8ddfOJIlBHuKdlw12d
	ESUT9NCfiAdzGUMzVSOtNMccqSwNv98hcSF76ujEyo7Rf7k3pB4aR4YoZMP1DtdPg1VNEyvqhod
	c72q918tvGxM2FYbs4CZ7JAQRvV023duWe8fZqMIHcUT9CIAl/rVUIRP5LB3R86Jqg4sdZrOZe0
	Ev3stlQGhVKUCK3l01vNkCQ1hbZ8vbMU+awzezrE8kR592cJwWTrpTFKFrW3AsMuwPygCrhIi0O
	DZ1EsX36R08sYpJsv6IT1RCB1ejbM6H24Om5iaL+2Xc6G5gNLyRAlBiGkEDO
X-Received: by 2002:a05:690c:ee:b0:8b0:a957:80d4 with SMTP id 00721157ae682-8b2b66eccf9mr87622347b3.20.1793835038019;
        Wed, 04 Nov 2026 15:30:38 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:72::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b309bd35c7sm29090667b3.44.2026.11.04.15.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:30:37 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Harry Yoo <harry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v8 6/7] mm/memcontrol: add stock to the memsw page counter
Date: Wed,  4 Nov 2026 15:30:27 -0800
Message-ID: <20261104233029.3282438-7-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
References: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
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

Attach legacy memsw page counters to their own seven-slot per-CPU
stock. Charge, refill, drain, and hotplug handling now operate on the
memory and memsw banks independently.

Factor the common drain scheduling into schedule_stock_drain() now
that both stocks use it.

If the memory charge fails, roll back only nr_pages from memsw. Any
batch surplus the memsw charge already placed in the memsw stock
stays cached, like any other stock slot.

The separate banks can hit, contend, evict, and drain independently,
so their raw counters can temporarily drift by their cached amounts.
The previous patch preserves the user-visible cgroup-v1
memory <= memory + swap invariant by reporting memory.usage_in_bytes
as the smaller raw value.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 64 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 48 insertions(+), 16 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d03d64969548d..aac987ebaab6f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2057,6 +2057,13 @@ static DEFINE_PER_CPU_ALIGNED(struct page_counter_stock_pcp, memory_stock) = {
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
@@ -2161,12 +2168,30 @@ static bool schedule_drain_work(int cpu, struct work_struct *work)
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
@@ -2181,21 +2206,13 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
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
@@ -2221,6 +2238,9 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 	/* no need for the local lock */
 	drain_obj_stock(obj_st);
 	page_counter_drain_stock_fully(memory_st);
+#ifdef CONFIG_MEMCG_V1
+	page_counter_drain_stock_fully(per_cpu_ptr(&memsw_stock, cpu));
+#endif
 
 	/*
 	 * A drain work queued before the CPU went away is executed by an
@@ -2229,6 +2249,10 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 	 * the CPU comes back online.
 	 */
 	clear_bit(FLUSHING_CACHED_CHARGE, &memory_st->flags);
+#ifdef CONFIG_MEMCG_V1
+	clear_bit(FLUSHING_CACHED_CHARGE,
+		  &per_cpu_ptr(&memsw_stock, cpu)->flags);
+#endif
 	clear_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags);
 
 	return 0;
@@ -2614,8 +2638,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 retry:
 	if (do_memsw_account() &&
-	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter, false,
-				     NULL)) {
+	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter,
+				     may_batch, NULL)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		goto reclaim;
 	}
@@ -3046,7 +3070,7 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 	if (!mem_cgroup_is_root(memcg)) {
 		page_counter_refill_stock(&memcg->memory, nr_pages);
 		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, nr_pages);
+			page_counter_refill_stock(&memcg->memsw, nr_pages);
 	}
 
 	css_put(&memcg->css);
@@ -4198,6 +4222,10 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
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
@@ -5823,6 +5851,10 @@ int __init mem_cgroup_init(void)
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

