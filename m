From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] memcg: Fix memcg_kmem_bypass() for remote memcg
 charging
Date: Fri, 15 May 2020 10:34:58 +0200
Message-ID: <20200515083458.GK29153@dhcp22.suse.cz>
References: <e6927a82-949c-bdfd-d717-0a14743c6759@huawei.com>
 <20200513090502.GV29153@dhcp22.suse.cz>
 <76f71776-d049-7407-8574-86b6e9d80704@huawei.com>
 <20200513112905.GX29153@dhcp22.suse.cz>
 <3a721f62-5a66-8bc5-247b-5c8b7c51c555@huawei.com>
 <20200513161110.GA70427@carbon.DHCP.thefacebook.com>
 <20e89344-cf00-8b0c-64c3-0ac7efd601e6@huawei.com>
 <20200514225259.GA81563@carbon.dhcp.thefacebook.com>
 <20200515065645.GD29153@dhcp22.suse.cz>
 <bad0e16b-7141-94c0-45f6-6ed03926b5f8@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <bad0e16b-7141-94c0-45f6-6ed03926b5f8-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri 15-05-20 16:20:04, Li Zefan wrote:
> On 2020/5/15 14:56, Michal Hocko wrote:
> > On Thu 14-05-20 15:52:59, Roman Gushchin wrote:
[...]
> >>> I thought the user should ensure not do this, but now I think it makes sense to just bypass
> >>> the interrupt case.
> >>
> >> I think now it's mostly a legacy of the opt-out kernel memory accounting.
> >> Actually we can relax this requirement by forcibly overcommit the memory cgroup
> >> if the allocation is happening from the irq context, and punish it afterwards.
> >> Idk how much we wanna this, hopefully nobody is allocating large non-temporarily
> >> objects from an irq.
> > 
> > I do not think we want to pretend that remote charging from the IRQ
> > context is supported. Why don't we simply WARN_ON(in_interrupt()) there?
> > 
> 
> How about:
> 
> static inline bool memcg_kmem_bypass(void)
> {
>         if (in_interrupt()) {
>                 WARN_ON(current->active_memcg);
>                 return true;
>         }

Why not simply 

	if (WARN_ON_ONCE(in_interrupt())
		return true;

the idea is that we want to catch any __GFP_ACCOUNT user from IRQ
context because this just doesn't work and we do not plan to support it
for now and foreseeable future. If this is reduced only to active_memcg
then we are only getting a partial picture.
		
> 
>         /* Allow remote memcg charging in kthread contexts. */
>         if ((!current->mm || (current->flags & PF_KTHREAD)) && !current->active_memcg)
>                 return true;
>         return false;
> }

-- 
Michal Hocko
SUSE Labs
