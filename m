Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC28F4A2A65
	for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 16:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194280; cv=none; b=eUkzVeY+JAdSgIxZJoFY2wlI3SQbW/ZAJmjh5hKu01TTHZzH+jxPuWKsLaA6NVYtLJdd23YnJBztSE480cRTfVo/Bj4sEpPAF8hCvGB4RN/MLpdz/MISOSybLRv9h2gC+ocCaznS8ekgWqqhznBfPEo9YQeTcu0b5dFXy8F8Ups=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194280; c=relaxed/simple;
	bh=rJFpJjImstzEz9X/weAONaIfNQqNwroPzDQP73j8CWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DeEzY/ogVoozCPpYSnBSeY6T7bnAK3ngiNUB6OE7SB8u5EWBkS0yBxOtgVwNfeg3vIlUe1P3mUtTVXQLvrfSQ49rhcurPX+XmpBt0aTqDG0fywjfPSVFsJPVzEHymLGR6iNMGT12Fh+h6EI94pWBBk9RKcrS6I86sGqI3gbXJc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N6GXDAXH; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N6GXDAXH"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7eb61bbeb25so4054879a34.1
        for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 09:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788194277; x=1788799077; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UZzK6JqUVQtEF4ncuPC417FBn/U4i41SWhLzyFT/8Js=;
        b=N6GXDAXHbUOQxq0ydFPAAvDt7iR+d1ZmdUByPJOY/l2X6jK1oDCkMPXVfVF0/VAP4u
         HxBQFDHDixYpSJNz6c1qEm5RMsPtgtzTxAfFlDFRRXOKdxRlRQNfzZORlgyvRDHJb/zj
         KDVgLkHNwASS7gIA26C5uL1EOENAms6s8voa9q0TiwlurerJLTVLZjmdDqt9d7+pGi9l
         gJn+i3qnOpxg2z9+nN0ApdVh5zFGIH+VL3xLqQ6sKRg2Kkh7HiUVL7venX4xqhzQwfH3
         i+PEonuzCBdz4f/lXiL1bPS27EGH0vfJZnJxor/iiokojuR51FbPLEo2aZgcDPXVXe00
         X2Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788194277; x=1788799077;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UZzK6JqUVQtEF4ncuPC417FBn/U4i41SWhLzyFT/8Js=;
        b=mv9uh8WqzadZjbT+3PPBc1rg0mbsu4ExmgUC7ghstEOmOnKmfdFN8+0tABjSKzEur1
         zXEz2U7S+qRyQBeWOXdplp5mcZdVHtl8KRA7joYcXiPVUoZ3nQcoMG9gs0V1k2JGsW4G
         iXlyTcrPimlYxoGqoDwMnxdjLjc4V6DqhL7qwWYq870CfRjQ8Mxe3WjE2MqLmuKW+Bby
         PuP5voxa9YTXnUVk0bDzEYjsz9c8Oncd42qKL38XzwPwEZtH8Re/a+ch8Faw0FXlUJfQ
         50KF92EdZiMCxTWomVNhYDlYEdgQWCkFi+OyL74lvW3POLsdFRJ2tj2lt9dFsRLnlTu1
         kO6Q==
X-Forwarded-Encrypted: i=1; AHgh+Rp1KGtsiEjc/JGhyDKtC5gEcnRFzQCZqE/CAirBjPM5xuVhXsuQZSeWaupPSzEyRspbD4v0bQFR@vger.kernel.org
X-Gm-Message-State: AFuF++mAkmU12kRkmkuhhIlvbiiPo1dWwZuxpg2zPjzbeQ/bn0Ap51Ai
	mjLcebGyfI62qykXPvBisu4szx2fRIYYc8yfPBmeEfmMQ6m/NAQPtRya
