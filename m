From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 04/11] mm: memcg: push down PageSwapCache check into
 uncharge entry functions
Date: Mon, 9 Jul 2012 09:36:14 +0200
Message-ID: <20120709073614.GB1779@cmpxchg.org>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
 <1341449103-1986-5-git-send-email-hannes@cmpxchg.org>
 <4FFA4504.4040408@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FFA4504.4040408-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jul 09, 2012 at 11:42:12AM +0900, Kamezawa Hiroyuki wrote:
> (2012/07/05 9:44), Johannes Weiner wrote:
> > @@ -3278,10 +3283,11 @@ void mem_cgroup_end_migration(struct mem_cgroup *memcg,
> >   		unused = oldpage;
> >   	}
> >   	anon = PageAnon(used);
> > -	__mem_cgroup_uncharge_common(unused,
> > -		anon ? MEM_CGROUP_CHARGE_TYPE_ANON
> > -		     : MEM_CGROUP_CHARGE_TYPE_CACHE,
> > -		true);
> > +	if (!PageSwapCache(page))
> > +		__mem_cgroup_uncharge_common(unused,
> > +					     anon ? MEM_CGROUP_CHARGE_TYPE_ANON
> > +					     : MEM_CGROUP_CHARGE_TYPE_CACHE,
> > +					     true);
> 
> !PageSwapCache(unused) ?

Argh, right.

> But I think unused page's PG_swapcache is always dropped. So, the check is
> not necessary.

Oh, this is intentional: the check was in __mem_cgroup_uncharge_common
before, which means it applied to this entry point as well.  This is
supposed to be a mechanical change that does not change any logic.
The check is then removed in the next patch.

---
Subject: mm: memcg: push down PageSwapCache check into uncharge entry functions fix

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a3bf414..f4ff18a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3283,7 +3283,7 @@ void mem_cgroup_end_migration(struct mem_cgroup *memcg,
 		unused = oldpage;
 	}
 	anon = PageAnon(used);
-	if (!PageSwapCache(page))
+	if (!PageSwapCache(unused))
 		__mem_cgroup_uncharge_common(unused,
 					     anon ? MEM_CGROUP_CHARGE_TYPE_ANON
 					     : MEM_CGROUP_CHARGE_TYPE_CACHE,
