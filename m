From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/5] mm, memcg: narrow the scope of percpu_charge_mutex
Date: Fri, 30 Jul 2021 08:50:02 +0200
Message-ID: <YQOhGs3k9rHx3mmT@dhcp22.suse.cz>
References: <20210729125755.16871-1-linmiaohe@huawei.com>
 <20210729125755.16871-3-linmiaohe@huawei.com>
 <YQNsxVPsRSBZcfGG@carbon.lan>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1627627803; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xojnLgK/32nxOjCn8ZrhjIhAgNUPqzZVxeCUL5Yhwn8=;
        b=hAr/6b2qqY+vI9OuPMkGd1wYvnwVpqYOzmgAWJVVfz/cuy4qh4vYDL8ENtabW+YJ+NeJuV
        S+MgrWHeMKCcm8MUeT3IoYVeA5003ijTHbYjXne5Fz+LyJAh2BJittkpTk5+5blrGinP4y
        b0qhbxN2wMXENaebAmqI7+QsEl98acY=
Content-Disposition: inline
In-Reply-To: <YQNsxVPsRSBZcfGG-esYZh5BkUNV+urZeOPWqwQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 29-07-21 20:06:45, Roman Gushchin wrote:
> On Thu, Jul 29, 2021 at 08:57:52PM +0800, Miaohe Lin wrote:
> > Since percpu_charge_mutex is only used inside drain_all_stock(), we can
> > narrow the scope of percpu_charge_mutex by moving it here.
> > 
> > Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > ---
> >  mm/memcontrol.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 6580c2381a3e..a03e24e57cd9 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2050,7 +2050,6 @@ struct memcg_stock_pcp {
> >  #define FLUSHING_CACHED_CHARGE	0
> >  };
> >  static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
> > -static DEFINE_MUTEX(percpu_charge_mutex);
> >  
> >  #ifdef CONFIG_MEMCG_KMEM
> >  static void drain_obj_stock(struct obj_stock *stock);
> > @@ -2209,6 +2208,7 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> >   */
> >  static void drain_all_stock(struct mem_cgroup *root_memcg)
> >  {
> > +	static DEFINE_MUTEX(percpu_charge_mutex);
> >  	int cpu, curcpu;
> 
> It's considered a good practice to protect data instead of code paths. After
> the proposed change it becomes obvious that the opposite is done here: the mutex
> is used to prevent a simultaneous execution of the code of the drain_all_stock()
> function.

The purpose of the lock was indeed to orchestrate callers more than any
data structure consistency.
 
> Actually we don't need a mutex here: nobody ever sleeps on it. So I'd replace
> it with a simple atomic variable or even a single bitfield. Then the change will
> be better justified, IMO.

Yes, mutex can be replaced by an atomic in a follow up patch.
-- 
Michal Hocko
SUSE Labs
