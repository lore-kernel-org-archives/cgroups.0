From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [PATCH v4 5/6] mm/memcg: Protect memcg_stock with a local_lock_t
Date: Mon, 21 Feb 2022 19:25:39 +0100
Message-ID: <20220221182540.380526-6-bigeasy@linutronix.de>
References: <20220221182540.380526-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645467968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=afPsn9rdRXuPIOkd2LrdE/DTtbz9dmfBZBL5Zj4hTBY=;
        b=bAMIvvaS8izzIXLN/yKmx/SZzf4XD0A9mjhtYK+4wQumis5YbRtI0v9S5LCDGA8BNHa6ZR
        UJ9dgdR9iF6/R/ycwurKikTQNRky6WKB6qABns12M2VBcmZWFE9kChEUzYZiF69FmHYfVQ
        07EhbQUqvu2CKdjsyBHWGWuUniPdN9/3uqbNJII4gCpy5Z+0CPMwwz8MWKKz2xdxITvlMb
        cq1fwR4FIid/XUOGfqSg5L+UZ9jCEkzW4Uh8Xz9/+8BnPmNApYDF2F8xVQfP8zpC7DTzq/
        91dz55kWZgS1t8+FXU81ODR23AvRcZKVSBO2GlMnfUhmWd58KzYZ0P0Bdgzkgg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645467968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=afPsn9rdRXuPIOkd2LrdE/DTtbz9dmfBZBL5Zj4hTBY=;
        b=LEsm8zvj0QFiLV4gnO0Wd/aFp1laeYbe6IOV5T48bfuHjKhQ+uOzREcdnLWdbZTPBQEMT2
        dLcDKKTTIFfoOhAg==
In-Reply-To: <20220221182540.380526-1-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The members of the per-CPU structure memcg_stock_pcp are protected by
disabling interrupts. This is not working on PREEMPT_RT because it
creates atomic context in which actions are performed which require
preemptible context. One example is obj_cgroup_release().

The IRQ-disable sections can be replaced with local_lock_t which
preserves the explicit disabling of interrupts while keeps the code
preemptible on PREEMPT_RT.

drain_obj_stock() drops a reference on obj_cgroup which leads to an invocat=
ion
of obj_cgroup_release() if it is the last object. This in turn leads to
recursive locking of the local_lock_t. To avoid this, obj_cgroup_release() =
is
invoked outside of the locked section.

obj_cgroup_uncharge_pages() can be invoked with the local_lock_t acquired a=
nd
without it. This will lead later to a recursion in refill_stock(). To
avoid the locking recursion provide obj_cgroup_uncharge_pages_locked()
which uses the locked version of refill_stock().

- Replace disabling interrupts for memcg_stock with a local_lock_t.

- Let drain_obj_stock() return the old struct obj_cgroup which is passed
  to obj_cgroup_put() outside of the locked section.

- Provide obj_cgroup_uncharge_pages_locked() which uses the locked
  version of refill_stock() to avoid recursive locking in
  drain_obj_stock().

Link: https://lkml.kernel.org/r/20220209014709.GA26885@xsang-OptiPlex-9020
Reported-by: kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---
 mm/memcontrol.c | 55 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 21 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cd3950256519d..3d7ccb104374c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2128,6 +2128,7 @@ void unlock_page_memcg(struct page *page)
 }
=20
 struct memcg_stock_pcp {
+	local_lock_t stock_lock;
 	struct mem_cgroup *cached; /* this never be root cgroup */
 	unsigned int nr_pages;
=20
@@ -2143,18 +2144,21 @@ struct memcg_stock_pcp {
 	unsigned long flags;
 #define FLUSHING_CACHED_CHARGE	0
 };
-static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
+static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock) =3D {
+	.stock_lock =3D INIT_LOCAL_LOCK(stock_lock),
+};
 static DEFINE_MUTEX(percpu_charge_mutex);
=20
 #ifdef CONFIG_MEMCG_KMEM
-static void drain_obj_stock(struct memcg_stock_pcp *stock);
+static struct obj_cgroup *drain_obj_stock(struct memcg_stock_pcp *stock);
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg);
 static void memcg_account_kmem(struct mem_cgroup *memcg, int nr_pages);
=20
 #else
-static inline void drain_obj_stock(struct memcg_stock_pcp *stock)
+static inline struct obj_cgroup *drain_obj_stock(struct memcg_stock_pcp *s=
tock)
 {
+	return NULL;
 }
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg)
@@ -2186,7 +2190,7 @@ static bool consume_stock(struct mem_cgroup *memcg, u=
nsigned int nr_pages)
 	if (nr_pages > MEMCG_CHARGE_BATCH)
 		return ret;
=20
-	local_irq_save(flags);
+	local_lock_irqsave(&memcg_stock.stock_lock, flags);
=20
 	stock =3D this_cpu_ptr(&memcg_stock);
 	if (memcg =3D=3D stock->cached && stock->nr_pages >=3D nr_pages) {
@@ -2194,7 +2198,7 @@ static bool consume_stock(struct mem_cgroup *memcg, u=
nsigned int nr_pages)
 		ret =3D true;
 	}
=20
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
=20
 	return ret;
 }
