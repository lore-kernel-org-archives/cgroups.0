Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.224
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792535764;
	b=lpaWj9u6V/Zx7IomgwWvfBBgxjPqnwNl70BPkMii+dI9GubS4msTquw1R/ZZyJ0WBBUb
	 wn60n7dqUCVRxmX+CV+zbAJ5vyVgkNHYSWsi8r/BuPB49xmgrbak+j1/z8DI+JqVVlkxw
	 ZqhgZEIhLrsRL39h4mxRH0XSXxR4rEuqpP1kqsfyrpdBL2NfND9sNpVrJar2z0kDDXXyO
	 +bKdvoWpo36ecmaFXd/as3aQ3bvYI6uCCbF7NZUuZFovS2TrWlWfdeViX4nmoxMsUlXjf
	 RaWR2bvugavbyHCOjMOzFsxv4a8Nk+J4OqWW7O8dpl02ZkGz6yFEA5EwEoKIySxFwNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792535764;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=HodTXsgPBzIPYL+ZGw+MXUWqV6VcazjbsVd6O07Sa00=;
	b=oAa0IMGeiczshf3nQNGsVoXOFDbOXbuWedmBZU5vp0gx4lfhqR+MjEBTJvbm8NX3I8uA
	 0oBfbjmMBODNnOUauhhiBcjG5UKqSg559uUqn5P1ECpHJMpAQueic4vhDSI4ESp8rdrXC
	 BO7Tzdw+qm+xYdgm41Pg8tiXRR/epmJnx0iLV5aQMfPWQGX4wCwnMnzu/RQ5Ob70325Jz
	 uxGA3VzxRjRs/01EGg0LrR2qDBsfq/Qf5s0iUTgyK/Xjrd07yK8F0hmPQGvc0cIWYK+d9
	 XeuuGk1Gh5erP/3Uexadl4sQo9qOd1WaICetn2dWXX7gjogJ2gcXZdVnystF5rNm7yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="ZXPP/uAv";
	arc=none smtp.remote-ip=91.218.175.224
Received: from mta0.migadu.com (out-224.mta0.migadu.com [91.218.175.224])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB8E606A329
	for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 22:36:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BB8E606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZXPP/uAv
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=HbWlWrJdZDODn99IUscfxlxDII0g4fQaUHUOuuxABQs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792535761; v=1; x=1793140561;
 b=ZXPP/uAvbcjlW4KO8bLxZrWdSR6PcxsuOq5Fxj3xPF3hbnAsK2rr8MSqEAFdVSSJvHP9YCJG
 o/lMcs9KV389oOxWcBdRRCmkvOJnPvOBDZU4xfkOVbUhwkaR2/1WfjLr7IiAdgvFyalVTEdeTrX
 HaAeRfUewF3oi4IQTNpDFRdo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f1fdcb3e0d7c102c;
	Tue, 20 Oct 2026 22:36:00 +0000
X-Mizu-Trace-ID: f1fdcb3e0d7c102c
X-Migadu-Flow: FLOW_OUT
Date: Tue, 20 Oct 2026 15:35:59 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1] memcg: fix cacheline contention between lruvec stat
 updates and LRU lists
Message-ID: <atfrhsr6bft4t7SI@linux.dev>
References: <20261020200730.250189-1-joannelkoong@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020200730.250189-1-joannelkoong@gmail.com>

On Tue, Oct 20, 2026 at 01:07:30PM -0700, Joanne Koong wrote:
> Every memcg lruvec (per-node) stat update reads the memcg and
> lruvec_stats_percpu pointers in the first 64 bytes of struct
> mem_cgroup_per_node, and the ones that go through mod_lruvec_state()
> (such as lruvec_stat_mod_folio()) also read lruvec->pgdat. These updates
> are extremely frequent (eg these updates happen several times for every
> page that's faulted in, freed, dirtied, or written back).
> 
> The memcg_pn_read_mostly cacheline group keeps those read-mostly fields
> on a different cacheline from the lruvec, but on CPUs that do spatial
> prefetching [1] (which is most Intel CPUs / modern CPUs), cachelines are
> fetched in 128-byte aligned pairs. Depending on where struct
> mem_cgroup_per_node lands in its slab, that cacheline can be paired with
> the cacheline holding the LRU list heads, and the lruvec->pgdat
> cacheline with the one holding lru_lock.
> 
> When this happens, every stat update also pulls in a copy of the LRU
> list heads and lru_lock cachelines, which are written to constantly by
> other CPUs under the lru_lock. The stat update has to fetch them from
> another CPU, which is unnecessary overhead since the stat update doesn't
> use the LRU list heads or lru_lock at all. But even worse, the lru_lock
> holder then has to invalidate those copies and wait for the
> acknowledgements to come back before it can do its next write, which
> makes the lru_lock critical section longer for everyone waiting on the
> lock.

Can you please reproduce on a non-intel machine?

Second, can you try the following patch instead of your on the intel
machine?

From a747ceeb4e3f10fb0c3e7daf5660076a49b77126 Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeel.butt@linux.dev>
Date: Tue, 20 Oct 2026 15:33:26 -0700
Subject: [PATCH] memcg: rearrage mem_cgroup_per_node

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 74110a324f9e..0e73f5c96e15 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -95,6 +95,17 @@ struct mem_cgroup_per_node {
 
 	__cacheline_group_end_aligned(memcg_pn_read_mostly);
 
+	/* Touched only when the memcg is reparented or freed. */
+	__cacheline_group_begin_aligned(memcg_pn_cold);
+	/*
+	 * orig_objcg preserves a pointer (and a reference) to the original
+	 * objcg until the end of life of memcg.
+	 */
+	struct obj_cgroup	*orig_objcg;
+	/* list of inherited objcgs, protected by objcg_lock */
+	struct list_head objcg_list;
+	__cacheline_group_end_aligned(memcg_pn_cold);
+
 	/*
 	 * Keep lruvec on its own lines. Sharing them with lru_zone_size[]
 	 * regressed, see commit f59adcf59332 ("mm: memcg: add cacheline
@@ -114,17 +125,6 @@ struct mem_cgroup_per_node {
 	atomic_t		slab_unreclaimable;
 #endif
 	__cacheline_group_end_aligned(memcg_pn_write_hot);
-
-	/* Touched only when the memcg is reparented or freed. */
-	__cacheline_group_begin_aligned(memcg_pn_cold);
-	/*
-	 * orig_objcg preserves a pointer (and a reference) to the original
-	 * objcg until the end of life of memcg.
-	 */
-	struct obj_cgroup	*orig_objcg;
-	/* list of inherited objcgs, protected by objcg_lock */
-	struct list_head objcg_list;
-	__cacheline_group_end_aligned(memcg_pn_cold);
 };
 
 struct mem_cgroup_threshold {
-- 
2.53.0-Meta

