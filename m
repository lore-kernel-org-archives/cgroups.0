Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236A5221F39
	for <cgroups@vger.kernel.org>; Sat,  3 Oct 2026 00:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790986747; cv=none; b=p5GDEVNMgVaGViKbZkawMWjjGaV7p/VrTdvfPSR4ugi7QhBcU28hijZWqAfnBTzG8BtU3q1++tCIHCsbfJXkIdb/OJ7/3fpANNpzhJ+EMRCfMw7WKHeXgLEFXXoXlRNRi4zgUZnSCl7JyRUB4swamy5Y0F7Em8OF7erq6zwAfsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790986747; c=relaxed/simple;
	bh=LejAv59+w0LmBOfRWjgurmuY2Ss610ibefUPVKzMFLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MF3bwjRSoC8XMX6gf268kuDp/XvVHVax+Vnw+hJW+3enePQlYSZztBkuD1husNhlnVZNUg5X9dNe1VVrZLKnrH3b7hkZMoqduc118zW243UXcWLOMPtLaFjy7gvQx0VGb6zBZgUXMqjuFSUfqztRXRiD+wGp4/QdIUOZ4sXpXS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hm+wafZb; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hm+wafZb"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-82374c2d7aeso297184a34.1
        for <cgroups@vger.kernel.org>; Fri, 02 Oct 2026 17:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790986745; x=1791591545; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FS9XCl9z0DTVjd2kXBwt268wO43LTyKRy6tPTS178aI=;
        b=hm+wafZb4woFkyxDXGw1LEG6Z32OyZp1GbpdeNOCqxpSgV2y/VwdUmy0eUjnjJCIsV
         f8MerwlBI6z6j6xzkYGLsR4f67IN39HORwPm99nSCabAgNyZJBLBKCb7uza9+07jqBs9
         Tuw0g/8K3DNqILRQJ2MHe7Pn9aJLzkQ4yCeOPNn1gT25rZUsD85TNogOnPO0rgsIx9wk
         G3RDVnmvIlOxAf5FQjo4eI/Ic/3lQsKHr3NudRT86QvEAX9vNFZ3LY9HGLiSA+g+X3RY
         oFvDJdIeNoJq+uu/RALl68oQQLqvAx+vmE6w1bcasD6CBsymfmaaVqWe7OaUTqOTptuO
         ESyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986745; x=1791591545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FS9XCl9z0DTVjd2kXBwt268wO43LTyKRy6tPTS178aI=;
        b=IvQg7Ehy0ohvlfkI/tkZHnpXFKkOGH3LcCWqadk/gyAhiwYPgSeWSJKGx7UForBXzN
         vTzatr4jjiX+DO/7SVQaRe45hAbG2TCLxrwCIpbcMV4sYuXyTTuixHc7OilujHCayP/s
         9JVpOKQZzRpa7CPgOYXG3r13xZ/gvXjFLg2ecqEOvJn6A4pI2z6YIRalxicqWps37cDh
         aIpcMXyxJdFg5WfYktjDwYC3QoKXvUASPbblOxmQk5ug1XrxtXPkJI/9KXZHfvqGCL18
         Oct2grCgv+JrdL34TxJKxyQB0Xk5gWuTEdvcnJv3CN8CqTo7afKRNTy6WZmOfZOrsRlO
         rM9Q==
X-Forwarded-Encrypted: i=1; AKwUvByw9yQJ/I8o6748WqSCLOgzTWw+/5nQ0kMOvCz3q38HGjFH8lpttH1psOWM8OfOW0iI2JrGYYem@vger.kernel.org
X-Gm-Message-State: AFuF++nsQnm9BHrHaEoFGUmxR2+DHDVegzH1+mKFoSb2y8mparjnp/Ui
	2ccl248VREo1qgwvY4Gu89IDLqbeFW8ynpMY/5Ku0OekLCUDw9dqBfWB4YX4QRoc
X-Gm-Gg: AYBFou1qjwLqJdKRxZl/MWgAf97k+MZlpXUM+XRVJKxTpsB/nRmZR5eDdhfs7FC5dMq
	iFSA5hl4PSoeWpUqMrug5TbexdBkXtOICHzKgI8R9XzlVmTqHQziHnQp3jKpUce0C9CeAkIXVZM
	UaGnGOCcqXWILnWWbZsuxVgAypS5JrF1jLw4wHzxh7oaK+DO/jn6OgPTXj2cLo4/wZhqNuUOjya
	vbRHPL8QB8pI2685g3xcyCUGcDt9qOgWC2nhW5kk5uiOau+7niDKmxeb8SrS+WuGee0AYVm2hLC
	as4ib4bu5ShVlwERz+ewRqnNEzqvHeTsq2ObvU45e056LMFgkPnEFackxNplkEVWvB+Ht1NS2He
	qQZPGDaZIW4a51BtyCZIMmULnHCDwWqIQbt5Sfx7F2xgvRufNCgt5BFfewirr8YGWTTjNvNrZ8S
	27+EApBNaMXDiknvhh2lxAvRyLOA208bn6lnK4ms6U8TMXxdcbABIWAYXf5QJBP7gnntTAFrtMQ
	GEitOBZOy0ErNuQ40Ue/BSOFctWQdw8W/5Un6gVqpdhE/QaCQ==
