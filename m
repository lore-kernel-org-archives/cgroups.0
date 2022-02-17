From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [PATCH v3 4/5] mm/memcg: Opencode the inner part of obj_cgroup_uncharge_pages() in drain_obj_stock()
Date: Thu, 17 Feb 2022 10:48:01 +0100
Message-ID: <20220217094802.3644569-5-bigeasy@linutronix.de>
References: <20220217094802.3644569-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645091288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kVZ+pt/1JgatWwehiTV0O06PG+qwCoPYYdHavMUynSM=;
        b=4x9pQZ/+arQ/FUcXDBSf7ajEi9bG8limTx2HLP/v/9S+hPtIQiVs8TUZ8cG1MNt9qftfG1
        wv6Vu94lG30+5KKsrMfPkT3v9fx0ZbkXKaunTjctUGxxhpbQzq2Vx7yKsPGjirqDjBEGcD
        0bcWb4Nr93llKX1bRJpOpGDY11Ov4PZIJGZ3WZffELk9zawW1CjsxP6qBZujcEYsDvzXGb
        HEF0IxoGx4udky4Y6xLnXqf+yIvU5BA4ruPxXDxfYmVCTmD7w6bpyilKwKUE/TojuN1z53
        E5ziOGJx7FRydzUfWPyvqYbxAtj7GEX44mhz64RntOsELfDJCyF4G+Jfqan3OQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645091288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kVZ+pt/1JgatWwehiTV0O06PG+qwCoPYYdHavMUynSM=;
        b=QVjj988fUUlnn/EqqXHo3xd5ZhfV68qeGSA1a8/kZBPOggQ+//vcqDwdf3nC068q2JU6qu
        OKpWyyCYjWCXCdBw==
In-Reply-To: <20220217094802.3644569-1-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Provide the inner part of refill_stock() as __refill_stock() without
disabling interrupts. This eases the integration of local_lock_t where
recursive locking must be avoided.
Open code obj_cgroup_uncharge_pages() in drain_obj_stock() and use
__refill_stock(). The caller of drain_obj_stock() already disables
interrupts.

[bigeasy: Patch body around Johannes' diff ]

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---
 mm/memcontrol.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 36ab3660f2c6d..a3225501cce36 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2224,12 +2224,9 @@ static void drain_local_stock(struct work_struct *du=
mmy)
  * Cache charges(val) to local per_cpu area.
  * This will be consumed by consume_stock() function, later.
  */
-static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
+static void __refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	struct memcg_stock_pcp *stock;
-	unsigned long flags;
-
-	local_irq_save(flags);
=20
 	stock =3D this_cpu_ptr(&memcg_stock);
 	if (stock->cached !=3D memcg) { /* reset if necessary */
@@ -2241,7 +2238,14 @@ static void refill_stock(struct mem_cgroup *memcg, u=
nsigned int nr_pages)
=20
 	if (stock->nr_pages > MEMCG_CHARGE_BATCH)
 		drain_stock(stock);
+}
=20
+static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__refill_stock(memcg, nr_pages);
 	local_irq_restore(flags);
 }
=20
@@ -3158,8 +3162,16 @@ static void drain_obj_stock(struct memcg_stock_pcp *=
stock)
 		unsigned int nr_pages =3D stock->nr_bytes >> PAGE_SHIFT;
 		unsigned int nr_bytes =3D stock->nr_bytes & (PAGE_SIZE - 1);
=20
-		if (nr_pages)
-			obj_cgroup_uncharge_pages(old, nr_pages);
+		if (nr_pages) {
+			struct mem_cgroup *memcg;
+
+			memcg =3D get_mem_cgroup_from_objcg(old);
+
+			memcg_account_kmem(memcg, -nr_pages);
+			__refill_stock(memcg, nr_pages);
+
+			css_put(&memcg->css);
+		}
=20
 		/*
 		 * The leftover is flushed to the centralized per-memcg value.
--=20
2.34.1

