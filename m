From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v2 1/8] memcg: accounting for fib6_nodes cache
Date: Mon, 15 Mar 2021 12:32:07 -0700
Message-ID: <YE+2N0zb9wKTriDH@carbon.dhcp.thefacebook.com>
References: <YEnWUrYOArju66ym@dhcp22.suse.cz>
 <85b5f428-294b-af57-f496-5be5fddeeeea@virtuozzo.com>
 <20210315100942.3cc98bb4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CALvZod4ct6X_M1fzKufX1jKoO2JEE_ONwEmiDWTbpt-fut85yA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=8Eic15bnwssyrTC0MtuFIgfAK3NI+tsH0PxRIioEzGc=;
 b=BdWoyIaUOgf2LdUSQ/sX36cR3MC/GI45abvSvDnz7FyR/BMqukyL5UHIQuBS0D6rC9SG
 6DcTkoGKgV9vGq4duoHXfQnynSmxTsT2SHxeqrohHKd7b2Go+HXF5ISUq6YBYsIQ2kA9
 2WettMpPV9AlVJrSpjjy07jHm+vfLiF3BfA= 
Content-Disposition: inline
In-Reply-To: <CALvZod4ct6X_M1fzKufX1jKoO2JEE_ONwEmiDWTbpt-fut85yA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Mon, Mar 15, 2021 at 12:24:31PM -0700, Shakeel Butt wrote:
> On Mon, Mar 15, 2021 at 10:09 AM Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Mon, 15 Mar 2021 15:23:00 +0300 Vasily Averin wrote:
> > > An untrusted netadmin inside a memcg-limited container can create a
> > > huge number of routing entries. Currently, allocated kernel objects
> > > are not accounted to proper memcg, so this can lead to global memory
> > > shortage on the host and cause lot of OOM kiils.
> > >
> > > One such object is the 'struct fib6_node' mostly allocated in
> > > net/ipv6/route.c::__ip6_ins_rt() inside the lock_bh()/unlock_bh() section:
> > >
> > >  write_lock_bh(&table->tb6_lock);
> > >  err = fib6_add(&table->tb6_root, rt, info, mxc);
> > >  write_unlock_bh(&table->tb6_lock);
> > >
> > > It this case is not enough to simply add SLAB_ACCOUNT to corresponding
> > > kmem cache. The proper memory cgroup still cannot be found due to the
> > > incorrect 'in_interrupt()' check used in memcg_kmem_bypass().
> > > To be sure that caller is not executed in process contxt
> > > '!in_task()' check should be used instead
> >
> > Sorry for a random question, I didn't get the cover letter.
> >
> > What's the overhead of adding SLAB_ACCOUNT?
> >
> 
> The potential overhead is for MEMCG users where we need to
> charge/account each allocation from SLAB_ACCOUNT kmem caches. However
> charging is done in batches, so the cost is amortized. If there is a
> concern about a specific workload then it would be good to see the
> impact of this patch for that workload.
> 
> > Please make sure you CC netdev on series which may impact networking.

In general the overhead is not that big, so I don't think we should argue
too much about every new case where we want to enable the accounting and
rather focus on those few examples (if any?) where it actually hurts
the performance in a meaningful way.

Thanks!
