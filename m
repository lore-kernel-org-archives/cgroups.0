Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792623320;
	b=QjR+/kz8NEaPswv2w/+qgp1Lu1QcMH21sUs0AB1al95dILTpBlnUmOnWcrGn2hUPguSJ
	 Rrv3Qo1UrIVKAI1aRwKZcPOqGXDwiRred7UVu3518mBqqkShLo4SxR/y1RSpqQkujbByd
	 EJSzfs4+nbsXH6Ops+E0DPEPMwkNRpT8gGGT7qdSB/nATJHJgFCb+c/JoLUvI55wPKkvc
	 lPHS9LhrpmkVT78iJmbZfEuLchFhMg/c4WuKbzPMJbAh+kpsA9gDZN3+wkIYg0xJ4U3a4
	 nmerR8HvQyymX00DAY7Qcl4jqHxjK/TNFSm36uSclrfrx/Nb4iAjp8bTZJDH1s1Q5PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792623320;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=udCmSGAkUzXb8RB9tqi7fNnGMXP8Z9/o+Pg4FL7fz5A=;
	b=iyOT/YpeCI4SjDDE7bazycxbprtCLateVlTyDjAXQiFe5DFv7u3MD3byyJZxZPhRprBP
	 b21DPLpbHKvKYfpSeLuR1gHHsx1jBOz7Mc1nF+ibg62ueE+dB+VXeWvvhtLzrrdEpohhy
	 cGc5vvt2I6/lNTRrkg/4zlAUDPT6v479zZ8jSLyoy5ambbwC5eIF/CSAbmRqAO+vbl5gt
	 ANTW0ulBmD/31YfGyxAa9VKYf7Y04lke/VUqBL7P/KCKv28e0u1k2TrGT70GswsB/x0mz
	 hJkgebH7AqPhLA2SBIkF7C8lPS/KJUQSo0/8xqjBqoEe6m7qhfRs0jKg76z1eBHiIZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=M0A9ufKv;
	arc=none smtp.remote-ip=74.125.224.44
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F9A606A32A
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 22:55:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80F9A606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=M0A9ufKv
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-6798d4ab549so1258706d50.0
        for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 15:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792623319; x=1793228119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=udCmSGAkUzXb8RB9tqi7fNnGMXP8Z9/o+Pg4FL7fz5A=;
        b=M0A9ufKvsHq+Rz2O61XQO4kgkSSRs1kV2q1AseoF6cIr/0zCsp3ACQZz3IMJ6UaaMq
         Yb+A67t6bJvFgiYw4kMI0UjmL5bGWKYcvYz+dRqFs1ubPvjIZ9GgfK8r0LSXcNMsNQvU
         RPKpyJWUrkyeHz1XVkLx4J7trYBMlOZ3ZdRg3ze7g/OnepOXRjIpNFj5vZePS5qIgmOL
         D4ouxX6fE+zOV9XAn2wFCuIQg0SP3RjtdsrIf2uuXkaaxnKx6hrDBE8NX7d4VrZ4LXJp
         MX73/+lyGoTOEsJFnVnR/L5yBWxBKDliLHFMZVQh+8mD2l2aTWITGsnHPnCG1BdSlVhZ
         wDOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792623319; x=1793228119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=udCmSGAkUzXb8RB9tqi7fNnGMXP8Z9/o+Pg4FL7fz5A=;
        b=z8wEJGvEhBQYAs6L9H4LV5wMj7Czun36i4LNSRViqydZuAS838faOGtIqZ/+ajfJW5
         nQ25yGxiepUpgtT46xZpqJNjLaWJCK+KrkbkizqSNnGC7edaMAFQvlzW7FNA6AHasZjy
         Ak1+H+6pXdjC1bCxh0q/VAhk+YwQKfmmw1HFc7XK3XlhKUUjlHce7WwaRNSIVklUg1vE
         HDXzjHEuBlrfWXL3A7cL0k51Sj7/iZ/GASy/CZ2Rmbc/pSoTAJ4TOoazcaRuArnvvZtd
         3gIb212KqL6zVpO5aCeEaOReadyWuk/Hqu9VvWd5Gkp7olMhQTTEHOR3055a6xJ+zzfb
         inDA==
