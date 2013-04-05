From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC][PATCH 3/7] memcg: use css_get/put when charging/uncharging
 kmem
Date: Fri, 5 Apr 2013 15:48:44 +0200
Message-ID: <20130405134844.GI31132@dhcp22.suse.cz>
References: <515BF233.6070308@huawei.com>
 <515BF284.7060401@huawei.com>
 <20130404094333.GE29911@dhcp22.suse.cz>
 <515EA532.4050706@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <515EA532.4050706-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Fri 05-04-13 14:19:30, Glauber Costa wrote:
> 
> > 	 * __mem_cgroup_free will issue static_key_slow_dec because this
> > 	 * memcg is active already. If the later initialization fails
> > 	 * then the cgroup core triggers the cleanup so we do not have
> > 	 * to do it here.
> > 	 */
> >> -	mem_cgroup_get(memcg);
> >>  	static_key_slow_inc(&memcg_kmem_enabled_key);
> >>  
> >>  	mutex_lock(&set_limit_mutex);
> >> @@ -5823,23 +5814,33 @@ static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
> >>  	return mem_cgroup_sockets_init(memcg, ss);
> >>  };
> >>  
> >> -static void kmem_cgroup_destroy(struct mem_cgroup *memcg)
> >> +static void kmem_cgroup_css_offline(struct mem_cgroup *memcg)
> >>  {
> >> -	mem_cgroup_sockets_destroy(memcg);
> >> +	/*
> >> +	 * kmem charges can outlive the cgroup. In the case of slab
> >> +	 * pages, for instance, a page contain objects from various
> >> +	 * processes, so it is unfeasible to migrate them away. We
> >> +	 * need to reference count the memcg because of that.
> >> +	 */
> > 
> > I would prefer if we could merge all three comments in this function
> > into a single one. What about something like the following?
> > 	/*
> > 	 * kmem charges can outlive the cgroup. In the case of slab
> > 	 * pages, for instance, a page contain objects from various
> > 	 * processes. As we prevent from taking a reference for every
> > 	 * such allocation we have to be careful when doing uncharge
> > 	 * (see memcg_uncharge_kmem) and here during offlining.
> > 	 * The idea is that that only the _last_ uncharge which sees
> > 	 * the dead memcg will drop the last reference. An additional
> > 	 * reference is taken here before the group is marked dead
> > 	 * which is then paired with css_put during uncharge resp. here.
> > 	 * Although this might sound strange as this path is called when
> > 	 * the reference has already dropped down to 0 and shouldn't be
> > 	 * incremented anymore (css_tryget would fail) we do not have
> > 	 * other options because of the kmem allocations lifetime.
> > 	 */
> >> +	css_get(&memcg->css);
> > 
> > I think that you need a write memory barrier here because css_get
> > nor memcg_kmem_mark_dead implies it. memcg_uncharge_kmem uses
> > memcg_kmem_test_and_clear_dead which imply a full memory barrier but it
> > should see the elevated reference count. No?
> > 
> 
> We don't use barriers for any other kind of reference counting. What is
> different here?

Now we need to make sure that the racing uncharge sees an elevated
reference count before the group is marked dead. Otherwise we could see
a dead group with ref count == 0, no?

-- 
Michal Hocko
SUSE Labs
