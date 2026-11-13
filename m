Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794607553;
	b=NidaR7lLYGtZ7aVymB8+2R8G1mf3jO5b89oVYS79imkGWfjdMWNFt9U1FG91bmXY8ZKj
	 ub+PmRCZuo5ltKexNeSVIZnEZmdK/+o9l9SJaM3ydtp/gzAmQoUW9FFMGN4sj3d//LrPi
	 oYQWTr7rZlgWHN9/Jh95dw2kCy1lAra/H2Hbq8fMLg46KN0C2FWQm8zh8lChuAfuUavQf
	 dK5MLo/Q7vhmezOqbwxYgzRUejN76hu83iZgCjTeoelHk4YU8gJQRTzSRlfKR3UxdC+Qp
	 c4fXGvgdWJ91I+MmgLnZGgvFsrsH1IL+0K2Nm37KPNdokKL0N16OeNQ1k2hiTN6EfKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794607553;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JF1gznMA200N9VzxTW8ChL8ETWhruoAV8NPYuDGd9o4=;
	b=ElTkGw/7lFGfiKA+weCC4mCeOH9l9EtF4CBLLwdPJJcERpiTJgkkSx31ZmlMiTZFTJ8q
	 n4Z0kj+bdXprk0V17aO/6n7nvHatO6hT2wEWfqBwB1MF3MfRpz9ehMumgDM4FKVR0OCE7
	 CJyN6Q7ljZAIwO59cjaR160S4TIPRSXwJ7XHbgFz2sntbBIuygYNBDAneG0bHXLqTUIve
	 nNnuvj5BKTECp/OSlN/PWtpKNQfCTuYuu0ThQgdQbiSUB0MUBGnR/z2wEslpnvOCE/Oln
	 g4oQYIUQPIY5zItoL0oDgi3qNI3XJ6D35nw5rdIg2tVYcO7eX9oF6r5oP6GAXvPzYbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XcxmgJ7d;
	arc=none smtp.remote-ip=209.85.128.179
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8443860A2621
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 22:05:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8443860A2621
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XcxmgJ7d
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b305e10ac7so17612277b3.0
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 14:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794607551; x=1795212351; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JF1gznMA200N9VzxTW8ChL8ETWhruoAV8NPYuDGd9o4=;
        b=XcxmgJ7dmhzEU0TwY2yr8TEZd/lse75qfTAZNisI9iO3h/mF1JdMSVEEg5aJUvnGlf
         +BCCuCQyj5WAsr3oPVuPQarWyjC4cCOpe2yJp6qfgMuoICh6UvPU5mg0UZG1y0Xbn/cY
         6Tfbqf5uz+rJk1AlOePytRqI4KVtELKX5+Flgv2YlJiLpZjPefzhC1QbnnXRUlAFsbYV
         WZ8I0THr5hs6jPWK02eg5Tu95pGbLI4VDm6HavEbaN77wKAGmoY56CJ10QtZDafV10CT
         FDdnlPwKOIOj8AYV3RsAwP1XboqYDA+iuoOhbOlOYpw9CzNyAwt1r+fcYNKjBi2YqMeK
         IH1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794607551; x=1795212351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JF1gznMA200N9VzxTW8ChL8ETWhruoAV8NPYuDGd9o4=;
        b=ScnFQDb+XidfG6B47rW3bw5ikzwuUFpZWgiKWZOMkWqzJk0ej1ME+x/IHpFuO35cM0
         Js/w0EuUMkVIeVRN5zeY923f40I4Kirggrxoc8S2TGwr6qbAY4hWL9yo7Pu9oBJvioMo
         yHzFnzaT5qZ2kXwkP+ACZbg1zLGInZGih8vMGykEMCIfKj9iV5YtFczi6jjylta2B5TJ
         V79x+uZSQMnOu4CttXYF+4euSf1y+wXT9UPSMBRN/1DhPbn/Yv9m8wnKjAVpx5/JZBf9
         XZbwwzz7vSjyuv7NGjxF/5r5/Hdy8hXt/Bws9Npv0p0Izica0/lQsj101kfX64e4L7Oy
         rL2w==
X-Forwarded-Encrypted: i=1; AL+hErG5SVfDy/DUZjK83LuQVITKD6HoNrlRqhF/lRtcAaXHm9baO3SfQ73n/Fnoh6Em3kMGlUXXm+u8@vger.kernel.org
X-Gm-Message-State: APuU4Z9rYVpwXNtGsG/0qc278fyLOtVM6y9B541rrIL+i3Thp65mIQ+f
	jK4zXdBoB+oJQPDLIifqSu3ymQuqQtSJcNX+b8xQP/M5ajfP11Z+uurz
