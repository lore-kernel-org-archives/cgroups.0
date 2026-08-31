Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BB14A3853
	for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 16:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194283; cv=none; b=kxydKl+D7MeimaP1tndMDfVoBK4Y2F+RYqGZIo+pwZtMB19cYNC+Yg97EBnr4MIFCHi5DUsmV0JSjKZTdRQgSmg86IMS4TxDASwY9IvMPs2ne6wLVfN0CCLkdDp2lNlaeu/UGKJ9UHU8U/QNa7zJLZM5P7QB5miZueV4jCxK0t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194283; c=relaxed/simple;
	bh=GGcdgcidJRK4f6nVOmkrYxscF0UoppYT966YKJwy27I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlABKa8tX+u76U2qvFR/KQcw1EBFrysAgrv5WfV7KIeIgJWVNvVa01LZnJexwwjW76AjznWEHbrXucjmiaICCa13Q0Yn3XFXb8MLSNnQENi3ISs9fsMZrjqOlkO6XLvOTyWiBWndAiKfs2oelCTxZKFPSGyiAT6mhU9B05dTaqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nXxPixKM; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nXxPixKM"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7e9ef94c0e2so2511811a34.3
        for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 09:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788194279; x=1788799079; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tZLPtkE4K+x7inkg5AOVUnb1Simer6GkDXLFxdMoHE0=;
        b=nXxPixKMBGtAS8SA87yCVSy8wlTGTGgLh3py9zTibbLgoySarv+kJOAdCWTx4Ow7UB
         zcBIi/6e7InTjykVKfp8k+oeooGm4iHaAxucVM5Z40vNnZrWimD+sDYdcFeoa1mBaBny
         RumlAz4lowAWmcHEHSOxySgN6cm6IlsdgfUK6w8YpeH/4vTSBvohATI+FtXJYioEh1e+
         iorkPyLZcMplD74VcGDyVJVdlnD6QCDX6t/h/Jfbe25kNTp0aYmnxOJ8tReUxsR/vAgM
         35ZPYGa+ppJ06hX0Tj4U6P2yPJlNTc8ltPc62dSW42RFYN50VhKH+ia/bSpP21PakcVs
         kC2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788194279; x=1788799079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tZLPtkE4K+x7inkg5AOVUnb1Simer6GkDXLFxdMoHE0=;
        b=PiDP0xgoKjVPMUeFZlyca79j6Dg25PZaV/L2jbSWmBCye1QdsaOvfFs9IeSvVMloGz
         Tq/RqumR8kgNxxdiVUeekhMLueppAYJHWRwMS07O3MbICgOi6nofv/MOwqzwVlzsRDaO
         cY3wqhiLbpF95q+7V0FBphI+HATWs/SpDCsX7dsaLPgblzBSqEBkW08QZGlbpxYpicrK
         FuW1vSbtRu7z+ogfM9dBf10mWF+UxHmmQNTXwohBLKJIDFlmFluD9kbsy4f8g6miNT1e
         zOr7IYz7Xk6Lfc0WdRLWAyUr5GXav+bGkdJnA2UOuz3RIiif6VBA6h3AAwBL4oz+u7cd
         gCSA==
X-Forwarded-Encrypted: i=1; AHgh+RrTe/mceQoqDu6/UKZWqh2sNAgsQN0ZzfysHhH2sLk/ArwCQpLmHfquxvvfX9ImkmDEBg4quo8X@vger.kernel.org
X-Gm-Message-State: AFuF++ni+JyL8FPb6iTS1ixA5EITAoS9Pkqd+qkSIJHKyS4tBNH2cdnZ
	6FziQDzoTixLnoTHiv7OZTW+Vr+zov4hBpOxYECAptoOXFekkv9yvv0n
