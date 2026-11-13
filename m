Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794607549;
	b=v1Z0NG8BFaq4tYeaoc17818VEBCKc/IMZpkuKGAKPVsskWWzTZ5/3ZWCF/2zOqn4cFxc
	 qeI0FdoR6yqIS7tKU+9MbMvMCNXWtODsxzB9z/3ZQ/p0yKwqXRoKGdFFWxTVXJVC5wPA+
	 Iy1ibeBBOWDHKEDYO2k7IzpRyE5zCzkKfIji1se1jvQRUnkSNblmH7kkHJdIIQUwnm33X
	 P4g2P6lsSeaUOtwcNbJSNBxuParY/kvo0UMfEVlwLMHv3JscbHqiYII6GXTU0w4GJKCdV
	 RxGtg7baajCe4NebEzPAgrZrUp81levJOpJsJD6Joky2k3DOdqsfJNrXUPvdmkV6ifw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794607549;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x3U8jhke3RBD55kF2ywexkvmentOUqyFGvRCrHrWYAo=;
	b=AdULtF94Ye5P70vDFgxl8LcoQuFsRJ7ghzRjBLblLQ1wpjBXSL22SD4V/mBhSNOcGnEJ
	 OtTPWY9kSUoIC/ZArkxNn3UsC76gIos+lGyPVA5vzlRPqoOBf+AucN169P7zUj4mUWBlo
	 Klc1i9SErTn0cmwFecvdlAMCXeHOs1bVI+RegBzKpZnvhBXOH/TkG71JXo96Acsl3Lbk4
	 RipEdTKrdNFPixEJ3Bid9/SkdzSzMJSlAeN1zY4FGTm5XHC6z63xIJHQu7f7Iod7AdZve
	 ed7ZC4Ytvc7chqMR/nkNWbs9fvukqlYHDn2WPRuMdnkPgwDVgedklN032jy5WXy0r6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZsMLVwzZ;
	arc=none smtp.remote-ip=209.85.128.182
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A068A606A894
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 22:05:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A068A606A894
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZsMLVwzZ
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8b3653df740so8394647b3.2
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 14:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794607548; x=1795212348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x3U8jhke3RBD55kF2ywexkvmentOUqyFGvRCrHrWYAo=;
        b=ZsMLVwzZrgZY0La4eNuco03w/PNlqkzArrVFOK5g+lSpd8S26UPRXobvf8IXmgxiZr
         PHCv+uBgs414KNmSS4zGt44jBbWCDhyemoyOqA75iYtjUkOD5M884cuFNbCsE2e3wViF
         kb8+n1lRuQxHOBOk+HAsxnW4T5Wbs1mEZVtMm+ibOikWNmsY9XgY2GXiPP+S3X//Dijb
         0V13IypfLbkIPNdSkZKoxTRZjYaZfQo1NGqN/ZGph8CJThbsEpOWaGLLnqldsamNehpx
         +nFXmdzFZLAYeMeTJs+APvYuy+ruOnBwH0daCBynV6Zu6UWax96jHALIUfv7tEzwJsIv
         n8YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794607548; x=1795212348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=x3U8jhke3RBD55kF2ywexkvmentOUqyFGvRCrHrWYAo=;
        b=oDsmCEvpk+PMoMlmYtIwgWKGbFOLSGzn5typMpQHCPnFGBBuBpUdbr8phCHLbH6nck
         s++XkHtJeRd+5YLMSkNudz7xPPsDA/smaJHvTVHEjrYQ07IHNOPY8Y06CMuuGPazrJJZ
         vCiEdCFtFQTMuZ839svtmgrRoZ7B45vxsbpCA0c31/VX+yrVbtJGuHN6X5wEdRpLO+Y8
         2WfEr0sqONlIiexrDPDOAcy2rpaMRDkjXrmle1K8m1c19DxCPU2HwZBhBIDgb9nfY/WV
         cE+OvdFGoTaTCDyXws7PcI+OzvA4uMAji8F5nexKSkqncIiGCVkZi0XV/JeHyv0NbmEF
         EVhA==
X-Forwarded-Encrypted: i=1; AL+hErFz517y/rO37gf2/oTO07AcNw91nA+3pmua3aX4gOAVvbUeECH9Lu7ELwpPXNiL+j2tFLuyudQc@vger.kernel.org
X-Gm-Message-State: APuU4Z+jkutYPQctgfkSXyFqq3UTX4GqjPEfCDahZJ6QOFyTPkaJas6G
	mupv0s2JZwvOB89YykCebSXT6c5z2vFa7IfMSCszYxc9BEWF1jBisIGT