X-Gm-Gg: AYBFou2tB/apuGqWIuYt+w5ma6BuQtGLG/Rkd9RYdiY3T/ULnQPO7iUuz1v9GNE4Rbj
	o9LToGA+8Unh+cRQLtOTJE0bQKB79De3gZVuLYbmb8zzbPGw9CKaY++z/QljWOML9w68lHw8Jpv
	awPAAYIz4LlDJS/732Yst/+5r6bhp/jrEUv3ZnY/lXuTxcS2T+slXbuyko7VuwWkdRRTsPr4d6J
	/BvfLsYIQGBoBn5OStvg+WTDxNR4Pz26tS8uFhrjBN7Q4gSeJkwOJzYjYkFu9mIP/1rLBQJcAu6
	WiEkAahMiLa5idS8G6M50CnrA1MrMl+kD7c5Lwl4RcXPCDNIMakOt4jjpUJYUlX/R3gj+eTxabg
	pT/uznxYQYuti2nb/qWCZ9uGp5O+tUIC5z70LWq15kCzP7w/106G/8DNY+KfsLaJsTMQ0jLXHsG
	jw4jWMke74X004XzNPsXSr6GPxfRn4PfiJ4GiWMLsLZBSA0wuZe1bu7yZ9kr8dlAjegEeM6ebE7
	ApZaHW4fZ+HchfChzX9XyQaDGlPoMJgZUie4bnWmFLTuyUZ9GKCtEIRUhS5M7udvwsB9bW5SnHz
	CrvpqWOJmGn1qIzmpFWD+XVNAv6IwrXyCQyW2KKNW7nOqmmZdtb4fFFsP2Fz
X-Received: by 2002:a05:690c:e00c:20b0:8b3:2eb4:1429 with SMTP id 00721157ae682-8b4aa3b2d6emr21276247b3.65.1794607551254;
        Fri, 13 Nov 2026 14:05:51 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:11::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa7ee982sm31328467b3.2.2026.11.13.14.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 14:05:50 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Koutny <mkoutny@suse.com>
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
	Balbir Singh <balbirs@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v9 5/7] mm/memcontrol: move memory stock to page counters
Date: Fri, 13 Nov 2026 14:05:32 -0800
Message-ID: <20261113220539.2275715-6-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261113220539.2275715-1-joshua.hahnjy@gmail.com>
References: <20261113220539.2275715-1-joshua.hahnjy@gmail.com>
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

Transition memcg to use the page_counter_stock for the memory
page_counter instead of relying on a memcg-wide stock.

One aspect that remains non-transparent to memcg is the uncharge path.
This is intentional, as the caller is responsible for managing the
batching. Cacheable releases refill the stock, while already-batched
frees (i.e. uncharge_gather), rollbacks, and accounting transfers
uncharge the hierarchy directly. The refill helper itself already falls
back to a raw uncharge when the stock cannot accept the pages anyways.

Because the memory and memsw counters no longer share one stock, their
raw values can temporarily diverge, and the raw memory counter can
exceed the raw memsw counter. Preserve the legacy user-visible
memory <= memory+swap relationship by reporting the smaller of the two
raw values for memory.usage_in_bytes.

We accept this fuzziness over breaking the invariant, as usage_in_bytes
has always been a fuzzy value due to stock charges being included.
Moreover, the raw counters are upper bounds on charged memory, so the
reported value stays within that fuzz.

One final nuance is that with divergent charges now, it is possible for
memory to fail first even when memory and memsw have equal limits.
When this happens, make sure reclaim doesn't swap, as if memsw failed.
Factor out this logic into memcg_charge_reclaim_options() for clarity.

With this transition, remove all memcg code that is no longer used.
After all of this, there should be no functional change for cgroup v2
users, and the cgroup-v1 equal-limit no-swap behavior is preserved. All
v2 behaviors from memcg are preserved, just moved from memcg to
page_counter code, so that future work can introduce additional
page_counters without removing the fast path.
Explicitly, the preserved behaviors are:
 - 7-slot stock
 - drain policy works locally and remotely through the memcg_wq
 - check whether a stock requires flushing before taking action
 - exact charging for non-spinning callers
 - report hierarchy growth for memory.high overage accounting

