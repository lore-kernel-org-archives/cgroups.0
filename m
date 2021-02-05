From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [External] Re: [PATCH] mm: memcontrol: fix missing wakeup oom
 task
Date: Fri, 5 Feb 2021 11:21:47 +0100
Message-ID: <YB0cO7R1WtJgAxI2@dhcp22.suse.cz>
References: <20210205062310.74268-1-songmuchun@bytedance.com>
 <YB0Ay+epP/hnFmDS@dhcp22.suse.cz>
 <CAMZfGtWKNNhc1Jy1jzp2uZU_PM6GNWup7d=yUVk9AehKFo_CRw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612520509; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=441WHve7NP2TxAMx0OJ30INfKQWqrKfmb5j39ihe/DY=;
        b=vD+GXDhlMi+q+LG9eTNBL8QlKKkp0Yk2YsIRnv1U0jtK12zgNa84A5lVmwU25sEhOXR1g3
        r/tOBtkZeacMgrU3FSrlbpsoUpc6zQv2UU0Pk7EeQE2dfk4jtBkU3TZXUhKrL67tRGs+5K
        iR6YLPQo02cieBvDO2ytc1YLsSVnVWI=
Content-Disposition: inline
In-Reply-To: <CAMZfGtWKNNhc1Jy1jzp2uZU_PM6GNWup7d=yUVk9AehKFo_CRw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri 05-02-21 17:55:10, Muchun Song wrote:
> On Fri, Feb 5, 2021 at 4:24 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > On Fri 05-02-21 14:23:10, Muchun Song wrote:
> > > We call memcg_oom_recover() in the uncharge_batch() to wakeup OOM task
> > > when page uncharged, but for the slab pages, we do not do this when page
> > > uncharged.
> >
> > How does the patch deal with this?
> 
> When we uncharge a slab page via __memcg_kmem_uncharge,
> actually, this path forgets to do this for us compared to
> uncharge_batch(). Right?

Yes this was more more or less clear (still would have been nicer to be
explicit). But you still haven't replied to my question I believe. I
assume you rely on refill_stock doing draining but how does this address
the problem? Is it sufficient to do wakeups in the batched way?

> > > When we drain per cpu stock, we also should do this.
> >
> > Can we have anything the per-cpu stock while entering the OOM path. IIRC
> > we do drain all cpus before entering oom path.
> 
> You are right. I did not notice this. Thank you.
> 
> >
> > > The memcg_oom_recover() is small, so make it inline.
> >
> > Does this lead to any code generation improvements? I would expect
> > compiler to be clever enough to inline static functions if that pays
> > off. If yes make this a patch on its own.
> 
> I have disassembled the code, I see memcg_oom_recover is not
> inline. Maybe because memcg_oom_recover has a lot of callers.
> Just guess.
> 
> (gdb) disassemble uncharge_batch
>  [...]
>  0xffffffff81341c73 <+227>: callq  0xffffffff8133c420 <page_counter_uncharge>
>  0xffffffff81341c78 <+232>: jmpq   0xffffffff81341bc0 <uncharge_batch+48>
>  0xffffffff81341c7d <+237>: callq  0xffffffff8133e2c0 <memcg_oom_recover>

So does it really help to do the inlining?
-- 
Michal Hocko
SUSE Labs
