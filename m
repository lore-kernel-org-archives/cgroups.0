Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792785290;
	b=tr2QOxCd4+nwcekuZGA5FUbZHpzvmdIAkrPTymOrCDHjbJV9mgY8dF9aZNreoJwhzXub
	 bZmR0+nNNp9tYCifySESW6PcWHAEZfhILdURAKw7o3/jykl+qStw4yMJiZA2ja/9XBIjv
	 XW00Vmhvc7bx9lsyDyHfTxFdapMb+fHWHBLHqSqn0N7KP7BkJ7/pG5p0vsP82AF7BLy1Q
	 qYRfJsCNfYviFiRRYlE4+AdcPdYjDYbDGJ+//0Mnbb/fJRECQE7ZNPSQdEqRLNJTQ+bRh
	 SWQ72Arpw6mXoFRydKfAAdF0Vctkru12y01fSmdqTpL2VI/6pGGoID4cyxnuSkyUIpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792785290;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oyKibSqm1+8ho4Nz7jrRZ3yeDtEDcgPdxxTeTW5ThPU=;
	b=eQ8Bar54fvitgn8K/HJlDyt1y6UUFaP39zsAvz00uY6qxI1pBQe6Z57FZM3p4/myWDLH
	 Cc/H2GZq9MMQ/KvCpHyQSSCmApJONWmdTromvGj3RBnrCt48qqZOXBVafBzPJW7MJwDW4
	 hSiQVX7GGpJsaiEtvweeEVTxUCDthsMClZvKzXM7WOPdppCeeWS/xSnxf/KRUlsPyRNI1
	 q3/jWvCYtl91BoBfU4W1E/Bd1EVubQbDacujYHY0dBHPNy4Oyxy0/Ux/No7F9F0EsGyQm
	 MUT9xmRRIhLh46GkNiQ9H8YiqJNMOVDoI81XhvI3+8TtamYgtedrytcRnxclOmc3KXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sKxY+7Dc;
	arc=none smtp.remote-ip=74.125.224.48
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C0D606A31F
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 19:54:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09C0D606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sKxY+7Dc
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-679334baa1fso1391178d50.2
        for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 12:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792785289; x=1793390089; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oyKibSqm1+8ho4Nz7jrRZ3yeDtEDcgPdxxTeTW5ThPU=;
        b=sKxY+7DcMlu1xTJC/+vsbscMWzsbxuDs+PmNbQFvee6m7TAp1qB91gu05whtrVsWnp
         FLeK+HJT192r9+fhHOaywZiYCRzetSyK9/lQuYwQ4BqfAowrxmr96Xc3Ga25yINOiiB+
         Kl8V7f1pom0vml6AVrxPXVU+O3rlavz4/MTbCTy8KyLmUmDVWD60cSI081/gSoVByhOy
         Q9aKPFa2kmszfJw0exJqDH9+v6fd3nUAWxriJ0iDYpno5/PBt9TBjatxJNuD5tmjqchI
         BwuBVr31SepH5HJyS6mlDTgN+I+jAu/YtoDShDnHtj//yVZCTpt0I7D6gXLS2P8mSMNc
         fU0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792785289; x=1793390089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oyKibSqm1+8ho4Nz7jrRZ3yeDtEDcgPdxxTeTW5ThPU=;
        b=gDYSMXbxcaVgswAYTZiHwuNutRNhqpaips2PObdv0N/g7BLWft6ZRtVIWk0pLEafqK
         atxGoAZK1smx9OF2Md8Wv3CpU1YZ7P1QHwbDTIYpbQEuThKHF95c7B6KVTUDA+WqEqbn
         i38X5PzYKgNyFapts+sGTxbUagVbBrLih/aOaP/Hd1+SQmrPJzReLYex3s+6vCyNRuus
         dfEfZ6J4PxbZzjekyOQIq6NvWBnMum/Nm1VEcJj6eSThf9LaneJtLiCildvN0NmqnR0o
         z384vdywDdtG3wQ+ekjIxbaVdjETVsQIrWCAm1NkHeI6JGSmelPvZnfXVglCaAYrHXII
         DVkg==