X-Received: by 2002:a05:6830:7285:10b0:823:89b7:a57e with SMTP id 46e09a7af769-82389b7a603mr1114212a34.33.1790986745097;
        Fri, 02 Oct 2026 17:19:05 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:9::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-8227a66c6dfsm4498434a34.23.2026.10.02.17.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 17:19:03 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	willy@infradead.org,
	jack@suse.cz
Cc: mhocko@suse.com,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	surenb@google.com,
	riel@surriel.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 2/3] mm: memcontrol: add mem_cgroup_reclaim_for_batch()
Date: Fri,  2 Oct 2026 17:15:54 -0700
Message-ID: <20261003001555.3498357-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261003001555.3498357-1-joannelkoong@gmail.com>
References: <20261003001555.3498357-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some callers charge a batch of folios one at a time, where each charge
may reclaim. At the memcg limit, each one of those charges then enters
reclaim separately. Readahead is the main example. This was observed on
Meta's fleet, where a single fault's readahead window can trigger more
than a dozen reclaim passes.

Add mem_cgroup_reclaim_for_batch() so that such callers can reclaim for
a whole batch at once instead of once per folio. Callers can then charge
without reclaim and if a charge fails, call
mem_cgroup_reclaim_for_batch() to make room for the rest of the batch.
Unlike try_charge_memcg(), it retries reclaim only once rather than up
to MAX_RECLAIM_RETRIES since failing is acceptable for the callers'
charges.

The next patch uses it for readahead.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/internal.h   | 10 ++++++++
 mm/memcontrol.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index ff28b940e0cd..6d914f6a6138 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1652,4 +1652,14 @@ static inline bool can_spin_trylock(void)
 /* char-mem.c */
 bool file_is_dev_zero(const struct file *file);
 
+#ifdef CONFIG_MEMCG
+bool mem_cgroup_reclaim_for_batch(unsigned long nr_pages, gfp_t gfp);
+#else
+static inline bool mem_cgroup_reclaim_for_batch(unsigned long nr_pages,
+						gfp_t gfp)
+{
+	return false;
+}
+#endif
+
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1d4b603085a5..9aea684ea755 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2736,6 +2736,70 @@ static unsigned long memcg_charge_reclaim(struct mem_cgroup *memcg,
 	return nr_reclaimed;
 }
 
+/**
+ * mem_cgroup_reclaim_for_batch - make room for a batch of upcoming charges
+ * @nr_pages: number of pages about to be charged
+ * @gfp: reclaim context
+ *
+ * Reclaim is needed when a memcg's margin (limit minus usage) is less than
+ * @nr_pages. Starting from the memcg that the current task's charges go to,
+ * reclaim @nr_pages from the closest ancestor whose margin is too small, with
+ * at most one retry. This lets callers that charge a batch of folios one at a
+ * time (like readahead) reclaim @nr_pages at once instead of once per folio.
+ * Callers must be ok with the charges failing.
+ *
+ * Returns true if reclaim was needed and done or false if no reclaim was
+ * needed or if the current task may not reclaim.
+ */
+bool mem_cgroup_reclaim_for_batch(unsigned long nr_pages, gfp_t gfp)
+{
+	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
+	struct mem_cgroup *orig, *memcg;
+
+	if (mem_cgroup_disabled() || !memcg_charge_may_reclaim(gfp))
+		return false;
+
+	orig = get_mem_cgroup_from_mm(NULL);
+	for (memcg = orig; !mem_cgroup_is_root(memcg);
+	     memcg = parent_mem_cgroup(memcg))
+		if (mem_cgroup_margin(memcg) < nr_pages)
+			break;
+
+	/* No reclaim needed. No memcg up to the root lacks the margin */
+	if (mem_cgroup_is_root(memcg)) {
+		css_put(&orig->css);
+		return false;
+	}
+
+	/*
+	 * cgroup v1 can limit memory+swap together (memsw). If memsw is the
+	 * limit being hit, swapping a page out doesn't help, so reclaim without
+	 * swapping.
+	 */
+	if (do_memsw_account() &&
+	    page_counter_read(&memcg->memsw) + nr_pages >
+	    READ_ONCE(memcg->memsw.max))
+		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
+
+	memcg_charge_reclaim(memcg, nr_pages, gfp, reclaim_options);
+	/*
+	 * Like try_charge_memcg(), if reclaiming didn't make enough room, drain
+	 * the per-cpu stocks and if that doesn't help enough either, try
+	 * reclaiming again. Other tasks charging the same memcg may have used
+	 * up what was just reclaimed. Unlike try_charge_memcg(), only retry
+	 * once rather than up to MAX_RECLAIM_RETRIES times, since failing is
+	 * acceptable for the caller's charges.
+	 */
+	if (mem_cgroup_margin(memcg) < nr_pages) {
+		drain_all_stock(memcg);
+		if (mem_cgroup_margin(memcg) < nr_pages)
+			memcg_charge_reclaim(memcg, nr_pages, gfp,
+					     reclaim_options);
+	}
+	css_put(&orig->css);
+	return true;
+}
+
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			    unsigned int nr_pages)
 {
-- 
2.52.0

