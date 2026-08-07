Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4EB44D01D
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 20:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786134080; cv=none; b=p+i5auL00bcXACQc7k1DJo5RTW+ejxWPnO60XNDDn82q+XvHVqp5b1tMjK2sdXPIJgwdjHKy1MDy/6XnXhEMuZFOUEbgvB8yHsU/9ECSe5ea9CYksc6r3/AhsgFly1/wHneL1oNw3FsncudWkWE/raKpzaQpNqNh8bzTSUi7Li0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786134080; c=relaxed/simple;
	bh=GZJxuSitrZmCJ6vWZysBfmLLWrvpgKrXs+OpthlLIUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AaUZxhJMEnZtILCsGi1Zb3VM1RrymnuTe/riJKIu5UYDMjsoqDhG0hvh67xS9LETudr/4WHz0nja60vs0iXa9UJeTnhXq2cF44NJBCi11JYZIgM8E7hl9vzCe2Dmi33isMVCfIiUK36AQkN966SYf0ITC2U3Usb34+g740b8dVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Grn9cZH1; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Grn9cZH1"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-448b0ff4a57so2892019fac.2
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 13:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134077; x=1786738877; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wktIFByfmvNWwU5aKwDRUJNG+vu9pXnbr6sGB9f+FbU=;
        b=Grn9cZH1nmBb7d8y0HdAuqVm+AehKqoQAHhCe482dRInzIloDi+T+PRn4de+RWo88K
         Evlv+u3oLZjpNRknXnIYhFdexyNPAmcgQAkDEiBgfLHSYBf7wuCiqQH/CFqOYKieb91C
         SuiGF8sTtRoS3v4VImaGezQMpRbFaAwhpkuLOli2kA+IfovGmZ8D5sJpGXuzjNsab1Go
         3GT+6/VULX8P0GIlXpbSnNR5EbAKlLWFT+QcoFekRcl/MA1XyU468SBa9+KSxDqVTig1
         KYggbGsu33JXsLhBXTjW40oLGG5RrVt5zAoSmQjESPMpDfICFEXb2apPnjm9yzEz6NwP
         MB2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134077; x=1786738877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wktIFByfmvNWwU5aKwDRUJNG+vu9pXnbr6sGB9f+FbU=;
        b=KPo704DUvjA++yctNfY5xqQJAKz5r9CtAKthWYF9n+9bGerwJngCY49jDFv1vCH0LM
         cOixa30Gny5tMhAs7fQL62V9Pxaj3L/i6vvBY2IowwTYZ7qud92Im0d/7UL0ohvrf0I6
         TRUrreUfRQE5WFvlApJrOnqIZ2LcSZ0/DRW176f3h0eIZVC7wkhuhn7AhGlIzq6AenoA
         nOZ9WzdAcuosC3CX1cPX/HLDPnEqmRgk43uc20d5TYTe/lmSAK3OZiCUygoDgEOYExSn
         P0ZLKOVloM9E/nZgO8/sKjxUVRytxMa9IZD/j0lZDLuha0O+WkvZAK5VGstlLDJmsT7n
         +1gQ==
X-Forwarded-Encrypted: i=1; AHgh+RohTtcZb1I5A9EkT2nLagG+2/dyYWTTzyZWOz+Qo+txZthiSE2jmQgiNSPkYI8+yfDPEcI6K6BB@vger.kernel.org
X-Gm-Message-State: AOJu0YzuZ5TL3vQPasx+VCBMW04feacOoTzt2F0Y2nkHrubu1IahKIR2
	UEAx/tmOsV6QQ8mNcYJ6lRTDUjglxjXesqiESgliKJ7Hn68H2Akrtmuk
