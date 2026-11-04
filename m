Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793835034;
	b=ME1IVQxuYPLPMu52InBCm99DEmqL/doP9ykGb8GZR5Csn/X48E3HW96ic9PzQeCW48iz
	 0WjvClrHSiPDXm/P1kM7ofJeIffMCea6N5ucRo6qfVvrcm09tHJA2iMdsjAwV4mhxLjYR
	 QIeVOKLC8mdJhobIBW8FcOCOyszv7XvE9/855+UwfmWk5nSf80qB4ONkIdR/Cb2Y6Vx5l
	 eP+0dvi23RC79k9releJvpXJMRfVoSrIhydsbT7j2cj68gIZLPSi9L4M6o5sDY/CraToU
	 aVQneTZ5xVP2SbYEAKjlMXa51rhjsZijfavnNesXKg3eV1JCTg6vUJUYeb8G+ItxjhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793835034;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fuNaHz2eYoLXRYUaHGG3mBL1JjkfQbmi09ULNtXItRk=;
	b=0CoaxfsSw9ykMjv22KP7gSHpTDrO0ufDTutuNb095eXH3c9o4X63mqIosmgKeKRfDup3
	 PhZDIvFMp92Hm6G4GtP7wRtfTBJBtJUgDLSSr0xDBxVUT+fVr93NNO1QrN7+qTzOExsFE
	 5fzsvRmnMOfVWnxoGp02YMM2FY/pOInaUWPM6DbFsuM9QsA1zfPJCvn/HNySqpyN0ADcB
	 vkgmgP2TI5qzmcNfATbm7Tep8+5OszkiWtjXbXEh3Ru5C6SGLO3k4diiw8xhIaW6pJPJP
	 z/tRB5vFyE2+KAP8oQoVVTKrMVJtuYaJGplAr4kAjbdvxvL40khJXgfmzWJnzmTtCzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=A0fAlUGp;
	arc=none smtp.remote-ip=74.125.224.47
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1EA606A33B
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 23:30:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D1EA606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=A0fAlUGp
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-67be4f2f4d4so1497409d50.2
        for <cgroups@vger.kernel.org>; Wed, 04 Nov 2026 15:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793835033; x=1794439833; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fuNaHz2eYoLXRYUaHGG3mBL1JjkfQbmi09ULNtXItRk=;
        b=A0fAlUGpX+ugBrIKSV7LUiapsNp2ktuibzIX0s9Lt6WvWXZGVFAYM/yO90iLT7tyIU
         SfJp/FNU+KB4S20yhoG0eYH7RRTckDq2Pcl1UJcvTzl6V6Ee6hAqtSmMEYmUktiB/Tu0
         a43w+AWvqAabeqxjeDxj+fn6LSk5ODFb1vI8f9mLiX2/7DGHQnemYOwXbgIdJ/wATc0M
         /pazqnfchmzY6OcHPtQkfZh7aKTDQmm8I9Hcyg6DpnG1qSDenuv2kguRPtaPNGJrz0Ox
         vZIF2IqliRfrkfAvX3KiuS56FEm5ZoJL5IGZn90AMdUwtHWAPQCF0BK1daHDwrpSVsdF
         3QIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793835033; x=1794439833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fuNaHz2eYoLXRYUaHGG3mBL1JjkfQbmi09ULNtXItRk=;
        b=VKv417IjUHZedQSKlpGtGQgwBWfKamCiCqFGTObYyEiWFAMB0fvlKc25PXiO3XPEXF
         A+PUK7GS7ZSflaeZ7lbsRadcV8CnCeuiJaQThhrlb81Y19edb7utFOneWa191QLa0r7Y
         gwulRbzC35wLvYpTSFHmrwWzpluA6wN8RNhQmMuh6qfiwCuVB3vVTRo3CDoNFSrSArqi
         xll9mOP4qVJCqtgWg37fkkzrUWszomF8s21QmrlShyLB9leXUDayoZPElNi9YaqJUlxa
         eYnmKNfOxk699gnPSs0CdAkoB/Imeeh6g02Cb/NZ8+CCmI4J25OE291dDccXoSr5nds2
         YM3w==
X-Forwarded-Encrypted: i=1; AKwUvBzcTzykxSuMlsyG8VWu+ulq4jvS/6e36r89jEbTDaQhBVMYbMwseqYASL/9G2oHu4hE4mgnJYLI@vger.kernel.org
X-Gm-Message-State: APuU4Z+MHggm6fImoMELla387SD2i9XwUCEvqOjeJehqchjNlal5m8gw
	D1jVqHEOC8nyZqOwmaYojmMn7Ai7fGljNmGyG1FBAqKZ+RNYVr7wl/AZ