X-Gm-Gg: AR+sD13nTyzImdnphFN28jtUWv15cjWJ+0hDKrZdgaZfqQIOU8UtG2NY6nDU/MMY400
	WtW5rew9brKP3cmH7C0nmNqMdQvHNmquHdT+Vyr/23zE1RYP8mjERAv2RgVWpdNjE5GOGSm+GHq
	r0Q/12FDhAh8hoaoQqbrl+87uPM4n7J/oIQxUHyzby3QRX9KsbQtUH+GH/Vcqeu0VjvameuPreg
	ezWBCZd/DP2CxU1rNDw3d78oe7lVOBa3UYvH0HIvJdCLZRp1hqC1JUxezwYPn6BXgjx0Mc4yfw4
	CIFrwagmgbNhFQ8HfH+DMHRfIXiI+Xb5z8rf2k+Cl9YFQkxCU/gxrrRbQMc3zClLir1na2yIkIx
	aevwPvWMJp5XOvUvA++eI4giVArVT4TGBFdH30Jp5PM2/nXoKHhakre/SBViF383GUEbkUKr7mA
	+sDGWp4nFiiLOrNYwBLaHsx+BhLb/o7mL+CZYoBTdJX5oElM82ssSjLq69zLVxGLGzkLzXkO8S3
	0ueFGP5k6F1w44YcbVD
X-Received: by 2002:a05:6820:4d02:b0:6b1:afc8:3162 with SMTP id 006d021491bc7-6b1c6642c52mr23408705eaf.7.1788194279553;
        Mon, 31 Aug 2026 09:37:59 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:2b::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-468a2fedbcasm10399867fac.2.2026.08.31.09.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 09:37:59 -0700 (PDT)
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
Subject: [PATCH v5 5/7] mm/page_counter: introduce an asynchronous drainer
Date: Mon, 31 Aug 2026 09:37:49 -0700
Message-ID: <20260831163752.2193337-6-joshua.hahnjy@gmail.com>
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

The existing percpu memcg stock drainer schedules a stock drain worker
per-cpu, one for every CPU containing the target memcg's stock.

One issue with this design is the coarseness of the drain; when a worker
runs on a CPU, it drains not only the target memcg's stock, but all
other (up to 6) memcgs who are stocked on that CPU.

Instead, use a per-page_counter drainer that iterates through each CPU
and flushes any existing charges, leaving other unrelated memcgs' stock
alone. Since that walks every possible CPU, the per-cpu helper now skips
the remote lock when a stock looks empty.

One benefit of having one worker flush through all CPUs is that
duplicate drain requests when a worker is already queued are coalesced,
since the asynchronous drainer takes no arguments and flushes all CPUs.

We use the system_dfl_wq for this asynchronous drain worker, since
memcg_wq is a percpu workqueue. Note that neither workqueue has
WQ_MEM_RECLAIM.

Previously the local CPU was drained inline because local_lock made it
the only reachable stock. The lock is now a per-cpu raw_spinlock_t that
any CPU can take, so drain any CPU's stock to return pages immediately.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h |  1 +
 mm/page_counter.c            | 55 ++++++++++++++++++++++++++++++++----
 2 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 428ca8e7b2da5..b10ef785f06de 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -114,6 +114,7 @@ static inline void page_counter_reset_watermark(struct page_counter *counter)
 }
 
 void page_counter_drain_cpu_stock(struct page_counter *counter, int cpu);
+void page_counter_drain_stock_async(struct page_counter *counter);
 void page_counter_alloc_stock(struct page_counter *counter, unsigned long batch);
 void page_counter_free_stock(struct page_counter *counter);
 
diff --git a/mm/page_counter.c b/mm/page_counter.c
index a76949abf04e7..e6cfb5865ba75 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -12,6 +12,7 @@
 #include <linux/string.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
+#include <linux/workqueue.h>
 #include <linux/bug.h>
 #include <asm/page.h>
 