X-Gm-Gg: AR+sD10nNzS4mXwsj/ZMn+d62naAHyOI70rf4vgVY1TNDSdi3TXeQMVGgWoOZL/hvue
	hI5NP1mUEAjHb8GJKAx7f86WnHu4MQ0W11x9pD44nKmY/d4KY9nuMyoJ5s8aVTm2lsqkcjeqrWH
	orr6JZf72ixavueaHGfzt3HqQu3fqumPu5Vuxu6VEpjpAXEbohFXSk0kCfBHu9THu13+xnsbZ+f
	JeKWawd+1L9h2DZVIReMvW4quJOpCQ5dikRgo11I6t5UcQ29UZfi3SoiCBBDHdVKlIlj3ROxDkH
	J9Ghh5uln5T8IzYKZ0smpEbexvllO4uqZqH6rtxEAZvsNI29t9lIuUNxm6rF5dkR176vn8fLYhZ
	kP/FFQxX4DEFotE7BmQOBAzDWNsR9K6QqglYXe01CSIfS7imRY5wh3HUT9EabwRc97GCJ9aGjUU
	Qm7VATufa1gby0sGxAT6K+WhHScC7jfRyjJcU6GItZXKPyvPFNNnmGlVP9vjQu3TNALLyRAOgsv
	t+wsqn/HHoso61+4r7T9nUs/q+2bH/9xypn12pusw==
X-Received: by 2002:a05:6870:c250:b0:453:9b2b:f3f1 with SMTP id 586e51a60fabf-459ff6b0630mr3346442fac.5.1786134077083;
        Fri, 07 Aug 2026 13:21:17 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:55::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-459f1e28910sm2664792fac.15.2026.08.07.13.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:16 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kairui Song <kasong@tencent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Rakie Kim <rakie.kim@sk.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [RFC PATCH v3 11/14] mm/memcontrol, migrate: Transfer tier charge on migration
Date: Fri,  7 Aug 2026 13:20:54 -0700
Message-ID: <20260807202059.2620949-12-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Folio migration is charge-neutral, and existing migration paths take
advantage of this fact to simply force destination folio charges or
just transfer memcg data across folios.

Per-tier memcg limits break this assumption. A migration across tiers
(i.e. promotion or demotion) keeps the memcg-level charge neutral,
but the per-memcg tier charges change. As a result, the destination tier
may go over the limit.

Charge the destination separately instead, from migrate_folio_unmap
where the destination folio has just been allocated but can still be
rolled back. This charge attempts a single pass at reclaim if it goes
over the hard limit, and fails the migration if not enough headroom is
created on the destination memcg tier.

Note that this source of migration failure returns -EBUSY and not
-ENOMEM since -ENOMEM will attempt the migration again by splitting the
folio and aborting the batch, which both do nothing to reduce the
memory usage of the memcg tier. We also don't try too hard to reclaim
here (__GFP_NORETRY) since failing migrations is cheap, and we don't
want to OOM kill because of a promotion attempt.

One side effect is that cross-tier migrations now hold both folios'
charges until the source is freed, the same way mem_cgroup_replace_folio
temporarily holds a duplicate charge.

No-op unless the system has tiered memcg limits enabled.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h |  8 ++++++++
 mm/memcontrol.c            | 35 +++++++++++++++++++++++++++++++++++
 mm/migrate.c               | 30 +++++++++++++++++++++++++++---
 3 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ceba0fd6de184..9c2f11191a499 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -708,6 +708,8 @@ static inline void mem_cgroup_uncharge_folios(struct folio_batch *folios)
 
 void mem_cgroup_replace_folio(struct folio *old, struct folio *new);
 void mem_cgroup_migrate(struct folio *old, struct folio *new);