As of this patch, this leaves memsw un-stocked and always taking the
slow path (raw hierarchy charge). The next patch will make memsw
stocked, which will close the fast path gap for legacy cgroup users.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol-v1.c |  14 +-
 mm/memcontrol.c    | 322 ++++++++++-----------------------------------
 2 files changed, 84 insertions(+), 252 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index a146e54c6f9f7..2f29315b69fc3 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -122,10 +122,18 @@ static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 		if (swap)
 			val += total_swap_pages - get_nr_swap_pages();
 	} else {
-		if (!swap)
-			val = page_counter_read(&memcg->memory);
-		else
+		if (!swap) {
+			/*
+			 * Both counters remain upper bounds on charged memory,
+			 * but cached charges can make their raw values drift.
+			 * Use the smaller value to preserve the user-visible
+			 * memory <= memsw invariant.
+			 */
+			val = min(page_counter_read(&memcg->memory),
+				  page_counter_read(&memcg->memsw));
+		} else {
 			val = page_counter_read(&memcg->memsw);
+		}
 	}
 	return val;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fe97b320b2589..0f5481b276fa1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2054,33 +2054,11 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
 	pr_cont(" are going to be killed due to memory.oom.group set\n");
 }
 
-/*
- * The value of NR_MEMCG_STOCK is selected to keep the cached memcgs and their
- * nr_pages in a single cacheline. This may change in future.
- */
-#define NR_MEMCG_STOCK 7
-
-/*
- * Watermarks for a charge stock slot, in the spirit of pcp->high and
- * pcp->batch: MEMCG_STOCK_HIGH is the high watermark at which a slot is
- * trimmed, and it is trimmed down to MEMCG_STOCK_LOW rather than emptied.
- */
-#define MEMCG_STOCK_LOW		(MEMCG_CHARGE_BATCH / 2)
-#define MEMCG_STOCK_HIGH	(MEMCG_CHARGE_BATCH)
-
 #define FLUSHING_CACHED_CHARGE	0
-struct memcg_stock_pcp {
-	local_trylock_t lock;
-	uint8_t nr_pages[NR_MEMCG_STOCK];
-	struct mem_cgroup *cached[NR_MEMCG_STOCK];
-
-	struct work_struct work;
-	unsigned long flags;
-	uint8_t drain_idx;
-};
 
-static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
+static DEFINE_PER_CPU_ALIGNED(struct page_counter_stock_pcp, memory_stock) = {
 	.lock = INIT_LOCAL_TRYLOCK(lock),
+	.base = &memory_stock,
 };
 
 /*
@@ -2130,54 +2108,6 @@ static void drain_obj_stock(struct obj_stock_pcp *stock);
 static bool obj_stock_flush_required(struct obj_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg);
 
-/**
- * consume_stock: Try to consume stocked charge on this cpu.
- * @memcg: memcg to consume from.
- * @nr_pages: how many pages to charge.
- *
- * Consume the cached charge if enough nr_pages are present otherwise return
- * failure. Also return failure for charge request larger than
- * MEMCG_CHARGE_BATCH or if the local lock is already taken.
- *
- * returns true if successful, false otherwise.
- */
-static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
-{
-	struct memcg_stock_pcp *stock;
-	uint8_t stock_pages;
-	bool ret = false;
-	int i;
-
-	if (unlikely(nr_pages > MEMCG_CHARGE_BATCH ||
-		     !local_trylock(&memcg_stock.lock)))
-		return ret;
-
-	stock = this_cpu_ptr(&memcg_stock);
-
-	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		if (memcg != stock->cached[i])
-			continue;
-
-		stock_pages = stock->nr_pages[i];
-		if (unlikely(stock_pages < nr_pages))
-			break;
-
-		stock_pages -= nr_pages;
-		WRITE_ONCE(stock->nr_pages[i], stock_pages);
-		if (unlikely(!stock_pages)) {
-			WRITE_ONCE(stock->cached[i], NULL);
-			css_put(&memcg->css);
-		}
-
-		ret = true;
-		break;
-	}
-
-	local_unlock(&memcg_stock.lock);
-
-	return ret;
-}
-
 static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	page_counter_uncharge(&memcg->memory, nr_pages);
@@ -2185,49 +2115,22 @@ static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
 		page_counter_uncharge(&memcg->memsw, nr_pages);
 }
 
