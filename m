Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792623335;
	b=4DIh60DeJUJ3mk77FyvFH2Be7LfnvZt0wqRB/7+YmvzpLjM2+pwMLkVVsHtBiip6IVwt
	 3BUBMtaaRTjvUzIn3+KZVFnOnHs43xtfVskNh+ehOGIAAe9GJc4/17YR57asW/5jvjJFL
	 jMBS4oXebA44RRPyksdMLDNu4mq8llkVpSYNBX5YbyeifYAgNTo3VK4FkCf/LdRlIgjh+
	 QGpGPYNPRvNmKvAasNAJJxET40BLMA99qmY+EPZ736vM7eIhf22Wc4UMCLw/N3dhFok+8
	 spKek97UKGWtkA+9j0tf9F/hQs5L68w/EJswEoOVPRbeaEYOMkEewJUZruM/zkTFUvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792623335;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WwOVRaeIHz9zAbT7euRoVVtSbXMHrTnxV5h5/F0jgC4=;
	b=mT9aalI9QJQ12XqL4wQuQYLBuxSRb0qlRVu6Qsd6mAKrm/foiEWhOdvDB35jP1ULdOtT
	 CRBZcy4hCjtC8wobDovJdjU8Y98VVYPQsPmSlkbHId33mmoM0ur2Apzf4KcFgej49KdSC
	 tUHeGdkuGI+5UytUTWXbwIPrjFgKvIe1NTjkSD02SRgTpM2846bC6Nv7HmmWt2CG3q8Ba
	 jwz2yVmUmEjsrngmKIh5fkf4pFqHAxMSE619K78Tr3F4cKlPHjnH82nBWEdCL/mtaX4FC
	 aIFnUqVhUJV7+r0LLDwA2FGacxbGNtWQd+jyB+mxkjMRnaBG13MnnddtBbHPmTs6YjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Lq14LELn;
	arc=none smtp.remote-ip=74.125.224.52
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D0B60A2608
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 22:55:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96D0B60A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Lq14LELn
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-677af43eed4so1172849d50.0
        for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 15:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792623323; x=1793228123; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WwOVRaeIHz9zAbT7euRoVVtSbXMHrTnxV5h5/F0jgC4=;
        b=Lq14LELnurMq139KxN0xW0n1A0RiX/CtdF1J6GsX3e7o7Qna/cZEa29FgpvVfSsqYp
         mP7ni0zEnd1nvowBw5UhnflPndCgDxSzvzz2VbanWPOSPNFkRPTyLyHCNh+JqyttL3Rz
         XjRltfHRgwUR/IC/uhqFYKtr8eotEpvo0PcT3dR/SgbpZMwlHefaGmetfCoipV12QNVd
         SmdKSsUr+DQMQdhy5ugq8c/eHXx1yFtGrY+Dibi8R8UXpu7N/m7ABF/7cF2sUmYdIs7m
         dBfkxex1ULSy7+SpApUgzbKFeMGQbp0N4W7Zce7ZtgJ7kiAU5cc4syphAUQW8CpNQYxu
         2Dlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792623323; x=1793228123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WwOVRaeIHz9zAbT7euRoVVtSbXMHrTnxV5h5/F0jgC4=;
        b=UhxMyA6BiAGnCdEoQzZrWIfVrfoMpuYeDi5jP7ssu9jLv4RrO2gm5sm0P07wnfL4SH
         nLmMAQ0D4ZFLGe6TEo9Hd7zgIN1/vYEje7yKXU+CVMMy3i0xVeL79Ds7Nf+etwgw2S0C
         Y4sq/tKxi0jJ4foNn1qvsq0Kcvk/UUODAZ4UJtfY3KfnYyvMoTLQZ/MXB0m79nybC72q
         qlqnYUWMgym6Jh6knfuBLhO+CnNNoRCrZRsxAundf1IJvDFe0RBlzSSq3CpUn+HHUADA
         6XQbuUyBmbGPPcVXnZLmiRT3v7rbirqPQDrCHp+y8356TwxAq4xVU0BvTOmghhEHgW9c
         W+MA==
