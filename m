From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] memcg: Fix memcg_kmem_bypass() for remote memcg
 charging
Date: Fri, 15 May 2020 08:56:45 +0200
Message-ID: <20200515065645.GD29153@dhcp22.suse.cz>
References: <e6927a82-949c-bdfd-d717-0a14743c6759@huawei.com>
 <20200513090502.GV29153@dhcp22.suse.cz>
 <76f71776-d049-7407-8574-86b6e9d80704@huawei.com>
 <20200513112905.GX29153@dhcp22.suse.cz>
 <3a721f62-5a66-8bc5-247b-5c8b7c51c555@huawei.com>
 <20200513161110.GA70427@carbon.DHCP.thefacebook.com>
 <20e89344-cf00-8b0c-64c3-0ac7efd601e6@huawei.com>
 <20200514225259.GA81563@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200514225259.GA81563-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu 14-05-20 15:52:59, Roman Gushchin wrote:
> On Thu, May 14, 2020 at 09:16:29AM +0800, Zefan Li wrote:
> > On 2020/5/14 0:11, Roman Gushchin wrote:
> > > On Wed, May 13, 2020 at 07:47:49PM +0800, Zefan Li wrote:
> > >> While trying to use remote memcg charging in an out-of-tree kernel module
> > >> I found it's not working, because the current thread is a workqueue thread.
> > >>
> > >> As we will probably encounter this issue in the future as the users of
> > >> memalloc_use_memcg() grow, it's better we fix it now.
> > >>
> > >> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > >> ---
> > >>
> > >> v2: add a comment as sugguested by Michal. and add changelog to explain why
> > >> upstream kernel needs this fix.
> > >>
> > >> ---
> > >>
> > >>  mm/memcontrol.c | 3 +++
> > >>  1 file changed, 3 insertions(+)
> > >>
> > >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > >> index a3b97f1..43a12ed 100644
> > >> --- a/mm/memcontrol.c
> > >> +++ b/mm/memcontrol.c
> > >> @@ -2802,6 +2802,9 @@ static void memcg_schedule_kmem_cache_create(struct mem_cgroup *memcg,
> > >>  
> > >>  static inline bool memcg_kmem_bypass(void)
> > >>  {
> > >> +	/* Allow remote memcg charging in kthread contexts. */
> > >> +	if (unlikely(current->active_memcg))
> > >> +		return false;
> > >>  	if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
> > >>  		return true;
> > > 
> > > Shakeel is right about interrupts. How about something like this?
> > > 
> > > static inline bool memcg_kmem_bypass(void)
> > > {
> > > 	if (in_interrupt())
> > > 		return true;
> > > 
> > > 	if ((!current->mm || current->flags & PF_KTHREAD) && !current->active_memcg)
> > > 		return true;
> > > 
> > > 	return false;
> > > }
> > > 
> > 
> > I thought the user should ensure not do this, but now I think it makes sense to just bypass
> > the interrupt case.
> 
> I think now it's mostly a legacy of the opt-out kernel memory accounting.
> Actually we can relax this requirement by forcibly overcommit the memory cgroup
> if the allocation is happening from the irq context, and punish it afterwards.
> Idk how much we wanna this, hopefully nobody is allocating large non-temporarily
> objects from an irq.

I do not think we want to pretend that remote charging from the IRQ
context is supported. Why don't we simply WARN_ON(in_interrupt()) there?

> 
> Will you send a v3?
> 
> Thanks!

-- 
Michal Hocko
SUSE Labs
