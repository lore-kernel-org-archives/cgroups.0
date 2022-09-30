From: Alexander Fedorov <halcien-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Possible race in obj_stock_flush_required() vs drain_obj_stock()
Date: Fri, 30 Sep 2022 14:06:48 +0000
Message-ID: <1664546131660.1777662787.1655319815@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:content-transfer-encoding:user-agent:date:subject:cc
         :to:from:message-id:from:to:cc:subject:date;
        bh=Eu1UCcsFNrtGDpP0teOX35SousjnhGHT123vvgcKo/k=;
        b=JQHL799ma39mxOGPE+gyXK+ZE69/Sgnv6GL9hyUmyU/NRAySECqAPsYLbdp+YJWo78
         oKpJ5jAWZ8QzBeVm0jto83to21gR84tMwmSCDr7v5J56xkHakG6Mo4QwOPbbx4Ntm/Rn
         7duiyJxmoUkZeToHp0Yt//TWHvf+YWoWz/Qntgh0rBP1CMmfqHL8so3IOPL1Ov9YN8gJ
         PgeuTxU/R+ge84LDxb7a9cy/oes8BDQiwVSssGTBzsI41gCjIcNg79GoVBX7XGiBE3d6
         BAtqACLyIXMLlplZb98X3gYtYmr7J6taw3Gqj7mW/+uMhwn4rQdq/WJSO1+KY0Meyrna
         Ar9g==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hi,

reposting this to the mainline list as requested and with updated patch.

I've encountered a race on kernel version 5.10.131-rt72 when running
LTP cgroup_fj_stress_memory* tests and need help with understanding
synchronization in mm/memcontrol.c, it seems really not-trivial...
Have also checked patches in the latest mainline kernel but do not see
anything similar to the problem.  Realtime patch also does not seem to
be the culprit: it just changed preemption to migration disabling and
irq_disable to local_lock.

It goes as follows:

1) First CPU:
    css_killed_work_fn() -> mem_cgroup_css_offline() ->
drain_all_stock() -> obj_stock_flush_required()
         if (stock->cached_objcg) {

This check sees a non-NULL pointer for *another* CPU's `memcg_stock` 
instance.

2) Second CPU:
   css_free_rwork_fn() -> __mem_cgroup_free() -> free_percpu() ->
obj_cgroup_uncharge() -> drain_obj_stock()
It frees `cached_objcg` pointer in its own `memcg_stock` instance:
         struct obj_cgroup *old = stock->cached_objcg;
         < ... >
         obj_cgroup_put(old);
         stock->cached_objcg = NULL;

3) First CPU continues after the 'if' check and re-reads the pointer
again, now it is NULL and dereferencing it leads to kernel panic:
static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
                                      struct mem_cgroup *root_memcg)
{
< ... >
         if (stock->cached_objcg) {
                 memcg = obj_cgroup_memcg(stock->cached_objcg);

Since it seems that `cached_objcg` field is protected by RCU, I've also
tried the patch below (against 5.10.131-rt72) and confirmed that it seems
to fix the problem (at least the same LTP tests finish successfully) but
am not sure if that's the right fix.  The patch does not apply cleanly to
mainline kernel but I can try rebasing it if needed.


     mm/memcg: fix race in obj_stock_flush_required() vs drain_obj_stock()
     
     When obj_stock_flush_required() is called from drain_all_stock() it
     reads the `memcg_stock->cached_objcg` field twice for another CPU's
     per-cpu variable, leading to TOCTTOU race: another CPU can
     simultaneously enter drain_obj_stock() and clear its own instance of
     `memcg_stock->cached_objcg`.
     
     To fix it mark `cached_objcg` as RCU protected field and use
     rcu_*() accessors everywhere.

Signed-off-by: Alexander Fedorov <halcien-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c1152f8747..2ab205f529 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2215,7 +2215,7 @@ struct memcg_stock_pcp {
  	unsigned int nr_pages;
  
  #ifdef CONFIG_MEMCG_KMEM
-	struct obj_cgroup *cached_objcg;
+	struct obj_cgroup __rcu *cached_objcg;
  	unsigned int nr_bytes;
  #endif
  
@@ -3148,7 +3148,7 @@ static bool consume_obj_stock(struct obj_cgroup 
*objcg, unsigned int nr_bytes)
  	local_lock_irqsave(&memcg_stock.lock, flags);
  
  	stock = this_cpu_ptr(&memcg_stock);
-	if (objcg == stock->cached_objcg && stock->nr_bytes >= nr_bytes) {
+	if (objcg == rcu_access_pointer(stock->cached_objcg) && stock->nr_bytes 
>= nr_bytes) {
  		stock->nr_bytes -= nr_bytes;
  		ret = true;
  	}
@@ -3160,7 +3160,8 @@ static bool consume_obj_stock(struct obj_cgroup 
*objcg, unsigned int nr_bytes)
  
  static void drain_obj_stock(struct memcg_stock_pcp *stock)
  {
-	struct obj_cgroup *old = stock->cached_objcg;
+	struct obj_cgroup *old = rcu_replace_pointer(stock->cached_objcg, NULL,
+						lockdep_is_held(&stock->lock));
  
  	if (!old)
  		return;
@@ -3198,16 +3199,16 @@ static void drain_obj_stock(struct memcg_stock_pcp 
*stock)
  	}
  
  	obj_cgroup_put(old);
-	stock->cached_objcg = NULL;
  }
  
  static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
  				     struct mem_cgroup *root_memcg)
  {
  	struct mem_cgroup *memcg;
+	struct obj_cgroup *cached_objcg = rcu_dereference(stock->cached_objcg);
  
-	if (stock->cached_objcg) {
-		memcg = obj_cgroup_memcg(stock->cached_objcg);
+	if (cached_objcg) {
+		memcg = obj_cgroup_memcg(cached_objcg);
  		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
  			return true;
  	}
@@ -3223,11 +3224,11 @@ static void refill_obj_stock(struct obj_cgroup 
*objcg, unsigned int nr_bytes)
  	local_lock_irqsave(&memcg_stock.lock, flags);
  
  	stock = this_cpu_ptr(&memcg_stock);
-	if (stock->cached_objcg != objcg) { /* reset if necessary */
+	if (rcu_access_pointer(stock->cached_objcg) != objcg) { /* reset if 
necessary */
  		drain_obj_stock(stock);
  		obj_cgroup_get(objcg);
-		stock->cached_objcg = objcg;
  		stock->nr_bytes = atomic_xchg(&objcg->nr_charged_bytes, 0);
+		rcu_assign_pointer(stock->cached_objcg, objcg);
  	}
  	stock->nr_bytes += nr_bytes;
  
@@ -7162,6 +7163,7 @@ static int __init mem_cgroup_init(void)
  
  		stock = per_cpu_ptr(&memcg_stock, cpu);
  		INIT_WORK(&stock->work, drain_local_stock);
+		RCU_INIT_POINTER(stock->cached_objcg, NULL);
  		local_lock_init(&stock->lock);
  	}
  