-/*
- * Returns stocks cached in percpu and reset cached information.
- */
-static void drain_stock(struct memcg_stock_pcp *stock, int i)
-{
-	struct mem_cgroup *old = stock->cached[i];
-	uint8_t stock_pages;
-
-	if (!old)
-		return;
-
-	stock_pages = stock->nr_pages[i];
-	if (stock_pages) {
-		memcg_uncharge(old, stock_pages);
-		WRITE_ONCE(stock->nr_pages[i], 0);
-	}
-
-	WRITE_ONCE(stock->cached[i], NULL);
-	css_put(&old->css);
-}
-
-static void drain_stock_fully(struct memcg_stock_pcp *stock)
-{
-	int i;
-
-	for (i = 0; i < NR_MEMCG_STOCK; ++i)
-		drain_stock(stock, i);
-}
-
-static void drain_local_memcg_stock(struct work_struct *dummy)
+static void drain_local_stock(struct work_struct *work)
 {
-	struct memcg_stock_pcp *stock;
+	struct page_counter_stock_pcp *pcp_stock;
+	struct page_counter_stock_pcp __percpu *stock;
 
 	if (WARN_ONCE(!in_task(), "drain in non-task context"))
 		return;
 
-	local_lock(&memcg_stock.lock);
+	stock = container_of(work, struct page_counter_stock_pcp, work)->base;
+	local_lock(&stock->lock);
 
-	stock = this_cpu_ptr(&memcg_stock);
-	drain_stock_fully(stock);
-	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
+	pcp_stock = this_cpu_ptr(stock);
+	page_counter_drain_stock_fully(pcp_stock);
+	clear_bit(FLUSHING_CACHED_CHARGE, &pcp_stock->flags);
 
-	local_unlock(&memcg_stock.lock);
+	local_unlock(&stock->lock);
 }
 
 static void drain_local_obj_stock(struct work_struct *dummy)
@@ -2246,109 +2149,6 @@ static void drain_local_obj_stock(struct work_struct *dummy)
 	local_unlock(&obj_stock.lock);
 }
 
