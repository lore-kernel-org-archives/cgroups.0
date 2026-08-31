Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F7C4A33ED
	for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 16:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194282; cv=none; b=KyObztmMzeUT9feDEdWtqSEbSP86WRTa8ndt/RFuvSlzrdFDlQijvXz6kp2M9YormmtFszdBXFZgnTy/2ThWoglhjW72dP83jI2yng6FRQcFlBenjOHBoNdiAVt540OgXo95hj4Mp1f0aHOzhqFRusKGHKJBEk7bZEiu6ewTHF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194282; c=relaxed/simple;
	bh=dZraJ7RTBatWlxTVjR14xRqPdJ/jnRpH20RMutxDuWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aERM1QiZiFSxlblko3j+/7/PpptEX4EHzN6B3OSedwroLgxfFtAReNoSYMhrq4ZjZEF7vUvMN1AzLviTOlFK6HLe4Iuk/D4c4ts1sWlGRb6y3cg7EhxPfBCGQQLG12ThE4ZmWQrNPoyi+fnNEssHZpgnguqi0rz4gk3xEC0XvgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NeHe404P; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NeHe404P"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-46556b9e02cso64513fac.1
        for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 09:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788194278; x=1788799078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vXFNKbTdOrOMYaajm/HLCYSs/GSBNBi/73jyNLJmP+Y=;
        b=NeHe404Ph+4dXuR07BEA3+0AbDRA5pVVSNy6dyeXGmpqXVAilXlE2iceT9/J2hsX4D
         nw+hl1IELiqpe8dUx3tfaTaM6RiHyK6mrTImr1c4tG4TSKh0+p/dNU0r4MWWpev/UjtN
         mR1xyiLxt1+Lk50O2ibMz/r3OWX7tAL7zMOsj30hvwAVfjlwY6rMcfsUMaUmXUFSuSfQ
         ED6UYYR75xCWHOJCqK9o+m365DgABZ8+c6Qa49OGqyrrL8EnIdtJmGkTwfNerXnffwSI
         KERozlAfHRzSiT/0r7v44O/1YzP0F+WDz1D+fsoydAXPlWeplbnF5XIaxZgi8V5bQQ60
         ypMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788194278; x=1788799078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vXFNKbTdOrOMYaajm/HLCYSs/GSBNBi/73jyNLJmP+Y=;
        b=Wl6BCSec0kL6woMWGHGSbjk7c48SD7Kd6ejv9wPfcjHse72140S12mn9u7kTgTkeAn
         NAZW7YQvkaN0oeFPPzhofymZFB6CEvfG1dS9HqzWiPSUEPBegK52CdgXd1OO6YgF2TTP
         DHktQ1x8PQV/xVjOWYwHvj/yO3f/z50A/zbOAD7dzD5y8CkXV22XCioF51EXOdQBRi58
         KswwmWJ5SR4GilTXCBvW4jgzC9gGf0myxIx3sXkGffLRbV3EMu+a34VLOwz/x9pHh6m8
         X/n3xHWf8qOTcg2gYWQycNtv7ZpEQcynsF1smGWKoH2DP2OiMGuzEL5ZG0gpIqymoHgm
         wVQA==
X-Forwarded-Encrypted: i=1; AHgh+Ros5+DehghA5wpmLWv5nUu+5BggdcOlZ33sAGfgvsb4kyBwQbULqi32/8Fz/YAXLXME3oeTWvdK@vger.kernel.org
X-Gm-Message-State: AFuF++lMlKWEraOV9/tZKWmizzWMzgwUIsdDyiHtLFxFgJ3+t7mR6Fpy
	Bm3YvcLarKQBIMImQh/lPuCuhjlcq5q9BTlqtbu5/FpOYjZiNT4kR8Pg
X-Gm-Gg: AYBFou02bjdpYb0HKG4enmYvTrRMTAU6eFKuBKnRGZF+BiBMDPIZ0BxSsk1QSIyH+hE
	B3RWz7B/mJT+NXUBdTviotop6t6B8d7Y1SBPuht3rXejVmX6AsyDLW3PHLvTqVtZGtNLhmXyWdH
	BwhaOZ2nRSbj5Qxp3n1a+7aqI8+Y+oWZE+7XvErWCAAZH/sLbH5VDCfhTCoRfIjXzMucjFGVq1R
	OXa3MG5z3SsGfTpv350hAy1HOgD6ZcjFqp+sY1YoFlMrA7Y17RVbS4xQo4coqY6FXb9SPsnGcoA
	CPZ3BtQKUDYHepYbeKwFiERK7BtRYaimfHTbR5AnotU9RDjs9nKqDK8xI6SDzF8YR2h+I/SUi7v
	y9OXYdfegvnY6swgmY+WOva2LBdFfiC9p54KDYgm2rDXneIRUvDyY/UAW6gL7a/WDqEddGPYc9K
	uyHRM+dMNdXstyCmuFOVcdSn83CPRisaymWGMVSaspe5oE0ZarPopuCUTNADI4QcqFMGjj5ZtIf
	FhRbpUVuZ4w4LknOIs=
