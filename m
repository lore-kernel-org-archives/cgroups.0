Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793835035;
	b=UscjyBVPE+7eCYOIAUbUfV/N3+hj01UIlzZxJW0DxUNk26iw0OA7JDtBYLPib3qgZc+U
	 UJc4eM/rzF18tmqYs0zFS7FcFnGBjArvFpvMTzNXuNyNYWJ39oUOrZpxKhoIfGQR1atER
	 ewvTeDjHHvs8ZsTIU8PpFVHLPMJ2TvRfa6lmLdBg20FJBWRRZncy9aoXQ7LcTEvy2YbzT
	 3cq8qRqfSU8duY29w9oyshTRYUGE3FE1JCmqO4anOalj0v9zT6RuI5sx0d21/RneI6bpN
	 CLTMqnitfWDVCzfs6QWZr7Hu6O/MKV7j8u/dDGVwx5x/haWufjXSln+lUE9Aylo43CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793835035;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FLEbYdbz2ZYNUmD7gx73lbpFTU6wBtu/7lasgoqtOEw=;
	b=zSSbAGsQZTpNQDfeOtthyM8OfVw3D7Q3gORZH1NKX7/AhPo+PoljSy3dwpyQ2AfCVhxx
	 1/m8HULYemoHhgwKf7t/j7fapcXfy4scp34NgYFRX6JVu5LJxdYRkatEOf4lgpwDom0hV
	 XPuyumjSJOBj9mOfw01F97EtBzvNiDusKbeRGaE/Kj+UFYJT5hZqBhOj/UAC3WbN/juAV
	 5/WLrKzvRiKCuwSBGS3dvuQTWMQ4LArS1E6KeSDTg9RaVy0djhS7RCOroxtoYZQtg+ggk
	 VjXLitUCa1hX8JCj3eZZP+qQ15h+7iCZwpaI45In8tgxH6NUiklJBtikO3VroSj7kzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vrE3BSg9;
	arc=none smtp.remote-ip=74.125.224.44
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116FD606D80B
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 23:30:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 116FD606D80B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vrE3BSg9
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-67bec5dc8d4so1299351d50.0
        for <cgroups@vger.kernel.org>; Wed, 04 Nov 2026 15:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793835034; x=1794439834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FLEbYdbz2ZYNUmD7gx73lbpFTU6wBtu/7lasgoqtOEw=;
        b=vrE3BSg9at366kCCL4MDBwUjVdJWYINeG3Gjbba4PXE7tNlZesYG59SQGyN30wWvAd
         cgRwKssPi8v0VVyXUJe/nf03d33wSyI0pe3zqyDk28exXBiQPCtztIhP07hZvbFblsSL
         rZexdBJUp47V9DbMfTLA+53h9Tpj+bln+EUw3JWBgB7sGOYa5axOHDrv0nEcO4HCjmNO
         +HbF2/pye98cZ+ZAuSSZ8ZtLMCnO3uxnuaEUf/LLk56MyekZX6wwgviossNcJ1WsLs4u
         hDonRoVqiHJaCpRmxpIDSJtc2pV1f+u/M57pfDZmtnOaTe2QgoIUL/APB4jCRRaOIYJb
         Rkyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793835034; x=1794439834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FLEbYdbz2ZYNUmD7gx73lbpFTU6wBtu/7lasgoqtOEw=;
        b=YZZBexF9LDLVGbF9Tv3ihjgAnm3dwV8g8RmeFK6lWu39Bq7yt711brXLeQaCAwFx0P
         ysbI3Wzq95agwQcIqYXGGyzs562APFt8849lnG+AAs3VcOd4V+3lcmdS5GEw1gtO73mz
         M1VtS4QJ5fuEQbG/NodYmjXuwVG1owZLzF2a7O7xNT4F/jGZ42c6e9Iom1uiWCxHW72Z
         VoTLo45yi2dNYDgZgtN2eyJFcEB28Mcc5e0rnibLKvY5ErX6nARXyeHDF380W1lyVIyR
         ctB38CNIHK0+fy3cMECMi5x2TGp78KcEzBNxeMMp8pFPDjuNR5HxMHA4rt7bRtKOLwnD
         g26Q==
X-Forwarded-Encrypted: i=1; AKwUvBzFuk/xar6+cKqAJ8XetgyfSrg/hMLzbKWUVv7DER1UtqulAQPvzAnZQYj1Yh5tQWy1PeYcPDWl@vger.kernel.org
X-Gm-Message-State: APuU4Z9MvqSJnOlwbjlLGJyxRgaYyobVAx57bQNhSV9dDtNgv83unmQB
	G5SbVIVe0sECwPjjQw78ZLxmxZd0hCslKJ1Azk51itd/oDatZ3TVAPBj
X-Gm-Gg: AYBFou0jnTvhksnMsFxbYejGIddSKh70GjDkIbAtDNkrksfneMD0jDJ4qWAxEtaTHDz
	ocYOhMULrHnIeRzuEfZWZtBlfB/uOZLK+2Ig0blYwnN3Gg5LQfBnrZwg6UCqdPD4iLX9Qadm5vR
	5uB64qK3xqDU3RWhM+buI4E2BVPgMU3h/czudE9twNFHzBlr+gWzq0WaNOdtCOJODQnQeY+GIur
	ntjohT6hyRsyJRR1Qr31VIoqJq9F+V2ezCsLDR1MyZRMlXMWdGDXmG1C5FSU0B9xKQvWvlLX/SS
	y7N7j+RTLIs/D2QciZ6yCVadO3w9+A2UmX70WbcoFaMpqvrRJqzqmEhBOvSJqeQycVZ9z2yPo9u
	jSUs2EyJ0zJz+kKnLL35EJ6JXle0pcz+T6kaia9yX3ifY+W5kSN2c4GPpzR8z3U9e+IEZqwRm5S
	3O+KJr7FYpv6zCX/OBprS9Mb8A2cHI+kyuibhhJ17nojeW4FC4CWRKtND2HTSZnI8j9f4rCourJ
	VHNq71hJcLueSpWLWvU09qz1t02GxPD/rnmATiVUNa/0hpNcPNV7LnZVV9sQXZpNKw84tsZkbJm
	J8Y3OP1xW+wPR4tErHtdExOvD6IR/ZZGNLq7HL9y6NqL/ir+oixyumLwgug=
X-Received: by 2002:a05:690e:1c1e:b0:67c:7f7:206e with SMTP id 956f58d0204a3-67c07f72658mr45393d50.77.1793835034093;
        Wed, 04 Nov 2026 15:30:34 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:b::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67bee2a03cfsm2382004d50.19.2026.11.04.15.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:30:33 -0800 (PST)
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
Subject: [PATCH v8 3/7] mm/page_counter: make page_counter_try_charge() stock-aware
Date: Wed,  4 Nov 2026 15:30:24 -0800
Message-ID: <20261104233029.3282438-4-joshua.hahnjy@gmail.com>
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
index 3fb41311e4c7d..bbc2dd3fa3c97 100644
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
index 66f38efb800ab..311bc2fa644a3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2812,13 +2812,14 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
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
@@ -6051,7 +6052,8 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
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
2.53.0-Meta