@@ -135,7 +136,7 @@ static bool page_counter_consume_stock(struct page_counter *counter,
 		return false;
 
 	if (pcp_stock->nr_pages >= nr_pages) {
-		pcp_stock->nr_pages -= nr_pages;
+		WRITE_ONCE(pcp_stock->nr_pages, pcp_stock->nr_pages - nr_pages);
 		charged = true;
 	}
 
@@ -183,10 +184,10 @@ unsigned long page_counter_refill_stock(struct page_counter *counter,
 	 */
 	stocked = pcp_stock->nr_pages + overage;
 	if (stocked > high) {
-		pcp_stock->nr_pages = low;
+		WRITE_ONCE(pcp_stock->nr_pages, low);
 		to_flush = stocked - low;
 	} else {
-		pcp_stock->nr_pages = stocked;
+		WRITE_ONCE(pcp_stock->nr_pages, stocked);
 		to_flush = 0;
 	}
 	raw_spin_unlock_irqrestore(&pcp_stock->lock, flags);
@@ -429,15 +430,53 @@ void page_counter_drain_cpu_stock(struct page_counter *counter, int cpu)
 		return;
 
 	pcp_stock = per_cpu_ptr(stock, cpu);
+
+	/*
+	 * Skip the remote lock when empty. Racing with the charge path is why
+	 * nr_pages uses WRITE_ONCE(); a stale read defers to the next drain.
+	 */
+	if (!READ_ONCE(pcp_stock->nr_pages))
+		return;
+
 	raw_spin_lock_irqsave(&pcp_stock->lock, flags);
 	nr_pages = pcp_stock->nr_pages;
-	pcp_stock->nr_pages = 0;
+	WRITE_ONCE(pcp_stock->nr_pages, 0);
 	raw_spin_unlock_irqrestore(&pcp_stock->lock, flags);
 
 	if (nr_pages)
 		page_counter_uncharge(counter, nr_pages);
 }
 
+static void page_counter_drain_work_fn(struct work_struct *work)
+{
+	struct page_counter *counter = container_of(work, struct page_counter,
+						    drain_work);
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		page_counter_drain_cpu_stock(counter, cpu);
+}
+
+/**
+ * page_counter_drain_stock_async - schedule a page_counter stock drain
+ * @counter: page_counter to drain
+ *
+ * Drains any CPU's stock inline, then schedules a drain over every CPU and
+ * returns. Concurrent requests coalesce onto the same queued work. @counter
+ * must outlive that work, which page_counter_free_stock() cancels.
+ * Must not be called from NMI context.
+ */
+void page_counter_drain_stock_async(struct page_counter *counter)
+{
+	/* Pairs with the smp_store_release() in page_counter_alloc_stock() */
+	if (!smp_load_acquire(&counter->stock))
+		return;
+
+	/* Drain any CPU's stock to immediately return pages; migrating is OK */
+	page_counter_drain_cpu_stock(counter, raw_smp_processor_id());
+	queue_work(system_dfl_wq, &counter->drain_work);
+}
+
 /**
  * page_counter_alloc_stock - allocate the percpu stock for a page_counter
  * @counter: counter to allocate percpu stock for
@@ -469,6 +508,7 @@ void page_counter_alloc_stock(struct page_counter *counter, unsigned long batch)
 	}
 
 	counter->batch = batch;
+	INIT_WORK(&counter->drain_work, page_counter_drain_work_fn);
 	/* Publish stock only after percpu allocs / inits are finished */
 	smp_store_release(&counter->stock, stock);
 }
@@ -477,8 +517,9 @@ void page_counter_alloc_stock(struct page_counter *counter, unsigned long batch)
  * page_counter_free_stock - free @counter's percpu cached charge
  * @counter: page_counter whose stock to free
  *
- * Caller must guarantee no (un)charge or drain of @counter is in flight or can
- * start. memcg only calls this once the cgroup is dead and unreachable.
+ * Caller must guarantee no (un)charge or drain of @counter can start, and must
+ * be ordered against the last CPU to touch the stock, since the drain peeks at
+ * nr_pages unlocked. memcg's RCU grace period before css_free provides both.
  */
 void page_counter_free_stock(struct page_counter *counter)
 {
@@ -490,6 +531,8 @@ void page_counter_free_stock(struct page_counter *counter)
 
 	/* Stop greedy over-charging before the stock goes away */
 	counter->batch = 0;
+	/* Make sure pending drainers don't run on freed page_counters */
+	cancel_work_sync(&counter->drain_work);
 	for_each_possible_cpu(cpu)
 		page_counter_drain_cpu_stock(counter, cpu);
 
-- 
2.53.0-Meta

