From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Mon, 18 Nov 2013 20:16:55 +0100
Message-ID: <20131118191655.GB12923@dhcp22.suse.cz>
References: <5278B3F1.9040502@huawei.com>
 <20131107235301.GB1092@cmpxchg.org>
 <20131108001437.GC1092@cmpxchg.org>
 <CA+SBX_P6wzmb0k0qM1m06C_1024ZTfYZOs0axLBBJm46X+osqA@mail.gmail.com>
 <20131111153943.GA22384@dhcp22.suse.cz>
 <CA+SBX_PiRoL7HU-C_wXHjHYduYrbTjO3i6_OoHOJ_Mq+sMZStg@mail.gmail.com>
 <20131112135844.GA6049@dhcp22.suse.cz>
 <CA+SBX_O4oK1H7Gtb5OFYSn_W3Gz+d-YqF7OmM3mOrRTp6x3pvw@mail.gmail.com>
 <20131118094554.GA32623@dhcp22.suse.cz>
 <CA+SBX_PqdsG5LBQ1uLpPsSUsbjF8TJ+ok4E+Hp_3AdHf+_5e-A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=UmzQ5zF2ZYXjt+LInIwoRDUcCgA4OddMJ4Sr1SozN1A=;
        b=warAC5q86NU7hyiztfX8EX3E4bux2zlMTX8dF6pUh2e2lF+cFG6AT5CQi7gCrEoCVY
         KIdyx77a5+9L1J68sVU8fklgRKBp+CsmEZewMt2j8sF6+2sOS+eNjKHbD/ffDflbDI01
         y0eUDueVVTmX3F5Zw/pgEBaHad/lYo5pcrOJKnqMsftp268+UwkbHPLtHP0otBnolbbA
         BmNsaR9wR5bctopztF1tDCwngYNZHjLFKfv8Zv+2JSkR/4+KhjnY7sGPe22Y8NFipHY/
         Rd+HNqw2AQvcvCFI/SWVtWygZbPEGmu24DJ5JQ6oQ4/qlGDM7DHvSOre4myP8AekCnGj
         0sOA==
Content-Disposition: inline
In-Reply-To: <CA+SBX_PqdsG5LBQ1uLpPsSUsbjF8TJ+ok4E+Hp_3AdHf+_5e-A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 18-11-13 15:31:26, Markus Blank-Burian wrote:
> > There is one more issue which is discussed in another thread
> > (https://lkml.org/lkml/2013/11/15/31) and Tejun has posted a patch (and
> > Hugh followed up on it https://lkml.org/lkml/2013/11/17/166) to fix
> > the cgroup destruction path which may get stuck.
> >
> 
> Tried out the patches from Johannes, Tejun+Hugh and Michal all

You do not have to apply my patch as Johannes' one should be sufficient.

> together and my problem still persists :-(
> Anything I can try besides bisectioning (which I still could not get
> to work yet)?

Add more debugging information I guess. Let's see if something like the
following helps
---
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3d69a3fe4c55..602db53c690d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3928,6 +3928,8 @@ static int mem_cgroup_move_parent(struct page *page,
 put:
 	put_page(page);
 out:
+	if (ret)
+		trace_printk("%s failed with %d for memcg:%p\n", __FUNCTION__, ret, child);
 	return ret;
 }
 
@@ -4946,7 +4948,7 @@ static void mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
 static void mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
 {
 	int node, zid;
-	u64 usage;
+	u64 usage, u, k;
 
 	do {
 		/* This is for making all *used* pages to be on LRU. */
@@ -4978,8 +4980,11 @@ static void mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
 		 * right after the check. RES_USAGE should be safe as we always
 		 * charge before adding to the LRU.
 		 */
-		usage = res_counter_read_u64(&memcg->res, RES_USAGE) -
-			res_counter_read_u64(&memcg->kmem, RES_USAGE);
+		u = res_counter_read_u64(&memcg->res, RES_USAGE);
+		k = res_counter_read_u64(&memcg->kmem, RES_USAGE);
+		usage = u - k;
+		if (usage > 0)
+			trace_printk("memcg:%p u:%lu k:%lu tasks:%d\n", memcg, u, k, cgroup_task_count(memcg->css.cgrp));
 	} while (usage > 0);
 }
 
@@ -6358,12 +6363,14 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
+	trace_printk("memcg:%p is going offline now\n", memcg);
 	kmem_cgroup_css_offline(memcg);
 
 	mem_cgroup_invalidate_reclaim_iterators(memcg);
 	mem_cgroup_reparent_charges(memcg);
 	mem_cgroup_destroy_all_caches(memcg);
 	vmpressure_cleanup(&memcg->vmpressure);
+	trace_printk("memcg:%p is offline now\n", memcg);
 }
 
 static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
@@ -6746,6 +6753,10 @@ static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 	unsigned long move_charge_at_immigrate;
 
+	if (!css_tryget(css))
+		trace_printk("Target memcg %p is dead!\n", memcg);
+	else
+		css_put(css);
 	/*
 	 * We are now commited to this value whatever it is. Changes in this
 	 * tunable will only affect upcoming migrations, not the current one.

-- 
Michal Hocko
SUSE Labs