-static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
-{
-	struct memcg_stock_pcp *stock;
-	struct mem_cgroup *cached;
-	unsigned int stock_pages;
-	int empty_slot = -1;
-	int i;
-
-	/*
-	 * nr_pages[] is a uint8_t and a slot's count is capped at
-	 * MEMCG_STOCK_HIGH. Raising MEMCG_CHARGE_BATCH beyond 127 would need
-	 * more careful handling of nr_pages[] in struct memcg_stock_pcp.
-	 */
-	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S8_MAX);
-	BUILD_BUG_ON(MEMCG_STOCK_HIGH > U8_MAX);
-
-	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
-
-	if (unlikely(nr_pages > MEMCG_CHARGE_BATCH ||
-		     !local_trylock(&memcg_stock.lock))) {
-		/*
-		 * In case of larger than batch refill or unlikely failure to
-		 * lock the percpu memcg_stock.lock, uncharge memcg directly.
-		 */
-		memcg_uncharge(memcg, nr_pages);
-		return;
-	}
-
-	stock = this_cpu_ptr(&memcg_stock);
-	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		cached = stock->cached[i];
-		if (!cached && empty_slot == -1)
-			empty_slot = i;
-
-		if (memcg != cached)
-			continue;
-
-		stock_pages = stock->nr_pages[i] + nr_pages;
-		if (unlikely(stock_pages > MEMCG_STOCK_HIGH)) {
-			WRITE_ONCE(stock->nr_pages[i], MEMCG_STOCK_LOW);
-			stock_pages -= MEMCG_STOCK_LOW;
-		} else {
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			stock_pages = 0;
-		}
-
-		local_unlock(&memcg_stock.lock);
-
-		if (unlikely(stock_pages))
-			memcg_uncharge(memcg, stock_pages);
-		return;
-	}
-
-	cached = NULL;
-	stock_pages = 0;
-
-	i = empty_slot;
-	if (i == -1) {
-		i = stock->drain_idx++;
-		if (stock->drain_idx == NR_MEMCG_STOCK)
-			stock->drain_idx = 0;
-
-		cached = stock->cached[i];
-		stock_pages = stock->nr_pages[i];
-	}
-
-	css_get(&memcg->css);
-	WRITE_ONCE(stock->cached[i], memcg);
-	WRITE_ONCE(stock->nr_pages[i], nr_pages);
-
-	local_unlock(&memcg_stock.lock);
-
-	if (unlikely(cached)) {
-		if (stock_pages)
-			memcg_uncharge(cached, stock_pages);
-
-		css_put(&cached->css);
-	}
-}
-
-static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
-				  struct mem_cgroup *root_memcg)
-{
-	struct mem_cgroup *memcg;
-	bool flush = false;
-	int i;
-
-	rcu_read_lock();
-	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		memcg = READ_ONCE(stock->cached[i]);
-		if (!memcg)
-			continue;
-
-		if (READ_ONCE(stock->nr_pages[i]) &&
-		    mem_cgroup_is_descendant(memcg, root_memcg)) {
-			flush = true;
-			break;
-		}
-	}
-	rcu_read_unlock();
-	return flush;
-}
-
 static bool schedule_drain_work(int cpu, struct work_struct *work)
 {
 	/*
@@ -2380,23 +2180,25 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 	 * Notify other cpus that system-wide "drain" is running
 	 * We do not care about races with the cpu hotplug because cpu down
 	 * as well as workers from this path always operate on the local
-	 * per-cpu data. CPU up doesn't touch memcg_stock at all.
+	 * per-cpu data. CPU up doesn't touch the stocks at all.
 	 */
 	migrate_disable();
 	curcpu = smp_processor_id();
 	for_each_online_cpu(cpu) {
-		struct memcg_stock_pcp *memcg_st = &per_cpu(memcg_stock, cpu);
+		struct page_counter_stock_pcp *memory_st =
+			per_cpu_ptr(&memory_stock, cpu);
 		struct obj_stock_pcp *obj_st = &per_cpu(obj_stock, cpu);
 
-		if (!test_bit(FLUSHING_CACHED_CHARGE, &memcg_st->flags) &&
-		    is_memcg_drain_needed(memcg_st, root_memcg) &&
+		if (!test_bit(FLUSHING_CACHED_CHARGE, &memory_st->flags) &&
+		    page_counter_stock_flush_required(memory_st,
+						      &root_memcg->css) &&
 		    !test_and_set_bit(FLUSHING_CACHED_CHARGE,
-				      &memcg_st->flags)) {
+				      &memory_st->flags)) {
 			if (cpu == curcpu)
-				drain_local_memcg_stock(&memcg_st->work);
-			else if (!schedule_drain_work(cpu, &memcg_st->work))
+				drain_local_stock(&memory_st->work);
+			else if (!schedule_drain_work(cpu, &memory_st->work))
 				clear_bit(FLUSHING_CACHED_CHARGE,
-					  &memcg_st->flags);
+					  &memory_st->flags);
 		}
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
@@ -2416,12 +2218,13 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
-	struct memcg_stock_pcp *memcg_st = &per_cpu(memcg_stock, cpu);
+	struct page_counter_stock_pcp *memory_st =
+		per_cpu_ptr(&memory_stock, cpu);
 	struct obj_stock_pcp *obj_st = &per_cpu(obj_stock, cpu);
 
 	/* no need for the local lock */
 	drain_obj_stock(obj_st);
-	drain_stock_fully(memcg_st);
+	page_counter_drain_stock_fully(memory_st);
 
 	/*
 	 * A drain work queued before the CPU went away is executed by an
@@ -2429,7 +2232,7 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 	 * clear the flags here to make these stocks drainable again once
 	 * the CPU comes back online.
 	 */
-	clear_bit(FLUSHING_CACHED_CHARGE, &memcg_st->flags);
+	clear_bit(FLUSHING_CACHED_CHARGE, &memory_st->flags);
 	clear_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags);
 
 	return 0;
@@ -2775,13 +2578,33 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 		__mem_cgroup_handle_over_high(gfp_mask);
 }
 
