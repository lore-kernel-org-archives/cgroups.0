Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.68
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793393679;
	b=4z3BZut7JRSN+Br8vV0cpDoB9m2iS2Lg96Ky1qxxmXRleYbf3MXXSG5TswMXBmuC1FoJ
	 7wL0ca0deQs2jZtCIO5FPgdrpRyq/sy8CXVqmOk1a33jqoHpm1qFcpL7ZbcarINO5Dcbn
	 TOaqi2DXDu4kagiXuKQKjcN72Er6XnZgEo6C+n/drznGjctjO5exnOfC9wxCXhhA9AEiY
	 0oUmd0X5lrSCKXXtDPbdlcbnaIuLEJUa+/qICWwK8/zPIzHwC/XT4PjWnttTWbBhuWo4l
	 TJnx05DdvHKek8JplIgnUj0qENIpeV728ib+ym47W6qcJB31cy2t+KnahLwR4WHDUsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793393679;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0hWhsFqL4o7a+PlWoQKkkYolvzPkWBNQ122cMEPY64o=;
	b=20xvauIYkwljRfYchcSvXWOlMPGBP6eELDnfWvek5E0yImtSKqHBN7lxVDu2UE6AxHPU
	 zxYZusUdkXrgKGv1wLnAAXVFDU/v6/CRjG2X+TNOnr+7HA/J0C+n3IBaz5w4Z83mQ0NkK
	 SihiAa9vgkyWpAnqmVL13yqEr5itaChQui1YuRKQv3bLRarLdqYgS6LV3mKyNNu4O/oKQ
	 brHyxlfn/kG/pDMGG8MBesj0uNiqpsk/zTQJG66mBIiqQVKlScCizgwfzahVIy4J23I2l
	 BOY/F5ZbB2HxXO4SsLL2ap7eqGvErKJM0SeZ7NlZBx78b5YgRT8QRdVluXfEFfUmcsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Q0vS3LDe;
	arc=none smtp.remote-ip=91.218.175.68
Received: from mta0.migadu.com (out-68.mta0.migadu.com [91.218.175.68])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7E6606A31F
	for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 20:54:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D7E6606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Q0vS3LDe
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JhFjjTfFHwS2ETw6CvldSvQqCSIDUPmk8rGckT9Z2J0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793393677; v=1; x=1793998477;
 b=Q0vS3LDemhwAC/nakTJrIhZPQlKSALkwEH+DUCftDKTKOX4nMPm89tRkynmybIJc/zTMWBho
 k489W2wRGzfPUSoYmUvYA1CVZYh6SZSEVQHPZmIPwICTzXDokWMtjJ6xsMmr9rdRj6yBjLR9J6M
 1sH+sn6ug7Lg+3ZbAOVKwGEo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id de517227bb2ad7eb;
	Fri, 30 Oct 2026 20:54:37 +0000
X-Mizu-Trace-ID: de517227bb2ad7eb
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v2 2/5] memcg: force charges from reclaim before trying the limits
Date: Fri, 30 Oct 2026 13:54:13 -0700
Message-ID: <20261030205418.341214-3-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261030205418.341214-1-shakeel.butt@linux.dev>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
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

Reclaim can charge memory, for example when zswap stores a page.
try_charge_memcg() forces these PF_MEMALLOC charges, but only after
they fail at a limit. A charge that fits still has memory.high
enforced. That can make a task in direct reclaim do more reclaim and
sleep longer later, and kswapd records overage that it never handles.

It is also a problem for the next patches, which make kernel threads
queue high_work. The worker charges memory from its own reclaim, so it
can queue itself again. With those patches but not this one, the worker
queued itself in 118 of 284 runs in a VM test with incompressible zswap
data.

Check PF_MEMALLOC before trying the limits. Reclaim charges then skip
memory.high, as they can already go over memory.max. Drop the
PF_MEMALLOC check in memcg_enforce_high(), which no longer sees them.

Other effects:
- As before, the check reads current, so it also catches interrupts on
  a PF_MEMALLOC task such as kswapd. Softirqs set PF_MEMALLOC
  themselves for swap over network, so the check can't be limited to
  task context.
- These charges no longer charge a batch or refill the per-cpu stock.
- MEMCG_MAX still goes to the first cgroup that the charge puts over
  its limit. On cgroup v1, memory.failcnt no longer counts them.
- high_work can still run again and again when there is nothing left
  to reclaim. This only stops reclaim from queuing more reclaim.

Suggested-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0e484f7f823a..af95a4574a0f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2762,7 +2762,6 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 	 * when it rechecks the overage and simply bail out.
 	 */
 	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
-	    !(current->flags & PF_MEMALLOC) &&
 	    gfpflags_allow_blocking(gfp_mask))
 		__mem_cgroup_handle_over_high(gfp_mask);
 }
@@ -2787,6 +2786,21 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (consume_stock(memcg, nr_pages))
 		return ret;
 
+	/*
+	 * Reclaim may need memory to free memory. Let it go over the
+	 * limits for a while rather than fail or OOM kill. Doing this
+	 * before trying the limits also skips memory.high, so the
+	 * high_work worker can't queue itself from its own reclaim.
+	 */
+	if (unlikely(current->flags & PF_MEMALLOC)) {
+		/* Find the cgroup this charge puts over its limit, if any. */
+		for (mem_over_limit = memcg; mem_over_limit;
+		     mem_over_limit = parent_mem_cgroup(mem_over_limit))
+			if (mem_cgroup_margin(mem_over_limit) < nr_pages)
+				break;
+		goto force;
+	}
+
 	if (!allow_spinning)
 		/* Avoid the refill and flush of the older stock */
 		batch = nr_pages;
@@ -2809,15 +2823,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto retry;
 	}
 
-	/*
-	 * Prevent unbounded recursion when reclaim operations need to
-	 * allocate memory. This might exceed the limits temporarily,
-	 * but we prefer facilitating memory reclaim and getting back
-	 * under the limit over triggering OOM kills in these cases.
-	 */
-	if (unlikely(current->flags & PF_MEMALLOC))
-		goto force;
-
 	if (unlikely(task_in_memcg_oom(current)))
 		goto nomem;
 
@@ -2913,9 +2918,9 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 out:
 	/*
 	 * Don't forget to raise a MEMCG_MAX event for forced or rejected
-	 * requests.
+	 * requests. mem_over_limit is NULL if a PF_MEMALLOC charge fits.
 	 */
-	if (!raised_max_event)
+	if (!raised_max_event && mem_over_limit)
 		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 
 	return ret;
-- 
2.53.0-Meta