X-Gm-Gg: AYBFou0czTXL+gmNz1cVpTRsFHRHQFz1g1A+WB2QhxtFuiUKq3V9+Q5M59MlILQ6FBZ
	hHslCjHfYFoKmD9c/cPBd+JeLtWS3ygW9Erju/DnoMJ3tcDScyIWEF0jcumzUoepjtn3bedJapv
	vfC+/d7bTsIXwGqzU/s3yowKJw2x3yjwxPTxTGNFcG25Zmbhm+VPEmXl4Whfb0IwStVIJ1eowQN
	RkO7lGkOu8a3w5VhKSsEj9Ehlq4+FWv2wOs1GZUNDsvg1Ukxq2VmOL5aaYAsFw5QL20tTDX01Zu
	gRX8o+WR3mFsswsDVPK7BXjhpJg5Cyp/MSbvLxYqJs9ochosBYxPoct9Oei5EwfDXr9xApc4QU7
	5rzbTmB5256T4GV1u7vXUqXOgc75k2RDDex/pCoTvTaHaSEKEBJM1+R0dyky445wmQeeLiA/aRS
	EA4boE5pAFhW18AQtqYa8fhZyhPAKU1xfMgKoIEJQLj1u205gW6OvF75v02l/tRctbKu7lbA4R4
	EySnuhFsAcQtvtRLppdM+/AfA0cdks+1T7YI8w+KWeerYL5WxhiHh58m/u3GFR06Ni7ib/IFJKy
	OnA7ilUrg7czZgRt7+V2hLL4GYv3N0WCnLp0J+V8QoL7FfgBQC9B3EJFEGiK
X-Received: by 2002:a05:690c:530a:10b0:8b3:2997:f9d8 with SMTP id 00721157ae682-8b4aa36ecffmr20756877b3.54.1794607547707;
        Fri, 13 Nov 2026 14:05:47 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:58::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa8f354asm31651117b3.14.2026.11.13.14.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 14:05:46 -0800 (PST)
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
Subject: [PATCH v9 3/7] mm/page_counter: make page_counter_try_charge() stock-aware
Date: Fri, 13 Nov 2026 14:05:30 -0800
Message-ID: <20261113220539.2275715-4-joshua.hahnjy@gmail.com>
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

Make page_counter_try_charge() consume stock transparently to callers
while preserving the same semantics as try_charge_memcg's greedy
charge attempt, refill, and !allow_spinning special case.

page_counter_try_charge gets two new parameters, may_batch and
nr_charged.

may_batch is intended to preserve the behavior of !allow_spinning
scenarios in try_charge_memcg, where the goal is to charge as quickly
as possible, without evicting other stock slots or making a greedy
charge to refill the stock.

nr_charged is used to reflect the size of the successful hierarchy
charge, preserving the existing batch-based memory.high accounting
for current->memcg_nr_pages_over_high. As with refill_stock() today,
the full charge is reported even if the excess is later uncharged
because the stock could not accept it. This only affects memory.high
throttling heuristics and never fails a charge.

So this preserves the existing accounting heuristic. Accounting for
credits returned by refill would be a separate behavioral change which
may be addressed in a future follow-up.

As of this patch, no page_counter has stock yet, so there are no
functional changes intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h |  4 +-
 kernel/cgroup/dmem.c         |  2 +-
 mm/hugetlb_cgroup.c          |  2 +-
 mm/memcontrol-v1.c           |  3 +-
 mm/memcontrol.c              |  8 ++--
 mm/page_counter.c            | 85 +++++++++++++++++++++++++++++++-----
 6 files changed, 86 insertions(+), 18 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index cf627c5090093..58532259e7f59 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -98,8 +98,8 @@ long page_counter_margin(const struct page_counter *counter);
 void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
-			     unsigned long nr_pages,
-			     struct page_counter **fail);
+			     unsigned long nr_pages, struct page_counter **fail,
+			     bool may_batch, unsigned long *nr_charged);
 void page_counter_refill_stock(struct page_counter *counter,
 			       unsigned long nr_pages);
 void page_counter_drain_stock_fully(struct page_counter_stock_pcp *stock);
diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index d49ed5d4a9237..dd325e9413fb5 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -736,7 +736,7 @@ int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
 		goto err;
 	}
 