X-Received: by 2002:a05:6870:2b11:b0:456:4c6b:773a with SMTP id 586e51a60fabf-46aca5a5f8amr7723915fac.9.1788194278410;
        Mon, 31 Aug 2026 09:37:58 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:30::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-468a4effb4dsm10497204fac.10.2026.08.31.09.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 09:37:58 -0700 (PDT)
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
Subject: [PATCH v5 4/7] mm/page_counter: use stock in page_counter_try_charge
Date: Mon, 31 Aug 2026 09:37:48 -0700
Message-ID: <20260831163752.2193337-5-joshua.hahnjy@gmail.com>
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

Transparently make page_counter_try_charge attempt to service the charge
from its stock. We preserve the same semantics as the existing stock
management in try_charge_memcg:

1. Limit-check against the stock. If there is enough, then skip the
   hierarchy walk and charge to the stock.
2. Greedily attempt to fulfill the charge request and refill the stock
   simultaneously to the hierarchy.
3. If this fails, retry the stock and charge without trying to refill
   the stock, i.e. with the number of pages requested.
4. If the greedy attempt succeeds, return excess pages to the stock.

page_counter_refill_stock() falls back to a hierarchical uncharge when
there is no stock, in NMI contexts, on lock contention, or for a refill
larger than the batch.

The greedy charge is also skipped in NMI where both stock helpers bail
out since the batch charge would be undone again.

No functional change intended, since no page_counter enables stock yet
and counter->batch is left at 0.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h |   2 +
 mm/page_counter.c            | 135 +++++++++++++++++++++++++++++++----
 2 files changed, 125 insertions(+), 12 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index c1fe331f34e7e..428ca8e7b2da5 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -82,6 +82,8 @@ static inline unsigned long page_counter_read(struct page_counter *counter)
 
 void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
+unsigned long page_counter_refill_stock(struct page_counter *counter,
+					unsigned long overage);
 bool page_counter_try_charge(struct page_counter *counter,
 			     unsigned long nr_pages, struct page_counter **fail,
 			     unsigned long *nr_charged);
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 3f61eba695518..a76949abf04e7 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -113,25 +113,126 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages)
 	}
 }
 