X-Gm-Gg: AYBFou31VIZmgPuQ3oUGFNP2hL3bK/Jc2YeZbKkMv1QMOvLJ4SkfDO8T2UjvHNFASxb
	Z0gv7eNRBZR6rKJeHDosvI3VuWj44QXlGeGdXHdo+ZO7aowuLhG7uqJVZrWbLpV+CeYLgK0yHTm
	c3kIrTAnterjplKqaRqHImgx7MFVI5m0S/cor39iKwSxcornGunHpPJrTYYB3Ml+RXJGFxtsBk9
	nCgSgZuJdQ3PHUgYRi2dgKeqVDHqslf9obrxed176RgVH1BPVfuZK0EKRwr5D0xEPdQakbf9uyB
	Ydc1SRkdZSP0be+b7TwaYT0ElxdXYBAlbxtT9silZu9icwdXHVHCNmbejV/9LUdr5qys2sRoxqI
	nrwLJPUNUCjZrYaiUdIcBfXPctZJft+bNBSVhu4G2259xvQR+dPzfgQULc0EdlG7CagOfL1obDW
	sqrIijVRxT5pQtpNgYKyC3dICKQFeOODMRwA9+Xe1n9wFoYJeK2LM5TMUsmF2+UAII+ng2K0/bm
	Ki5VbpZ1SSoE4lvaiKNGK/6oGETT8KRl4HeCFGpxxlcvxF0zb0Petk7Q5R8+/KdRpmjo7UlNAs+
	b7uKlW3x0q+ecf1SznXDWPrYnqmrvOrfVBrK5vktbseILMf4rbO/bsoNeIB9
X-Received: by 2002:a05:690c:39a:b0:89a:63da:fa90 with SMTP id 00721157ae682-8b2b6765816mr108513857b3.75.1793835032878;
        Wed, 04 Nov 2026 15:30:32 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:41::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b30999b889sm29096017b3.33.2026.11.04.15.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:30:32 -0800 (PST)
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
Subject: [PATCH v8 2/7] mm/page_counter: introduce per-CPU stock
Date: Wed,  4 Nov 2026 15:30:23 -0800
Message-ID: <20261104233029.3282438-3-joshua.hahnjy@gmail.com>
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
 include/linux/page_counter.h |  31 ++++++++
 mm/page_counter.c            | 142 +++++++++++++++++++++++++++++++++++
 2 files changed, 173 insertions(+)

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
index 5293460831f80..70d76689e3212 100644
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
@@ -127,6 +136,24 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages)
 	}
 }
 
+static void page_counter_drain_stock(struct page_counter_stock_pcp *stock,
+				     int i)
+{
+	struct page_counter *counter = stock->cached[i];
+	u8 nr_pages;
+
+	if (!counter)
+		return;
+
+	nr_pages = stock->nr_pages[i];
+	if (nr_pages) {
+		page_counter_uncharge(counter, nr_pages);
+		WRITE_ONCE(stock->nr_pages[i], 0);
+	}
+	WRITE_ONCE(stock->cached[i], NULL);
+	css_put(counter->stock_css);
+}
+
 /**
  * page_counter_try_charge - try to hierarchically charge pages
  * @counter: counter
@@ -192,6 +219,121 @@ bool page_counter_try_charge(struct page_counter *counter,
 	return false;
 }
 
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
+	struct page_counter_stock_pcp __percpu *stock = READ_ONCE(counter->stock);
+	struct page_counter_stock_pcp *pcp_stock;
+	struct page_counter *cached;
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
+	if (unlikely(!stock || nr_pages > PAGE_COUNTER_STOCK_BATCH ||
+		     !local_trylock(&stock->lock))) {
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
+		cached = pcp_stock->cached[i];
+		if (!cached && empty_slot == -1)
+			empty_slot = i;
+		if (counter != cached)
+			continue;
+
+		stock_pages = pcp_stock->nr_pages[i] + nr_pages;
+		if (unlikely(stock_pages > PAGE_COUNTER_STOCK_HIGH)) {
+			WRITE_ONCE(pcp_stock->nr_pages[i], PAGE_COUNTER_STOCK_LOW);
+			stock_pages -= PAGE_COUNTER_STOCK_LOW;
+		} else {
+			WRITE_ONCE(pcp_stock->nr_pages[i], stock_pages);
+			stock_pages = 0;
+		}
+		local_unlock(&stock->lock);
+
+		if (unlikely(stock_pages))
+			page_counter_uncharge(counter, stock_pages);
+		return;
+	}
+
+	cached = NULL;
+	stock_pages = 0;
+
+	i = empty_slot;
+	if (i == -1) {
+		i = pcp_stock->drain_idx++;
+		if (pcp_stock->drain_idx == NR_PAGE_COUNTER_STOCK)
+			pcp_stock->drain_idx = 0;
+
+		cached = pcp_stock->cached[i];
+		stock_pages = pcp_stock->nr_pages[i];
+	}
+	css_get(counter->stock_css);
+	WRITE_ONCE(pcp_stock->cached[i], counter);
+	WRITE_ONCE(pcp_stock->nr_pages[i], nr_pages);
+	local_unlock(&stock->lock);
+
+	if (unlikely(cached)) {
+		if (stock_pages)
+			page_counter_uncharge(cached, stock_pages);
+		css_put(cached->stock_css);
+	}
+}
+
 /**
  * page_counter_uncharge - hierarchically uncharge pages
  * @counter: counter
-- 
2.53.0-Meta