X-Gm-Gg: AR+sD12+zxZphuna5DPP1c41SEsbt09HQrkfb2sXs3DEXbiA5cpKQpgNUYs6Yi6LkpY
	/77a5UKxIcFjFQTX2BmCEnoO6st5lM6HsdlTRPoajM0l6aYwb+/7p4DiGkhpeUSZSV5xMkx6tK1
	w6NJcnZKjL4CmFRk63gW5pJw4HVgigC+uyr+QQyRWmMdK38g+vzL7I8VOya0Fp9hfZ9WV1EQETW
	71iZ8V2PLBaMTCxxEkajLpU/RSEFIs4DD2tq7eaeJneDVL/CLXorCL8Xq+ZGDBYHWL5WxdmYNh1
	IqNve2EpPOHzIo5UaGymeSJqtRIF35Ni+yh7rkirlFjbjI1w6k/7XD9thNTAIF8L4KK2QijZYVK
	PA5n6CM8cgRpnBab7EWTTav9GYLecmnD+VpTH+WujGXCB/0wvKTpIX8qihkYTanXq2T3hoJ16Zh
	Ty4283ytoiPTi0KLFH8e38gCd3zETp8swneXTrJXvlbsDcWbcjF47UtQV/gwRWEXtfoGPGg4luH
	ObJOJZYVLIwYG/TUw==
X-Received: by 2002:a05:6830:349a:b0:7e9:e288:2b60 with SMTP id 46e09a7af769-7f4f21cb626mr27446752a34.1.1788194277265;
        Mon, 31 Aug 2026 09:37:57 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:3::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f4fa96cf17sm8719481a34.15.2026.08.31.09.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 09:37:56 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org
Cc: roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	dev@lankhorst.se,
	mripard@kernel.org,
	nat@pixelcluster.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	osalvador@suse.de,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	kernel-team@meta.com
Subject: [PATCH v5 3/7] mm/page_counter: introduce per-page_counter stock
Date: Mon, 31 Aug 2026 09:37:47 -0700
Message-ID: <20260831163752.2193337-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to avoid expensive hierarchy walks on every memcg charge and
limit check, memcontrol uses per-cpu stocks (memcg_stock_pcp) to cache
pre-charged pages and introduce a fast path to try_charge_memcg.

However, there are a few quirks with the current implementation that
can be improved upon.

First, each memcg_stock_pcp can only cache the charges of 7 memcgs
(NR_MEMCG_STOCK). When an 8th memcg wants to cache its charge on a CPU,
a victim memcg is chosen among the 7 cached memcgs and is evicted,
losing all cached charges.

Second, stock draining is per-CPU rather than per-memcg. That is,
when a memcg is under pressure and must retrieve all cached charges,
it iterates through every CPU and drains the stock charges of all
present memcgs. This means that one under-pressure memcg evicts the
caches of all co-cpu-resident memcg stock caches.

Finally, stock is tightly coupled with memcg, so adding new
page_counters to memcg is an unscalable operation where only one counter
gets to use the fastpath.

We can address all of these concerns by pushing stock caches down to the
page_counter level, and making each counter responsible for its own
charge.

Introduce struct page_counter_stock along with its allocation, free, and
per-CPU drain helpers.

No functional change intended.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h | 16 +++++++
 mm/page_counter.c            | 90 ++++++++++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 89a083f16fbf7..c1fe331f34e7e 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -5,8 +5,11 @@
 #include <linux/atomic.h>
 #include <linux/cache.h>
 #include <linux/limits.h>
+#include <linux/workqueue_types.h>
 #include <asm/page.h>
 
+struct page_counter_stock;
+
 struct page_counter {
 	/*
 	 * Make sure 'usage' does not share cacheline with any other field in
@@ -41,6 +44,13 @@ struct page_counter {
 	unsigned long high;
 	unsigned long max;
 	struct page_counter *parent;
+	struct page_counter_stock __percpu *stock;
+	unsigned long batch;
+
+	/* make sure the work_struct is separate from the read most fields */
+	CACHELINE_PADDING(_pad3_);
+
+	struct work_struct drain_work;
 } ____cacheline_internodealigned_in_smp;
 
 #if BITS_PER_LONG == 32
@@ -61,6 +71,8 @@ static inline void page_counter_init(struct page_counter *counter,
 	counter->parent = parent;
 	counter->protection_support = protection_support;
 	counter->track_failcnt = false;
+	counter->stock = NULL;
+	counter->batch = 0;
 }
 
 static inline unsigned long page_counter_read(struct page_counter *counter)
@@ -99,6 +111,10 @@ static inline void page_counter_reset_watermark(struct page_counter *counter)
 	counter->watermark = usage;
 }
 
