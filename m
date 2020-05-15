From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v2] memcg: Fix memcg_kmem_bypass() for remote memcg
 charging
Date: Fri, 15 May 2020 10:31:10 -0700
Message-ID: <20200515173110.GB94522@carbon.DHCP.thefacebook.com>
References: <76f71776-d049-7407-8574-86b6e9d80704@huawei.com>
 <20200513112905.GX29153@dhcp22.suse.cz>
 <3a721f62-5a66-8bc5-247b-5c8b7c51c555@huawei.com>
 <20200513161110.GA70427@carbon.DHCP.thefacebook.com>
 <20e89344-cf00-8b0c-64c3-0ac7efd601e6@huawei.com>
 <20200514225259.GA81563@carbon.dhcp.thefacebook.com>
 <20200515065645.GD29153@dhcp22.suse.cz>
 <bad0e16b-7141-94c0-45f6-6ed03926b5f8@huawei.com>
 <20200515083458.GK29153@dhcp22.suse.cz>
 <CALvZod64-Yc0firp9C8MNhEaF6FTiKmSx2B3HOrvi8GkyOD-7g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=fff8INmGrPkWukb8lVnvz9ySQRHkmmYenu+695toJNM=;
 b=Zj7VKKXIsVYd6CL6TxyVbOP2Tw8JZGDckYQuhpuYW04ELNBFvp+8RTwDXeAXXN4RKm39
 p856DYK2gQCvHBxxLqdfy4WffN22iKOOS19wX7edYwkRl8AGbwYVH5JgOqb5UyQzB8JK
 5Q/UDSyw0NsVRvOVY7ybQ7zq0KSZnUxuP/I= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fff8INmGrPkWukb8lVnvz9ySQRHkmmYenu+695toJNM=;
 b=ZpivsFou4ZAroJgfmSyZHI6M7YFqMr50u/n9jVhREWDfsVFJbq1XUJRvbGJ6zl5MWMc9+s+gDzTawbhWCySBLDoDRmAHDsviLzPfk1h6rsHqmmfPYXraRiV/Jy3PJohqzXBLf7qFxcUPwFpohqbD48sueFgopG9QCUfd/gHiuwk=
Content-Disposition: inline
In-Reply-To: <CALvZod64-Yc0firp9C8MNhEaF6FTiKmSx2B3HOrvi8GkyOD-7g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Fri, May 15, 2020 at 09:22:25AM -0700, Shakeel Butt wrote:
> On Fri, May 15, 2020 at 1:35 AM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Fri 15-05-20 16:20:04, Li Zefan wrote:
> > > On 2020/5/15 14:56, Michal Hocko wrote:
> > > > On Thu 14-05-20 15:52:59, Roman Gushchin wrote:
> > [...]
> > > >>> I thought the user should ensure not do this, but now I think it makes sense to just bypass
> > > >>> the interrupt case.
> > > >>
> > > >> I think now it's mostly a legacy of the opt-out kernel memory accounting.
> > > >> Actually we can relax this requirement by forcibly overcommit the memory cgroup
> > > >> if the allocation is happening from the irq context, and punish it afterwards.
> > > >> Idk how much we wanna this, hopefully nobody is allocating large non-temporarily
> > > >> objects from an irq.
> > > >
> > > > I do not think we want to pretend that remote charging from the IRQ
> > > > context is supported. Why don't we simply WARN_ON(in_interrupt()) there?
> > > >
> > >
> > > How about:
> > >
> > > static inline bool memcg_kmem_bypass(void)
> > > {
> > >         if (in_interrupt()) {
> > >                 WARN_ON(current->active_memcg);
> > >                 return true;
> > >         }
> >
> > Why not simply
> >
> >         if (WARN_ON_ONCE(in_interrupt())
> >                 return true;
> >
> > the idea is that we want to catch any __GFP_ACCOUNT user from IRQ
> > context because this just doesn't work and we do not plan to support it
> > for now and foreseeable future.

Actually, why not?
It should be fairly simple, especially after the rework of the slab controller.

> If this is reduced only to active_memcg
> > then we are only getting a partial picture.
> >
> 
> There are SLAB_ACCOUNT kmem caches which do allocations in IRQ context
> (see sk_prot_alloc()), so, either we make charging work in IRQ or no
> warnings at all.

I agree. Actually, there is nothing wrong to warn about, it's just a limitation
of the current accounting implementation.

Thanks!
