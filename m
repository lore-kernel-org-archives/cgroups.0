Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794607547;
	b=HL2TLa9d0kEJGdilXS2DbjP1fN47fsBE2bcATRl5xeWIeQaLE1xPObOziBMg5hH/C2T4
	 oacYc05NUEOtff+BPCfivb2pJ/zpetoBm+R2SV8sucWHwaRzRNrWlIDiPNjw7cyltp5fw
	 0GjvnC7/br98nequr4m7QHEt3EW3D/rQ8XzxsnTtPcy3AOcavjRL6wBoaBm9Nl04a4jIx
	 M+Evle00ZfNw6HgvMSIv5XmCDlE0kiL3T/autfDmGm+g26UIdqlaxv7p+F39RpHYsHE5C
	 OlCOPaai/1uhtFEz+KGeVF3TyaLeziD87cUJIIMFX2wp2h5Ei03rEF7+wiI0NsOcnLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794607547;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cu+cTJ0hL/GwCE7XQ3GWlN1dT5x6HJrmKisyxShQ97Y=;
	b=Eu6BO4/oQ7XqQzURKTkWAhZ+NS/CIrxkPSgubGXjG1UtkgBYF9O8hY4SIUCTLZcf8TMy
	 Vo4oQx5Ey8FTtr24hCZYOIgoTjHOIu7VYs23Y0zSz6WG2XUQNyZWM2VQQ+rEAMNAxj9ws
	 LUy8UF/7fyMTw7426QVUByyUjh5OmVbREaSWFtuOfWFOOtyHVhGcUfaMP4s4ctuCkkJwt
	 cMYTWuiKTwjXQg4rXLd1ZYRxRKh3euMOX9nyIPR1ptd3IIvrtdTtM3MrD/K1mdmnpwzaS
	 2oIS7FeO2Gc1Gj08zY7wEQeq7O3fr9VYPJNZghPUVe+XLXxlKPV9UD/66ouHg5sYRqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zhw+ylPj;
	arc=none smtp.remote-ip=209.85.128.173
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9523606A33B
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 22:05:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9523606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zhw+ylPj
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8b3541bb1a2so9210037b3.1
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 14:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794607546; x=1795212346; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Cu+cTJ0hL/GwCE7XQ3GWlN1dT5x6HJrmKisyxShQ97Y=;
        b=zhw+ylPj5+QszoBMX1ljeazQCmaA8FNvh+VMRFWzpqyney6Daq3+dVOvppoVL22hAN
         wV0Md4OEC3P0IhF0lFWJRoTDPD60RbX5l9z9aXTWrA8WhiLq6hOJkU39Z8VeLlF4xTl+
         AaJiu+mS1z2um0AmI9YESOp84f14tuAwtL+Pi/JN2qZ8K3CaKine2OgE36PCAFz1SWKl
         r9I0W3zawLq045SCgIZwzFxtejyp79suEc/QwEaLi9ytbVt/pN6aKyztD2/mYPH8cbSA
         Ff3zj7j/W8549Tz774nMOWgVrj3xomRBnAdwNzDWO5vdaawFfqqVv9MRtKKJjjsJ0wkx
         2QCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794607546; x=1795212346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Cu+cTJ0hL/GwCE7XQ3GWlN1dT5x6HJrmKisyxShQ97Y=;
        b=qmVXG0OO/C+DoQfEn3dSGGzWMk8Ii+7hmWFFuoKssFPm7n6lCZMwP7qWMobsE3DVmI
         h1dCm+F4Wl6l+VbkEOxKRBLsnXTICn7Vk5eDKY/r1CDU5vQxe+qETevI2aJGz+Do9osO
         DsCz9pmhnWD/sa0QWXWYt5nM6FxXvJ8SIbpGO8+JHNsmHqOdv5qWEXYYqhp8glv4aAR2
         nuyj5EE2k31QoBKhyaQ3144iOTAEMzq4QHUDS3W48QZ021MnXbVsMAmtAQhXf4icR7tM
         PjuLvQP1xHD7vt1+lz+38MzJNkUofIVQBlzEDpe5aZpheG7tWzN+wotDK3BENDwhlfWX
         oo5A==
X-Forwarded-Encrypted: i=1; AL+hErEOXUBRXgxPt4MKZ3449u8aswDhRD2NgPa6lI83R6R22Iskie+E7etkLHJg9k9P51KClIxStClH@vger.kernel.org
X-Gm-Message-State: APuU4Z+yN8T08+jyGMI/nLc2S94i2YeJuBApjTDFnK1zb65/KX1rR/90
	wj10CzgU0+7VZvT4cKSbeBkw4BX5FrgUchUvQqi7tW9Fa83TaIFtdXtx
X-Gm-Gg: AYBFou37WLhkeEsANN+crCJ9dPqE17ELbU16sQVils+wEVzx7cbz3YoikwQRO41wi50
	7redQaBSLYqinT8Pn9jxQGdRCddzLLVgoJ+As9dM2E3/hOGRtQHWM9g/yjngN5pAIiKB53bSNEE
	OMg0HmELZC6D2kbqBpd0hIyGrhNEL2LY9AkHSh6cDN2eGyIHcK/ZQJIPKcABoRsh838hYOGByGC
	3WB4qTni6x7mtE2DbspXxXH0RkvG5ErVRH84Xcq5ECkYN5ojy8RcKjT0z9Mh41IhyNfdYUGGThA
	B3hxY83qCjiibISTAe7LqXoDlWfRWeRuDl+rBR0NQGvgPcIzU6yivjOVbOHJXXwgGljtQuzAYqH
	1Koa7MwDVuwUAfNvkxqtNifeL3TL82BeDHptdPVRIFQ+LNhxccMUQKgt6I/IUeTcTM+o4qFfc3c
	qvCxA/oJJo5n68oH7A5ghK8lWAzNFX33gXuT7Yi+nGIwRkUtrhcwba4gMP/VhEPWDzSl5xEiE5B
	mYIG0uZNgv2vkj/EfckEoiStLWLllCJLfZbWa3sWuGogLHV41+YPcb0ToEUyqrNLvgF4L0JfI6X
	fd53fLVHgpMLTuCcIzouRbArzGrN+9u+fCVt3jkmaymfgYAuEKOylkzpCbc=
X-Received: by 2002:a05:690c:e3cc:b0:8b0:e13c:284d with SMTP id 00721157ae682-8b4aa2e997bmr20151567b3.49.1794607545154;
        Fri, 13 Nov 2026 14:05:45 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:a::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa8ea7c4sm31092547b3.10.2026.11.13.14.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 14:05:43 -0800 (PST)
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
Subject: [PATCH v9 2/7] mm/page_counter: introduce per-CPU stock
Date: Fri, 13 Nov 2026 14:05:29 -0800
Message-ID: <20261113220539.2275715-3-joshua.hahnjy@gmail.com>
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
2.53.1-Meta