X-Forwarded-Encrypted: i=1; AKwUvBzZl5ReAulQ+U3Z3SPWMseKohs9kJzhEIqy7aAz8ki8ZkyWhpjDkjjrhLVZHhWvC2netaUAqebI@vger.kernel.org
X-Gm-Message-State: AFq9FYIu4/wZ/gXTeArQJYgJkY/GlbHBfqeQcxMIR5PfLi+fCfe7ASjx
	UDObTvw8cx00v8DQNs7NkeyUs+i+azG965qBakyNcXUN2XPKaNAHzkem
X-Gm-Gg: AYBFou10kPf+wLyisGB5w1BpsBTOLDUqTRJVwHf7tzdE8nEYg+/OfjDQZp8uejZVbIt
	UFvSVFZhlSyaAMxc7ZncI993UQei9MumvLNtEQpP6g1fmSxUdhvk7tEPv5vGE1TR98Wsz/A+g0S
	VrkMYvQmguWk2WZ1tebZk10ao+0FAaVxHy3oH0GAOmmDP5BselmrVjtCqqYilbPZn20ExLN0w+U
	RxrNdzTGuikPI/dMDWYaQwIVUpld2nZ/oZkdYdyqb5hiyCEGHJ9dJeXUZcCKePVH/DP5XQGuCaM
	p17OS77dZMdiYwFgCsjjeo5c2hB1MmFGHWlFMUHr+sdFK/ZkMl0cumdAA14A4ZCB26LnKdEH2p2
	TwFlLXUlEBdye7+//jJUPTDes6c3ysRksOGQ/gwhBialWCQfQWiC+RPUwOa8IKsFsFviR0bk8+S
	AoZ2DQPnN4zge52Ltbr/Y2CJX+Oru/N5t8aLmZES4j8jdmoRxEY3Tmb19lTcJtAqU6OGtYKR2ex
	dY/u/7s+A8zJQ6CxjnQusqGzvbV5xbOKCugi7PoSN0IOdv5a7Ijv+cmlTc17pZfvcTg96jM/05m
	t9tPgNzOFw==
X-Received: by 2002:a05:690e:4381:b0:679:c12b:ec09 with SMTP id 956f58d0204a3-67a0e4acf74mr1765499d50.51.1792623322691;
        Wed, 21 Oct 2026 15:55:22 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:b::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a0e539f46sm1754377d50.17.2026.10.21.15.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 15:55:22 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>
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
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v7 5/5] mm/memcontrol: add stock to the memsw page counter
Date: Wed, 21 Oct 2026 15:55:14 -0700
Message-ID: <20261021225516.1620680-6-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021225516.1620680-1-joshua.hahnjy@gmail.com>
References: <20261021225516.1620680-1-joshua.hahnjy@gmail.com>
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
 mm/memcontrol.c | 62 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ee1e46e58e38f..aa3531a3828e5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2070,6 +2070,13 @@ static DEFINE_PER_CPU_ALIGNED(struct page_counter_stock_pcp, memory_stock) = {
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
@@ -2174,12 +2181,30 @@ static bool schedule_drain_work(int cpu, struct work_struct *work)
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
@@ -2194,21 +2219,13 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
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
@@ -2235,6 +2252,11 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
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
@@ -2557,8 +2579,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 retry:
 	if (do_memsw_account() &&
-	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter, false,
-				     NULL)) {
+	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter,
+				     may_batch, NULL)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		goto reclaim;
 	}
@@ -3038,7 +3060,7 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 	if (!mem_cgroup_is_root(memcg)) {
 		page_counter_refill_stock(&memcg->memory, nr_pages);
 		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, nr_pages);
+			page_counter_refill_stock(&memcg->memsw, nr_pages);
 	}
 
 	css_put(&memcg->css);
@@ -4190,6 +4212,10 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
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
@@ -5818,6 +5844,10 @@ int __init mem_cgroup_init(void)
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

