From: Wei Wang <weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()
Date: Wed, 12 Oct 2022 21:04:59 -0700
Message-ID: <CAEA6p_BUUzhHVAyaD3semV84M+TeZzmrkyjpwb-gs8e6sQRCWw@mail.gmail.com>
References: <20210817194003.2102381-1-weiwan@google.com> <20221012163300.795e7b86@kernel.org>
 <CALvZod5pKzcxWsLnjUwE9fUb=1S9MDLOHF950miF8x8CWtK5Bw@mail.gmail.com>
 <20221012173825.45d6fbf2@kernel.org> <20221013005431.wzjurocrdoozykl7@google.com>
 <20221012184050.5a7f3bde@kernel.org> <20221012201650.3e55331d@kernel.org>
 <CAEA6p_CqqPtnWjr_yYr1oVF3UKe=6RqFLrg1OoANs2eg5_by0A@mail.gmail.com> <20221012204941.3223d205@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8++WI2cB9cLDorIe3CMpDCvK7dTWV1cZarVzqx3Q8ko=;
        b=QoMAkPZR2s/9mh6z5NesmgaH9PxD8SZ0UocJKumuHdLnwHhyAgawHy+OKUMhF0su4+
         48C6vUCMIuys8ybRZyuyuv8rQD0YniayJkgetcaw3AAy/H41Z7Nk6EIMBwS+0CGkduLI
         A43TwjfVlB0qhSJNRwkUXf1GfQ8zeiLRwb3uefzWaMUK2pc36vJymFDjIYFO9fM6y/2A
         1exw9RUTaswJiNEbTcb/vyoWss0Ddz0QT8CsKGQotGK0Ixb1iFZ30REunvUU7mIsVf3O
         KV+Z/ToGGx5pPFDn2Mm+K/BwcE5B4uZu91SeuJN3+6khHwE8Ro/iEWbObwH1QYTBR+aJ
         IPVQ==
In-Reply-To: <20221012204941.3223d205-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

On Wed, Oct 12, 2022 at 8:49 PM Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Wed, 12 Oct 2022 20:34:00 -0700 Wei Wang wrote:
> > > I pushed this little nugget to one affected machine via KLP:
> > >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 03ffbb255e60..c1ca369a1b77 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -7121,6 +7121,10 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
> > >                 return true;
> > >         }
> > >
> > > +       if (gfp_mask == GFP_NOWAIT) {
> > > +               try_charge(memcg, gfp_mask|__GFP_NOFAIL, nr_pages);
> > > +               refill_stock(memcg, nr_pages);
> > > +       }
> > >         return false;
> > >  }
> > >
> > AFAICT, if you force charge by passing __GFP_NOFAIL to try_charge(),
> > you should return true to tell the caller that the nr_pages is
> > actually being charged.
>
> Ack - not sure what the best thing to do is, tho. Always pass NOFAIL
> in softirq?
>
> It's not clear to me yet why doing the charge/uncharge actually helps,
> perhaps try_to_free_mem_cgroup_pages() does more when NOFAIL is passed?
>
I am curious to know as well.

> I'll do more digging tomorrow.
>
> > Although I am not very sure what refill_stock() does. Does that
> > "uncharge" those pages?
>
> I think so, I copied it from mem_cgroup_uncharge_skmem().