+int mem_cgroup_migrate_charge(struct folio *src, struct folio *dst,
+			      bool force);
 
 /**
  * mem_cgroup_lruvec - get the lru list vector for a memcg & node
@@ -1204,6 +1206,12 @@ static inline void mem_cgroup_migrate(struct folio *old, struct folio *new)
 {
 }
 
+static inline int mem_cgroup_migrate_charge(struct folio *src,
+					    struct folio *dst, bool force)
+{
+	return 0;
+}
+
 static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
 					       struct pglist_data *pgdat)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index de6762520f475..1161934e81380 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5716,6 +5716,41 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 	rcu_read_unlock();
 }
 
+/**
+ * mem_cgroup_migrate_charge - Charge a migration destination up front.
+ * @src: Folio being migrated away from.
+ * @dst: Folio being migrated to.
+ * @force: Charge even if the destination tier is at its limit.
+ *
+ * Folio migrations result in a net 0 memcg charge, but the node location of the
+ * charge may change during promotions or demotions. When this happens, charge
+ * @dst in its own right instead of inheriting @src's charge.
+ *
+ * Return: 0, or -ENOMEM if @dst could not be charged.
+ */
+int mem_cgroup_migrate_charge(struct folio *src, struct folio *dst, bool force)
+{
+	struct mem_cgroup *memcg;
+	gfp_t gfp = GFP_KERNEL;
+	int ret;
+
+	if (mem_cgroup_disabled() || !folio_memcg_charged(src))
+		return 0;
+
+	if (!mem_cgroup_tiered_limits() ||
+	    nid_tier_slot(folio_nid(src)) == nid_tier_slot(folio_nid(dst)))
+		return 0;
+
+	/* Refuse the migration if the first reclaim round fails */
+	gfp |= force ? __GFP_NOFAIL : __GFP_NORETRY;
+
+	memcg = get_mem_cgroup_from_folio(src);
+	ret = charge_memcg(dst, memcg, gfp);
+	mem_cgroup_put(memcg);
+
+	return ret;
+}
+
 /**
  * mem_cgroup_migrate - Transfer the memcg data from the old to the new folio.
  * @old: Currently circulating folio.
diff --git a/mm/migrate.c b/mm/migrate.c
index ab15a4dddd047..45d6d23d53859 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -862,7 +862,13 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 	folio_copy_owner(newfolio, folio);
 	pgalloc_tag_swap(newfolio, folio);
 
-	mem_cgroup_migrate(folio, newfolio);
+	/*
+	 * For failable memcg charge transfers (demotion / promotion) the charge
+	 * has already been transferred at this point. For everyone else simply
+	 * transfer the charge here, where it can no longer fail.
+	 */
+	if (!folio_memcg_charged(newfolio))
+		mem_cgroup_migrate(folio, newfolio);
 }
 EXPORT_SYMBOL(folio_migrate_flags);
 
@@ -1216,7 +1222,7 @@ static void migrate_folio_done(struct folio *src,
 static int migrate_folio_unmap(new_folio_t get_new_folio,
 		free_folio_t put_new_folio, unsigned long private,
 		struct folio *src, struct folio **dstp, enum migrate_mode mode,
-		struct list_head *ret)
+		bool force_charge, struct list_head *ret)
 {
 	struct folio *dst;
 	int rc = -EAGAIN;
@@ -1228,6 +1234,17 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	dst = get_new_folio(src, private);
 	if (!dst)
 		return -ENOMEM;
+
+	if (mem_cgroup_migrate_charge(src, dst, force_charge)) {
+		if (put_new_folio)
+			put_new_folio(dst, private);
+		else
+			folio_put(dst);
+		if (ret)
+			list_move_tail(&src->lru, ret);
+		return -EBUSY;
+	}
+
 	*dstp = dst;
 
 	dst->migrate_info = 0;
@@ -1918,8 +1935,15 @@ static int migrate_pages_batch(struct list_head *from,
 				continue;
 			}
 
+			/*
+			 * Hotplug must not be refused: offline_pages() retries
+			 * indefinitely and ignores migration failures, so a
+			 * refusal would hang it rather than fail it.
+			 */
 			rc = migrate_folio_unmap(get_new_folio, put_new_folio,
-					private, folio, &dst, mode, ret_folios);
+					private, folio, &dst, mode,
+					reason == MR_MEMORY_HOTPLUG,
+					ret_folios);
 			/*
 			 * The rules are:
 			 *	0: folio will be put on unmap_folios list,
-- 
2.53.0-Meta

