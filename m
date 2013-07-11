From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2] vmpressure: make sure memcg stays alive until all
 users are signaled
Date: Thu, 11 Jul 2013 18:22:15 +0200
Message-ID: <20130711162215.GM21667@dhcp22.suse.cz>
References: <20130710184254.GA16979@mtj.dyndns.org>
 <20130711083110.GC21667@dhcp22.suse.cz>
 <51DE701C.6010800@huawei.com>
 <20130711092542.GD21667@dhcp22.suse.cz>
 <51DE7AAF.6070004@huawei.com>
 <20130711093300.GE21667@dhcp22.suse.cz>
 <20130711154408.GA9229@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130711154408.GA9229-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On Thu 11-07-13 08:44:08, Tejun Heo wrote:
> Hello, Michal.
> 
> On Thu, Jul 11, 2013 at 11:33:00AM +0200, Michal Hocko wrote:
> > +static inline
> > +struct mem_cgroup *vmpressure_to_mem_cgroup(struct vmpressure *vmpr)
> > +{
> > +	return container_of(vmpr, struct mem_cgroup, vmpressure);
> > +}
> > +
> > +void vmpressure_pin_memcg(struct vmpressure *vmpr)
> > +{
> > +	struct mem_cgroup *memcg = vmpressure_to_mem_cgroup(vmpr);
> > +
> > +	css_get(&memcg->css);
> > +}
> > +
> > +void vmpressure_unpin_memcg(struct vmpressure *vmpr)
> > +{
> > +	struct mem_cgroup *memcg = vmpressure_to_mem_cgroup(vmpr);
> > +
> > +	css_put(&memcg->css);
> > +}
> 
> So, while this *should* work, can't we just cancel/flush the work item
> from offline? 

I would rather not put vmpressure clean up code into memcg offlining.
We have reference counting for exactly this purposes so it feels strange
to overcome it like that.
Besides that wouldn't be that racy? The work item could be already
executing and preempted and we do not want vmpr to disappear from under
our feet. I know this is _highly_ unlikely but why to play games?

> There doesn't seem to be any possible deadlocks from my
> shallow glance and those mutexes don't seem to be held for long (do
> they actually need to be mutexes?  what blocks inside them?).

Dunno, to be honest. From a quick look they both can be turned to spin
locks but events_lock might cause long preempt disabled periods when
zillions of events are registered.

> Also, while at it, can you please remove the work_pending() check?
> They're almost always spurious or racy and should be avoided in
> general.

sure, this really looks bogus. I will cook patches for both issues and
send them tomorrow.

-- 
Michal Hocko
SUSE Labs
