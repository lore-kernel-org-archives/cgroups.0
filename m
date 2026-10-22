Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792708799;
	b=syByZDr4Z/7lphzelKSPQbhxVPv9hYNsilsHyUPk+QQSrRVGVV1YQD/1g3mBN82gpAoJ
	 EOc75hHJcnz3eZOKPV3b6v1wkxumYmosP6ybzQw1ci0O2ShvpMUo/Tn/KImrMR/amI+Kt
	 REd2QvXe88rG/Pkdd7rPEuDJLvr3gvWgXpEZ1Ka8V2x8H5kj6A61PKi1l9nO3e9ngvcxW
	 7z3MHHbQDr+5SUWdWTyEoXjvs7597HpaI/A5gw69NUxF/0ig8s/F5i+SpPtd/y2oji7xq
	 7NESlhmJM4Xv0GitO42Zt7iSP3NsM6KuJq+ndrTKHSUPi4n1HRjdLVsvAgnCnOQ35Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792708799;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rv4DFzQPHD9Cms8Ln5ojDdkO6t1/sYTvfN0XHmaC5ec=;
	b=q2oewdrQjOKHXKe+7BAp9SFgrgVKE0wdTAtIGQb41bJmkb7n6eZ+sMP2cWhinM6blkR3
	 9rqb5OiJY3mGTSB/U8Kj1blF5+rsP8WW6iGKxXXVVw1F6BrJos06SL6h1EJGSgYHl/Nkp
	 LlNWqJeZ9mLqV1wTEFvf8hL+391UnYj1TPz4Ex/SreD8tc2dhCinASTw/1ToUgW6vRKW4
	 Z52WCrEYuGC6+MgCgaBuU4RsLbj8rEUCzkSR/kytJTZSpKdpKSU231cD54ZFRp4IKlLSr
	 YMDRolexZBL6dVeXpjN9avimUAeT2i3WYDgFlGmzmZ4VnitNR/l9nEI5G+pxqOLvE7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jyjfBIPO;
	arc=none smtp.remote-ip=74.125.224.52
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FE2606A319
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 22:39:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4FE2606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jyjfBIPO
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-66fca0709caso334119d50.1
        for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 15:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792708798; x=1793313598; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rv4DFzQPHD9Cms8Ln5ojDdkO6t1/sYTvfN0XHmaC5ec=;
        b=jyjfBIPO0iYh8e2Dj3tXE6WNb6X+6Ja4Ull89Y0om/GHDbRzDEkI8qltB855Yuve9e
         MEF213zZlrolhQOv1y782FAua1CcNiU5UhtzPMDWEjt6M5T4JRdEPaVFl/r7Jf2V3GW8
         3kuWzZABRCQOA5S3BUyqvAoej38dsVi2bux3FO05nsQkjBUQPMkNZzSDCsihxQqn/3lv
         2gH88Yb4OYJbxj9tDjN4JzWDO8GvLCaZRA8bvX7uI/tgF4nj8pbRl6j7lVJDfmT5w3C5
         7Le7AzIzrPd+0BurS68KqtB37gOy3J0A3rA84YL9nHLPXc/gB6bXAcp3f7UxYImRPtDM
         0u8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792708798; x=1793313598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rv4DFzQPHD9Cms8Ln5ojDdkO6t1/sYTvfN0XHmaC5ec=;
        b=dzBORAr6f5qmwZa5mHDbv2xDMXFzfNbQ0H1lYj1vgtE5QF38x4rB44vEcS7I8WXb6P
         xFYMvg0n3otP/1j7b/rgyhMJVxAPRpvWQzu7S/umiA+wLK6+1KrHZyUEAEcJPM1dBZO6
         h5tyGjazkESWY1l69lHC4uUGHgVvQdj4kydmIT+36HUZuDsSsCXCgTKKGMLBbsyUncBk
         P7wgPP6jrydOjLLzu36QK5/pxocR6ACI+ALOTPnf4bvGNfPNLhWtS4SLjf3Hc//2iA2x
         U0deVeR6gkTrUhZ09ybSuOvliVcVCfEAd/oKThCm/vyZ5TD5kzkfFWNOJPiAKIX+v6L0
         AFjg==
X-Forwarded-Encrypted: i=1; AKwUvBzuqO0lpiN/zGAY/vQBoawS7U/1ExZnyuko8WfRjCBu6LPl2cQXXZKMWNRBQNjzstJ9igV3G4hk@vger.kernel.org
X-Gm-Message-State: AFq9FYLmsjTTn6PP7Vuz2z5iDLas2OhUaEjBV0SxJBBMdZTKyQIMoCBt
	s8HPK3HPoKZ34WTcoBgarzFj085DN02Ihb5gAlBcxGCuJ6yrt3S8nGtnhHknVw==
X-Gm-Gg: AYBFou2Lug0FtJsP0yyyPXFQGmKGQc81OCjeaxAdYJpnY0gSJmN5+VCOCRK7KF0hDw8
	EKLTa+SLjLoMIzWqS71bK9DolsUyTMOeUEkorW5q1zW9+dPqeLrpVL3M4CvaljB8uLiBN3BzD8X
	KLjMW1rsmyzA/YiTCujrmWAi/m23Fw+6ZXLjf+Am4N6jr80EtYF4QeVfOPCwpKyXBD/ELPFUbur
	6YVvGkh8gJJOyvqw95gMfLC5NHm7tm9XVxLO7I8mP0P8wLJ4WgNAYlKPLS56ByTRyhbb8tYTr4Q
	HzmvnxHXiVqtCGrq8VOiUhtuhMTv4FIslJEsNiqskzuf+pXqIWVp43ABQ53htf6yFumDT1vH2+Y
	XlQrxzjSmHhO9tQNYp5OX3BhBSGJXpwP00DtIApRPkpDSFqsUwSuGJ6+cvZiI7zN+Im24t92a9n
	cbkmP+vtSKIDEs+0pHvppW8hpiLKjkMYYH4sOg1W6bkzFXhh6iZs4n/J0Foodfa8wG4fRY80EFd
	LTG3XwSTWtut3YnlsvT8jryIlJJ/+vP8mn1Oq8acTlclTZ4Lzw4rI23E6+ICE6FK5AQuWWZvBwj
	393nzSnzfT+sAHSptAn2WXuzDtGc2ufe
X-Received: by 2002:a05:690e:138c:b0:679:2ca6:e702 with SMTP id 956f58d0204a3-67a35c0d86emr297112d50.89.1792708797649;
        Thu, 22 Oct 2026 15:39:57 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:58::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a340745cdsm419859d50.23.2026.10.22.15.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 15:39:57 -0700 (PDT)
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
Subject: [PATCH v2 2/2] memcg: don't go through the lruvec for folio and kmem lruvec stat updates
Date: Thu, 22 Oct 2026 15:39:30 -0700
Message-ID: <20261022223930.138779-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261022223930.138779-1-joannelkoong@gmail.com>
References: <20261022223930.138779-1-joannelkoong@gmail.com>
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

