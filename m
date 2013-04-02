From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] memcg: don't do cleanup manually if
 mem_cgroup_css_online() fails
Date: Tue, 2 Apr 2013 15:32:27 +0200
Message-ID: <20130402133227.GM24345@dhcp22.suse.cz>
References: <515A8A40.6020406@huawei.com>
 <20130402121600.GK24345@dhcp22.suse.cz>
 <515ACD7F.3070009@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <515ACD7F.3070009-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue 02-04-13 16:22:23, Glauber Costa wrote:
> On 04/02/2013 04:16 PM, Michal Hocko wrote:
> > On Tue 02-04-13 15:35:28, Li Zefan wrote:
> > [...]
> >> @@ -6247,16 +6247,7 @@ mem_cgroup_css_online(struct cgroup *cont)
> >>  
> >>  	error = memcg_init_kmem(memcg, &mem_cgroup_subsys);
> >>  	mutex_unlock(&memcg_create_mutex);
> >> -	if (error) {
> >> -		/*
> >> -		 * We call put now because our (and parent's) refcnts
> >> -		 * are already in place. mem_cgroup_put() will internally
> >> -		 * call __mem_cgroup_free, so return directly
> >> -		 */
> >> -		mem_cgroup_put(memcg);
> >> -		if (parent->use_hierarchy)
> >> -			mem_cgroup_put(parent);
> >> -	}
> >> +
> >>  	return error;
> >>  }
> > 
> > The mem_cgroup_put(parent) part is incorrect because mem_cgroup_put goes
> > up the hierarchy already but I do not think mem_cgroup_put(memcg) should
> > go away as well. Who is going to free the last reference then?
> > 
> > Maybe I am missing something but we have:
> > cgroup_create
> >   css = ss->css_alloc(cgrp)
> >     mem_cgroup_css_alloc
> >       atomic_set(&memcg->refcnt, 1)
> >   online_css(ss, cgrp)
> >     mem_cgroup_css_online
> >       error = memcg_init_kmem		# fails
> >   goto err_destroy
> > err_destroy:
> >   cgroup_destroy_locked(cgrp)
> >     offline_css
> >       mem_cgroup_css_offline
> > 
> > no mem_cgroup_put on the way.
> > 
> 
> static void mem_cgroup_css_free(struct cgroup *cont)
> {
>         struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
> 
>         kmem_cgroup_destroy(memcg);
> 
>         mem_cgroup_put(memcg);
> }
> 
> kernel/cgroup.c:
> err_free_all:
>         for_each_subsys(root, ss) {
>                 if (cgrp->subsys[ss->subsys_id])
>                         ss->css_free(cgrp);
>         }

But we do not get to that path after online_css fails because that one
jumps to err_destroy. So this is not it. Maybe css_free gets called from
cgroup_diput but I got lost in the indirection.
-- 
Michal Hocko
SUSE Labs
