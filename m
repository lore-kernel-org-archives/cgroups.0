From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH -v2] memcg: don't do cleanup manually if
 mem_cgroup_css_online() fails
Date: Tue, 2 Apr 2013 17:04:22 +0200
Message-ID: <20130402150422.GB32520@dhcp22.suse.cz>
References: <515A8A40.6020406@huawei.com>
 <20130402121600.GK24345@dhcp22.suse.cz>
 <20130402141646.GQ24345@dhcp22.suse.cz>
 <515AE948.1000704@parallels.com>
 <20130402142825.GA32520@dhcp22.suse.cz>
 <515AEC3A.2030401@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <515AEC3A.2030401-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue 02-04-13 18:33:30, Glauber Costa wrote:
> On 04/02/2013 06:28 PM, Michal Hocko wrote:
> > On Tue 02-04-13 18:20:56, Glauber Costa wrote:
> >> On 04/02/2013 06:16 PM, Michal Hocko wrote:
> >>>  mem_cgroup_css_online
> >>>       memcg_init_kmem
> >>>         mem_cgroup_get		# refcnt = 2
> >>>           memcg_update_all_caches
> >>>             memcg_update_cache_size	# fails with ENOMEM
> >>
> >> Here is the thing: this one in kmem only happens for kmem enabled
> >> memcgs. For those, we tend to do a get once, and put only when the last
> >> kmem reference is gone.
> >>
> >> For non-kmem memcgs, refcnt will be 1 here, and will be balanced out by
> >> the mem_cgroup_put() in css_free.
> > 
> > So we need this, right?
> > ---
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index f608546..2ef875d 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5306,6 +5306,8 @@ static int memcg_propagate_kmem(struct mem_cgroup *memcg)
> >  	ret = memcg_update_cache_sizes(memcg);
> >  	mutex_unlock(&set_limit_mutex);
> >  out:
> > +	if (ret)
> > +		mem_cgroup_put(memcg);
> >  	return ret;
> >  }
> >  #endif /* CONFIG_MEMCG_KMEM */
> > @@ -6417,16 +6419,6 @@ mem_cgroup_css_online(struct cgroup *cont)
> >  
> >  	error = memcg_init_kmem(memcg, &mem_cgroup_subsys);
> >  	mutex_unlock(&memcg_create_mutex);
> > -	if (error) {
> > -		/*
> > -		 * We call put now because our (and parent's) refcnts
> > -		 * are already in place. mem_cgroup_put() will internally
> > -		 * call __mem_cgroup_free, so return directly
> > -		 */
> > -		mem_cgroup_put(memcg);
> > -		if (parent->use_hierarchy)
> > -			mem_cgroup_put(parent);
> > -	}
> >  	return error;
> >  }
> >  
> > 
> Yes, indeed you are very right - and thanks for looking at such depth.

So what about the patch bellow? It seems that I provoked all this mess
but my brain managed to push it away so I do not remember why I thought
the parent needs reference drop... It is "only" 3.9 thing fortunately.
---
From 3aff5d958f1d0717795018f7d0d6b63d53ad1dd3 Mon Sep 17 00:00:00 2001
From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Date: Tue, 2 Apr 2013 16:37:39 +0200
Subject: [PATCH] memcg: don't do cleanup manually if mem_cgroup_css_online()
 fails

mem_cgroup_css_online is called with memcg with refcnt = 1 and it
expects that mem_cgroup_css_free will drop this last reference.
This doesn't hold when memcg_init_kmem fails though and a reference is
dropped for both memcg and its parent explicitly if it returns with an
error.

This is not correct for two reasons. Firstly mem_cgroup_put on parent is
excessive because mem_cgroup_put is hierarchy aware and secondly only
memcg_propagate_kmem takes an additional reference.

The first one is a real use-after-free bug introduced by e4715f01
(memcg: avoid dangling reference count in creation failure)

The later one is non-issue right now because the only implementation
of init_cgroup seems to be tcp_init_cgroup which doesn't fail
but it is better to make the error handling saner and move the
mem_cgroup_put(memcg) to memcg_propagate_kmem where it belongs.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 mm/memcontrol.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f608546..cf9ba7e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5306,6 +5306,8 @@ static int memcg_propagate_kmem(struct mem_cgroup *memcg)
 	ret = memcg_update_cache_sizes(memcg);
 	mutex_unlock(&set_limit_mutex);
 out:
+	if (ret)
+		mem_cgroup_put(memcg);
 	return ret;
 }
 #endif /* CONFIG_MEMCG_KMEM */
@@ -6417,16 +6419,7 @@ mem_cgroup_css_online(struct cgroup *cont)
 
 	error = memcg_init_kmem(memcg, &mem_cgroup_subsys);
 	mutex_unlock(&memcg_create_mutex);
-	if (error) {
-		/*
-		 * We call put now because our (and parent's) refcnts
-		 * are already in place. mem_cgroup_put() will internally
-		 * call __mem_cgroup_free, so return directly
-		 */
-		mem_cgroup_put(memcg);
-		if (parent->use_hierarchy)
-			mem_cgroup_put(parent);
-	}
+
 	return error;
 }
 
-- 
1.7.10.4

-- 
1.7.10.4
-- 
Michal Hocko
SUSE Labs