-	if (!page_counter_try_charge(&pool->cnt, size, &fail)) {
+	if (!page_counter_try_charge(&pool->cnt, size, &fail, false, NULL)) {
 		if (ret_limit_pool) {
 			*ret_limit_pool = container_of(fail, struct dmem_cgroup_pool_state, cnt);
 			css_get(&(*ret_limit_pool)->cs->css);
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 6921b18572666..c67d961cf8943 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -304,7 +304,7 @@ static int __hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 
 	if (!page_counter_try_charge(
 		    __hugetlb_cgroup_counter_from_cgroup(h_cg, idx, rsvd),
-		    nr_pages, &counter)) {
+		    nr_pages, &counter, false, NULL)) {
 		ret = -ENOMEM;
 		hugetlb_event(h_cg, idx, HUGETLB_MAX);
 		css_put(&h_cg->css);
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index b7f2868885071..a146e54c6f9f7 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -2193,7 +2193,8 @@ bool memcg1_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
 {
 	struct page_counter *fail;
 
-	if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
+	if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail,
+				    false, NULL)) {
 		memcg->tcpmem_pressure = 0;
 		return true;
 	}
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aaeef20eec06a..0e7500624b9e3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2816,13 +2816,14 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (do_memsw_account() &&
-	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
+	    !page_counter_try_charge(&memcg->memsw, batch, &counter, false,
+				     NULL)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
 		goto reclaim;
 	}
 
-	if (page_counter_try_charge(&memcg->memory, batch, &counter))
+	if (page_counter_try_charge(&memcg->memory, batch, &counter, false, NULL))
 		goto done_restock;
 
 	if (do_memsw_account())
@@ -6057,7 +6058,8 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 		private_id = mem_cgroup_private_id_get(memcg, nr_pages);
 
 		if (!mem_cgroup_private_id_is_root(private_id) &&
-		    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
+		    !page_counter_try_charge(&memcg->swap, nr_pages, &counter,
+					     false, NULL)) {
 			memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 			memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 			mem_cgroup_private_id_put(private_id, nr_pages);
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 70d76689e3212..e1feb2bd1e225 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -154,23 +154,79 @@ static void page_counter_drain_stock(struct page_counter_stock_pcp *stock,
 	css_put(counter->stock_css);
 }
 
+/*
+ * Consume the cached charge if enough nr_pages are present, otherwise return
+ * failure. Also return failure for charge requests larger than
+ * PAGE_COUNTER_STOCK_BATCH or if the local lock is already taken.
+ */
+static bool page_counter_consume_stock(struct page_counter *counter,
+				       unsigned long nr_pages)
+{
+	struct page_counter_stock_pcp __percpu *stock = READ_ONCE(counter->stock);
+	struct page_counter_stock_pcp *pcp_stock;
+	u8 stock_pages;
+	bool ret = false;
+	int i;
+
+	if (!stock || unlikely(nr_pages > PAGE_COUNTER_STOCK_BATCH ||
+			       !local_trylock(&stock->lock)))
+		return false;
+
+	pcp_stock = this_cpu_ptr(stock);
+	for (i = 0; i < NR_PAGE_COUNTER_STOCK; i++) {
+		struct page_counter *cached = pcp_stock->cached[i];
+
+		if (counter != cached)
+			continue;
+
+		stock_pages = pcp_stock->nr_pages[i];
+		if (unlikely(stock_pages < nr_pages))
+			break;
+
+		stock_pages -= nr_pages;
+		WRITE_ONCE(pcp_stock->nr_pages[i], stock_pages);
+		if (unlikely(!stock_pages)) {
+			WRITE_ONCE(pcp_stock->cached[i], NULL);
+			css_put(counter->stock_css);
+		}
+		ret = true;
+		break;
+	}
+	local_unlock(&stock->lock);
+
+	return ret;
+}
+
 /**
- * page_counter_try_charge - try to hierarchically charge pages
+ * page_counter_try_charge - try to hierarchically charge pages using stock
  * @counter: counter
- * @nr_pages: number of pages to charge
- * @fail: points first counter to hit its limit, if any
+ * @nr_pages: number of pages requested
+ * @fail: points to the first counter to hit its limit, if any
+ * @may_batch: whether a stock miss may trigger a batch charge
+ * @nr_charged: optional; set to the hierarchy charge size on success
  *
- * Returns %true on success, or %false and @fail if the counter or one
- * of its ancestors has hit its configured limit.
+ * Return: %true if the request was satisfied. A failed batch charge may update
+ * @fail before an exact retry succeeds.
  */
 bool page_counter_try_charge(struct page_counter *counter,
-			     unsigned long nr_pages,
-			     struct page_counter **fail)
+			     unsigned long nr_pages, struct page_counter **fail,
+			     bool may_batch, unsigned long *nr_charged)
 {
+	unsigned long charge = nr_pages;
 	struct page_counter *c;
 	bool protection = track_protection(counter);
 	bool track_failcnt = counter->track_failcnt;
 
+	if (READ_ONCE(counter->stock) && may_batch)
+		charge = max(nr_pages, PAGE_COUNTER_STOCK_BATCH);
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
@@ -187,9 +243,9 @@ bool page_counter_try_charge(struct page_counter *counter,
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
@@ -210,11 +266,20 @@ bool page_counter_try_charge(struct page_counter *counter,
 				WRITE_ONCE(c->watermark, new);
 		}
 	}
+	if (charge > nr_pages)
+		page_counter_refill_stock(counter, charge - nr_pages);
+	if (nr_charged)
+		*nr_charged = charge;
 	return true;
 
 failed:
 	for (c = counter; c != *fail; c = c->parent)
-		page_counter_cancel(c, nr_pages);
+		page_counter_cancel(c, charge);
+
+	if (charge > nr_pages) {
+		charge = nr_pages;
+		goto retry;
+	}
 
 	return false;
 }
-- 
2.53.1-Meta