@@ -2223,6 +2227,7 @@ static void drain_stock(struct memcg_stock_pcp *stock)
 static void drain_local_stock(struct work_struct *dummy)
 {
 	struct memcg_stock_pcp *stock;
+	struct obj_cgroup *old =3D NULL;
 	unsigned long flags;
=20
 	/*
@@ -2230,14 +2235,16 @@ static void drain_local_stock(struct work_struct *d=
ummy)
 	 * drain_stock races is that we always operate on local CPU stock
 	 * here with IRQ disabled
 	 */
-	local_irq_save(flags);
+	local_lock_irqsave(&memcg_stock.stock_lock, flags);
=20
 	stock =3D this_cpu_ptr(&memcg_stock);
-	drain_obj_stock(stock);
+	old =3D drain_obj_stock(stock);
 	drain_stock(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
=20
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	if (old)
+		obj_cgroup_put(old);
 }
=20
 /*
@@ -2264,9 +2271,9 @@ static void refill_stock(struct mem_cgroup *memcg, un=
signed int nr_pages)
 {
 	unsigned long flags;
=20
-	local_irq_save(flags);
+	local_lock_irqsave(&memcg_stock.stock_lock, flags);
 	__refill_stock(memcg, nr_pages);
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
 }
=20
 /*
@@ -3093,10 +3100,11 @@ void mod_objcg_state(struct obj_cgroup *objcg, stru=
ct pglist_data *pgdat,
 		     enum node_stat_item idx, int nr)
 {
 	struct memcg_stock_pcp *stock;
+	struct obj_cgroup *old =3D NULL;
 	unsigned long flags;
 	int *bytes;
=20
-	local_irq_save(flags);
+	local_lock_irqsave(&memcg_stock.stock_lock, flags);
 	stock =3D this_cpu_ptr(&memcg_stock);
=20
 	/*
@@ -3105,7 +3113,7 @@ void mod_objcg_state(struct obj_cgroup *objcg, struct=
 pglist_data *pgdat,
 	 * changes.
 	 */
 	if (stock->cached_objcg !=3D objcg) {
-		drain_obj_stock(stock);
+		old =3D drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
 		stock->nr_bytes =3D atomic_read(&objcg->nr_charged_bytes)
 				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
@@ -3149,7 +3157,9 @@ void mod_objcg_state(struct obj_cgroup *objcg, struct=
 pglist_data *pgdat,
 	if (nr)
 		mod_objcg_mlstate(objcg, pgdat, idx, nr);
=20
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	if (old)
+		obj_cgroup_put(old);
 }
=20
 static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_by=
tes)
@@ -3158,7 +3168,7 @@ static bool consume_obj_stock(struct obj_cgroup *objc=
g, unsigned int nr_bytes)
 	unsigned long flags;
 	bool ret =3D false;
=20
-	local_irq_save(flags);
+	local_lock_irqsave(&memcg_stock.stock_lock, flags);
=20
 	stock =3D this_cpu_ptr(&memcg_stock);
 	if (objcg =3D=3D stock->cached_objcg && stock->nr_bytes >=3D nr_bytes) {
@@ -3166,17 +3176,17 @@ static bool consume_obj_stock(struct obj_cgroup *ob=
jcg, unsigned int nr_bytes)
 		ret =3D true;
 	}
=20
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
=20
 	return ret;
 }
=20
-static void drain_obj_stock(struct memcg_stock_pcp *stock)
+static struct obj_cgroup *drain_obj_stock(struct memcg_stock_pcp *stock)
 {
 	struct obj_cgroup *old =3D stock->cached_objcg;
=20
 	if (!old)
-		return;
+		return NULL;
=20
 	if (stock->nr_bytes) {
 		unsigned int nr_pages =3D stock->nr_bytes >> PAGE_SHIFT;
@@ -3226,8 +3236,8 @@ static void drain_obj_stock(struct memcg_stock_pcp *s=
tock)
 		stock->cached_pgdat =3D NULL;
 	}
=20
-	obj_cgroup_put(old);
 	stock->cached_objcg =3D NULL;
+	return old;
 }
=20
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
@@ -3248,14 +3258,15 @@ static void refill_obj_stock(struct obj_cgroup *obj=
cg, unsigned int nr_bytes,
 			     bool allow_uncharge)
 {
 	struct memcg_stock_pcp *stock;
+	struct obj_cgroup *old =3D NULL;
 	unsigned long flags;
 	unsigned int nr_pages =3D 0;
=20
-	local_irq_save(flags);
+	local_lock_irqsave(&memcg_stock.stock_lock, flags);
=20
 	stock =3D this_cpu_ptr(&memcg_stock);
 	if (stock->cached_objcg !=3D objcg) { /* reset if necessary */
-		drain_obj_stock(stock);
+		old =3D drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
 		stock->cached_objcg =3D objcg;
 		stock->nr_bytes =3D atomic_read(&objcg->nr_charged_bytes)
@@ -3269,7 +3280,9 @@ static void refill_obj_stock(struct obj_cgroup *objcg=
, unsigned int nr_bytes,
 		stock->nr_bytes &=3D (PAGE_SIZE - 1);
 	}
=20
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	if (old)
+		obj_cgroup_put(old);
=20
 	if (nr_pages)
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
--=20
2.35.1