+static bool page_counter_consume_stock(struct page_counter *counter,
+				       unsigned long nr_pages)
+{
+	struct page_counter_stock __percpu *stock = READ_ONCE(counter->stock);
+	struct page_counter_stock *pcp_stock;
+	unsigned long flags;
+	bool charged = false;
+
+	if (!stock || nr_pages > counter->batch)
+		return false;
+
+	/* raw_spin_trylock isn't enough to protect against nested NMI in UP */
+	if (in_nmi())
+		return false;
+
+	/* It's OK to migrate here, since stock is fungible within a counter. */
+	pcp_stock = raw_cpu_ptr(stock);
+
+	if (!raw_spin_trylock_irqsave(&pcp_stock->lock, flags))
+		return false;
+
+	if (pcp_stock->nr_pages >= nr_pages) {
+		pcp_stock->nr_pages -= nr_pages;
+		charged = true;
+	}
+
+	raw_spin_unlock_irqrestore(&pcp_stock->lock, flags);
+	return charged;
+}
+
+/**
+ * page_counter_refill_stock - return pages to a page_counter's stock
+ * @counter: counter to return the pages to
+ * @overage: number of pages to return
+ *
+ * Return: how many of @overage went to the hierarchy rather than the stock.
+ * The flush itself can be larger, since it also returns what earlier callers
+ * stocked.
+ */
+unsigned long page_counter_refill_stock(struct page_counter *counter,
+					unsigned long overage)
+{
+	struct page_counter_stock __percpu *stock = READ_ONCE(counter->stock);
+	struct page_counter_stock *pcp_stock;
+	unsigned long high = counter->batch;
+	unsigned long low = high / 2;
+	unsigned long to_flush = overage;
+	unsigned long stocked;
+	unsigned long flags;
+
+	if (!stock || overage > high)
+		goto uncharge_counter;
+
+	/* See page_counter_consume_stock() for why NMI skips the stock. */
+	if (in_nmi())
+		goto uncharge_counter;
+
+	/* It's OK to migrate here, since stock is fungible within a counter. */
+	pcp_stock = raw_cpu_ptr(stock);
+	if (!raw_spin_trylock_irqsave(&pcp_stock->lock, flags))
+		goto uncharge_counter;
+
+	/*
+	 * Use a high/low watermark here, in the spirit of pcp->{batch, high}.
+	 * If the stock would exceed counter->batch, stock is trimmed to the low
+	 * watermark of counter->batch / 2 so that sequential uncharges don't
+	 * all trigger a hierarchy walk.
+	 */
+	stocked = pcp_stock->nr_pages + overage;
+	if (stocked > high) {
+		pcp_stock->nr_pages = low;
+		to_flush = stocked - low;
+	} else {
+		pcp_stock->nr_pages = stocked;
+		to_flush = 0;
+	}
+	raw_spin_unlock_irqrestore(&pcp_stock->lock, flags);
+
+	if (!to_flush)
+		return 0;
+
+uncharge_counter:
+	page_counter_uncharge(counter, to_flush);
+	return min(overage, to_flush);
+}
+
 /**
  * page_counter_try_charge - try to hierarchically charge pages
  * @counter: counter
  * @nr_pages: number of pages to charge
- * @fail: points first counter to hit its limit, if any
+ * @fail: only written on failure; the first counter to hit its limit
  * @nr_charged: optional; on success, set to the number of pages actually
- *		charged to the hierarchy
+ *		charged to the hierarchy. Set to 0 if stock was served.
+ *
+ * A successful charge may still have bumped failcnt on @counter or an
+ * ancestor, since the greedy attempt is retried at the requested size.
  *
- * Returns %true on success, or %false and @fail if the counter or one
- * of its ancestors has hit its configured limit.
+ * Returns %true on success, or %false and sets @fail if the counter or
+ * one of its ancestors has hit its configured limit.
  */
 bool page_counter_try_charge(struct page_counter *counter,
 			     unsigned long nr_pages, struct page_counter **fail,
 			     unsigned long *nr_charged)
 {
-	struct page_counter *c;
+	struct page_counter *c, *failed_at;
+	unsigned long charge = nr_pages;
 	bool protection = track_protection(counter);
 	bool track_failcnt = counter->track_failcnt;
 
+	/* The stock is skipped in NMI; a greedy charge would just be undone */
+	if (!in_nmi())
+		charge = max(counter->batch, nr_pages);
+
+retry:
+	if (page_counter_consume_stock(counter, nr_pages)) {
+		if (nr_charged)
+			*nr_charged = 0;
+		return true;
+	}
+
 	for (c = counter; c; c = c->parent) {
 		long new;
 		/*
@@ -148,9 +249,9 @@ bool page_counter_try_charge(struct page_counter *counter,
 		 * we either see the new limit or the setter sees the
 		 * counter has changed and retries.
 		 */
-		new = atomic_long_add_return(nr_pages, &c->usage);
+		new = atomic_long_add_return(charge, &c->usage);
 		if (new > c->max) {
-			atomic_long_sub(nr_pages, &c->usage);
+			atomic_long_sub(charge, &c->usage);
 			/*
 			 * This is racy, but we can live with some
 			 * inaccuracy in the failcnt which is only used
@@ -158,7 +259,7 @@ bool page_counter_try_charge(struct page_counter *counter,
 			 */
 			if (track_failcnt)
 				data_race(c->failcnt++);
-			*fail = c;
+			failed_at = c;
 			goto failed;
 		}
 		if (protection)
@@ -172,15 +273,25 @@ bool page_counter_try_charge(struct page_counter *counter,
 		}
 	}
 
+	if (charge > nr_pages)
+		charge -= page_counter_refill_stock(counter, charge - nr_pages);
+
 	if (nr_charged)
-		*nr_charged = nr_pages;
+		*nr_charged = charge;
 
 	return true;
 
 failed:
-	for (c = counter; c != *fail; c = c->parent)
-		page_counter_cancel(c, nr_pages);
+	for (c = counter; c != failed_at; c = c->parent)
+		page_counter_cancel(c, charge);
+
+	/* Retry the stock & charge with the exact number of pages requested */
+	if (charge > nr_pages) {
+		charge = nr_pages;
+		goto retry;
+	}
 
+	*fail = failed_at;
 	return false;
 }
 
@@ -330,7 +441,7 @@ void page_counter_drain_cpu_stock(struct page_counter *counter, int cpu)
 /**
  * page_counter_alloc_stock - allocate the percpu stock for a page_counter
  * @counter: counter to allocate percpu stock for
- * @batch: maximum number of pages a CPU may cache
+ * @batch: number of pages to precharge and the stock's high watermark
  *
  * Failure to allocate is not fatal; @counter falls back to hierarchy charges.
  * The caller must not (un)charge @counter concurrently with this call, and this
-- 
2.53.0-Meta