+void page_counter_drain_cpu_stock(struct page_counter *counter, int cpu);
+void page_counter_alloc_stock(struct page_counter *counter, unsigned long batch);
+void page_counter_free_stock(struct page_counter *counter);
+
 #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
 void page_counter_calculate_protection(struct page_counter *root,
 				       struct page_counter *counter,
diff --git a/mm/page_counter.c b/mm/page_counter.c
index a934619cc7bf7..3f61eba695518 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -8,11 +8,18 @@
 #include <linux/page_counter.h>
 #include <linux/atomic.h>
 #include <linux/kernel.h>
+#include <linux/percpu.h>
 #include <linux/string.h>
 #include <linux/sched.h>
+#include <linux/spinlock.h>
 #include <linux/bug.h>
 #include <asm/page.h>
 
+struct page_counter_stock {
+	raw_spinlock_t lock;
+	unsigned long nr_pages;
+};
+
 static bool track_protection(struct page_counter *c)
 {
 	return c->protection_support;
@@ -295,6 +302,89 @@ int page_counter_memparse(const char *buf, const char *max,
 	return 0;
 }
 
+/**
+ * page_counter_drain_cpu_stock - release @cpu's cached charges
+ * @counter: counter whose stock to drain
+ * @cpu: CPU whose stock is drained
+ */
+void page_counter_drain_cpu_stock(struct page_counter *counter, int cpu)
+{
+	struct page_counter_stock __percpu *stock = READ_ONCE(counter->stock);
+	struct page_counter_stock *pcp_stock;
+	unsigned long nr_pages;
+	unsigned long flags;
+
+	if (!stock)
+		return;
+
+	pcp_stock = per_cpu_ptr(stock, cpu);
+	raw_spin_lock_irqsave(&pcp_stock->lock, flags);
+	nr_pages = pcp_stock->nr_pages;
+	pcp_stock->nr_pages = 0;
+	raw_spin_unlock_irqrestore(&pcp_stock->lock, flags);
+
+	if (nr_pages)
+		page_counter_uncharge(counter, nr_pages);
+}
+
+/**
+ * page_counter_alloc_stock - allocate the percpu stock for a page_counter
+ * @counter: counter to allocate percpu stock for
+ * @batch: maximum number of pages a CPU may cache
+ *
+ * Failure to allocate is not fatal; @counter falls back to hierarchy charges.
+ * The caller must not (un)charge @counter concurrently with this call, and this
+ * must not be called twice on the same counter. A concurrent drain is fine
+ * since the stock is published with a release store the drain paths pair with.
+ *
+ * Context: Process context. May sleep, the percpu alloc uses GFP_KERNEL.
+ */
+void page_counter_alloc_stock(struct page_counter *counter, unsigned long batch)
+{
+	struct page_counter_stock __percpu *stock;
+	int cpu;
+
+	if (WARN_ON_ONCE(counter->stock))
+		return;
+
+	stock = alloc_percpu_gfp(struct page_counter_stock, GFP_KERNEL_ACCOUNT);
+	if (!stock)
+		return;
+
+	for_each_possible_cpu(cpu) {
+		struct page_counter_stock *pcp_stock = per_cpu_ptr(stock, cpu);
+
+		raw_spin_lock_init(&pcp_stock->lock);
+	}
+
+	counter->batch = batch;
+	/* Publish stock only after percpu allocs / inits are finished */
+	smp_store_release(&counter->stock, stock);
+}
+
+/**
+ * page_counter_free_stock - free @counter's percpu cached charge
+ * @counter: page_counter whose stock to free
+ *
+ * Caller must guarantee no (un)charge or drain of @counter is in flight or can
+ * start. memcg only calls this once the cgroup is dead and unreachable.
+ */
+void page_counter_free_stock(struct page_counter *counter)
+{
+	struct page_counter_stock __percpu *stock = counter->stock;
+	int cpu;
+
+	if (!stock)
+		return;
+
+	/* Stop greedy over-charging before the stock goes away */
+	counter->batch = 0;
+	for_each_possible_cpu(cpu)
+		page_counter_drain_cpu_stock(counter, cpu);
+
+	WRITE_ONCE(counter->stock, NULL);
+	free_percpu(stock);
+}
 
 #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
 /*
-- 
2.53.0-Meta