X-Forwarded-Encrypted: i=1; AKwUvBxZwpjYqHxgyy0WhV0O6V0sLrUtDTErAuTAFW/Ma5rlFlguWuI/UfUhEY0UF8vVQWH6IeX3v/8Q@vger.kernel.org
X-Gm-Message-State: AFq9FYLo1rSbI/0og+B/TJ4ukZ2gwJX2vmA/TAWmI20e2kpz0Psr8IzC
	+cCuD+HzUvW9pRlKl+rc4U6+nvNi8m4klZsy2EdvM+10UxfVRjKfJ9fD
X-Gm-Gg: AYBFou0HLCoSXCq0g8qhMXTT6BxyMw1xnQxSFjYvlI2PWlcRd2HFawK1zAvz7VmXU6q
	0F954PJj4PlfdJXhKWAft69komOf92BWV5eQj9yg8Kq3LUWgbrMy3+uWXfKmUMM6ty8gatfq6lS
	9yyz/I8nhkP4eIsIaNHmzFSD6OdBOMUkgSm+Z4+Od4siB5o8tX7v2CHkDygSW7HcYXCihU4LAQn
	JHFBLwhq77B11WgbvAmsWh8zlXORCWmE7dtyk8Qj1dJ+BdDKMCDWWRXk/RCOP/yIEw6BmbtiGYR
	TQbxMq4ju4peHYNFPYYVeydfpKSHTRKodaHiCaXnTC4zKO/32xSQ4d1lWKFA4R0mRY41gBahr1L
	2aRBCxrXpQz3zifFhHcPdVx5CViOadFIcOEyCQrn+7x7h26rZro2Q8J8AI+6BlsYE2yzYeLa3wh
	A0FVaChX+axYxgGzjzSvvQT4mtqxyf0elkQbP2aA6YXXy3m89eW/+MmkFsIJIyHSMCBT8HcfNnd
	qQQRjlMJ/HvYb+58qFavGGGQ+wHG7u89D3zP6SquL03kpcfGf2+A5Ikgemrb/eMSloY/d3U8Ww7
	aaUhYV7OzHd1CQbEsqrO2r+Ons5tDUL4
X-Received: by 2002:a05:690e:4553:20b0:677:a7ac:5624 with SMTP id 956f58d0204a3-67a45493fecmr69048d50.44.1792785288872;
        Fri, 23 Oct 2026 12:54:48 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:47::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a4626fb03sm9649d50.17.2026.10.23.12.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 12:54:48 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 2/2] memcg: don't go through the lruvec for folio and kmem lruvec stat updates
Date: Fri, 23 Oct 2026 12:54:17 -0700
Message-ID: <20261023195417.1391216-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261023195417.1391216-1-joannelkoong@gmail.com>
References: <20261023195417.1391216-1-joannelkoong@gmail.com>
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

lruvec_stat_mod_folio() and mod_lruvec_kmem_state() already know the memcg
and the node, but look up the lruvec with mem_cgroup_lruvec() and update
the stats through mod_lruvec_state(), which reads lruvec->pgdat and
mem_cgroup_per_node->memcg to get them back. lruvec->pgdat shares a
128-byte cacheline pair with lines that the lru_lock holder writes
constantly (lru_lock or lru_zone_size[], depending on the alignment of
struct mem_cgroup_per_node), so on CPUs that do spatial prefetching
these per-folio stat updates contend with the lru_lock holder.

Pass the memcg and node they already know to mod_memcg_node_state()
instead.

On top of the mem_cgroup_per_node rearrangement, on a 2-socket Skylake
(80 CPUs) with threads faulting in and freeing shmem in a single memcg,
this improves throughput by about 3% at 20 threads (5.59M -> 5.77M
pages/sec) and 2% at 80 threads (8.66M -> 8.82M).

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/memcontrol.c | 71 ++++++++++++++++++++-----------------------------
 1 file changed, 29 insertions(+), 42 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a05d9a8baa1b..9f33cc5c8293 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -587,7 +587,7 @@ unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 	return x;
 }
 
-static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
+static void __mod_memcg_lruvec_state(struct mem_cgroup *memcg, int nid,
 				     enum node_stat_item idx, long val);
 
 void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