+static unsigned int memcg_charge_reclaim_options(struct mem_cgroup *memcg,
+						 struct page_counter *counter)
+{
+	if (!do_memsw_account())
+		return MEMCG_RECLAIM_MAY_SWAP;
+
+	if (counter == &memcg->memsw)
+		return 0;
+
+	/*
+	 * With separate stocks, raw memory can exceed raw memsw, so memory can
+	 * fail first even when equal limits leave no room for swap. Don't swap
+	 * in that case, as if memsw had failed.
+	 */
+	if (READ_ONCE(memcg->memory.max) >= READ_ONCE(memcg->memsw.max))
+		return 0;
+
+	return MEMCG_RECLAIM_MAY_SWAP;
+}
+
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			    unsigned int nr_pages)
 {
-	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
 	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
+	unsigned long nr_charged;
 	unsigned long nr_reclaimed;
 	bool passed_oom = false;
 	unsigned int reclaim_options;
@@ -2789,37 +2612,31 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool raised_max_event = false;
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+	/* Charges from reclaim or non-spinning contexts don't batch. */
+	bool may_batch = allow_spinning && !(current->flags & PF_MEMALLOC);
 	int ret = 0;
 
 retry:
-	if (consume_stock(memcg, nr_pages))
-		return ret;
-
-	/* Charges from reclaim or non-spinning contexts don't batch. */
-	if (!allow_spinning || (current->flags & PF_MEMALLOC))
-		batch = nr_pages;
-
-	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (do_memsw_account() &&
-	    !page_counter_try_charge(&memcg->memsw, batch, &counter, false,
+	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter, false,
 				     NULL)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
-		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
 		goto reclaim;
 	}
 
-	if (page_counter_try_charge(&memcg->memory, batch, &counter, false, NULL))
-		goto done_restock;
+	if (page_counter_try_charge(&memcg->memory, nr_pages, &counter,
+				    may_batch, &nr_charged))
+		goto check_high;
 
 	if (do_memsw_account())
-		page_counter_uncharge(&memcg->memsw, batch);
+		page_counter_uncharge(&memcg->memsw, nr_pages);
 	mem_over_limit = mem_cgroup_from_counter(counter, memory);
 
 reclaim:
-	if (batch > nr_pages) {
-		batch = nr_pages;
-		goto retry;
-	}
+	reclaim_options = memcg_charge_reclaim_options(mem_over_limit, counter);
+
+	/* Do not retry speculative batch charges after the first miss. */
+	may_batch = false;
 
 	/*
 	 * Reclaim may need memory to free memory. Let it go over the
@@ -2930,9 +2747,9 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	return ret;
 
-done_restock:
-	if (batch > nr_pages)
-		refill_stock(memcg, batch - nr_pages);
+check_high:
+	if (!nr_charged)
+		return ret;
 
 	/*
 	 * Skip memory.high for charges from reclaim, so the high_work
@@ -2941,7 +2758,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (unlikely(current->flags & PF_MEMALLOC))
 		return ret;
 
-	memcg_enforce_high(memcg, batch, gfp_mask);
+	memcg_enforce_high(memcg, nr_charged, gfp_mask);
 	return ret;
 }
 
@@ -3230,8 +3047,11 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 
 	account_kmem_nmi_safe(memcg, -nr_pages);
 	memcg1_account_kmem(memcg, -nr_pages);
-	if (!mem_cgroup_is_root(memcg))
-		refill_stock(memcg, nr_pages);
+	if (!mem_cgroup_is_root(memcg)) {
+		page_counter_refill_stock(&memcg->memory, nr_pages);
+		if (do_memsw_account())
+			page_counter_uncharge(&memcg->memsw, nr_pages);
+	}
 
 	css_put(&memcg->css);
 }
@@ -4380,6 +4200,8 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
 		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
+		memcg->memory.stock = &memory_stock;
+		memcg->memory.stock_css = &memcg->css;
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
@@ -5845,7 +5667,7 @@ void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages)
 
 	mod_memcg_state(memcg, MEMCG_SOCK, -nr_pages);
 
-	refill_stock(memcg, nr_pages);
+	page_counter_refill_stock(&memcg->memory, nr_pages);
 }
 
 void mem_cgroup_flush_workqueue(void)
@@ -5993,6 +5815,8 @@ int __init mem_cgroup_init(void)
 	 * exceed S32_MAX / PAGE_SIZE.
 	 */
 	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S32_MAX / PAGE_SIZE);
+	/* Batched page-counter charges feed memcg's memory.high accounting. */
+	BUILD_BUG_ON(MEMCG_CHARGE_BATCH != PAGE_COUNTER_STOCK_BATCH);
 
 	memcg_struct_check();
 
@@ -6003,8 +5827,8 @@ int __init mem_cgroup_init(void)
 	WARN_ON(!memcg_wq);
 
 	for_each_possible_cpu(cpu) {
-		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
-			  drain_local_memcg_stock);
+		INIT_WORK(&per_cpu_ptr(&memory_stock, cpu)->work,
+			  drain_local_stock);
 		INIT_WORK(&per_cpu_ptr(&obj_stock, cpu)->work,
 			  drain_local_obj_stock);
 	}
-- 
2.53.1-Meta