X-Forwarded-Encrypted: i=1; AKwUvBxs8F7Rr1LExDSMXx0GxsQi5z/gLMNIWGNBC0AtCaWV/ybAcH/XovGiJfgN8h8YldfFykhqSHIw@vger.kernel.org
X-Gm-Message-State: AFq9FYIWd7k5Xu6Ha5w3QEFZKfZDxUI1mtVSdBit1aIhRTzy/D9s1okK
	7/ZgSkvfjCFGsJgqWugmH4DQ/a8RNQGdlroAh8wL9bXn7Ijpdw+mWOXr
X-Gm-Gg: AYBFou3tI4mYUWc2Mpw5VNLMoiV0dkgL4SvjZccq5OL/B3/aH56W4coFcY60Na+/Tg3
	zBgSgllDN0mYNNOCCpUtYNC9IwCjFfGfsSPdN25FqXX2CLOx1305Md8tyKcf9NF4JloznDAFgvo
	0LVZNNvQ5/Bn75T07sQ7W4wxQQDCRTarc0CxOkS7s15AVyQ2mKA5Dz9xAgT6L+s9qSvu1yS/qTA
	LkjfeGsuqh/ewF05GuxQWMFQcH3K9z+CdOkLSLwjepqoKJJYuPnBi8apfaiZYbKTDpmdTlvaZXh
	Kx/KGumriKPSATPUgK6TQC4mhkTMJmbTUe1D198ukXcf3d84aGCkIn5OsurCH251chlV/05ArCz
	yvyKa1O8n5o1BJjQ2cf9fRhODlyeRFd1lKCEi6L8V5sPkSMI/FnltH7yI7XUjV4FgPh9FAqKszV
	e6Cpol53VUPEVYgBkmyirtV5UkEIKFQ5y4RLsdVtp5YQ0HEF+JMVz372nPNe9dq/nWaWM68anJO
	s8xn1WLCqIV2vRCHVVEAzOofLIrcVF1j+aIqRNi6qas07+nXH5WH7ZhLx3zezbCIujEp3nI7vAo
	zFLWsgyDDUc=
X-Received: by 2002:a05:690e:488d:20b0:677:d4b0:47fd with SMTP id 956f58d0204a3-67a0e49b2dfmr1244538d50.23.1792623319495;
        Wed, 21 Oct 2026 15:55:19 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5b::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a0e496732sm1729420d50.5.2026.10.21.15.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 15:55:19 -0700 (PDT)
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
Subject: [PATCH v7 2/5] mm/page_counter: introduce per-CPU stock
Date: Wed, 21 Oct 2026 15:55:11 -0700
Message-ID: <20261021225516.1620680-3-joshua.hahnjy@gmail.com>
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

Introduce a copy of the seven-slot per-CPU stock representation from
memcg in the page_counter layer. struct page_counter_stock_pcp preserves
everything from struct memcg_stock_pcp, but adds a new backpointer to
the base of the percpu stock, since there will be multiple percpu stock
base pointers later in the series (one for memory, one for memsw).

struct page_counter also gets a pointer to the base of the percpu stock,
as well as a struct cgroup_subsys_state pointer to pin its owning CSS
as long as the cached counter remains reachable.

Let's also copy over the drain, refill, and "flush required" functions,
preserving all behaviors from the memcg equivalent. In this patch they
are not connected.

No functional changes intended.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h |  31 +++++++++
 mm/page_counter.c            | 127 +++++++++++++++++++++++++++++++++++
 2 files changed, 158 insertions(+)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 2baf7a2b29b2e..cf627c5090093 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -5,8 +5,30 @@
 #include <linux/atomic.h>
 #include <linux/cache.h>
 #include <linux/limits.h>
+#include <linux/percpu.h>
+#include <linux/local_lock.h>
+#include <linux/workqueue_types.h>
 #include <asm/page.h>
 