@@ -596,16 +596,11 @@ void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 	int nid;
 
 	for_each_node(nid) {
-		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
-		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
-		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
-		struct mem_cgroup_per_node *child_pn, *parent_pn;
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+		unsigned long value = lruvec_page_state_local(lruvec, idx);
 
-		child_pn = container_of(child_lruvec, struct mem_cgroup_per_node, lruvec);
-		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
-
-		__mod_memcg_lruvec_state(child_pn, idx, -value);
-		__mod_memcg_lruvec_state(parent_pn, idx, value);
+		__mod_memcg_lruvec_state(memcg, nid, idx, -value);
+		__mod_memcg_lruvec_state(parent, nid, idx, value);
 	}
 }
 
@@ -990,10 +985,10 @@ void reparent_memcg_state_local(struct mem_cgroup *memcg,
 }
 #endif
 
-static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
+static void __mod_memcg_lruvec_state(struct mem_cgroup *memcg, int nid,
 				     enum node_stat_item idx, long val)
 {
-	struct mem_cgroup *memcg = pn->memcg;
+	struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
 	int i = memcg_stats_index(idx);
 	int cpu;
 
@@ -1015,21 +1010,23 @@ static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
 	put_cpu();
 }
 
+static void mod_memcg_node_state(struct mem_cgroup *memcg, int nid,
+				 enum node_stat_item idx, int val)
+{
+	bool rcu_locked = false;
+
+	memcg = get_non_dying_memcg_start(memcg, &rcu_locked);
+	__mod_memcg_lruvec_state(memcg, nid, idx, val);
+	get_non_dying_memcg_end(rcu_locked);
+}
+
 void mod_memcg_lruvec_state(struct lruvec *lruvec,
 			    enum node_stat_item idx, int val)
 {
-	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup_per_node *pn;
-	struct mem_cgroup *memcg;
-	bool rcu_locked = false;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	memcg = get_non_dying_memcg_start(pn->memcg, &rcu_locked);
-	pn = memcg->nodeinfo[pgdat->node_id];
-
-	__mod_memcg_lruvec_state(pn, idx, val);
-
-	get_non_dying_memcg_end(rcu_locked);
+	mod_memcg_node_state(pn->memcg, lruvec_pgdat(lruvec)->node_id, idx, val);
 }
 
 /**
@@ -1058,19 +1055,13 @@ void lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
 {
 	struct mem_cgroup *memcg;
 	pg_data_t *pgdat = folio_pgdat(folio);
-	struct lruvec *lruvec;
+
+	mod_node_page_state(pgdat, idx, val);
 
 	rcu_read_lock();
 	memcg = folio_memcg(folio);
-	/* Untracked pages have no memcg, no lruvec. Update only the node */
-	if (!memcg) {
-		rcu_read_unlock();
-		mod_node_page_state(pgdat, idx, val);
-		return;
-	}
-
-	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	mod_lruvec_state(lruvec, idx, val);
+	if (memcg)
+		mod_memcg_node_state(memcg, pgdat->node_id, idx, val);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(lruvec_stat_mod_folio);
@@ -1079,23 +1070,19 @@ void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 {
 	pg_data_t *pgdat = page_pgdat(virt_to_page(p));
 	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
+
+	mod_node_page_state(pgdat, idx, val);
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_virt(p);
 
 	/*
-	 * Untracked pages have no memcg, no lruvec. Update only the
-	 * node. If we reparent the slab objects to the root memcg,
-	 * when we free the slab object, we need to update the per-memcg
-	 * vmstats to keep it correct for the root memcg.
+	 * If we reparent the slab objects to the root memcg, when we free the
+	 * slab object, we need to update the per-memcg vmstats to keep it
+	 * correct for the root memcg.
 	 */
-	if (!memcg) {
-		mod_node_page_state(pgdat, idx, val);
-	} else {
-		lruvec = mem_cgroup_lruvec(memcg, pgdat);
-		mod_lruvec_state(lruvec, idx, val);
-	}
+	if (memcg)
+		mod_memcg_node_state(memcg, pgdat->node_id, idx, val);
 	rcu_read_unlock();
 }
 
-- 
2.52.0

