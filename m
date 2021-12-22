From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [RFC PATCH 3/3] mm/memcg: Allow the task_obj optimization only on non-PREEMPTIBLE kernels.
Date: Wed, 22 Dec 2021 12:41:11 +0100
Message-ID: <20211222114111.2206248-4-bigeasy@linutronix.de>
References: <20211222114111.2206248-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1640173280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jUscNupxAInGNFwdgPxE24F7XsB5NZIGxnYUda6WoJA=;
        b=bcjoPvk55c8sAaoa4q4VH8gB+SPU56a6QMGfWd0AfqBzVu3AeAt8CCDMhe16bhDtBok1UD
        usKttDwFRFWs1/Ezqralb/mLw6YJ0YTfpIGTBz49xbWW9wf5FKPMM3yCKn249Ktxmvk1Sc
        EHv3w9lS0/Hu651QBvj5pAtNn8uZxp0PFHbdmpzDB4zARDrzdsb6r9qhN1v8cpWH0JY9T3
        mDjcgxykAiwCcprtHLugrtzNLyh8kGRZ+2pgh+iSFLHbP9EyFYHZlk6B3QI6F8xuNlaXFc
        K3GwPKRKxAMG4tsqLw7CcAab5ZOJuL9VE7sMvnVlQ4t8tyXs3kVDqAU9Fls7rQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1640173280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jUscNupxAInGNFwdgPxE24F7XsB5NZIGxnYUda6WoJA=;
        b=RucXExCrOFfGkre/X3jLYZdkXqI6Sh25YhnYIuGWSVc208J6vybnoQ1tw2htJE3pia7ZJf
        mpOWiyHmHescuOCQ==
In-Reply-To: <20211222114111.2206248-1-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Based on my understanding the optimisation with task_obj for in_task()
mask sense on non-PREEMPTIBLE kernels because preempt_disable()/enable()
is optimized away. This could be then restricted to !CONFIG_PREEMPTION kern=
el
instead to only PREEMPT_RT.
With CONFIG_PREEMPT_DYNAMIC a non-PREEMPTIBLE kernel can also be
configured but these kernels always have preempt_disable()/enable()
present so it probably makes no sense here for the optimisation.

Restrict the optimisation to !CONFIG_PREEMPTION kernels.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---
 mm/memcontrol.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1e76f26be2c15..92180f1aa9edc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2126,7 +2126,7 @@ struct memcg_stock_pcp {
 	local_lock_t stock_lock;
 	struct mem_cgroup *cached; /* this never be root cgroup */
 	unsigned int nr_pages;
-#ifndef CONFIG_PREEMPT_RT
+#ifndef CONFIG_PREEMPTION
 	/* Protects only task_obj */
 	local_lock_t task_obj_lock;
 	struct obj_stock task_obj;
@@ -2139,7 +2139,7 @@ struct memcg_stock_pcp {
 };
 static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock) =3D {
 	.stock_lock =3D INIT_LOCAL_LOCK(stock_lock),
-#ifndef CONFIG_PREEMPT_RT
+#ifndef CONFIG_PREEMPTION
 	.task_obj_lock =3D INIT_LOCAL_LOCK(task_obj_lock),
 #endif
 };
@@ -2228,7 +2228,7 @@ static void drain_local_stock(struct work_struct *dum=
my)
 	 * drain_stock races is that we always operate on local CPU stock
 	 * here with IRQ disabled
 	 */
-#ifndef CONFIG_PREEMPT_RT
+#ifndef CONFIG_PREEMPTION
 	local_lock(&memcg_stock.task_obj_lock);
 	old =3D drain_obj_stock(&this_cpu_ptr(&memcg_stock)->task_obj, NULL);
 	local_unlock(&memcg_stock.task_obj_lock);
@@ -2837,7 +2837,7 @@ static inline struct obj_stock *get_obj_stock(unsigne=
d long *pflags,
 {
 	struct memcg_stock_pcp *stock;
=20
-#ifndef CONFIG_PREEMPT_RT
+#ifndef CONFIG_PREEMPTION
 	if (likely(in_task())) {
 		*pflags =3D 0UL;
 		*stock_pcp =3D NULL;
@@ -2855,7 +2855,7 @@ static inline struct obj_stock *get_obj_stock(unsigne=
d long *pflags,
 static inline void put_obj_stock(unsigned long flags,
 				 struct memcg_stock_pcp *stock_pcp)
 {
-#ifndef CONFIG_PREEMPT_RT
+#ifndef CONFIG_PREEMPTION
 	if (likely(!stock_pcp))
 		local_unlock(&memcg_stock.task_obj_lock);
 	else
@@ -3267,7 +3267,7 @@ static bool obj_stock_flush_required(struct memcg_sto=
ck_pcp *stock,
 {
 	struct mem_cgroup *memcg;
=20
-#ifndef CONFIG_PREEMPT_RT
+#ifndef CONFIG_PREEMPTION
 	if (in_task() && stock->task_obj.cached_objcg) {
 		memcg =3D obj_cgroup_memcg(stock->task_obj.cached_objcg);
 		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
--=20
2.34.1