+/*
+ * The value of NR_PAGE_COUNTER_STOCK is selected to keep the cached counters
+ * and their nr_pages in a single cacheline. This may change in the future.
+ */
+#define NR_PAGE_COUNTER_STOCK 7
+#define PAGE_COUNTER_STOCK_BATCH 64UL
+struct cgroup_subsys_state;
+struct page_counter;
+struct page_counter_stock_pcp {
+	local_trylock_t lock;
+	u8 nr_pages[NR_PAGE_COUNTER_STOCK];
+	struct page_counter *cached[NR_PAGE_COUNTER_STOCK];
+
+	struct page_counter_stock_pcp __percpu *base;
+	struct work_struct work;
+	unsigned long flags;
+	u8 drain_idx;
+};
+
 struct page_counter {
 	/*
 	 * Make sure 'usage' does not share cacheline with any other field in
@@ -41,6 +63,8 @@ struct page_counter {
 	unsigned long high;
 	unsigned long max;
 	struct page_counter *parent;
+	struct page_counter_stock_pcp __percpu *stock;
+	struct cgroup_subsys_state *stock_css;
 } ____cacheline_internodealigned_in_smp;
 
 #if BITS_PER_LONG == 32
@@ -61,6 +85,8 @@ static inline void page_counter_init(struct page_counter *counter,
 	counter->parent = parent;
 	counter->protection_support = protection_support;
 	counter->track_failcnt = false;
+	counter->stock = NULL;
+	counter->stock_css = NULL;
 }
 
 static inline unsigned long page_counter_read(const struct page_counter *counter)
@@ -74,6 +100,11 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
 			     unsigned long nr_pages,
 			     struct page_counter **fail);
+void page_counter_refill_stock(struct page_counter *counter,
+			       unsigned long nr_pages);
+void page_counter_drain_stock_fully(struct page_counter_stock_pcp *stock);
+bool page_counter_stock_flush_required(struct page_counter_stock_pcp *stock,
+				       struct cgroup_subsys_state *root_css);
 void page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_min(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_low(struct page_counter *counter, unsigned long nr_pages);
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 9167ffd1380c8..71c7a89026cb9 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -7,6 +7,7 @@
 
 #include <linux/page_counter.h>
 #include <linux/atomic.h>
+#include <linux/cgroup.h>
 #include <linux/kernel.h>
 #include <linux/math64.h>
 #include <linux/string.h>
@@ -14,6 +15,14 @@
 #include <linux/bug.h>
 #include <asm/page.h>
 
+/*
+ * Watermarks for a charge stock slot, in the spirit of pcp->high and
+ * pcp->batch: PAGE_COUNTER_STOCK_HIGH is the high watermark at which a slot is
+ * trimmed down to PAGE_COUNTER_STOCK_LOW rather than emptied.
+ */
+#define PAGE_COUNTER_STOCK_LOW (PAGE_COUNTER_STOCK_BATCH / 2)
+#define PAGE_COUNTER_STOCK_HIGH PAGE_COUNTER_STOCK_BATCH
+
 static bool track_protection(struct page_counter *c)
 {
 	return c->protection_support;
@@ -192,6 +201,124 @@ bool page_counter_try_charge(struct page_counter *counter,
 	return false;
 }
 
+static void page_counter_drain_stock(struct page_counter_stock_pcp *stock,
+				     int i)
+{
+	struct page_counter *counter = READ_ONCE(stock->cached[i]);
+	u8 nr_pages;
+
+	if (!counter)
+		return;
+
+	nr_pages = READ_ONCE(stock->nr_pages[i]);
+	if (nr_pages) {
+		page_counter_uncharge(counter, nr_pages);
+		WRITE_ONCE(stock->nr_pages[i], 0);
+	}
+	WRITE_ONCE(stock->cached[i], NULL);
+	css_put(counter->stock_css);
+}
+
+void page_counter_drain_stock_fully(struct page_counter_stock_pcp *stock)
+{
+	int i;
+
+	for (i = 0; i < NR_PAGE_COUNTER_STOCK; i++)
+		page_counter_drain_stock(stock, i);
+}
+
+bool page_counter_stock_flush_required(struct page_counter_stock_pcp *stock,
+				       struct cgroup_subsys_state *root_css)
+{
+	struct cgroup_subsys_state *css;
+	struct page_counter *counter;
+	bool flush = false;
+	int i;
+
+	rcu_read_lock();
+	for (i = 0; i < NR_PAGE_COUNTER_STOCK; i++) {
+		counter = READ_ONCE(stock->cached[i]);
+		if (!counter)
+			continue;
+		css = READ_ONCE(counter->stock_css);
+
+		if (READ_ONCE(stock->nr_pages[i]) &&
+		    cgroup_is_descendant(css->cgroup, root_css->cgroup)) {
+			flush = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return flush;
+}
+
+/**
+ * page_counter_refill_stock - return pages to a counter's stock
+ * @counter: counter to return pages to
+ * @nr_pages: number of pages to return
+ *
+ * If the stock cannot accept the pages, uncharge them from the hierarchy.
+ */
+void page_counter_refill_stock(struct page_counter *counter,
+			       unsigned long nr_pages)
+{
+	struct page_counter_stock_pcp __percpu *stock = counter->stock;
+	struct page_counter_stock_pcp *pcp_stock;
+	unsigned int stock_pages;
+	int empty_slot = -1;
+	int i;
+
+	/*
+	 * nr_pages[] is a u8 and a slot is capped at PAGE_COUNTER_STOCK_HIGH.
+	 * Raising PAGE_COUNTER_STOCK_BATCH beyond 127 would need careful
+	 * handling of nr_pages[] in struct page_counter_stock_pcp.
+	 */
+	BUILD_BUG_ON(PAGE_COUNTER_STOCK_BATCH > S8_MAX);
+	BUILD_BUG_ON(PAGE_COUNTER_STOCK_HIGH > U8_MAX);
+
+	if (!stock || nr_pages > PAGE_COUNTER_STOCK_BATCH ||
+	    !local_trylock(&stock->lock)) {
+		/*
+		 * For a larger-than-batch refill or an unlikely failure to lock
+		 * the per-CPU stock, uncharge the hierarchy directly.
+		 */
+		page_counter_uncharge(counter, nr_pages);
+		return;
+	}
+
+	pcp_stock = this_cpu_ptr(stock);
+	for (i = 0; i < NR_PAGE_COUNTER_STOCK; i++) {
+		struct page_counter *cached = READ_ONCE(pcp_stock->cached[i]);
+
+		if (!cached && empty_slot == -1)
+			empty_slot = i;
+		if (counter != cached)
+			continue;
+
+		stock_pages = READ_ONCE(pcp_stock->nr_pages[i]) + nr_pages;
+		if (stock_pages > PAGE_COUNTER_STOCK_HIGH) {
+			page_counter_uncharge(counter,
+					      stock_pages - PAGE_COUNTER_STOCK_LOW);
+			stock_pages = PAGE_COUNTER_STOCK_LOW;
+		}
+		WRITE_ONCE(pcp_stock->nr_pages[i], stock_pages);
+		local_unlock(&stock->lock);
+		return;
+	}
+
+	i = empty_slot;
+	if (i == -1) {
+		i = pcp_stock->drain_idx++;
+		if (pcp_stock->drain_idx == NR_PAGE_COUNTER_STOCK)
+			pcp_stock->drain_idx = 0;
+		page_counter_drain_stock(pcp_stock, i);
+	}
+	css_get(counter->stock_css);
+	WRITE_ONCE(pcp_stock->cached[i], counter);
+	WRITE_ONCE(pcp_stock->nr_pages[i], nr_pages);
+	local_unlock(&stock->lock);
+}
+
 /**
  * page_counter_uncharge - hierarchically uncharge pages
  * @counter: counter
-- 
2.53.0-Meta

